-- Pour chaque mois
-- Par employe => Nom EMploye | CAMois | CA Total Du mois | %CAParRapportauCAtotalDumois | RankCAMois | Evolution Par rapport au moins precedent

-- 1) Jointure + groupby :

CREATE OR ALTER VIEW VentesParEmploye
AS
WITH Ventes AS (
SELECT	YEAR(SOI.orderdate) AS Annee,
		MONTH(SOI.orderdate) AS Mois,
		HRE.empid AS IdEmploye, 
		HRE.firstname AS Prenom, 
		HRE.lastname AS Nom,
		SUM(SOI.qty*SOI.unitprice) AS CA FROM HR.Employees HRE
INNER JOIN Sales.OrderInfos SOI ON SOI.empid=HRE.empid
GROUP BY YEAR(SOI.orderdate),
		MONTH(SOI.orderdate), HRE.empid, HRE.firstname, HRE.lastname)

	
-- Données sur lesquelles je base mon classement
SELECT AM.Annee, AM.mois, IdEmploye,Nom,Prenom,ISNULL(CA,0) AS CA FROM Helpers.AnneeMois(2006,2008) AM LEFT JOIN
Ventes V ON V.Mois=AM.Mois AND v.Annee=AM.Annee 


-- | Annee | Mois | Employe | CAMois => Function
SELECT * ,
	SUM(CA) OVER (PARTITION BY Annee,Mois) AS CAMois,
	RANK() OVER (PARTITION BY Annee,Mois ORDER BY CA DESC) AS RankParCASurMois,
	IIF(SUM(CA) OVER (PARTITION BY Annee,Mois)!=0,CA/(SUM(CA) OVER (PARTITION BY Annee,Mois)),NULL) AS PercentCAParMois,
	CA-LAG(CA) OVER (PARTITION BY IdEmploye ORDER BY Annee,Mois),
	IIF(MAX(CA) OVER(PARTITION BY Annee,Mois )=0,null,IIF(CA/MAX(CA) OVER(PARTITION BY Annee,Mois )>0.7,'OK','Pas OK')) AS MeilleurCA10Percent
	
FROM VentesParEmploye VPE
ORDER BY VPE.Annee,VPE.Mois, VPE.IdEmploye 

-- 2) Ajout des fonctions de fenetrage à la sélection (simplifier avec CTE-with)
-- CA Total Du mois 
-- RankCAMois
-- %CAParRapportauCAtotalDumois 
-- Evolution Par rapport au moins precedent

-- 3) OUI/NON  employe a un  CA pour l'annee  à plus de 10000 € de moins que le meilleur employe de l'année