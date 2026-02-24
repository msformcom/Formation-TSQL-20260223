-- Pour chaque produit vendu, je veux la difference entre le prix de vente du produit et son prix de vente catalogue
 -- Selection 1 (jointure) => With
 -- | Nom  produit | Prix catalogue | Prix Vente |

 -- Selection 2 (group by) =>
 -- | Nom  produit | Prix catalogue | Moyenne prix Vente | Moyenne dif |
 WITH Etape1 AS (
 SELECT PP.productname AS NomProduit, 
		PP.unitprice AS PrixCatalogue, 
		SOD.unitprice AS PrixVente,
		SOD.qty AS Quantite
 FROM Production.Products AS PP 
	INNER JOIN Sales.OrderDetails AS SOD ON PP.productid=SOD.productid
	),
	Etape2 AS (

SELECT	NomProduit, 
		PrixCatalogue,
		AVG(PrixVente) AS MoyennePrixNegocie,
		SUM(PrixVente*Quantite)/SUM(quantite) AS MoyennePrixVente
FROM Etape1
GROUP BY NomProduit, PrixCatalogue)
SELECT *, 
	PrixCatalogue-MoyennePrixNegocie AS ReductionNegocie,
	PrixCatalogue-MoyennePrixVente AS ReducVente
 FROM Etape2