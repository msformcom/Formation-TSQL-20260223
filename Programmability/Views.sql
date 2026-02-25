-- Création de schémas (pour organiser les objets que je créé)
CREATE SCHEMA Helpers


-- Création d'une vue
CREATE OR ALTER VIEW Helpers.Intervalles
AS
SELECT * 
FROM (VALUES(0,5),(5,10),(10,20),(20,50),(50,100),(100,200),(200,10000000)) AS T(Min,Max)


-- Deuxième view => On aimerait des paramètres
CREATE VIEW Helpers.AnneesMois20062008
AS 
WITH Annees AS (SELECT n AS Annee FROM nums WHERE n BETWEEN 2006 AND 2008),
Mois AS (SELECT n AS Mois FROM nums WHERE n BETWEEN 1 AND 12)
SELECT * FROM Annees,Mois

SELECT * FROM Helpers.AnneesMois20062008



-- Fonction de type table => View avec Paramètres
CREATE OR ALTER FUNCTION Helpers.AnneeMois(
	 @annee_debut INT,
	 @annee_fin INT) 
	 RETURNS TABLE AS RETURN
WITH Annees AS (SELECT n AS Annee FROM nums WHERE n BETWEEN @annee_debut AND @annee_fin),
Mois AS (SELECT n AS Mois FROM nums WHERE n BETWEEN 1 AND 12)
SELECT * FROM Annees,Mois 

SELECT * FROM Helpers.AnneeMois(2000, DATEPART(year,GETDATE()))


-- Vue des revenus avec utilisation de anneeMois
CREATE OR ALTER VIEW Sales.RevenueInfos AS

WITH Selection AS (SELECT DatePart(year,orderdate) AS Year, 
		DATEPART(month,orderdate) AS Month,
		SUM(qty*unitprice) AS GrossRevenue,
		COUNT(DISTINCT orderid) AS OrderCount
FROM Sales.OrderInfos
GROUP BY DatePart(year,orderdate), DATEPART(month,orderdate)) 
SELECT AM.Annee,
		Am.mois, 
		ISNULL(GrossRevenue,0) AS GrossRevenue,
		ISNULL(Ordercount,0)  AS OrderCount
FROM Helpers.AnneeMois(
	(SELECT DATEPART(year,Min(orderdate)) FROM Sales.orders),
	(SELECT DATEPART(year,MAX(orderdate)) FROM Sales.orders)) AS AM
LEFT JOIN Selection AS S ON AM.Annee=S.Year AND AM.Mois=S.Month


SELECT * FROM Sales.RevenueInfos