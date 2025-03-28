SELECT
    p.Id_Producto,           -- PK de producto
    p.Code_,                 -- Pk de producto
    p.Modelo,                
    p.Kw,                    
    p.TIPO_CARROCERIA,       
    p.TRANSMISION_ID,        
    
    -- Tipo de combustible 
    f.FUEL,                 
    
    -- Categoría
    cat.CATEGORIA_ID,
    cat.Equipamiento,        
    
    -- Costes asociados
    cost.Margen,
    cost.Costetransporte,
    cost.Margendistribuidor,
    cost.GastosMarketing

FROM [DATAEX].[006_producto] p
LEFT JOIN [DATAEX].[015_fuel] f ON p.Fuel_ID = f.Fuel_ID -- JOIN con tipo de combustible
LEFT JOIN [DATAEX].[014_categoría_producto] cat ON p.CATEGORIA_ID = cat.CATEGORIA_ID -- JOIN con categoría de producto
LEFT JOIN [DATAEX].[007_costes] cost ON p.Modelo = cost.Modelo;  -- JOIN con costes asociados al producto



