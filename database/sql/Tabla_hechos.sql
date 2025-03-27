SELECT
    s.CODE,  -- PK de la tabla de ventas
    s.Code_,             -- Fk de la tabla de productos
    s.Customer_ID,       -- Fk de la tabla de clientes
    s.PVP AS Precio_Venta,       
    s.COSTE_VENTA_NO_IMPUESTOS, 
    s.IMPUESTOS,                 
    s.MANTENIMIENTO_GRATUITO,    
    s.EN_GARANTIA,               
    s.EXTENSION_GARANTIA,
    CONVERT(DATE, s.FIN_GARANTIA, 103) AS Fecha_Fin_Garantia,     
    s.SEGURO_BATERIA_LARGO_PLAZO,      
    s.Id_Producto,       -- Fk de la tabla de productos
    CONVERT(DATE,s.Sales_Date,103) AS Sales_Date,     -- Fk de la tabla de tiempo
    s.TIENDA_ID,         -- Fk de la tabla de zona          
    
    -- Forma de pago
    fp.FORMA_PAGO_ID,           
    
    -- Motivo de venta
    mv.MOTIVO_VENTA_ID,          

    -- Zona y Provincia               
    z.ZONA_ID,                   
    prov.PROVINCIA_ID,     
    -- Revisiones
    CONVERT(DATE, rev.DATE_UTIMA_REV, 103) AS DATE_ULTIMA_REVISION,
    CASE
        WHEN rev.DIAS_DESDE_ULTIMA_REVISION IS NULL OR rev.DIAS_DESDE_ULTIMA_REVISION = '' THEN 1
        ELSE CAST(REPLACE(rev.DIAS_DESDE_ULTIMA_REVISION, '.', '') AS INT)
    END AS DIAS_DESDE_ULTIMA_REVISION,
    rev.Km_medio_por_revision,
    rev.km_ultima_revision,
    rev.Revisiones,     
    
    -- Costes
    cost.Costetransporte,        
    cost.GastosMarketing,

    -- Logística.
    logist.Fue_Lead,
    logist.Lead_compra,
    CONVERT(DATE, logist.Logistic_date, 103) AS Logistic_date,
    CONVERT(DATE, logist.Prod_date, 103) AS Prod_date,
    logist.t_logist_days,
    logist.t_prod_date,
    logist.t_stock_dates,
    --Logística: Origen de la Venta.
    origen_venta.Origen,

    -- Edad del Coche.
    edad_coche.Car_Age,

      -- Quejas y mantenimiento
    cac.DIAS_DESDE_LA_ULTIMA_ENTRADA_TALLER,
    cac.DIAS_EN_TALLER,
    cac.QUEJA,

    CASE
    -- Caso 1: revisión reciente o sin revisión (0 a 400 días) ⇒ NO churn
    WHEN TRY_CAST(REPLACE(rev.DIAS_DESDE_ULTIMA_REVISION, '.', '') AS INT) BETWEEN 0 AND 400 THEN 0

    -- Caso 2: revisión muy antigua (> 400 días) ⇒ churn
    WHEN TRY_CAST(REPLACE(rev.DIAS_DESDE_ULTIMA_REVISION, '.', '') AS INT) > 400 THEN 1

    -- Caso 3: nulo o vacío ⇒ depender de la edad del coche
    WHEN (rev.DIAS_DESDE_ULTIMA_REVISION IS NULL OR rev.DIAS_DESDE_ULTIMA_REVISION = '')
        THEN CASE 
            WHEN edad_coche.Car_Age >= 5 THEN 1  -- coches viejos sin revisión ⇒ churn
            ELSE 0
        END

    -- Caso 4: cualquier otro valor inesperado ⇒ asumimos churn por precaución
    ELSE 1
END AS Tasa_Churn,


    --  Margen bruto: lo que se gana después de aplicar el margen, quitando los impuestos
ROUND(s.PVP * cost.Margen / 100 * (1 - s.IMPUESTOS / 100.0), 2) AS Margen_Bruto_Euros,

--  Margen neto aproximado: restamos al margen bruto el coste de venta y el transporte
ROUND(
    (s.PVP * cost.Margen / 100 * (1 - s.IMPUESTOS / 100.0)) -- margen bruto
    - s.COSTE_VENTA_NO_IMPUESTOS                            -- coste de venta
    - cost.Costetransporte,                                 -- transporte
    2
) AS Margen_Neto_Euros,

--  Coste total aproximado: lo que nos cuesta vender el coche (venta + transporte)
ROUND(
    s.COSTE_VENTA_NO_IMPUESTOS + cost.Costetransporte,
    2
) AS Coste_Total_Venta_Euros,

--  Queja del cliente: 1 si hubo queja, 0 si no
CASE 
    WHEN cac.QUEJA IS NOT NULL THEN 1
    ELSE 0 
END AS Hubo_Queja

-- Tabla de ventas  
FROM [DATAEX].[001_sales] s

-- Dimensión Fecha
LEFT JOIN [DATAEX].[002_date] d ON s.Sales_Date = d.Date

-- Dimensión Cliente
LEFT JOIN [DATAEX].[003_clientes] c ON s.Customer_ID = c.Customer_ID
LEFT JOIN [DATAEX].[005_cp] cp ON c.CODIGO_POSTAL = cp.CP
LEFT JOIN [DATAEX].[019_Mosaic] m ON c.CODIGO_POSTAL = m.CP_value

-- Dimensión Producto con Costes
LEFT JOIN [DATAEX].[006_producto] p ON s.Id_Producto = p.Id_Producto
LEFT JOIN [DATAEX].[015_fuel] f ON p.Fuel_ID = f.Fuel_ID
LEFT JOIN [DATAEX].[014_categoría_producto] cat ON p.CATEGORIA_ID = cat.CATEGORIA_ID
LEFT JOIN [DATAEX].[007_costes] cost ON p.Modelo = cost.Modelo

-- Dimensión Forma de Pago
LEFT JOIN [DATAEX].[010_forma_pago] fp ON s.FORMA_PAGO_ID = fp.FORMA_PAGO_ID

-- Dimensión Motivo de Venta
LEFT JOIN [DATAEX].[009_motivo_venta] mv ON s.MOTIVO_VENTA_ID = mv.MOTIVO_VENTA_ID

-- Dimensión Tienda y Ubicación
LEFT JOIN [DATAEX].[011_tienda] t ON s.TIENDA_ID = t.TIENDA_ID
LEFT JOIN [DATAEX].[013_zona] z ON t.ZONA_ID = z.ZONA_ID
LEFT JOIN [DATAEX].[012_provincia] prov ON t.PROVINCIA_ID = prov.PROVINCIA_ID

-- Dimensiones de Logística
LEFT JOIN [DATAEX].[017_logist] logist ON s.CODE = logist.CODE
LEFT JOIN [DATAEX].[016_origen_venta] origen_venta 
    ON logist.Origen_Compra_ID = origen_venta.Origen_Compra_ID

-- Dimensión Edad del Coche
LEFT JOIN [DATAEX].[018_edad] edad_coche ON s.CODE = edad_coche.CODE

LEFT JOIN [DATAEX].[008_cac] cac ON s.CODE = cac.CODE

-- Dimensión Revisiones
LEFT JOIN [DATAEX].[004_rev] rev ON s.CODE = rev.CODE