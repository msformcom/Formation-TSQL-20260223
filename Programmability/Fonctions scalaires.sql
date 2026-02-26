-- SELECT
-- Par produit Nom produit - Moyenne du prix de vente - Commentaire
-- unitprice <10 => Bon marché <50 Prix moyen sinon Cher

SELECT PP.productid, 
		PP.productname,
		CASE WHEN AVG(SOD.unitprice)<10 THEN 'Bon marché'
			WHEN AVG(SOD.unitprice)<50 THEN 'Prix moyen'
			ELSE 'Cher' END AS Commentaire,
		AVG(SOD.unitprice) PrixVenteMoyen
FROM Production.Products PP 
INNER JOIN Sales.OrderDetails SOD ON SOD.productid=PP.productid
GROUP BY PP.productid, PP.productname

-- Fonction scalaire => renvoit une seule valeur
CREATE OR ALTER FUNCTION Helpers.CommentairePrix(
	@prix DECIMAL(18,2)
	)
	RETURNS NVARCHAR(100)
	AS BEGIN
	
		RETURN CASE WHEN @prix<10 THEN 'Bon marché'
				WHEN @prix<50 THEN 'Prix moyen'
				ELSE 'Cher' END

	END

SELECT PP.productid, 
		PP.productname,
		Helpers.CommentairePrix(AVG(SOD.unitprice)) AS Commentaire,
		AVG(SOD.unitprice) PrixVenteMoyen
FROM Production.Products PP 
INNER JOIN Sales.OrderDetails SOD ON SOD.productid=PP.productid
GROUP BY PP.productid, PP.productname

SELECT *, 
Helpers.CommentairePrix(PP.unitprice) AS commentaire
FROM Production.Products PP




