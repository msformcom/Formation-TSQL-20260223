-- qty*unitprice

-- Colonne calculee => le calcul est réalisé à l'insert ou update
-- Sans persisted => calcul au moment du select
-- Avec persisted => le résultat est stocké => pas calcule sur select
ALTER TABLE Sales.orderdetails
ADD ammount AS qty*unitprice PERSISTED



SELECT * FROM Sales.OrderDetails