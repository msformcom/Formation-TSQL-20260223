-- Analyse de ce batch
USE TSQL
GO
-- Le batch précédent est exécuté avant analyse de la suite
SELECT * FROM HR.Employees;

-- Bonnes pratiques : Alias sur table + Préfixe sur les colonnes
SELECT	E.lastname AS Nom,
		E.firstname AS Prenom,
		E.city + ' '+E.region AS CityRegion,
		CONCAT(E.City,' ',E.region) AS CityRegion,
		CONCAT(
				ISNULL(E.City,''),
				IIF(E.City IS NULL OR E.region IS NULL ,'',' '),
				ISNULL(E.Region,'')) AS CityRegion
		FROM HR.Employees AS E

SELECT * FROM HR.Employees WHERE null IS null

DBCC FREESYSTEMCACHE('ALL')
DBCC DROPCLEANBUFFERS
SET STATISTICS IO ON
-- La liste des employés avec leur adresse en une seule colonne
-- Adresse + Retourchariot + Code postal + espace + ville + retour chariot + (Region  country)
SELECT	E.lastname AS Nom,
		E.firstname AS Prenom,
		Datediff(year,E.hiredate,Getdate()) AS Anciennete,
		CASE WHEN Datediff(year,E.hiredate,Getdate()) <10 THEN 'Junior'
				WHEN Datediff(year,E.hiredate,Getdate()) <20 THEN 'Médior'
				ELSE 'Sénior' END
		--CONCAT( E.Address, 
		--		CHAR(10),
		--		Postalcode,
		--		' ',
		--		E.city,
		--		CHAR(10),
		--		ISNULL(E.region,''),
		--		IIF(E.region IS NULL ,'',' '),
		--		E.Country) AS CityRegion
		FROM HR.Employees AS E 


-- SQL => Structured Query Language
-- Objectif du langage => etre proche du language parlé
-- Différence avec le plan d'éxécution
-- Syntaxe => SELECT avec alias => FROM => WHERE => ORDER BY
-- FROM => WHERE => SELECT => ALIAS => ORDER BY 

SELECT D.*,
CASE WHEN D.Anciennete <10 THEN 'Junior'
				WHEN D.Anciennete <20 THEN 'Médior'
				ELSE 'Sénior' END AS Anciennete
 FROM (
SELECT	E.lastname AS Nom,
		E.firstname AS Prenom,
		Datediff(year,E.hiredate,Getdate()) AS Anciennete
		FROM  HR.Employees AS E ) AS D


DBCC FREEPROCCACHE
-- Déclarer les données statiques utilisées dans la requète
-- Limite haute junior
DECLARE @Limite1 INT =12
-- Limite haute Médior
DECLARE @Limite2 INT =20

;WITH D AS (SELECT	E.lastname AS Nom,
		E.firstname AS Prenom,
		Datediff(year,E.hiredate,Getdate()) AS Anciennete
		FROM  HR.Employees AS E)

SELECT D.*,
CASE WHEN D.Anciennete <@Limite1 THEN 'Junior'
				WHEN D.Anciennete <@Limite2 THEN 'Médior'
				ELSE 'Sénior' END AS Anciennete
 FROM D


