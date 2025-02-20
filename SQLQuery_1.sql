-- ver que hay en la tabla

SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = '001_sales';   ---- que salga varchar en la tabla no es bueno.

-- Primer ejercicio: Agrupar por producto y contar el número de productos y su precio medio

SELECT 
    [Id_Producto], 
    COUNT([Id_Producto]) AS Numero_Productos, 
    ROUND(AVG([PVP]),2) AS Precio_Medio
FROM [DATAEX].[001_sales]
GROUP BY [Id_Producto]

-- Segundo ejercicio: Agrupar por producto y contar distintivo y quitar los nulos.

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


-- dame las ventas por años y mes, y la tasa de variación

SELECT 
    YEAR(CAST(CONVERT(DATE, Sales_Date, 103) AS DATE)) AS Año,
    COUNT(*) AS Total_Ventas
FROM [DATAEX].[001_sales]
GROUP BY YEAR(CAST(CONVERT(DATE, Sales_Date, 103) AS DATE))
ORDER BY Año DESC;

-- Día de máximo de ventas

SELECT TOP 1
    CAST(CONVERT(DATE, Sales_Date, 103) AS DATE) AS Fecha_Convertida,
    COUNT(*) AS Total_Ventas,
    'Máximo Global' AS Tipo
FROM [DATAEX].[001_sales]
GROUP BY CAST(CONVERT(DATE, Sales_Date, 103) AS DATE)  -- El GROUP BY coge todas las variables categoricas y te hace una operacion matematica de suma o agregación.
ORDER BY Total_Ventas DESC;

-- Máximo de ventas en 2023

SELECT TOP 1 
--WITH TIES
    CAST(CONVERT(DATE, Sales_Date, 103) AS DATE) AS Fecha_Convertida,
    COUNT(*) AS Total_Ventas,
    'Máximo 2023' AS Tipo
FROM [DATAEX].[001_sales]
WHERE YEAR(CAST(CONVERT(DATE, Sales_Date, 103) AS DATE)) = 2023  -- El Where es importante para filtrar el año
GROUP BY CAST(CONVERT(DATE, Sales_Date, 103) AS DATE)
ORDER BY Total_Ventas DESC;


-- Calcula la tasa de variación por año

SELECT
    YEAR(CAST(CONVERT(DATE, Sales_Date, 103) AS DATE)) AS Año,
    COUNT(*) AS Total_Ventas,
    LAG(COUNT(*)) OVER (                                                -- LAG es para coger el valor anterior 
        ORDER BY YEAR(CAST(CONVERT(DATE, Sales_Date, 103) AS DATE))
        ) AS Total_Ventas_Anterior,

        -- Cálculo de la tasa de variación en porcentaje
    CASE  -- CASE es un if en SQL, es decir, si se cumple la condición, entonces se hace una cosa, si no, se hace otra.
        
        WHEN LAG(COUNT(*)) OVER (                                          -- Estas tres líneas comentadas es para explicar como se usa el OVER       
            ORDER BY YEAR(CAST(CONVERT(DATE, Sales_Date, 103) AS DATE))   -- Tu tienes una tabla con el dato super desagregado y quieres saber cuantos ''clientes'' o lo que sea, el año pasado,   
        ) IS NULL                                                         -- pues te creas otra tabla con todos los clientes y hago una op que te diga las ventas de t-1. Luego me creo otra tabla con las ventas del cliente y las ventas de t...
        THEN NULL                                                         -- Hacer todo esto es un rollo, por eso tenemos el SQL. La funcióon Over te lo calcula y te lo agrupa por año, te hace las dos operaciones en una sola función. OVER te coge la venta del año pasado me la vas a agrupar por año y me vas a hacer la suma.
        ELSE 
            ROUND(
                100.0 * (COUNT(*) - LAG(COUNT(*)) OVER (
                                ORDER BY YEAR(CAST(CONVERT(DATE, Sales_Date, 103) AS DATE))
                            )) 
                / NULLIF(LAG(COUNT(*)) OVER (
                                ORDER BY YEAR(CAST(CONVERT(DATE, Sales_Date, 103) AS DATE))
                            ), 0), 2)
    END AS Tasa_Variacion_Porcentual

FROM [DATAEX].[001_sales]
GROUP BY YEAR(CAST(CONVERT(DATE, Sales_Date, 103) AS DATE))
ORDER BY Año DESC;

-- Este azure se conecta directamente con el Visual Studio Code, por lo que se puede hacer directamente en el Visual Studio Code.

-- Calcula las ventas por año y mes y su tasa de variación.

