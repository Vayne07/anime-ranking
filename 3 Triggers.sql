/*
Creo una tabla de auditoria, para registrar los cambios en la base de datos.
*/
CREATE TABLE 
	Auditoria (
		ID INT PRIMARY KEY IDENTITY (1, 1),
		Tipo CHAR(1), -- I = Insert, U = Update, D = Delete
		FechaAudit DATETIME DEFAULT GETDATE(),
		Usuario VARCHAR(100),
		Aplicacion VARCHAR(100),
		AnimeID INT,
		Name NVARCHAR(255),
		Type VARCHAR(50),
		Episodes SMALLINT,
		Status VARCHAR(50),
		Premiered VARCHAR(50),
		Broadcast VARCHAR(50),
		Producers VARCHAR(255),
		Licensors VARCHAR(255),
		Studios VARCHAR(255),
		Source VARCHAR(50),
		Genres VARCHAR(255),
		Duration VARCHAR(50),
		Rating VARCHAR(50),
		Score FLOAT,
		Ranked INT,
		Popularity INT,
		Favorites INT,
		Aired_Date DATE,
		Finished_Date DATE
		)

/*
Creo los triggers para las tres distintas opciones INSERT, UPDATE, DELETE.
*/

--	INSERT
CREATE OR ALTER TRIGGER TR_insert ON animerank
AFTER INSERT
AS
BEGIN
	SET NOCOUNT ON
	DECLARE 
		@usuario VARCHAR(100) = SUSER_NAME(),
		@app VARCHAR(100) = APP_NAME()
	INSERT INTO Auditoria(	Tipo,
							Usuario,
							Aplicacion,
							AnimeID,
							Name,
							Type,
							Episodes,
							Status,
							Premiered,
							Broadcast,
							Producers,
							Licensors,
							Studios,
							Source, 
							Genres, 
							Duration, 
							Rating, 
							Score, 
							Ranked, 
							Popularity, 
							Favorites,
							Aired_Date, 
							Finished_Date
						)
	SELECT
		'I',
        @usuario,
        @app,
        id,
        name,
        type,
        episodes,
        status,
        premiered,
        broadcast,
        producers,
        licensors,
        studios,
        source,
        genres,
        duration,
        rating,
        score,
        ranked,
        popularity,
        favorites,
        aired_date,
        finished_date
    FROM inserted
END

/*
Hago la prueba ingresando valores de ejemplo y funciona.
*/

INSERT INTO animerank VALUES
	('anime ejemplo',
	'type',
	12, 
	'status',
	'premiered', 
	'broadcast', 
	'producers',
	'licensors',
	'studios', 
	'source',
	'genres',
	'1hs',
	'+13',
	10,
	3000,
	1,
	1,
	'2024-04-27',
	'2024-01-01')

SELECT
	*
FROM
	Auditoria



--	UPDATE.
CREATE OR ALTER TRIGGER TR_update ON animerank
AFTER UPDATE
AS
BEGIN
	SET NOCOUNT ON
	DECLARE 
		@usuario VARCHAR(100) = SUSER_NAME(),
		@app VARCHAR(100) = APP_NAME()
	INSERT INTO Auditoria(	Tipo,
							Usuario,
							Aplicacion,
							AnimeID,
							Name,
							Type,
							Episodes,
							Status,
							Premiered,
							Broadcast,
							Producers,
							Licensors,
							Studios,
							Source, 
							Genres, 
							Duration, 
							Rating, 
							Score, 
							Ranked, 
							Popularity, 
							Favorites,
							Aired_Date, 
							Finished_Date
						)
	SELECT
		'U',
        @usuario,
        @app,
        id,
        name,
        type,
        episodes,
        status,
        premiered,
        broadcast,
        producers,
        licensors,
        studios,
        source,
        genres,
        duration,
        rating,
        score,
        ranked,
        popularity,
        favorites,
        aired_date,
        finished_date
    FROM deleted


	INSERT INTO Auditoria(	Tipo,
							Usuario,
							Aplicacion,
							AnimeID,
							Name,
							Type,
							Episodes,
							Status,
							Premiered,
							Broadcast,
							Producers,
							Licensors,
							Studios,
							Source, 
							Genres, 
							Duration, 
							Rating, 
							Score, 
							Ranked, 
							Popularity, 
							Favorites,
							Aired_Date, 
							Finished_Date
						)
	SELECT
		'U',
        @usuario,
        @app,
        id,
        name,
        type,
        episodes,
        status,
        premiered,
        broadcast,
        producers,
        licensors,
        studios,
        source,
        genres,
        duration,
        rating,
        score,
        ranked,
        popularity,
        favorites,
        aired_date,
        finished_date
    FROM inserted
END


/*
Hago la prueba actualizando valores de ejemplo y funciona.
*/

UPDATE
	animerank
SET
	name = 'actualizacion',
	type = 'OVA',
	episodes = 1
WHERE
	ID = 2023


SELECT
	*
FROM
	Auditoria


