SELECT
    c.Customer_ID,     -- PK de clientes
    c.EDAD,
    c.GENERO,
    c.RENTA_MEDIA_ESTIMADA,
    c.STATUS_SOCIAL,
    c.CODIGO_POSTAL,
    cp.poblacion,
    cp.provincia,
    c.Fecha_nacimiento,
    RIGHT('00000' + REPLACE(c.CODIGO_POSTAL, 'CP', ''), 5) AS CP_NUM,    -- Código postal en formato numérico: quita el 'CP' y lo deja con 5 dígitos
    m.Mosaic_number,
    m.Max_Mosaic
FROM [DATAEX].[003_clientes] c   -- Tabla principal de clientes
LEFT JOIN [DATAEX].[005_cp] cp ON c.CODIGO_POSTAL = cp.CP  -- JOIN con CODIGO_POSTAL
LEFT JOIN [DATAEX].[019_Mosaic] m   -- JOIN con CP en formato numérico
    ON RIGHT('00000' + REPLACE(c.CODIGO_POSTAL, 'CP', ''), 5) = RIGHT('00000' + CAST(m.CP_value AS VARCHAR), 5);
