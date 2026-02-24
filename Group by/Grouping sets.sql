-- TP : Par categorie, par produit et par an et mois => montant des vente

-- => orders, orderdetails, products, categories
-- Cumuls par categorie, produit, annee
-- | IdCategorie | Nom Cat | IdProduit  | Nom produit | Annee  | CA


SELECT		PC.categoryid, PC.categoryname,
			PP.productid, PP.productname,
			DATEPART(year,SO.orderdate) AS Annee,
			SUM(SOD.unitprice*SOD.qty) AS MontantVentes
			
FROM Production.Categories PC		
INNER JOIN Production.Products PP ON PC.categoryid=PP.categoryid
INNER JOIN Sales.OrderDetails SOD ON SOD.productid=PP.productid
INNER JOIN Sales.Orders SO ON SO.orderid=SOD.orderid
 GROUP BY GROUPING SETS(
	(), -- Total
	(DATEPART(year,SO.orderdate)), -- Par annee
	(PC.categoryid, PC.categoryname), -- Par catégorie
	(PC.categoryid, PC.categoryname, DATEPART(year,SO.orderdate)), -- Cat et année
	(PC.categoryid, PC.categoryname,PP.productid, PP.productname), -- Produit
	(PC.categoryid, PC.categoryname,PP.productid, PP.productname,DATEPART(year,SO.orderdate)) -- Produit et Annee
)