-- DELETE
CREATE OR ALTER TRIGGER TR_delete ON animerank
AFTER DELETE
AS
BEGIN
	SET NOCOUNT ON
	DECLARE 
		@usuario VARCHAR(100) = SUSER_NAME(),
		@app VARCHAR(100) = APP_NAME()
	INSERT INTO Auditoria(	Tipo,
							Usuario,
							Aplicacion,
							AnimeID,
							Name,
							Type,
							Episodes,
							Status,
							Premiered,
							Broadcast,
							Producers,
							Licensors,
							Studios,
							Source, 
							Genres, 
							Duration, 
							Rating, 
							Score, 
							Ranked, 
							Popularity, 
							Favorites,
							Aired_Date, 
							Finished_Date
						)
	SELECT
		'D',
        @usuario,
        @app,
        id,
        name,
        type,
        episodes,
        status,
        premiered,
        broadcast,
        producers,
        licensors,
        studios,
        source,
        genres,
        duration,
        rating,
        score,
        ranked,
        popularity,
        favorites,
        aired_date,
        finished_date
    FROM deleted
END

/*
Hago la prueba eliminando valores de ejemplo y funciona.
*/

DELETE FROM
	animerank
WHERE
	ID = 2023

SELECT
	*
FROM
	Auditoria





/*
Triggers para Validacion y Normalizacion.
peque�a limpieza de datos para los valores que van ingresando.
cada campo va a manejar cuestiones como eliminacion de espacios, valores nulos, capitalzaciones y correcciones de fechas.
*/
CREATE OR ALTER TRIGGER TR_limpieza ON animerank
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON
    
    UPDATE
		animerank
    SET
        name =	CASE 
					WHEN TRIM(name) = '' OR name IS NULL THEN 'Unknown'
					ELSE UPPER(LEFT(TRIM(REPLACE(name, '  ', ' ')), 1)) + RIGHT(TRIM(REPLACE(name, '  ', ' ')), LEN(TRIM(REPLACE(name, '  ', ' ')))-1)
				END,

		type =	CASE
					WHEN TRIM(type) = '' OR type IS NULL THEN 'Unknown'
					ELSE TRIM(type)
				END,

		episodes = ISNULL(episodes, 0),

		status = TRIM(status),

		premiered =	CASE
						WHEN TRIM(premiered) = '' OR premiered IS NULL THEN 'Unknown'
						ELSE TRIM(premiered)
					END,

		broadcast =	CASE
						WHEN TRIM(broadcast) = '' OR broadcast IS NULL THEN 'Unknown'
						ELSE TRIM(broadcast)
					END,

		source =	CASE
						WHEN TRIM(source) = '' OR source IS NULL THEN 'Unknown'
						ELSE TRIM(source)
					END,

		genres =	CASE
						WHEN TRIM(genres) = '' OR genres IS NULL THEN 'Unknown'
						ELSE TRIM(genres)
					END,

		duration = TRIM(duration),

		rating = TRIM (rating),

		score = ISNULL(score, 0),

		ranked = ISNULL(ranked, 0),

		popularity = ISNULL(popularity, 0),

		aired_date =	CASE
							WHEN aired_date IS NULL THEN '1900-01-01'
							WHEN aired_date > CAST(GETDATE() AS DATE) THEN CAST(GETDATE() AS DATE)
							ELSE aired_date
						END,

		finished_date = CASE
							WHEN finished_date IS NULL THEN '9999-12-31'
							WHEN finished_date > CAST(GETDATE() AS DATE) THEN CAST(GETDATE() AS DATE)
						END
    WHERE id IN (SELECT id FROM inserted)
END

-- INSERTO VALORES DE PRUEBA, CORROBORO Y TODO FUNCIONA OK.

INSERT INTO animerank
VALUES('ejemplo  de  nombre',
		'', 
		NULL,
		'Currently Airing',
		'    Fall 2023      ',
		'',
		'asd',
		'asd',
		'asd',
		'manga',
		null,
		'00:20',
		'+18',
		null,
		null,
		null,
		5,
		null,
		'2025-02-02')
	
SELECT * FROM animerank

/*
Implementaci�n de Logs de Errores.
EJEMPLO: crear tabla para registrar los errores para su posterior analisis.
CREATE TABLE ErrorLog (
    LogID INT IDENTITY(1,1) PRIMARY KEY,
    ErrorMessage NVARCHAR(4000),
    ErrorNumber INT,
    ErrorSeverity INT,
    ErrorState INT,
    ErrorProcedure NVARCHAR(128),
    ErrorLine INT,
    LogDate DATETIME DEFAULT GETDATE()
);

*/


/*
Validaci�n y Restricciones en Datos Nuevos.
EJEMPLO: me aseguro que los datos que ingresan son correctos, de no ser asi devuelve un error descriptivo

CREATE PROCEDURE InsertAnimeData
    @Title VARCHAR(100),
    @Episodes INT,
    @PremieredDate DATE,
    @FinishedDate DATE
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;
        
        -- Validaciones
        IF @Episodes < 0
        BEGIN
            THROW 50000, 'El n�mero de episodios no puede ser negativo.', 1;
        END

        -- Inserci�n de datos
        INSERT INTO AnimeTable (title, episodes, premiered_date, finished_date)
        VALUES (@Title, @Episodes, @PremieredDate, @FinishedDate);
        
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        -- Manejo de errores
        THROW;
    END CATCH
END;

*/



/*	
Implementaci�n de Funciones:
EJEMPLO: calcula la duracion del anime.
CREATE FUNCTION dbo.CalculateAnimeDuration (@PremieredDate DATE, @FinishedDate DATE)
RETURNS INT
AS
BEGIN
    RETURN DATEDIFF(DAY, @PremieredDate, @FinishedDate);
END;
*/