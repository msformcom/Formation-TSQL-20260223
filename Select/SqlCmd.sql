-- Liste des produits 
-- | Nom | Prix unitaire | Prix Vente |
-- Nom en majuscule avec (Indisponible) si indisponible
-- Prix unitaire
-- Prix vente	=> si prix unitaire < 50 => prix unitaire +10
--				=> 50-100 => 10€ +prixunitaire *1.05
--				=> 100+ => prixunitaire * 1.15

-- Valeurs par défaut pour l'exécution par script (sqlcmd)
:setvar l1 50
:setvar l2 100

-- Valeurs de paramètre pour la requête
DECLARE @Limite1 DECIMAL(18,2)=$(l1)
DECLARE @Limite2 DECIMAL(18,2)=$(l2)

SELECT CONCAT(
		UPPER(PP.productname),
		IIF(PP.discontinued=1,' (Indisponible)','')
		)  AS NOM,
		PP.unitprice AS [Prix unitaire],
		CASE WHEN PP.unitprice<@Limite1  THEN PP.unitprice+10
			WHEN PP.unitprice<@Limite2 THEN PP.unitprice*1.05+10
			ELSE PP.unitprice*1.15 END AS [Prix vente]
FROM [Production].[Products] AS PP
