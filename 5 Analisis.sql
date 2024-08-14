/*
En esta seccion de analisis voy a realizar multiples consultas en busqueda de informacion relevante.

Primero explicar algunos campos relevantes:
FAVORITES: la cantidad de usuarios que marcaron el anime como favorito.
POPULARIDAD: la interaccion que tiene la gente con el anime, por ejemplo, marcarlo como favorito,
cambiar su estado (watching, completed, on hold, dropped, plan to watch).
SCORE: es el promedio de todas las calificaciones de los usuarios a ese anime.
RANKED: esta asociado directamente al campo SCORE, ej: ranked #1 = el SCORE mas alto.
*/

-- TOP 10 animes mejor posicionados.
SELECT
	TOP 10 name,
	ranked
FROM
	animerank
ORDER BY
	ranked


-- Animes con calificacion arriba de 9:
/* 
Vemos como el puntaje no esta relacionado directamente con otros campos como la popularidad o los favoritos.
El anime #1 no entra ni en el top 100 de los mas populares, 
*/
SELECT
	name,
	score,
	popularity,
	favorites
FROM
	animerank
WHERE
	score >= 9
ORDER BY
	score DESC


/*
Por otra parte, entre los campos popularity y favorites SI existe una correlacion.
*/
SELECT
	name,
	popularity,
	favorites,
	CONCAT('#', ranked) ranked
FROM
	animerank
ORDER BY
	popularity


/*
Los anime con mayor cantidad de episodios, junto a su estado y años de emision.
*/
SELECT
	name,
	status,
	CASE
		WHEN status = 'Finished Airing' THEN DATEDIFF(YEAR, aired_date, finished_date)
		WHEN status = 'Currently Airing' THEN DATEDIFF(YEAR, aired_date, GETDATE())
	END AS years,
	episodes
FROM
	animerank
ORDER BY
	episodes DESC



/*
Cantidad de animes emitidos por año.
*/
SELECT
	RIGHT(premiered, 4) premiered,
	COUNT(*) cnt
FROM
	animerank
GROUP BY
	RIGHT(premiered, 4)
ORDER BY
	cnt DESC



/*
Dias de emision mas frecuentes.
*/
SELECT
	CASE
		WHEN CHARINDEX(' ', broadcast) > 0 THEN SUBSTRING(broadcast, 0, CHARINDEX(' ', broadcast) -1)
		ELSE broadcast
	END days,
	COUNT(*) cnt
FROM
	animerank
GROUP BY
	CASE
		WHEN CHARINDEX(' ', broadcast) > 0 THEN SUBSTRING(broadcast, 0, CHARINDEX(' ', broadcast) -1)
		ELSE broadcast
	END
HAVING
	COUNT(*) > 3 
ORDER BY
	cnt DESC



/*
Cantidad de anime por genero.
*/
WITH CTE_genres AS
	(SELECT 
        TRIM(value) AS genero
    FROM 
        animerank
    CROSS APPLY 
        STRING_SPLIT(genres, ','))

SELECT 
    genero,
    COUNT(*) AS cnt
FROM 
    CTE_genres
GROUP BY 
    genero
ORDER BY 
    cnt DESC



/*
Anime del mismo ESTUDIO, que tienen una popularidad similar (diferencia de 10 puntos).
*/
SELECT 
    t1.name AS Anime1, 
    t2.name AS Anime2, 
    t1.studios AS Estudio,
    t1.popularity AS Popularidad1, 
    t2.popularity AS Popularidad2
FROM 
    animerank t1
JOIN 
    animerank t2
	ON t1.id < t2.id
	AND t1.studios = t2.studios
	AND ABS(t1.popularity - t2.popularity) <= 10
ORDER BY 
    Estudio, Popularidad1, Popularidad2


-----------------------------------------

SELECT
	*
FROM
	animerank
