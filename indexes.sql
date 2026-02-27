-- Création d'un table destinée au tests de perf
CREATE TABLE Personnes(
	personid UNIQUEIDENTIFIER PRIMARY KEY DEFAULT newid(),
	nom NVARCHAR(50) NOT NULL ,
	prenom NVARCHAR(50) NOT NULL,
	Age INT DEFAULT RAND()*100
	)

INSERT INTO Personnes(nom,prenom)
--VALUES('u','v')
SELECT CHAR(RAND()*30+65)+nom, CHAR(RAND()*30+65)+prenom FROM Personnes

-- Optimisé par index par defaut cluster sur la clé
SELECT * FROM Personnes
WHERE personid='34027249-894E-4A37-9C78-00005508FDB7'

-- Pas optimisé sans index
SELECT * FROM Personnes
WHERE nom='UYU'

CREATE NONCLUSTERED INDEX IX_Nom ON Personnes(Nom)

-- Pas optimisé meme avec index car la selectivité est faible =>
-- Il devra lire de toute façon quasiment toutes les données
SELECT * FROM Personnes
WHERE nom!='UYU'

-- Recherche estimée pas assez selective => SCAN du cluster
SELECT * FROM Personnes WITH (INDEX(IX_NOM))
WHERE Nom LIKE 'd%'

-- Recherchée estimée assez selective => SEEK dans l'index
SELECT * FROM Personnes
WHERE Nom LIKE 'ra%'






SELECT SUBSTRING(NOM,1,2),COUNT(*) AS NB
FROM Personnes 
GROUP BY SUBSTRING(NOM,1,2) ORDER BY NB DESC

-- Index cluster sur Nom => Ok
SELECT  * FROM Personnes
ORDER BY Nom 

SELECT Prenom,Age, Nom FROM Personnes-- WITH(INDEX(IX_Prenom))
ORDER BY Prenom

DROP INDEX IX_Prenom ON Personnes

-- Index couvrant pour une requete de type
-- SELECT Prenom -- Cle index
-- Age colonne incluse
-- Nom Colone clé du cluster => elle est dans tous les index=> retrouver l'enregistrement
CREATE INDEX IX_Prenom ON Personnes(Prenom) INCLUDE(age)

SELECT * FROM Sales.Orders
SELECT * FROM Sales.Customers SC
INNER JOIN Sales.Orders SO on SO.custid=SC.custId


-- Sur sales.orderdetail
-- Index simples
-- 1 index cluster
-- Index + colonne incluse

-- Optimiser le calcul du CA par facture 1 000 000 lignes de facture 100 000 factures 77 produits
-- (*) Index cluster ?=> CREATE CLUSTERED INDEX IX_orderID ON Sales.Orderdetails(orderid)
-- Index ? => CREATE INDEX IX_orderID ON Sales.Orderdetails(orderid) Optimise pour 1 facture => 1 000 000 / 100 000 => 10 ligne
-- Index col incluse CREATE INDEX IX_orderID ON Sales.Orderdetails(orderid) INCLUDE(qty,unitprice) 
-- Optimiser le calcul du CA Par produit
-- Index cluster ?=> CREATE CLUSTERED INDEX IX_orderID ON Sales.Orderdetails(productid)
-- Index ? => CREATE INDEX IX_orderID ON Sales.Orderdetails(orderid) Optimise pour 1 produit => 1 000 000 /77 produits => 12000
-- (*) Index col incluse CREATE INDEX IX_orderID ON Sales.Orderdetails(productid) INCLUDE(qty,unitprice) 
-- optimiser la recherche des lignes avec discount
-- Index cluster ? NOn
-- Index ? Oui
-- Index col incluse

-- Insertions => 


