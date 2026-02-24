-- Types numériques
-- TINYINT 0-255 => 1 octet
-- SMALLINT -32756 +32768

DECLARE @nombre FLOAT=0
DECLARE @increment FLOAT=0.3
DECLARE @i INT =0

WHILE @i<10
BEGIN
 SET @nombre= @nombre+@increment
 SET @i=@i+1
END




-- Exemple
-- Dermande client découpe planche 200 => DECIMAL
DECLARE @MesureDemandee DECIMAL =3
-- Mesure laser après découpe => Float
DECLARE @MesureReelle FLOAT =200
IF @MesureDemandee>=@nombre-0.01 AND @MesureDemandee<=@nombre+0.01
BEGIN 
	PRINT CONVERT(DECIMAL(18,16),@nombre)
END 