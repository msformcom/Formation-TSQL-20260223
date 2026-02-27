SELECT * FROM HR.primes

-- Update d'une table (Primes) en utilisant des données d'une autre table

UPDATE HRP
SET montant=ca*0.1
--SELECT *
FROM HR.primes AS HRP INNER JOIN
(SELECT empid, 
		SUM(qty*unitprice) AS CA,
		SUM(qty*unitprice)*0.1 AS Prime
FROM Sales.OrderInfos 
WHERE YEAR(orderdate)=2007 AND MONTH(orderdate)=12
GROUP BY empid) AS V ON HRP.empid=V.empid
