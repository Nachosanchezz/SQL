
-- Consulta para combinar información de clientes
-- con ventas y atributos relacionados


-- Esta consulta une la tabla de clientes (dim_clientes) con la tabla de hechos (tabla_hechos)
-- para obtener un dataset completo a nivel de transacción con métricas tanto demográficas
-- como comerciales. Esta vista es útil para análisis de segmentación, churn, CLTV o scoring.

SELECT
    -- 🔹 Información demográfica del cliente
    c.Customer_ID,                     -- Identificador único del cliente
    c.Edad,                            -- Edad del cliente
    c.Fecha_nacimiento,               -- Fecha de nacimiento
    c.GENERO,                          -- Género
    c.CODIGO_POSTAL,                  -- Código postal
    c.poblacion,                      -- Población
    c.provincia,                      -- Provincia
    c.STATUS_SOCIAL,                  -- Nivel socioeconómico
    c.RENTA_MEDIA_ESTIMADA,          -- Estimación de la renta
    c.ENCUESTA_ZONA_CLIENTE_VENTA,   -- Zona donde compró
    c.ENCUESTA_CLIENTE_ZONA_TALLER,  -- Zona donde repara

    -- 🔹 Variables de segmentación tipo Mosaic (sociodemográficas)
    c.A, c.B, c.C, c.D, c.E, c.F, c.G, c.H, c.I, c.J, c.K,
    c.Max_Mosaic_G,                   -- Segmento principal (grupo mosaico)
    c.Renta_Media,                   -- Renta media del área

    -- 🔹 Información de transacciones asociadas al cliente
    f.CODE,                          -- ID único de la transacción
    f.TIENDA_ID,                     -- Tienda donde se realizó la venta
    f.Id_Producto,                   -- Producto vendido
    f.Sales_Date,                    -- Fecha de la venta
    f.PVP,                           -- Precio de venta al público
    f.MANTENIMIENTO_GRATUITO,        -- Si incluye mantenimiento
    f.SEGURO_BATERIA_LARGO_PLAZO,    -- Si incluye seguro de batería
    f.FIN_GARANTIA,                  -- Fecha de fin de garantía
    f.COSTE_VENTA_NO_IMPUESTOS,      -- Coste de la venta sin impuestos
    f.IMPUESTOS,                     -- Porcentaje de impuestos aplicados
    f.EN_GARANTIA,                   -- Si está en garantía
    f.EXTENSION_GARANTIA,            -- Si hay extensión de garantía

    -- 🔹 Variables económicas y de rentabilidad
    f.Margen,                        -- Margen sobre PVP (%)
    f.Margendistribuidor,           -- Margen para el distribuidor (%)
    f.Costetransporte,              -- Coste de transporte
    f.GastosMarketing,              -- Gastos de marketing
    f.Comisión_marca,               -- Comisión para la marca (%)
    f.Margen_eur_bruto,             -- Margen bruto en euros
    f.Margen_eur,                   -- Margen neto en euros

    -- 🔹 Indicador de engagement comercial
    -- Sumamos si fue lead o convirtió en compra
    COALESCE(TRY_CONVERT(INT, f.Lead_compra), 0) +
    COALESCE(TRY_CONVERT(INT, f.fue_Lead), 0) AS Total_Leads

-- 🔹 JOIN entre la dimensión cliente y la tabla de hechos
FROM [dbo].[dim_clientes] AS c
LEFT JOIN [dbo].[tabla_hechos] AS f
    ON c.Customer_ID = f.Customer_ID;
