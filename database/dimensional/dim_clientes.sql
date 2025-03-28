SELECT 
    c.Customer_ID,
    c.CODIGO_POSTAL,
    c.Edad,
    c.GENERO,
    c.RENTA_MEDIA_ESTIMADA,
    c.STATUS_SOCIAL,
    c.Fecha_nacimiento,
    c.ENCUESTA_CLIENTE_ZONA_TALLER,
    c.ENCUESTA_ZONA_CLIENTE_VENTA,
    cp.poblacion,
    cp.provincia,
    cp.lat,
    cp.lon,
    cp.CP,
    m.Max_Mosaic,
    m.Max_Mosaic_G,
    m.Renta_Media,
    m.A,
    m.B,
    m.C,
    m.D,
    m.E,
    m.F,
    m.G,
    m.H,
    m.I,
    m.J,
    m.K
FROM [DATAEX].[003_clientes] AS c
LEFT JOIN [DATAEX].[005_cp] cp ON c.CODIGO_POSTAL = cp.CP -- Join con CODIGO_POSTAL (1:0..1).
LEFT JOIN [DATAEX].[019_mosaic] m ON TRY_CAST(cp.codigopostalid AS INT) = TRY_CAST(m.CP AS INT) -- Join con CP (1:0..1).



