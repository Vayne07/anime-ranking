select * from animerank


-- RESTRICCIONES O CONSTRAINTS.
ALTER TABLE
	animerank
ADD CONSTRAINT CHK_score CHECK(score BETWEEN 0 AND 10) -- DONE


ALTER TABLE animerank
ALTER COLUMN name VARCHAR(255)

ALTER TABLE
	animerank
ADD CONSTRAINT UQ_name UNIQUE(name) -- CAMBIE EL VARCHAR DE MAX A 255 PERO TENGO UN VALOR REPETIDO, CORREGIR ANTES DE AGREGAR ESTO.


ALTER TABLE
	animerank
ADD CONSTRAINT UQ_ranked UNIQUE(ranked) -- RANKED 412 DUPLICADO.


ALTER TABLE
	animerank
ADD CONSTRAINT CHK_date CHECK(aired_date <= finished_date) -- DONE











-- agregar restricciones o constrainst
-- manejo de errores para mostrar algun mensaje que marque el error y ayude a corregirlo
-- crear tabla de registro de errores (trigger)
-- crear tabla de auditoria: ingreso, actualizacion y eliminacion de datos (trigger)