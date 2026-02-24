SELECT	categoryid, -- Colonnes incluses dans la clause GROUP BY
		MIN(unitprice) AS Minimum, -- Des colonnes aggregées par fonctions aggragation
		MAX(unitprice) AS Maximum,
		SUM(unitprice) AS Somme,
		COUNT(*) AS NBEnregistrements,
		COUNT(discontinued) AS NbValeurNonnullesDiscontinued,
		COUNT(DISTINCT unitprice) AS NbPrixDistinct
 FROM [Production].[Products]
GROUP BY categoryid


-- Informations sur les ventes produits
-- | productid | moyenne du prix de vente | Nombre produits vendus | CA généré
-- ordre par CA desc
-- Seulement les produits dont le prix est > 5
-- Seulement si plus de 10 produits vendus

SELECT SOD.productid AS ProductId,
		AVG(SOD.unitprice) AS r, -- 2 ventes =>  9 a 10€ et 1 a 100 => 55
		SUM(SOD.unitprice*qty)/SUM(qty) AS MoyennePrixVente, --19
	SUM(qty) AS NbUnits,
	SUM(unitprice*qty) AS CA
FROM [Sales].[OrderDetails] SOD
WHERE unitprice>5 
GROUP BY productid
HAVING SUM(qty)>1000
ORDER BY CA DESC
-- FROM => WHERE => GROUP => HAVING => SELECT => ALIAS => ORDER BY
