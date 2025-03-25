SELECT
    s.CODE AS Venta_ID,  -- PK de la tabla de ventas
    s.Code_,             -- Fk de la tabla de productos
    s.Customer_ID,       -- Fk de la tabla de clientes
    s.PVP AS Precio_Venta,       
    s.COSTE_VENTA_NO_IMPUESTOS, 
    s.IMPUESTOS,                 
    s.MANTENIMIENTO_GRATUITO,    
    s.EN_GARANTIA,               
    s.EXTENSION_GARANTIA,
    CONVERT(DATE, s.FIN_GARANTIA, 103) AS Fecha_Fin_Garantia,     
    s.SEGURO_BATERIA_LARGO_PLAZO,      
    s.Id_Producto,       -- Fk de la tabla de productos
    CONVERT(DATE,s.Sales_Date,103) AS Sales_Date,     -- Fk de la tabla de tiempo
    s.TIENDA_ID,         -- Fk de la tabla de zona          
    
    -- Forma de pago
    fp.FORMA_PAGO_ID,           
    
    -- Motivo de venta
    mv.MOTIVO_VENTA_ID,          

    -- Zona y Provincia               
    z.ZONA_ID,                   
    prov.PROVINCIA_ID,          
    
    cost.Costetransporte,        
    cost.GastosMarketing        
FROM [DATAEX].[001_sales] s
-- Dimensión Fecha
LEFT JOIN [DATAEX].[002_date] d ON s.Sales_Date = d.Date
-- Dimensión Cliente
LEFT JOIN [DATAEX].[003_clientes] c ON s.Customer_ID = c.Customer_ID
LEFT JOIN [DATAEX].[005_cp] cp ON c.CODIGO_POSTAL = cp.CP
LEFT JOIN [DATAEX].[019_Mosaic] m ON c.CODIGO_POSTAL = m.CP_value
-- Dimensión Producto con Costes
LEFT JOIN [DATAEX].[006_producto] p ON s.Id_Producto = p.Id_Producto
LEFT JOIN [DATAEX].[015_fuel] f ON p.Fuel_ID = f.Fuel_ID
LEFT JOIN [DATAEX].[014_categoría_producto] cat ON p.CATEGORIA_ID = cat.CATEGORIA_ID
LEFT JOIN [DATAEX].[007_costes] cost ON p.Modelo = cost.Modelo
-- Dimensión Forma de Pago
LEFT JOIN [DATAEX].[010_forma_pago] fp ON s.FORMA_PAGO_ID = fp.FORMA_PAGO_ID
-- Dimensión Motivo de Venta
LEFT JOIN [DATAEX].[009_motivo_venta] mv ON s.MOTIVO_VENTA_ID = mv.MOTIVO_VENTA_ID
-- Dimensión Tienda y Ubicación
LEFT JOIN [DATAEX].[011_tienda] t ON s.TIENDA_ID = t.TIENDA_ID
LEFT JOIN [DATAEX].[013_zona] z ON t.ZONA_ID = z.ZONA_ID
LEFT JOIN [DATAEX].[012_provincia] prov ON t.PROVINCIA_ID = prov.PROVINCIA_ID;

