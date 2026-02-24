-- Par annee, mois le CA généré par les ventes + freight
-- Pour une vente d'un produit => qty * unitprice
-- jointure
-- group by
WITH Etape1 AS (
-- Jointure entre Orders(Annee, Mois, FraisPort) et OrderDetails(Montant)
SELECT Datepart(year,SO.orderdate) AS Annee,
		Datepart(month,SO.orderdate) AS Mois,
		SO.freight AS FraisPort,
		SOD.qty* SOD.unitprice AS Montant,
		SO.orderid AS IdCommande
FROM [Sales].[Orders] AS SO
INNER JOIN [Sales].[OrderDetails] AS SOD ON SO.orderid=SOD.orderid
), Etape2 AS (
    --Calcul Frais port + CA par orderid
SELECT Annee, 
		Mois, 
		IdCommande, 
		FraisPort, 
		SUM(Montant) AS Montants
FROM Etape1
GROUP BY Annee, Mois, IdCommande, FraisPort)
--SELECT * FROM Etape2
,
Etape3 AS (
    --Calcul Frais port + CA par Annee / Mois
SELECT Annee, 
		Mois, 
		COUNT(DISTINCT IdCommande) AS NbCommandes, 
		SUM(FraisPort) AS FraisPort,
		SUM(Montants) AS Montants,
		SUM(FraisPort+Montants) AS CA
	
FROM Etape2
GROUP BY Annee,Mois)
--SELECT * FROM Etape3
-- Calcul du cumul du CA
SELECT T1.Annee,T1.Mois, 
		T1.Montants,
		T1.FraisPort,
		T1.NbCommandes,
		T1.CA,
		SUM(T2.CA) AS CumulCA  
FROM Etape3 AS T1
INNER JOIN Etape3 AS T2 ON T1.Annee*12+T1.mois >= T2.Annee*12+T2.Mois
GROUP BY T1.Annee,T1.Mois, 
		T1.Montants,
		T1.FraisPort,
		T1.NbCommandes,
		T1.CA

-- Autre façon
;WITH Etape1 AS (
SELECT SOD.orderid,
		SUM( SOD.qty*SOD.unitprice) AS Montant
FROM Sales.OrderDetails AS SOD
GROUP BY SOD.orderid
)
SELECT Datepart(year,SO.orderdate) AS Annee,
		Datepart(month,SO.orderdate) AS Mois,
		SUM(SO.freight) AS FraisPort,
		SUM(Montant) as Montants,
		SUM(SO.freight+Montant) AS CA
		FROM Etape1 AS E1
INNER JOIN Sales.Orders AS SO ON SO.orderid=E1.orderid
GROUP BY Datepart(year,SO.orderdate) , Datepart(month,SO.orderdate)