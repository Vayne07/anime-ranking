/* LIMPIEZA DE DATOS. (paso a paso de como llevo a cabo un proceso de limpieza de datos)

1) Comprender los datos.
2) Identificar y manejar valores nulos o faltantes.
3) Detectar y corregir errores de entrada.
4) Estandarizar formatos de datos.
5) Resolver inconsistencias y redundancias.
6) Eliminar duplicados.
7) Validar la integridad referencial.
8) Documentar los cambios realizados.


2) VALORES NULOS EN "SOURCE":
	teniendo en cuenta la siguiente consulta tome la decision de no cambiar estos NULLS (32%).
*/

SELECT 
    source,
    cantidad,
    CAST(cantidad * 100.0 / cnt AS DECIMAL(10, 2)) AS porcentaje
FROM
	(SELECT
        source,
        COUNT(*) AS cantidad,
        (SELECT COUNT(*) FROM animerank) AS cnt
    FROM
        animerank
    GROUP BY
        source) AS t1
ORDER BY
	porcentaje DESC


/*
2) VALORES NULOS EN "GENRES":
	teniendo en cuenta la siguiente consulta tome la decision de no cambiar estos NULLS (23%).
*/

SELECT 
    genres,
    cantidad,
    CAST(cantidad * 100.0 / cnt AS DECIMAL(10, 2)) AS porcentaje
FROM
	(SELECT
        genres,
        COUNT(*) AS cantidad,
        (SELECT COUNT(*) FROM animerank) AS cnt
    FROM
        animerank
    GROUP BY
        genres) AS t1
ORDER BY
	porcentaje DESC

/*
2) VALORES NULOS EN "PREMIERED" Y "BROADCAST" Y NORMALIZACION DE "AIRED":

	Voy a crear un campo nuevo "FINISHED", luego separar la informacion de "AIRED" para pasar todo a fecha y asi tener mas info.
	Luego usar rangos de fechas para imputar "PREMIERED" y ponerle la temporada (summer, fall, winter, spring).
	Desde el campo "AIRED" voy a extraer el dia de estreno para imputar "BROADCAST" con el dia de la semana.
*/

-- creo el campo donde va a estar la fecha de finalizacion.
ALTER TABLE animerank ADD finished VARCHAR(50)

-- recorto el string, desde la parte de la fecha que me interesa.
UPDATE
	animerank
SET 
	finished = SUBSTRING(aired, CHARINDEX('to', aired) + 3, LEN(aired))
WHERE
	CHARINDEX('to', aired) > 0

-- cambio los ultimos valores que me sobraron con el signo de pregunta.
UPDATE
	animerank
SET
	finished = NULL
WHERE
	finished like '?'

-- creo un nuevo campo pero tipo FECHA
ALTER TABLE animerank ADD finished_date DATE

-- ubico los datos deseados en el nuevo campo pasandolos a tipo FECHA.
UPDATE
	animerank
SET
	finished_date = TRY_CAST(finished AS DATE)

-- borro el campo anterior.
ALTER TABLE animerank DROP COLUMN finished

-- recorto el string del campo "aired" para dejar solamente la fecha.
UPDATE
	animerank
SET
	aired = SUBSTRING(aired, 0, CHARINDEX('to', aired) -1)
WHERE
	CHARINDEX('to', aired) > 0

-- creo el campo nuevo donde va a estar la fecha de inicio.
ALTER TABLE animerank ADD aired_date DATE

-- ubico los datos deseados en el nuevo campo pasandolos a tipo FECHA.
UPDATE
	animerank
SET
	aired_date = TRY_CAST(aired AS DATE)

-- borro el campo "aired".
ALTER TABLE animerank DROP COLUMN aired

-- imputacion del campo "premiered", puse condicionales para extraer fechas y ponerle las temporadas.
UPDATE
	animerank
SET
	premiered = CASE
					WHEN DATEPART(MONTH, aired_date) BETWEEN 1 AND 3 THEN 'Winter ' + DATENAME(YEAR, aired_date)
					WHEN DATEPART(MONTH, aired_date) BETWEEN 4 AND 6 THEN 'Spring ' + DATENAME(YEAR, aired_date)
					WHEN DATEPART(MONTH, aired_date) BETWEEN 7 AND 9 THEN 'Summer ' + DATENAME(YEAR, aired_date)
					WHEN DATEPART(MONTH, aired_date) BETWEEN 10 AND 12 THEN 'Fall ' + DATENAME(YEAR, aired_date)
				END
WHERE
	premiered IS NULL

					

-- imputacion del campo "broadcast", puse el nombre del dia de estreno para tener una referencia de que dia se emite.

UPDATE
	animerank
SET
	broadcast = DATENAME(WEEKDAY, aired_date)
WHERE
	broadcast IS NULL OR broadcast LIKE 'Unknown'


/*
3) Detectar y corregir errores de entrada:
	No considero que haya errores de entrada para corregir.

4) Estandarizar formatos de datos:
	Ya realice una normalizacion en el campo inicial "aired" y luego cambie el tipo de dato a DATE.

5) Resolver inconsistencias y redundancias:
	No considero que haya incosistencias y redundancias para resolver.
*/

-- 6) Eliminar duplicados:
-- corroboro el campo "name" y efectivamente hay 2 valores duplicados.
SELECT
	name,
	COUNT(*) cnt
FROM
	animerank
GROUP BY
	name
ORDER BY
	cnt DESC

-- reviso en detalle el primer duplicado, falsa alarma.
SELECT
	*
FROM
	animerank
WHERE
	name LIKE '%gintama%'

-- reviso en detalle el segundo duplicado, falsa alarma.
SELECT
	*
FROM
	animerank
WHERE
	name LIKE '%working%'

/*
7) Validar la integridad referencial:
	Al ser una tabla sola no puedo realizar un chequeo.

8) Documentar los cambios realizados:
	El paso a paso fue documentado.
*/