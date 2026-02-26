-- Types de chaine
DECLARE @chaineVC VARCHAR(20)='Chien' --=> Taille variable => 5 octets + 2 octets fin de chaine
DECLARE @chaineC CHAR(20)='Chien' --=> Taille fixe => 20 octets => gestion disque plus simple

-- Coupe la valeur si variable
SET @chaineVC='987987229872927982792892872982982987298928892787'
-- Dans une colonne => erreur
UPDATE Production.Products SET productname='AHKAKJAHKAHKA IAUAIUA IUAYIAU IUA AIAIUA UIAAIUAY IU AYIU AUIAIAUYIAUA IAUIAU YAIUA AIU ' WHERE productid=1;

SELECT @chaineVC+'*'

-- NVARCHAR => Encodage Unicode VS encodage ASCII
-- ASCII => 1 caractere => 1 Octet de 128-255 caractères spéciaux dépendant du Pays
SET @chaineVC='René' -- => Code 12 56 87 165 (165 si é est spécifique FR)
-- Si chaineVC est affiché sur un poste danois => Renô => (165 => ô en DK)

DECLARE @chaineVC2 VARCHAR(50)
SET @chaineVC2=N'かき'
SELECT @chaineVC2


DECLARE @chaineNVC2 NVARCHAR(50)
SET @chaineNVC2=N'かき'
SELECT @chaineNVC2


-- Unicode => encodage sur 1, 2 , 3 ou 4 octets => 1 seul encodage par caractère
DECLARE @chaineNVC NVARCHAR(20)='Chien'



