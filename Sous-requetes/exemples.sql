-- Sous requètes
-- Nb Commandes pour custid=4
SELECT COUNT(SO.orderid) FROM Sales.Orders AS SO WHERE SO.custid=4

DECLARE @minPrice Money =(SELECT Min(unitprice) FROM Production.Products)
DECLARE @maxPrice Money =(SELECT Max(unitprice) FROM Production.Products)
SELECT @minPrice

DECLARE @minPrice2 Money
DECLARE @maxPrice2 Money
SELECT @MinPrice2=Min(unitprice), @maxPrice2=Max(unitprice) FROM Production.Products
SELECT @minPrice2, @maxPrice2


DECLARE @CA Money=0
SELECT @ca=@ca+qty*unitprice FROM Sales.OrderDetails
SELECT @CA


SELECT  
	SC.custid,
	SC.companyname,
	(SELECT COUNT(SO.orderid) FROM Sales.Orders AS SO WHERE SO.custid=SC.custid) AS NbCommandes
FROM Sales.Customers AS SC
ORDER BY SC.custid