-- Calculer la prime des employes
-- CA => 0 =>5000 => 5%
-- 5000 => 6000 => 6%
-- 6000 => 8000 => 7%
-- 8000 + => 10%

DROP TABLE HR.BaremePrimes
CREATE TABLE HR.BaremePrimes (
idbareme UNIQUEIDENTIFIER PRIMARY KEY DEFAULT Newid(),
seuil DECIMAL(18,2),
pourcentage DECIMAL(18,2))

INSERT INTO HR.BaremePrimes (seuil,pourcentage) VALUES(5000,0.05),(6000,0.06),(8000,0.07),(10000000000,0.1)

-- Création d'un type Table avec sa structure
CREATE TYPE HR.BaremePrimes AS TABLE(
	idbareme UNIQUEIDENTIFIER PRIMARY KEY DEFAULT Newid(),
	seuil DECIMAL(18,2),
	pourcentage DECIMAL(18,2))

	-- Declaration d'une variable de type Table HR.BaremePrimes
DECLARE @bareme HR.BaremePrimes

-- Création d'une table avec structure du type HR.BaremePrimes
SELECT * INTO HR.BaremePrimes FROM @bareme
INSERT INTO HR.BaremePrimes (idbareme,seuil,pourcentage) 
VALUES(newid(),5000,0.05),(newid(),6000,0.06),(newid(),8000,0.07),(newid(),10000000000,0.1)


-- Fonction de valcul des primes
CREATE FUNCTION HR.CalculPrimes(@date DATE, @bareme HR.BaremePrimes READONLY)
RETURNS TABLE
AS RETURN


	WITH CaEmployes AS (
	SELECT empid,
	SUM(qty*unitprice) AS CA
	FROM sales.OrderInfos
	WHERE YEAR(@date)=YEAR(orderdate) AND MONTH(@date)=MONTH(orderdate) 
	GROUP BY empid)
	SELECT
		CAE.*,
		CA*BP.pourcentage AS Prime
	
	FROM CaEmployes AS CAE 
	CROSS APPLY(SELECT TOP 1 * 
				FROM  @bareme BP WHERE BP.seuil>=CAE.CA ORDER BY BP.seuil ) AS BP


DECLARE @b HR.BaremePrimes
INSERT INTO @b 
SELECT * FROM HR.BaremePrimes 

SELECT * FROM HR.CalculPrimes('2007-12-01',@b)
-- Nom Employe, CA mois, MontantPrime

--Tables  Primes
-- empid,date, prime
CREATE TABLE HR.Primes(
	primeid UNIQUEIDENTIFIER PRIMARY KEY DEFAULT newid(),
	empid INT FOREIGN KEY REFERENCES HR.Employees(empid),
	date DATE NOT NULL,
	Montant DECIMAL(18,2)
)

-- Procedure stockee
CREATE OR ALTER PROC HR.InsertPrimes(@date DATE, @bareme HR.BaremePrimes READONLY)
AS
BEGIN
	-- !!!!!! Valider les paramètres
	IF EXISTS(SELECT * FROM HR.Primes WHERE YEAR(date)=YEAR(@date) AND MONTH(date)=MONTH(@date))
	BEGIN 
		;THROW 56000,'Les primes de ce mois ont déjà été distribuées',1
	END
	BEGIN TRY 
		-- Opérations à réaliser préférenciellement dans une transaction
		BEGIN TRAN
		INSERT INTO HR.Primes(date,empid,montant) 
		OUTPUT INSERTED.*
		SELECT @date,empid,prime FROM HR.CalculPrimes(@date,@bareme)
		-- Sans erreur => Commit
		COMMIT
	END TRY
	BEGIN CATCH
		ROLLBACK
		PRINT Error_Message() -- Message erreur Technique et peut contenir des infos sur la BDD
		-- Déclenchement d'une erreur avec message et numero choisi
		;THROW 16000,'Les primes de ce mois ont déjà été distribuées',1
	END CATCH

END

BEGIN TRY
	BEGIN TRAN 
	DECLARE @b HR.BaremePrimes
	INSERT INTO @b 
	SELECT * FROM HR.BaremePrimes 
	EXEC HR.InsertPrimes '2007-12-01',@b
	COMMIT
END TRY
BEGIN CATCH
	EXEC HR.InsertPrimes '2008-01-02',@b
	COMMIT
	-- GEstion erreur
END CATCH

--
SELECT * FROM HR.Primes
SELECT @@TRANCOUNT
ROLLBACK