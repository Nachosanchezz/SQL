SELECT
    z.ZONA_ID, -- PK de zona
    z.ZONA, -- Nombre de la zona  
    prov.PROVINCIA_ID, -- PK de provincia
    prov.PROV_DESC, -- Nombre de la provincia
    t.TIENDA_ID, -- PK de tienda
    t.TIENDA_DESC -- Nombre de la tienda
FROM [DATAEX].[011_tienda] t
LEFT JOIN [DATAEX].[013_zona] z ON t.ZONA_ID = z.ZONA_ID
LEFT JOIN [DATAEX].[012_provincia] prov ON t.PROVINCIA_ID = prov.PROVINCIA_ID
