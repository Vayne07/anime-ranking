


/*
Tabla de auditoria.

CREATE TABLE AnimeAudit (
    AuditID INT IDENTITY(1,1) PRIMARY KEY,
    AuditType CHAR(1), -- I = Insert, U = Update, D = Delete
    AuditDate DATETIME DEFAULT GETDATE(),
    AnimeID INT,
    OldTitle VARCHAR(100),
    NewTitle VARCHAR(100),
    OldEpisodes INT,
    NewEpisodes INT,
    OldPremieredDate DATE,
    NewPremieredDate DATE,
    OldFinishedDate DATE,
    NewFinishedDate DATE
);

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
Triggers para Validación y Normalización.
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
Implementación de Funciones:
EJEMPLO: calcula la duracion del anime.
CREATE FUNCTION dbo.CalculateAnimeDuration (@PremieredDate DATE, @FinishedDate DATE)
RETURNS INT
AS
BEGIN
    RETURN DATEDIFF(DAY, @PremieredDate, @FinishedDate);
END;
*/