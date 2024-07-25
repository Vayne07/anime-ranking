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
EJEMPLO: puedo hacer una mini limpieza de datos con estos triggers.
CREATE TRIGGER NormalizeDataTrigger
ON AnimeTable
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    
    UPDATE AnimeTable
    SET
        title = UPPER(title), -- Normalización a mayúsculas
        episodes = ISNULL(episodes, 0), -- Sustitución de NULL por 0
        finished_date = ISNULL(finished_date, '1900-01-01') -- Sustitución de NULL por una fecha por defecto
    WHERE id IN (SELECT id FROM inserted);
END;
*/



/*
Implementación de Logs de Errores.
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
Validación y Restricciones en Datos Nuevos.
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
            THROW 50000, 'El número de episodios no puede ser negativo.', 1;
        END

        -- Inserción de datos
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
Implementación de Funciones:
EJEMPLO: calcula la duracion del anime.
CREATE FUNCTION dbo.CalculateAnimeDuration (@PremieredDate DATE, @FinishedDate DATE)
RETURNS INT
AS
BEGIN
    RETURN DATEDIFF(DAY, @PremieredDate, @FinishedDate);
END;
*/