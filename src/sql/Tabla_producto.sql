SELECT
    p.Id_Producto,          -- PK de producto
    p.Code_,               -- Código de referencia del producto
    p.Modelo,              -- Nombre del modelo
    p.TIPO_CARROCERIA,     -- Tipo de carrocería
    p.Kw,                  -- Potencia en kW
    p.TRANSMISION_ID,      -- Tipo de transmisión
    f.FUEL,     
    cat.CATEGORIA_ID,      -- Categoría del producto
    cat.Equipamiento       -- Nivel de equipamiento

FROM [DATAEX].[006_producto] p
LEFT JOIN [DATAEX].[015_fuel] f ON p.Fuel_ID = f.Fuel_ID
LEFT JOIN [DATAEX].[014_categoría_producto] cat ON p.CATEGORIA_ID = cat.CATEGORIA_ID
LEFT JOIN [DATAEX].[007_costes] cost ON p.Modelo = cost.Modelo




