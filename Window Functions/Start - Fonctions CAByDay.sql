SELECT * FROM Helpers.GetCaByDay('2024-01-01','2024-12-31')

-- Création de fonction
CREATE OR ALTER FUNCTION Helpers.GetAllDays(
@Date_Debut DATE,
@Date_Fin DATE) RETURNS 

 @AllDays TABLE(
	Year INT,
	Month INT,
	Day INT,
	Date DATE) AS 
	BEGIN
		WHILE @Date_Debut<= @Date_Fin
		BEGIN
			INSERT INTO @AllDays(year,month,day,date)
			VALUES(
				DATEPART(year,@Date_Debut),
				DATEPART(month,@Date_Debut)
				,DATEPART(day,@Date_Debut),
				@Date_Debut
				)
			SET @Date_Debut=DATEADD(day,1,@date_debut)
		END
		RETURN
	END

CREATE OR ALTER  FUNCTION Sales.GetCAByDay(
@Date_Debut DATE,
@Date_Fin DATE)
	RETURNS TABLE AS RETURN 
SELECT Dates.Year, 
		Dates.Month,
		Dates.Day, 
		ISNULL(SUM(SOI.qty*SOI.unitprice),0) AS CA,
		COUNT(DISTINCT SOI.orderid) AS NbCommandes,
		ISNULL(SUM(SOI.qty),0) AS Quantite
		FROM Helpers.GetAllDays(@Date_Debut,@Date_Fin) AS Dates
LEFT JOIN Sales.OrderInfos SOI ON Dates.date=CONVERT(Date,SOI.orderdate)
GROUP BY Dates.Year, Dates.Month,Dates.Day

SELECT * FROM Sales.GetCAByDay('2006-07-01','2008-06-30')