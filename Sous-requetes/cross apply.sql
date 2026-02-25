-- par produit je veux 

-- avec sous-requetes ( + jointures si motivé)
-- | Nom produit | Prix catalogue | Montant des ventes | Date premiere vente | Date Derniere Vente | Moyenne qty par mois |
WITH Etape1 AS(
Select 
	PP.productname,
	PP.unitprice,
	(Select SUM(unitprice*qty) From [Sales].[OrderDetails] as SOD Where SOD.productid=PP.Productid) as MontantVentes,
	(Select SUM(qty) From [Sales].[OrderDetails] as SOD Where SOD.productid=PP.Productid) as QuantiteVendue,
	(Select Min(Orderdate) From [Sales].[Orders] as SO 
		Inner Join [Sales].[OrderDetails] as SOD on SO.orderid = SOD.Orderid
		WHERE SOD.productid=PP.productid) As Mindate,
	(Select Max(Orderdate) From [Sales].[Orders] as SO 
		Inner Join [Sales].[OrderDetails] as SOD on SO.orderid = SOD.Orderid
		WHERE SOD.productid=PP.productid ) As Maxdate
From [Production].[Products] as PP
)
SELECT *, QuantiteVendue/DATEDIFF(month, MinDate,MaxDate), DATEDIFF(month, MinDate,MaxDate) FROM Etape1



-- Avec les sous-requetes on ne peut pas calculer deux colonnes en meme temps
-- Intégrer plusieurs colonne d'une sous-requete dans une requète principale avec CROSS APPLY
Select 
	PP.productname,
	PP.unitprice,
	(Select SUM(unitprice*qty) From [Sales].[OrderDetails] as SOD Where SOD.productid=PP.Productid) as MontantVentes,
	(Select SUM(qty) From [Sales].[OrderDetails] as SOD Where SOD.productid=PP.Productid) as QuantiteVendue,
	SR.MinDate,
	SR.MaxDate
From [Production].[Products] as PP
CROSS APPLY (Select Min(Orderdate) AS MinDate  , 
					Max(Orderdate) AS MaxDate From [Sales].[Orders] as SO 
		Inner Join [Sales].[OrderDetails] as SOD on SO.orderid = SOD.Orderid
		WHERE SOD.productid=PP.productid) AS SR

		-- Sous-requetes => eviter trop de jointures ou explosision cartésienne => si cardinalités des relation pas bonne