-- SELECT de base
-- Colonnes : Uniquement caractères latins, pas d'accents, _
SELECT	1 AS [Col 1] , 
		2+2 AS 'Col2',
		2+7 AS "Col 3" 

-- Liste des BDD => vue métadonnées

-- Liste des BDD de cette instance
SELECT name FROM sys.databases

-- Changer de contexte => aller sur une BDD en particulier
USE TSQL -- Toujours commencer par spécifier la BDD de travail

-- Liste des tables
SELECT * FROM sys.tables

-- Liste des schemas
SELECT * FROM sys.schemas

-- dbo est généralement le schema par défaut => peut être modifié par utilisateur
SELECT * FROM Nums

-- Bonne pratique : Mettre systématiquement le nom du schema
SELECT * FROM HR.employees

-- Chercher les données dans un autre contexte de bdd
SELECT * FROM  AdventureWorks.Person.Address

-- Chercher des données sur une autre instance
-- Condition : Avoir créé un server lié
SELECT * FROM [MIA-SQL\SQL2].reportserver.dbo.datasets

