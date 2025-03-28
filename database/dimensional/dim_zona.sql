SELECT
    z.ZONA_ID, 
    z.ZONA, 
    prov.PROVINCIA_ID, 
    prov.PROV_DESC, 
    t.TIENDA_ID, -- PK de tienda
    t.TIENDA_DESC 
FROM [DATAEX].[011_tienda] t
LEFT JOIN [DATAEX].[013_zona] z ON t.ZONA_ID = z.ZONA_ID  -- JOIN con zona
LEFT JOIN [DATAEX].[012_provincia] prov ON t.PROVINCIA_ID = prov.PROVINCIA_ID -- JOIN con provincia
