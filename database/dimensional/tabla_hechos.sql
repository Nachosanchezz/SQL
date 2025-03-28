SELECT
    s.CODE,  -- PK de la tabla de ventas
    s.Code_,             -- Fk de la tabla de productos
    s.Customer_ID,       -- Fk de la tabla de clientes
    s.PVP,       
    s.COSTE_VENTA_NO_IMPUESTOS, 
    s.IMPUESTOS,                 
    s.MANTENIMIENTO_GRATUITO,    
    s.EN_GARANTIA,               
    s.EXTENSION_GARANTIA,
    s.FIN_GARANTIA,              -- Fecha de fin de garantía
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
    cost.Margen,
    cost.Margendistribuidor,
    cost.Comisión_marca,

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
    edad.Car_Age,

      -- Quejas y mantenimiento
    cac.DIAS_DESDE_LA_ULTIMA_ENTRADA_TALLER,
    cac.DIAS_EN_TALLER,
    cac.QUEJA,

    ROUND(s.PVP * (Margen)*0.01 * (1 - IMPUESTOS / 100), 2) AS Margen_eur_bruto,


-- Cálculo de Margen en Euros Neto
    ROUND(
        s.[PVP] * cost.[Margen] * 0.01 * (1 - s.[IMPUESTOS] / 100)
        - s.[COSTE_VENTA_NO_IMPUESTOS] 
        - (cost.[Margendistribuidor] * 0.01 + cost.[GastosMarketing] * 0.01 - cost.[Comisión_marca] * 0.01)
            * s.[PVP] * (1 - s.[IMPUESTOS] / 100)
        - cost.[Costetransporte], 
    2) AS Margen_eur,

     -- Tasa de Churn: Indica si la venta ha sido cancelada en los últimos 400 días (1) o no (0).
    CASE
            -- Caso 1: Revisión reciente o sin revisión (0-400 días) - No churn.
        WHEN
            rev.DIAS_DESDE_ULTIMA_REVISION IS NOT NULL AND
            rev.DIAS_DESDE_ULTIMA_REVISION <> '' AND
            TRY_CAST(REPLACE(rev.DIAS_DESDE_ULTIMA_REVISION, '.', '') AS INT) BETWEEN 0 AND 400
        THEN 0
            -- Caso 2: Revisión muy antigua (>400 días) - Churn.
        WHEN
            rev.DIAS_DESDE_ULTIMA_REVISION IS NOT NULL AND
            rev.DIAS_DESDE_ULTIMA_REVISION <> '' AND
            TRY_CAST(REPLACE(rev.DIAS_DESDE_ULTIMA_REVISION, '.', '') AS INT) > 400
        THEN 1
            -- Caso 3: Otros valores inesperados - Churn por precaución.
        ELSE 1
    END AS Tasa_Churn

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
LEFT JOIN [DATAEX].[018_edad] edad ON s.CODE = edad.CODE

LEFT JOIN [DATAEX].[008_cac] cac ON s.CODE = cac.CODE

-- Dimensión Revisiones
LEFT JOIN [DATAEX].[004_rev] rev ON s.CODE = rev.CODE



