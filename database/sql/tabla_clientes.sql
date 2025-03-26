WITH resumen_clientes AS (
    SELECT
        s.Customer_ID,
         COUNT(DISTINCT s.CODE) AS Num_Ventas,
            MIN(CONVERT(DATE, s.Sales_Date, 103)) AS Fecha_Primera_Compra,
            MAX(CONVERT(DATE, s.Sales_Date, 103)) AS Fecha_Ultima_Compra,
            SUM(ISNULL(logist.Fue_Lead, 0)) AS Total_Fue_Lead,
            SUM(ISNULL(logist.Lead_compra, 0)) AS Total_Lead_Compra,
        SUM(ISNULL(logist.Fue_Lead, 0)) + SUM(ISNULL(logist.Lead_compra, 0)) AS Total_Lead
    FROM [DATAEX].[001_sales] s
    LEFT JOIN [DATAEX].[017_logist] logist ON s.CODE = logist.CODE
    GROUP BY s.Customer_ID
)

SELECT
    -- 🧩 DATOS DE LA TABLA DE HECHOS
    s.CODE,
    s.Code_,
    s.Customer_ID,
    s.PVP AS Precio_Venta,
    s.COSTE_VENTA_NO_IMPUESTOS,
    s.IMPUESTOS,
    s.MANTENIMIENTO_GRATUITO,
    s.EN_GARANTIA,
    s.EXTENSION_GARANTIA,
    CONVERT(DATE, s.FIN_GARANTIA, 103) AS Fecha_Fin_Garantia,
    s.SEGURO_BATERIA_LARGO_PLAZO,
    s.Id_Producto,
    CONVERT(DATE,s.Sales_Date,103) AS Sales_Date,
    s.TIENDA_ID,

    -- Datos agregados desde la tabla de hechos
    rc.Num_Ventas,
    rc.Fecha_Primera_Compra,
    rc.Fecha_Ultima_Compra,
    rc.Total_Fue_Lead,
    rc.Total_Lead_Compra,
    rc.Total_Lead,
    

    -- Forma de pago y motivo de venta
    fp.FORMA_PAGO_ID,
    mv.MOTIVO_VENTA_ID,

    -- Zona y provincia
    z.ZONA_ID,
    prov.PROVINCIA_ID,

    -- CAC
    cac.DIAS_DESDE_LA_ULTIMA_ENTRADA_TALLER,
    cac.DIAS_EN_TALLER,
    cac.QUEJA,

    -- Costes
    cost.Costetransporte,
    cost.GastosMarketing,

    -- Logística
    logist.Fue_Lead,
    logist.Lead_compra,
    CONVERT(DATE, logist.Logistic_date, 103) AS Logistic_date,
    CONVERT(DATE, logist.Prod_date, 103) AS Prod_date,
    logist.t_logist_days,
    logist.t_prod_date,
    logist.t_stock_dates,
    origen_venta.Origen,

    -- Edad del coche
    edad_coche.Car_Age,

    -- Márgenes
    ROUND(s.PVP * cost.Margen / 100 * (1 - s.IMPUESTOS / 100.0), 2) AS Margen_Bruto_Euros,
    ROUND(
        (s.PVP * cost.Margen / 100 * (1 - s.IMPUESTOS / 100.0))
        - s.COSTE_VENTA_NO_IMPUESTOS
        - cost.Costetransporte,
        2
    ) AS Margen_Neto_Euros,
    ROUND(
        s.COSTE_VENTA_NO_IMPUESTOS + cost.Costetransporte,
        2
    ) AS Coste_Total_Venta_Euros,

    -- Indicador de queja
    CASE 
        WHEN cac.QUEJA IS NOT NULL THEN 1
        ELSE 0 
    END AS Hubo_Queja,

    -- 🧩 DATOS DE LA DIMENSIÓN CLIENTE
    c.EDAD,
    c.GENERO,
    c.RENTA_MEDIA_ESTIMADA,
    c.STATUS_SOCIAL,
    c.CODIGO_POSTAL,
    cp.poblacion,
    cp.provincia,
    c.Fecha_nacimiento,
    RIGHT('00000' + REPLACE(c.CODIGO_POSTAL, 'CP', ''), 5) AS CP_NUM,
    m.Mosaic_number,
    m.Max_Mosaic

FROM [DATAEX].[001_sales] s

-- JOIN con cliente y sus atributos
LEFT JOIN [DATAEX].[003_clientes] c ON s.Customer_ID = c.Customer_ID
LEFT JOIN [DATAEX].[005_cp] cp ON c.CODIGO_POSTAL = cp.CP
LEFT JOIN [DATAEX].[019_Mosaic] m 
    ON RIGHT('00000' + REPLACE(c.CODIGO_POSTAL, 'CP', ''), 5) = RIGHT('00000' + CAST(m.CP_value AS VARCHAR), 5)

-- JOIN con fecha (aunque no se usa ningún campo ahora)
LEFT JOIN [DATAEX].[002_date] d ON s.Sales_Date = d.Date

-- JOIN con producto y costes
LEFT JOIN [DATAEX].[006_producto] p ON s.Id_Producto = p.Id_Producto
LEFT JOIN [DATAEX].[015_fuel] f ON p.Fuel_ID = f.Fuel_ID
LEFT JOIN [DATAEX].[014_categoría_producto] cat ON p.CATEGORIA_ID = cat.CATEGORIA_ID
LEFT JOIN [DATAEX].[007_costes] cost ON p.Modelo = cost.Modelo

-- Forma de pago y motivo
LEFT JOIN [DATAEX].[010_forma_pago] fp ON s.FORMA_PAGO_ID = fp.FORMA_PAGO_ID
LEFT JOIN [DATAEX].[009_motivo_venta] mv ON s.MOTIVO_VENTA_ID = mv.MOTIVO_VENTA_ID

-- Tienda, zona y provincia
LEFT JOIN [DATAEX].[011_tienda] t ON s.TIENDA_ID = t.TIENDA_ID
LEFT JOIN [DATAEX].[013_zona] z ON t.ZONA_ID = z.ZONA_ID
LEFT JOIN [DATAEX].[012_provincia] prov ON t.PROVINCIA_ID = prov.PROVINCIA_ID

-- Logística y origen
LEFT JOIN [DATAEX].[017_logist] logist ON s.CODE = logist.CODE
LEFT JOIN [DATAEX].[016_origen_venta] origen_venta ON logist.Origen_Compra_ID = origen_venta.Origen_Compra_ID

-- Edad del coche
LEFT JOIN [DATAEX].[018_edad] edad_coche ON s.CODE = edad_coche.CODE

-- Quejas
LEFT JOIN [DATAEX].[008_cac] cac ON s.CODE = cac.CODE

LEFT JOIN resumen_clientes rc ON c.Customer_ID = rc.Customer_ID

