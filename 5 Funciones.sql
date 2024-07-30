
/*	
Implementación de Funciones:
*/

-- calcula la duracion del anime en DIAS.
CREATE OR ALTER FUNCTION FX_DuracionAnimeDIAS (@AiredDate DATE, @FinishedDate DATE)
RETURNS INT
AS
BEGIN
    RETURN DATEDIFF(DAY, @AiredDate, @FinishedDate)
END

-- calcula la duracion del anime en MESES.
CREATE OR ALTER FUNCTION FX_DuracionAnimeMESES (@AiredDate DATE, @FinishedDate DATE)
RETURNS INT
AS
BEGIN
    RETURN DATEDIFF(MONTH, @AiredDate, @FinishedDate)
END

--

SELECT
	Name,
	dbo.FX_DuracionAnimeDIAS (aired_date, finished_date) AS Dias,
	dbo.FX_DuracionAnimeMESES (aired_date, finished_date) AS Meses
FROM
	animerank
WHERE
	Name = 'Sousou no Frieren'

--

select * from animerank