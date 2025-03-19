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

