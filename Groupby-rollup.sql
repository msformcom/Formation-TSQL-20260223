-- Par Annee, Mois 
-- le nombre de commandes 
-- Le nombre de clients qui ont commandé
-- Lire dans les données le nombre de commandes par annee

WITH Groupby AS (
SELECT DATEPART(year,SO.orderdate) AS Annee,
		DATEPART(quarter,SO.orderdate) AS Trimestre,
		 DATEPART(month,SO.orderdate) AS mois,
		 COUNT(*) AS NbCommandes,
		
		 SUM(SO.freight) AS SommePort,
		  '€' AS Monnaie,
		CONVERT(DECIMAL(18,2), COUNT(*))/COUNT(DISTINCT SO.custid) AS MoyenneNbCommandesParClient,
		 COUNT(DISTINCT SO.custid) AS NbClients
FROM Sales.Orders SO

GROUP BY DATEPART(year,SO.orderdate),
		DATEPART(quarter,SO.orderdate),
		 DATEPART(month,SO.orderdate)
	WITH CUBE
	)
SELECT * 
FROM Groupby
--WHERE Annee =2007 AND Trimestre=1 AND mois IS NULL