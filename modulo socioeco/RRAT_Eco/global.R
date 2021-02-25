library(shiny)
library(shinydashboard)
library(shinydashboardPlus)
library(ggplot2)
library(rhandsontable)
library(excelR)
library(dplyr)
library(RPostgreSQL)
library(shinyjs)
library(stringr)

source("Eco-func-V3.R")

con <- dbConnect(PostgreSQL(), dbname = "pergamino", user = "admin",
                 host = "localhost",
                 password = "%Rsecret#")

sql <- "select * from pais order by cod_pais"
paises <- dbGetQuery(con,sql)

sql <- "select distinct rrat5, idpais from sat_regiones where rrat5 in (select nombre from region_alerta)"
regiones <- dbGetQuery(con,sql)

sql <- "select * from unidades order by cod_unidad"
unidades <- dbGetQuery(con,sql)

sql <- "select * from factorcosto order by id"
ncisql <- dbGetQuery(con,sql)

nci <- matrix(ncisql$factor,nrow=3,ncol=1,dimnames=list(c("alto","regular","bajo"),"factor"))

sql <- "select * from costomanejo order by id"
costomanejo <- dbGetQuery(con,sql)

sql <- "select * from roya_historica order by region, nmes"
royahistorica <- dbGetQuery(con,sql)

sql <- "select pais || ' - ' || region || ' - ' || tipoprod as perfil, * from valores_variables_socioeconomicas order by cod_pais, cod_region"
varsocioeco <- dbGetQuery(con,sql)

sql <- "select * from tiposproductores order by idtipo"
tipoproductor <- dbGetQuery(con,sql)

dbDisconnect(con)


