-- ========================================
-- Consulta agregada para análisis de churn
-- ========================================

-- Esta consulta tiene como objetivo generar un resumen de métricas relevantes 
-- para modelar el churn (abandono de cliente) en función del PVP (Precio de Venta al Público).
-- Se agrupan los registros por valor de PVP y se calculan promedios de variables clave 
-- para cada grupo, lo cual es útil en un análisis exploratorio previo a una regresión.


SELECT 
    s.PVP AS PVP,  -- Precio de venta al público (clave de agrupación)
    AVG(s.Car_Age) AS Edad_Media_Coche,  -- Edad media del coche en cada grupo de PVP
    AVG(s.km_ultima_revision) AS Km_Medio_Por_Revision,  -- Kilometraje medio entre revisiones, por grupo de PVP
    AVG(ISNULL(s.Revisiones, 0)) AS Revisiones_Media,  -- Número medio de revisiones por grupo, imputando los nulos como 0
    AVG(CAST(Tasa_Churn AS FLOAT)) AS churn_percentage  -- Porcentaje medio de churn en cada grupo de PVP
    
FROM [dbo].[tabla_hechos] s
GROUP BY s.PVP;