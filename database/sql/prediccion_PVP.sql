SELECT 
     sales.PVP AS PVP,
     AVG(sales.Car_Age) AS Edad_Media_Coche,
     AVG(sales.km_ultima_revision) AS Km_Medio_Por_Revision,
     COUNT(sales.CODE) * 1.0 / COUNT(DISTINCT sales.Customer_ID) AS Revisiones_Media,
     AVG(CAST(Tasa_Churn AS FLOAT)) AS churn_percentage
 FROM [dbo].[tabla_hechos] sales
 GROUP BY sales.PVP;
