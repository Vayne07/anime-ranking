/*
Implementacion de Logs de Errores.
EJEMPLO: crear tabla para registrar los errores para su posterior analisis.
*/
CREATE TABLE RegistroErrores 
	(
	ID INT IDENTITY(1,1) PRIMARY KEY,
    Error NVARCHAR(4000),
    Numero INT,
    Severidad INT,
    Estado INT,
    Procedimiento NVARCHAR(128),
    Linea INT,
    Fecha DATETIME DEFAULT GETDATE()
	)



/*
Ingreso de Datos controlado (uno por uno).
creo un SP para cuando deba ingresar de a un registro, con manejo de errores incluido.
*/
CREATE PROC SP_InsertarUno
    @Name VARCHAR(255),
	@Type NVARCHAR(50),
    @Episodes SMALLINT,
	@Status VARCHAR(50),
	@Premiered VARCHAR(50),
	@Broadcast VARCHAR(50),
	@Producers VARCHAR(255),
	@Licensors VARCHAR(255),
	@Studios VARCHAR(255),
	@Source VARCHAR(50),
	@Genres VARCHAR(255),
	@Duration VARCHAR(50),
	@Rating VARCHAR(50),
	@Score FLOAT,
	@Ranked INT,
	@Popularity INT,
	@Favorites INT,
	@Aired_Date DATE,
	@Finished_Date DATE
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
			IF @Episodes < 0
				BEGIN
					THROW 50000, 'El numero de episodios no puede ser negativo.', 1
				END
			INSERT INTO animerank(
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

			VALUES (
					@Name,
					@Type,
					@Episodes,
					@Status,
					@Premiered,
					@Broadcast,
					@Producers,
					@Licensors,
					@Studios,
					@Source,
					@Genres,
					@Duration,
					@Rating,
					@Score,
					@Ranked,
					@Popularity,
					@Favorites,
					@Aired_Date,
					@Finished_Date
					)
        
        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION
		BEGIN
			INSERT INTO RegistroErrores (Error, Numero, Severidad, Estado, Procedimiento, Linea)
				VALUES (ERROR_MESSAGE(), ERROR_NUMBER(), ERROR_SEVERITY(), ERROR_STATE(), ERROR_PROCEDURE(), ERROR_LINE());
				THROW
		END
    END CATCH
END


/*
Probamos el SP agregando un registro con error, voy cambiando valores para hacer distintas pruebas.
*/

EXEC SP_InsertarUno
					@Name = 'Ejemplo de nombre',
					@Type = 'TV',
					@Episodes = 0,
					@Status = 'Airing',
					@Premiered = '',
					@Broadcast = '',
					@Producers = '',
					@Licensors = '',
					@Studios = '',
					@Source = '',
					@Genres = '',
					@Duration = '',
					@Rating = '',
					@Score = 9,
					@Ranked = 3500,
					@Popularity = 12,
					@Favorites = 12,
					@Aired_Date = '2026-02-05',
					@Finished_Date = '2020-08-07'
					
SELECT * FROM RegistroErrores
