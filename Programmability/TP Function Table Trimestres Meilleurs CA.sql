-- Création de vue permettant d'avoir les données trimestre / mois
CREATE VIEW Helpers.QuarterMonths AS
SELECT (n-1)/3+1 AS Quarter, n AS Month FROM dbo.Nums WHERE n BETWEEN 1 AND 12

-- Ajout de la colonne Année pour 2008 => Année | Trimestre | Mois
CREATE OR ALTER FUNCTION GetInfosSales(
	@Year INT,
	@Catid INT
) RETURNS TABLE AS RETURN
SELECT @Year AS Year,
		HQM.* ,
		TopCA.*
FROM Helpers.QuarterMonths AS HQM
CROSS APPLY (

-- Pour °1/2008
SELECT TOP 3 PP.productid, SUM(SOI.qty*SOI.unitprice) AS CA FROM Sales.OrderInfos SOI
INNER JOIN Production.Products PP ON PP.productid=SOI.productid
WHERE DATEPART(year,orderdate) =@Year AND DATEPART(Month,orderdate)=HQM.Month
	AND PP.categoryid=@Catid
GROUP BY PP.productid
ORDER BY CA DESC ) AS TopCA

-- Liste des meilleures ventes par mois pour 2008 categorie 2
SELECT * FROM GetInfosSales(2008,2)