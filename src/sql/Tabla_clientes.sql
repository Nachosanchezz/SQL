SELECT
    c.Customer_ID,          -- PK de clientes
    c.EDAD,                 -- Edad del cliente
    c.GENERO,               -- Género del cliente
    c.RENTA_MEDIA_ESTIMADA, -- Renta media estimada
    c.STATUS_SOCIAL,        -- Estatus social del cliente
    c.CODIGO_POSTAL,        -- Código postal (para relacionarlo con la ubicación)
    cp.poblacion,           -- Nombre de la poblaciónx
    cp.provincia,           -- Provincia del cliente
COALESCE(cp.CP,
    CONCAT('CP', m.CP_value),
    CONCAT('CP', c.CODIGO_POSTAL)) AS CODIGO_POSTAL_UNIFICADO 
               
FROM [DATAEX].[003_clientes] c
LEFT JOIN [DATAEX].[005_cp] cp ON c.CODIGO_POSTAL = cp.CP
LEFT JOIN [DATAEX].[019_Mosaic] m ON c.CODIGO_POSTAL = m.CP_value;

SELECT TOP (10) *
  FROM [DATAEX].[005_cp]

SELECT TOP (10) *
  FROM [DATAEX].[019_Mosaic]