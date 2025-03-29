
-- Consulta para enriquecer los datos de clientes
-- mediante joins con información geográfica y
-- segmentación sociodemográfica.

-- Objetivo:
-- Obtener una tabla consolidada a nivel cliente, incorporando:
-- 1. Información demográfica del cliente desde la tabla [003_clientes].
-- 2. Datos geográficos (latitud, longitud, población, provincia) desde [005_cp].
-- 3. Información de segmentación Mosaic desde [019_mosaic].

-- Esto resulta útil para análisis de comportamiento, segmentación avanzada, 
-- geolocalización, estudios de mercado y modelado predictivo como churn o CLTV.

SELECT 
    -- 🔹 Identificador del cliente y datos base
    c.Customer_ID,                -- Clave primaria del cliente
    c.CODIGO_POSTAL,             -- Código postal (clave para unir con CP y Mosaic)
    c.Edad,                      -- Edad del cliente
    c.GENERO,                    -- Género
    c.RENTA_MEDIA_ESTIMADA,     -- Estimación de ingresos
    c.STATUS_SOCIAL,            -- Segmento social
    c.Fecha_nacimiento,         -- Fecha de nacimiento

    -- 🔹 Preferencias en relación con zonas de venta y taller
    c.ENCUESTA_CLIENTE_ZONA_TALLER,
    c.ENCUESTA_ZONA_CLIENTE_VENTA,

    -- 🔹 Información geográfica desde tabla de códigos postales
    cp.poblacion,               -- Nombre de la población
    cp.provincia,               -- Provincia
    cp.lat,                     -- Latitud geográfica
    cp.lon,                     -- Longitud geográfica
    cp.CP,                      -- Código postal limpio (para joins)

    -- 🔹 Información de segmentación Mosaic (datos sociodemográficos agregados por zona)
    m.Max_Mosaic,               -- Segmento Mosaic principal
    m.Max_Mosaic_G,            -- Grupo general Mosaic
    m.Renta_Media,             -- Renta media por CP
    m.A, m.B, m.C, m.D, m.E,    -- Variables sociodemográficas por zona
    m.F, m.G, m.H, m.I, m.J, m.K

-- 🔹 Tablas y relaciones
FROM [DATAEX].[003_clientes] AS c

-- 🔸 JOIN con tabla de códigos postales (1:0..1)
LEFT JOIN [DATAEX].[005_cp] cp 
    ON c.CODIGO_POSTAL = cp.CP

-- 🔸 JOIN con tabla Mosaic (1:0..1) usando CP convertido a entero
LEFT JOIN [DATAEX].[019_mosaic] m 
    ON TRY_CAST(cp.codigopostalid AS INT) = TRY_CAST(m.CP AS INT);
