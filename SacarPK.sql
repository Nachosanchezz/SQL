-- Ver las top 10 de la tabla de ventas. Con top 10 me refiero a las 10 primeras filas.

SELECT TOP (10) *
  FROM [DATAEX].[001_sales]

-- ver que hay en la tabla

SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = '001_sales';

-- La columna tiene valores únicos

SELECT COUNT(DISTINCT Id_Producto) AS Unicos_CODE, COUNT(*) AS Total_Filas
  FROM [DATAEX].[001_sales]

SELECT COUNT(DISTINCT Customer_ID) AS Unicos_Customer, COUNT(*) AS Total_Filas
    FROM [DATAEX].[001_sales]



-- La columna no puede tener valores nulos

SELECT COUNT(*) AS Nulos_CODE
    FROM [DATAEX].[001_sales]
    WHERE CODE IS NULL;


-- La columna representa una entidad única

SELECT Customer_ID, COUNT(*) AS Repeticiones
FROM [DATAEX].[001_sales]
GROUP BY Customer_ID
HAVING COUNT(*) > 1;

-- Columnas están en varias tablas y pueden ser claves foráneas (FK)
SELECT COLUMN_NAME, TABLE_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE COLUMN_NAME IN (
    SELECT COLUMN_NAME 
    FROM INFORMATION_SCHEMA.COLUMNS
    GROUP BY COLUMN_NAME
    HAVING COUNT(*) > 1
)
ORDER BY COLUMN_NAME;


-- Tabla revision
SELECT TOP (10) *
  FROM [DATAEX].[004_rev]




-- Clase, no tiene nada que ver con lo de arriba

SELECT
tienda.[TIENDA_ID]
    ,tienda.[PROVINCIA_ID]
    ,tienda.[ZONA_ID]
    ,tienda.[TIENDA_DESC]
    ,provincia.[PROV_DESC]
    ,zona.[ZONA]

FROM [DATAEX].[011_tienda] tienda
LEFT JOIN [DATAEX].[012_provincia] provincia ON tienda.PROVINCIA_ID = provincia.PROVINCIA_ID
LEFT JOIN [DATAEX].[013_zona] zona ON tienda.ZONA_ID = zona.ZONA_ID

 

SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = '004_rev';

SELECT COUNT(DISTINCT CODE) AS Unicos_CODE, COUNT(*) AS Total_Filas
  FROM [DATAEX].[004_rev]

SELECT COUNT(DISTINCT DIAS_DESDE_ULTIMA_REVISION) AS Unicos_CODE, COUNT(*) AS Total_Filas
  FROM [DATAEX].[004_rev]


SELECT TOP (10) *
  FROM [DATAEX].[017_logist]

SELECT COUNT(DISTINCT CODE) AS Unicos_CODE, COUNT(*) AS Total_Filas
  FROM [DATAEX].[017_logist]

-- Si Veces_En_Rev es siempre 1 → Relación 1:1
SELECT sales.CODE, COUNT(sales.CODE) AS Veces_En_Rev
FROM [DATAEX].[001_sales] sales
LEFT JOIN [DATAEX].[004_rev] rev ON sales.CODE = rev.CODE
GROUP BY sales.CODE
ORDER BY Veces_En_Rev DESC;

 -- Si Coincidencias = Total_Sales = Total_Rev, la relación es 1:1 estricta.
SELECT 
    (SELECT COUNT(*) FROM [DATAEX].[001_sales]) AS Total_Sales,
    (SELECT COUNT(*) FROM [DATAEX].[004_rev]) AS Total_Rev,
    (SELECT COUNT(*) FROM [DATAEX].[001_sales] s JOIN [DATAEX].[004_rev] r ON s.CODE = r.CODE) AS Coincidencias




SELECT TOP (10) *
  FROM [DATAEX].[018_edad]

SELECT COUNT(DISTINCT CODE) AS Unicos_CODE, COUNT(*) AS Total_Filas
  FROM [DATAEX].[018_edad]

SELECT 
    (SELECT COUNT(*) FROM [DATAEX].[001_sales]) AS Total_Sales,
    (SELECT COUNT(*) FROM [DATAEX].[018_edad]) AS Total_Edad,
    (SELECT COUNT(*) FROM [DATAEX].[001_sales] s JOIN [DATAEX].[018_edad] r ON s.CODE = r.CODE) AS Coincidencias

SELECT s.CODE
FROM [DATAEX].[001_sales] s
LEFT JOIN [DATAEX].[018_edad] e ON s.CODE = e.CODE
WHERE e.CODE IS NULL;


SELECT 
    (SELECT COUNT(*) FROM [DATAEX].[001_sales]) AS Total_Sales,
    (SELECT COUNT(*) FROM [DATAEX].[006_producto]) AS Total_Producto,
    (SELECT COUNT(*) FROM [DATAEX].[001_sales] s JOIN [DATAEX].[006_producto] p ON s.Id_Producto = p.Id_Producto) AS Coincidencias


SELECT TOP (10) *
  FROM [DATAEX].[006_producto]

SELECT COUNT(DISTINCT Id_Producto) AS Unicos_Id_Producto, COUNT(*) AS Total_Filas
  FROM [DATAEX].[006_producto]

SELECT COUNT(DISTINCT Code_) AS Unicos_Code_, COUNT(*) AS Total_Filas
  FROM [DATAEX].[006_producto]

SELECT TOP (10) *
  FROM [DATAEX].[003_clientes]

SELECT COUNT(DISTINCT RENTA_MEDIA_ESTIMADA) AS Unicos_Code_, COUNT(*) AS Total_Filas
  FROM [DATAEX].[003_clientes]

SELECT 
    (SELECT COUNT(*) FROM [DATAEX].[001_sales]) AS Total_Sales,
    (SELECT COUNT(*) FROM [DATAEX].[009_motivo_venta]) AS Total_Motivo_Venta,
    (SELECT COUNT(*) FROM [DATAEX].[001_sales] s JOIN [DATAEX].[009_motivo_venta] m ON s.MOTIVO_VENTA_ID = m.MOTIVO_VENTA_ID) AS Coincidencias
   

SELECT TOP (15) *
  FROM [DATAEX].[011_tienda]

SELECT 
    (SELECT COUNT(*) FROM [DATAEX].[001_sales]) AS Total_Sales,
    (SELECT COUNT(*) FROM [DATAEX].[011_tienda]) AS Total_Tienda,
    (SELECT COUNT(*) FROM [DATAEX].[001_sales] s JOIN [DATAEX].[011_tienda] e ON s.TIENDA_ID = e.TIENDA_ID) AS Coincidencias

SELECT COUNT(DISTINCT Sales_Date) AS Unicos_Id_Producto, COUNT(*) AS Total_Filas
  FROM [DATAEX].[001_sales]

SELECT COUNT(DISTINCT Sales_Date) AS Unicos_Id_Producto, COUNT(*) AS Total_Filas
  FROM [DATAEX].[018_edad]