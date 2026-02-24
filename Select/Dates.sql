
SELECT *, FirstName AS Nom,
		LastName AS Prenom
FROM [HR].[Employees]
WHERE BirthDate BETWEEN '01/02/1960' AND '01/02/1970'
ORDER BY Nom ASC, Prenom DESC

SELECT *, FirstName AS Nom,
		LastName AS Prenom
FROM [HR].[Employees]
WHERE country IN ('USA','UK')
ORDER BY Nom ASC, Prenom DESC

SELECT *, FirstName AS Nom,
		LastName AS Prenom
FROM [HR].[Employees]
WHERE country IN (SELECT country FROM [Sales].[Customers] WHERE custid=1)
ORDER BY Nom ASC, Prenom DESC





-- Attention ! Obligatoire !!!!!
SET DATEFORMAT DMY
SELECT CONVERT(datetime2,'1960-02-01 16:17:00.657')
DROP TABLE MesDates
CREATE TABLE MesDates (
	Date DATETIME2
)
-- Insertion avec nom de colonnes spécifiés
INSERT INTO MesDates(Date)
VALUES('1960-01-01 16:17:00.657'),
		('1960-12-31 16:17:00.657'),
		('1961-01-01 00:00:00')

-- Avec les dates éviter à tout prix BETWEEN
SELECT * FROM MesDates WHERE Date >= '1960-01-01' AND DATE < '1961-01-01'