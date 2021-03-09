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
library(waiter)
source("Eco-func-V3.R")

con <- dbConnect(PostgreSQL(), dbname = "pergamino", user = "admin",
                 host = "localhost",
                 password = "%Rsecret#")

sql <- "select * from pais order by cod_pais"
paises <- dbGetQuery(con,sql)

sql <- "select * from tiposproductores order by idtipo"
tipoproductor <- dbGetQuery(con,sql)

dbDisconnect(con)
nivel <- c('ninguno','minimo','bajo','medio','alto')
nivel2 <- c('bajo','regular','alto')