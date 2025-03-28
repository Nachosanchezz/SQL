SELECT
    c.Customer_ID,  -- Solo el Customer_ID de Dim_client
    c.Edad,
    c.Fecha_nacimiento,
    c.GENERO,
    c.CODIGO_POSTAL,
    c.poblacion,
    c.provincia,
    c.STATUS_SOCIAL,
    c.RENTA_MEDIA_ESTIMADA,
    c.ENCUESTA_ZONA_CLIENTE_VENTA,
    c.ENCUESTA_CLIENTE_ZONA_TALLER,
    c.A,
    c.B,
    c.C,
    c.D,
    c.E,
    c.F,
    c.G,
    c.H,
    c.I,
    c.J,
    c.K,
    c.Max_Mosaic_G,
    c.Renta_Media,
    f.CODE,
    f.TIENDA_ID,
    f.Id_Producto,
    f.Sales_Date,
    f.PVP,
    f.MANTENIMIENTO_GRATUITO,
    f.SEGURO_BATERIA_LARGO_PLAZO,
    f.FIN_GARANTIA,
    f.COSTE_VENTA_NO_IMPUESTOS,
    f.IMPUESTOS,
    f.EN_GARANTIA,
    f.EXTENSION_GARANTIA,
    f.Margen,
    f.Margendistribuidor,
    f.Costetransporte,
    f.GastosMarketing,
    f.Comisión_marca,
    f.Margen_eur_bruto,
    f.Margen_eur,

    -- 🔹 Sumatorio de leads con conversión segura
    COALESCE(TRY_CONVERT(INT, f.Lead_compra), 0) +
    COALESCE(TRY_CONVERT(INT, f.fue_Lead), 0) AS Total_Leads

FROM [dbo].[dim_clientes] AS c
LEFT JOIN [dbo].[tabla_hechos] AS f
    ON c.Customer_ID = f.Customer_ID;