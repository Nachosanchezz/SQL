---- ver que hay en la tabla

SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = '001_sales';   ---- que salga varchar en la tabla no es bueno.

---- Primer ejercicio: Agrupar por producto y contar el número de productos y su precio medio

SELECT 
    [Id_Producto], 
    COUNT([Id_Producto]) AS Numero_Productos, 
    ROUND(AVG([PVP]),2) AS Precio_Medio
FROM [DATAEX].[001_sales]
GROUP BY [Id_Producto]

----- Segundo ejercicio: Agrupar por producto y contar distintivo y quitar los nulos.

SELECT 
    [Id_Producto], 
    COUNT([Id_Producto]) AS Numero_Productos,
    COUNT(DISTINCT [Id_Producto]) AS Productos_Unicos, -- cuenta productos unicos/distintos
    ROUND(AVG(CAST([PVP] AS FLOAT)),2) AS Precio_Medio  -- convierte a float para que no salga varchar. Cast es para convertir de un tipo a otro.
FROM [DATAEX].[001_sales]
WHERE [Id_Producto] IS NOT NULL
GROUP BY [Id_Producto]

-- Tercer ejercico: Convertir la fecha de texto a número.

SELECT 
    Sales_Date,
    CAST(CONVERT(DATE, Sales_Date, 103) AS DATE) AS Fecha_Convertida   -- https://learn.microsoft.com/es-es/sql/t-sql/functions/cast-and-convert-transact-sql?view=sql-server-ver16  
FROM [DATAEX].[001_sales]                                              -- para ver los codigos, en este caso es el 103 es la fecha francesa. CAST y CONVERT lo vamos a usar mucho. 
WHERE Sales_Date IS NOT NULL
