-- Dimensión de tiempo

SELECT
    d.Date AS Fecha,           -- PK de la tabla de tiempo
    d.Anno AS Año,                    -- Año
    d.Annomes AS Añomes,                 -- Año y mes combinado
    d.Mes,                     -- Mes del año
    d.Dia,                     -- Día del mes
    d.Diadelasemana,           -- Día de la semana (numérico)
    d.Diadelesemana_desc,      -- Día de la semana (nombre)
    d.Festivo,                 -- Indica si es festivo o no
    d.Findesemana,             -- Indica si es fin de semana o no
    d.FinMes,                  -- Indica si es el último día del mes
    d.InicioMes,               -- Indica si es el primer día del mes
    d.Laboral,                 -- Indica si es un día laboral
    d.Mes_desc,                -- Nombre del mes
    d.Week AS Semana                     -- Semana del año
FROM [DATAEX].[002_date] d;

