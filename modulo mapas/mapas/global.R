library(sf)
library(openxlsx)
library(htmltools)
library(RPostgreSQL)
library(gdata)
library(plotly)
library(ggplot2)
library(gridExtra)
con <- dbConnect(PostgreSQL(), dbname = "pergamino", user = "admin",
                 host = "localhost",
                 password = "%Rsecret#")

zonas <- st_read("CafeCardSHP/CafeRRAT5b.shp")
zonas <- st_simplify(zonas, preserveTopology = T, dTolerance = 1)

sql <- "select
a.nombre as RRAT5,
b.periodo as Periodo,
c.catvariedad as CATvariedad,
UPPER(d.pais) as pais,
z.incidencia_media as media,
e.color as alertares,
f.color as alertamed,
g.color as alertasus,
z.nregistros as n,
z.mes,
z.anio
from region_alerta a
inner join evaluacion_regional_roya_detalle z on a.cod_region = z.cod_region 
inner join periodo_fenologia b on b.cod_periodo = z.cod_periodo
inner join categoria_variedad c on c.cod_catvariedad = z.cod_catvariedad
inner join pais d on d.cod_pais = z.cod_pais
inner join (select cod_alerta, color from alertas) as e on e.cod_alerta = z.cod_alerta_res
inner join (select cod_alerta, color from alertas) as f on f.cod_alerta = z.cod_alerta_med 
inner join (select cod_alerta, color from alertas) as g on g.cod_alerta = z.cod_alerta_sus
order by z.anio, z.mes asc"

epid <- dbGetQuery(con,sql)

sqlareas <- "select 
case when periodo = 'Antes de cosecha' then 1 
when periodo = 'Durante cosecha' then 2
when periodo = 'Después de cosecha' then 3
end as periodo,
case when catvariedad = 'Susceptibles' then 1
when catvariedad = 'Medianamente resistentes' then 2
when catvariedad = 'Resistentes' then 3
end as catvariedad,
mes,
anio,
case when color = 'azul' then '#00b2f3'
when color = 'verde' then '#63fd2c'
when color = 'amarilla' then '#fffc00'
when color = 'naranja' then '#fabf00'
when color = 'rojo' then '#fd0100' end as color,
areaalerta,
porcentaje
from alertas_porcentaje_areas order by periodo,catvariedad,mes,anio,color"

areas <- dbGetQuery(con,sqlareas)
  
dbDisconnect(con)
#epid <- read.xlsx("dataEpid/allData.xlsx")

epid$alerta[epid$alertares!=""] <- epid$alertares[epid$alertares!=""]
epid$alerta[epid$alertamed!=""] <- epid$alertamed[epid$alertamed!=""]
epid$alerta[epid$alertasus!=""] <- epid$alertasus[epid$alertasus!=""]

epid$id <- paste0(epid$rrat5,epid$pais)
zonas$id <- paste0(zonas$RRAT5,zonas$PAIS)

tabColors <- c("roja"="red","rojo"="red","naranja"="orange","amarillo"="yellow",
               "amarilla"="yellow","verde"="green","azul"="blue") 

epid$alerta <- tabColors[trim(epid$alerta)]


variedad <- unique(factor(epid$catvariedad))


epid$periodo2 <- ifelse(epid$periodo== "Antes de cosecha",
                        "De la floración hasta la cosecha",
                        ifelse(epid$periodo == "Durante cosecha",
                               "Durante de la cosecha",
                               "De la cosecha hasta la floración"))

periodo_feno <- unique(factor(epid$periodo2))

anios <- unique(factor(epid$anio))

zonas <- st_transform(zonas,4326) # à la place de 4326 "+proj=longlat +datum=WGS84"

bnd_zonas <- st_bbox(zonas)

minMes <- 1
maxMes <- 12

getMes <- function(mes)
{
  switch(mes,"1" = "Enero", "2" = "Febrero","3" = "Marzo","4" = "Abril","5" = "Mayo","6" = "Junio","7" = "Julio","8" = "Agosto","9" = "Septiembre","10" = "Octubre","11" = "Noviembre","12" = "Diciembre")
}