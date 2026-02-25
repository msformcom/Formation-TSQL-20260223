DECLARE @IdProduit INT =14

;WITH Annees AS (SELECT n AS Annee FROM nums WHERE n BETWEEN 2006 AND 2008),
Mois AS (SELECT n AS Mois FROM nums WHERE n BETWEEN 1 AND 12),
AnneesMois AS (SELECT * FROM Annees,Mois),
Data AS (SELECT DATEPART(year,SO.orderdate) AS Annee, 
			DATEPART(month,SO.orderdate) AS Mois,
			SUM(SOD.qty*SOD.unitprice) AS CA 
			FROM Sales.OrderDetails SOD
			INNER JOIN Sales.Orders SO ON SO.orderid=SOD.orderid
			WHERE SOD.productid=@IdProduit
			GROUP BY DATEPART(year,SO.orderdate), DATEPART(month,SO.orderdate)
			)
SELECT AM.Annee, AM.Mois, 
		ISNULL(D.CA,0) AS CA
FROM AnneesMois AM LEFT JOIN Data AS D
ON AM.Annee=D.Annee AND AM.Mois=D.Mois
ORDER BY AM.Annee,Am.Mois