-- Tableau permettant de modifier les prix
/*
| 10		| 1			| 5		|
| 20		| 1.5		| 6		|
| 50		| 3			| 9		|
| 1000000	| 10		| 10	|
*/

-- 1) Créer la table sous la forme d'une variable => @Bareme
-- 2) Créer une fonction qui prend en parametre Prix + @Bareme => Nouveau prix
-- 3) Créer un Procedure stockée => change le prix des produit

-- Déclaration de type 
CREATE TYPE PrecisionMonetaire FROM DECIMAL(18,2)
-- Type table
CREATE TYPE Bareme AS TABLE(
	Limite PrecisionMonetaire,
	Fixe PrecisionMonetaire,
	Percentage PrecisionMonetaire);

-- Déclaration de la variable
DECLARE @Bareme Bareme;
INSERT INTO @Bareme(Limite,Fixe,Percentage)
VALUES (10,1,0.05),(20,1.5,0.06),(50,3,0.09),(100000,10,0.1)

SELECT Helpers.CalculAugmentation(15,@Bareme)

CREATE OR ALTER FUNCTION Helpers.CalculAugmentation(
	@prix PrecisionMonetaire,
	@bareme Bareme READONLY
	)
	RETURNS PrecisionMonetaire
	AS BEGIN
		-- 	RETURN SELECT TOP 1 @Prix+fixe+@prix*pourcentage FROM Bareme WHERE limite > @prix ORDER BY Limite 
		-- Dans le corps de cette fonction
		-- Algorythmique
		-- Pas de INSERT, UPDATE, DELETE
		DECLARE @Fixe PrecisionMonetaire
		DECLARE @percentage PrecisionMonetaire
		SELECT TOP 1 @Fixe=fixe, @percentage=percentage FROM @Bareme WHERE limite > @prix ORDER BY Limite 
		RETURN @fixe+@prix*(1+@percentage)
	END