SELECT 
    YEAR(CAST(CONVERT(DATE, Sales_Date, 103) AS DATE)) AS Año,
    MONTH(CAST(CONVERT(DATE, Sales_Date, 103) AS DATE)) AS Mes,
    COUNT(*) AS Total_Ventas,
    LAG(COUNT(*)) OVER (PARTITION BY YEAR(CAST(CONVERT(DATE, Sales_Date, 103) AS DATE)) 
                        ORDER BY MONTH(CAST(CONVERT(DATE, Sales_Date, 103) AS DATE))) AS Ventas_Mes_Anterior,
    CASE 
        WHEN LAG(COUNT(*)) OVER (PARTITION BY YEAR(CAST(CONVERT(DATE, Sales_Date, 103) AS DATE)) 
                                 ORDER BY MONTH(CAST(CONVERT(DATE, Sales_Date, 103) AS DATE))) IS NULL 
        THEN NULL
        ELSE 
            ROUND(
                100.0 * (COUNT(*) - LAG(COUNT(*)) OVER (PARTITION BY YEAR(CAST(CONVERT(DATE, Sales_Date, 103) AS DATE)) 
                                                         ORDER BY MONTH(CAST(CONVERT(DATE, Sales_Date, 103) AS DATE))))
                / NULLIF(LAG(COUNT(*)) OVER (PARTITION BY YEAR(CAST(CONVERT(DATE, Sales_Date, 103) AS DATE)) 
                                             ORDER BY MONTH(CAST(CONVERT(DATE, Sales_Date, 103) AS DATE))), 0), 2)
    END AS Tasa_Variacion_Porcentual
FROM [DATAEX].[001_sales]
GROUP BY YEAR(CAST(CONVERT(DATE, Sales_Date, 103) AS DATE)), 
         MONTH(CAST(CONVERT(DATE, Sales_Date, 103) AS DATE))
ORDER BY Año DESC, Mes DESC;


-- JOINTS en SQL: Ejemplo: Yo estoy haciendo una consulta en la tabla de ventas, y quiero saber de x venta que categoría de producto es, pues hacemos un Joint
-- con otra tabla de producto. Entonces habra en cada tabla un id de producto. Tendra que haber una cardinalidad de varios a uno (si mi modelo está bien hecho)
-- También podría ser que en la tabla haya un producto x que en la tabla de ventas no esté, entonces cuando hacemos este tipo de consultas lo que queremos es 
-- mostrar (haciendo un inner joint, por ejemplo) solo los productos que estén en ambas tablas. 
-- Lo que te puede interesar es sacar todas las ventas y si no está en alguna tabla, pues pones un 0 (o un círculo), eso se llama left joint. Que es, cógeme
-- todos los datos y los que coinciden con la tabla de ventas, pues me los pones, y los que no, pues me pones un 0.
-- (HAY UNA FOTO CON ESQUEMA EN EL AULA VIRTUAL)
-- Si yo quiero coger otra tabla (la de Geo) y hago un left join voy a capturar toda la realidad de mi tabla de ventas.
-- Antes de hacer la consulta al SQL hay que pensar muy bien que es lo que quiero.

-- Cuando haces una venta y tienes un cliente con un cierto id (con un sistema transaccional(cuadno pones la tarjeta en el datafono sale el id del cliente)), 
-- Luego el vendedor pondrá tus datos: nombre, apellido, sexo... Pero con este id puede haber duplicidades debido a que ese cliente ha comprado varias veces.
-- Entonces, en la tabla de ventas, el id del cliente no es único, por lo que no puedo hacer un joint con la tabla de clientes. Entonces, lo que hago es hacer
-- un joint con la tabla de clientes, pero con el id de la venta. Entonces, en la tabla de ventas, el id de la venta es único, por lo que puedo hacer un joint
-- con la tabla de clientes.
-- Amazon no tiene este problema porque estás loggeado, por ejemplo.


-- Joint ejemplo con codigo

-- Dame los productos por forma de pago
SELECT
    Id_Producto, 
    FORMA_PAGO,
    COUNT(*) AS Total_Financiaciones
FROM [DATAEX].[001_sales] sales
left join [DATAEX].[010_forma_pago] fp
on sales.FORMA_PAGO_ID = fp.FORMA_PAGO_ID
GROUP BY Id_Producto, FORMA_PAGO
ORDER BY Total_Financiaciones DESC;


-- Dame los modelos por forma de pago = 3
SELECT
    MODELO,
    COUNT(*) AS Total_Financiaciones
FROM [DATAEX].[001_sales] sales
left join [DATAEX].[010_forma_pago] fp
on sales.FORMA_PAGO_ID = fp.FORMA_PAGO_ID
left join [DATAEX].[006_producto] prod 
on sales .Id_Producto = prod.Id_Producto
WHERE fp.FORMA_PAGO_ID = 3
GROUP BY MODELO
ORDER BY Total_Financiaciones DESC;
