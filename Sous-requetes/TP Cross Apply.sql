
-- Annee - Mois - CA - NombreEmploye - NomProduitPlusGrosCA - CA de ce produit


-- Obtenir le produit avec le plus gros CA pour Une annee donnée et un mois donne
-- Annee 2007, Mois Février
SELECT TOP 1 PP.productid, 
		PP.productname AS NomProduit,
		SUM(SOD.qty*SOD.unitprice) AS CA
FROM 
Sales.OrderDetails SOD 
INNER JOIN Sales.Orders AS SO ON SO.orderid=SOD.orderid
INNER JOIN Production.Products PP ON SOD.productid=PP.productid
WHERE DATEPART(year,orderdate)=2007 AND DATEPART(month,orderdate)=02
GROUP BY PP.productid, PP.productname
ORDER BY CA DESC

-- Orders - OrderDetails - Produit
WITH Jointure AS (
SELECT Datepart(year,SO.orderdate) AS Annee, 
		Datepart(month, SO.orderdate) AS mois,
		SOD.qty*SOD.unitprice AS Montant,
		empid

FROM Sales.Orders AS SO
INNER JOIN Sales.OrderDetails AS SOD ON SO.orderid=SOD.orderid)
, Group1 AS (
SELECT Annee,
	Mois, 
	SUM(Montant) AS CA,
	COUNT(DISTINCT empid) AS NbEmployes
FROM Jointure
GROUP BY Annee,Mois)
SELECT G.*,
		CAProd.NomProduit AS ProduitPlusGrosCA,
		CAProd.CA AS CAProduit
 FROM Group1 AS G
CROSS APPLY (SELECT TOP 1 PP.productid, 
		PP.productname AS NomProduit,
		SUM(SOD.qty*SOD.unitprice) AS CA
		FROM 
		Sales.OrderDetails SOD 
		INNER JOIN Sales.Orders AS SO ON SO.orderid=SOD.orderid
		INNER JOIN Production.Products PP ON SOD.productid=PP.productid
		WHERE DATEPART(year,orderdate)=G.Annee AND DATEPART(month,orderdate)=G.mois
		GROUP BY PP.productid, PP.productname
		ORDER BY CA DESC) AS CAProd
ORDER BY Annee,Mois


