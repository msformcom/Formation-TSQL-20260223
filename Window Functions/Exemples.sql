SELECT * ,
	ROW_NUMBER() OVER (ORDER BY unitprice ASC) AS ROwNumberPrix,
	RANK() OVER ( PARTITION BY Categoryid ORDER BY unitprice ASC) AS ClassementPrix,
	DENSE_RANK() OVER (ORDER BY unitprice ASC) AS ClassementDensePrix,
	MIN(unitprice) OVER(PARTITION BY categoryid) AS PrixMinCat,
	MAX(unitprice) OVER(PARTITION BY categoryid) AS PrixMaxCat,
	AVG(unitprice) OVER(PARTITION BY categoryid) AS PrixAvgCat,
	
	LAG(unitprice,1) OVER( PARTITION BY Categoryid ORDER BY unitprice ASC) PrixPrec,
	unitprice-LAG(unitprice,1) OVER( PARTITION BY Categoryid ORDER BY unitprice ASC) AS DiffPrixPrec,
	unitprice AS PrixLigne,
	LEAD(unitprice) OVER( PARTITION BY Categoryid ORDER BY unitprice ASC) PrixSuiv


FROM Production.Products
ORDER BY categoryid, unitprice

SELECT Year, 
		Month, 
		Day, 
		Date,
		CA,
		ROW_NUMBER() OVER(ORDER BY CA) AS ROWNumber,
		RANK() OVER (ORDER BY CA DESC) AS RANKCA,
		SUM(CA) OVER ( PARTITION BY Year ORDER BY Date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS CUMULAN,
		AVG(CA) OVER ( PARTITION BY Year ORDER BY Date ROWS BETWEEN 3 PRECEDING AND 1 PRECEDING) AS MoyGlissante

		FROM Sales.GetCAByDay('2006-07-01','2008-06-30')
	ORDER BY Date