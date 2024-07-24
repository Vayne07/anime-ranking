-- RESTRICCIONES / CONSTRAINTS.
ALTER TABLE
	animerank
ADD CONSTRAINT CHK_score CHECK(score BETWEEN 0 AND 10)

--

ALTER TABLE
	animerank
ADD CONSTRAINT UQ_name UNIQUE(name)
-- al agregar esta restriccion me tira error, me doy cuenta que tengo dos valores duplicados que habia decidido no quitar en la limpieza de datos
-- voy a crear un campo ID PK para diferenciarlos y cambiarle el nombre para aplicar la restriccion.
-- por alguna razon tambien tengo que cambiar el tipo de dato VARCHAR(MAX) a VARCHAR(255)
ALTER TABLE
	animerank
ADD ID INT PRIMARY KEY IDENTITY (1, 1)

ALTER TABLE
	animerank
ALTER COLUMN
	name VARCHAR(255)

--

ALTER TABLE
	animerank
ADD CONSTRAINT CHK_date CHECK(aired_date <= finished_date)