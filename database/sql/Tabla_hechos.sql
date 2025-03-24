SELECT
    s.CODE,                -- PK de sales
    c.Customer_ID,         -- FK de clientes
    prod.Id_Producto,         -- FK de producto
    s.Sales_Date,          -- FK de fecha
    fp.FORMA_PAGO_ID,       -- FK de forma_pago
    mv.MOTIVO_VENTA_ID,     -- FK de motivo_venta
    t.TIENDA_ID,           -- FK de tienda
    s.PVP                 -- Precio de venta
    prov.Provincia_ID      -- FK de provincia
FROM [DATAEX].[001_sales] s
LEFT JOIN [DATAEX].[002_date] d ON s.Sales_Date = d.Date
LEFT JOIN [DATAEX].[003_clientes] c ON s.Customer_ID = c.Customer_ID
LEFT JOIN [DATAEX].[006_producto] prod ON s.Id_Producto = prod.Id_Producto
LEFT JOIN [DATAEX].[010_forma_pago] f ON s.FORMA_PAGO_ID = f.FORMA_PAGO_ID
LEFT JOIN [DATAEX].[009_motivo_venta] m ON s.MOTIVO_VENTA_ID = m.MOTIVO_VENTA_ID
LEFT JOIN [DATAEX].[011_tienda] t ON s.TIENDA_ID = t.TIENDA_ID
LEFT JOIN [DATAEX].[012_provincia] p ON t.PROVINCIA_ID = p.PROVINCIA_ID

SELECT
    s.CODE AS Venta_ID,          -- PK de la tabla de ventas
    c.Customer_ID,               -- FK de clientes
    p.Id_Producto,               -- FK de producto
    d.Date AS Fecha,             -- FK de fecha
    fp.FORMA_PAGO_ID,            -- FK de forma de pago
    mv.MOTIVO_VENTA_ID,          -- FK de motivo de venta
    t.TIENDA_ID,                 -- FK de tienda
    z.ZONA_ID,                   -- FK de zona
    prov.PROVINCIA_ID,           -- FK de provincia
    s.PVP AS Precio_Venta,       -- Precio de venta
    s.COSTE_VENTA_NO_IMPUESTOS,  -- Coste de venta sin impuestos
    s.IMPUESTOS,                 -- Impuestos aplicados
    s.MANTENIMIENTO_GRATUITO,    -- Si tiene mantenimiento gratuito
    s.EN_GARANTIA,               -- Si está en garantía
    s.EXTENSION_GARANTIA,        -- Si tiene extensión de garantía
    s.SEGURO_BATERIA_LARGO_PLAZO,-- Si tiene seguro de batería a largo plazo
    cost.Costetransporte,        -- Coste de transporte del producto
    cost.GastosMarketing,        -- Gastos de marketing asociados al producto
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

