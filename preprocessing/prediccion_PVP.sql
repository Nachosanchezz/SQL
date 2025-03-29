SELECT 
    s.PVP AS PVP,
    AVG(s.Car_Age) AS Edad_Media_Coche,
    AVG(s.km_ultima_revision) AS Km_Medio_Por_Revision,
    AVG(CAST(Tasa_Churn AS FLOAT)) AS churn_percentage,
    AVG(ISNULL(s.Revisiones, 0)) AS Revisiones_Media,
    AVG(s.Margen) AS Margen
FROM [dbo].[tabla_hechos] s
GROUP BY s.PVP;