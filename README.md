# Analisis de MyAnimeList
Desde [Kaggle](https://www.kaggle.com/ "Kaggle") descargué una base de datos de [MyAnimeList](https://myanimelist.net/ "MyAnimeList") con el objetivo de hacer un análisis en SQL Server. Previamente realicé un proceso ETL e implementé tecnicas T-SQL.

## Contenido
##### 📄 CSV: 
1.  **"toprankedanime.csv":**
 - Archivo original descargado.
2. **"animerank.csv":**
 - Es el archivo original pero transformado (explicación más adelante). Este es el CSV que se va a importar a SQL.
 
##### 📄 SQL:
1. **"1 Limpieza de datos.sql":**
 - Consulta documentada donde se lleva a cabo el proceso de limpieza de datos.
2. **"2 Restricciones":**
 - Consulta documentada donde se aplican Constraints a los campos para asegurar la integridad de los datos.
3. **"3 Triggers":**
 - Consulta documentada donde se crea una tabla de auditoría y la implementación de Triggers al Insert, Update y Delete. Incluye también un Trigger adicional para la validación y limpieza automática de datos.
4. **"4 Manejo de errores":**
 - Consulta documentada donde se crea una tabla de logs de errores y la implementación de un Store Procedure que incluye validaciones adicionales antes de insertar los datos y manejo de errores.
5. **"5 Analisis":**
 - Consulta documentada donde, una vez terminado el proceso ETL y la preparación de datos, se realizan múltiples consultas en busqueda de información relevante.

## Explicación y guía del Proyecto
El archivo **"topranekdanime.csv"** es el original descargado de Kaggle pero tenía un problema, venía con una codificación distinta al contener caracteres especiales. En lenguajes como Python se cambia muy fácil pero SQL Server no me reconocía la codficación por lo que daba error al cargar los datos.
La solución la encontré con el mismo **Excel**. Utilizando **Power Query** cambié el encoding a UTF-8 y realicé una pequeña limpieza de datos para preparar el csv.
Ahora sí, los pasos son muy sencillos, hay que importar el csv **"animerank.csv"** para lo cual recomiendo la propia herramienta de importacion de datos de SQL (Server), sino se puede hacer un Bulk Insert logrando el mismo resultado.
Ahora queda ejecutar las consultas en orden numérico y de forma descendente. Cada archivo esta DOCUMENTADO: consultas explicadas, abordaje y resolución de problemas, explicación de campos, entre otras cosas. 
Una vez ejecutado el 4to archivo sql, la tabla ya está en condiciones para trabajar y solamente queda el Análisis.