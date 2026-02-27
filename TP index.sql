USE [TSQL]
GO

INSERT INTO [Sales].[Customers]
           ([companyname]
           ,[contactname]
           ,[contacttitle]
           ,[address]
           ,[city]
           ,[region]
           ,[postalcode]
           ,[country]
           ,[phone]
           ,[fax])


SELECT 
      [companyname]
      ,[contactname]
      ,[contacttitle]
      ,[address]
      ,[city]
      ,[region]
      ,[postalcode]
      ,[country]
      ,[phone]
      ,[fax]
  FROM [Sales].[Customers]
GO

-- Lister les client => noter l'ordre par défaut
-- Rechercher les clients dans un pays,region, ville
-- Inspecter le plan execution + subtreecost

-- Modifier l'ndex sur la cle => non cluster
-- Créer un index cluster sur Pays, region, ville
-- Lister les client => noter l'ordre par défaut
-- rejouer la requete de recherche et comparer

-- Avec index Country Region Ville
SELECT * FROM Sales.Customers
WHERE Country='USA' AND region='MT' AND city='Butte'

-- Requete pas optimisée mais en plus fausse
SELECT * FROM Sales.Customers
WHERE city='Butte'

CREATE CLUSTERED INDEX IX_CRV ON Sales.customers(Country,Region,City)

SELECT