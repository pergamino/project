args = commandArgs(trailingOnly=TRUE)

library(bsplus)
library(leaflet)
library(RPostgreSQL)

source("archivo_epidemio_app.R")
source("0.2-moulinette_inoculum.R")
source("1-moulinette_meteo.R")
source("2-ipsim.R")
source("3-pronostico.R")
source("4.1-plot_pronostico.R")
source("4.2-plot_moulinette_meteo.R")
source("4.3-infoBox_alerta.R")

func_ipsim_app <- function() {

  #create connection object
  con <- dbConnect(drv =PostgreSQL(), 
                   user="admin", 
                   password="%Rsecret#",
                   host="localhost", 
                   port=5432, 
                   dbname="pergamino")
  
  #---------------------Querys a la base de datos -----------------------------------### 
  result <- dbGetQuery(con, paste(paste("SELECT * from argumentos_ipsim_app where cod_lote=", args[1], sep=""), "order by fecha desc limit 1;"))
  #result <- dbGetQuery(con, "SELECT * from argumentos_ipsim_app where cod_lote=36 order by fecha desc limit 1;") #consulta de prueba 
  

  #cadena para hacer la consulta del clima segun la coordenada de lote
  consulta <- paste("select cast(fecha as varchar) as fecha, precipitacion as precip, temperatura as tmean from datosmodeloclima where gid in (select gid from climasamplingpoints order by st_distance(st_geogfromtext('POINT(",result["lng"]," ",result["lat"],")'),geom) limit 1)",sep="")

  #realizar la consulta en la tabla clima
  rs_clima <- dbGetQuery(con,consulta)
  
  dbDisconnect(con)   #disconnect from database
  
  #----------------PREPARAR parametros para IPSIM --------------------------#
  rs_clima$fecha <- format(strptime(as.character(rs_clima$fecha),  "%Y-%m-%d"),"%d/%m/%Y") #cambiar formato de fechas a datos climaticos
  fichier_epid <- fichier_epid_new(result) #formatear datos epidiomilogicos 
  
  df_moulinette_inoc <- moulinette_inoc(fichier_epid)           #preparar datos epidiomoligicos
  df_moulinette_meteo <- moulinette_meteo(rs_clima, fichier_epid)#preparar datos climaticos
  
  meses_fungicida <- as.vector(as.numeric(format(as.Date(result$fungicida_fecha), "%m"))) #obtener el mes en INT de fecha aplic. fungicida
  if(result$fertilizacion) #si es true es 1 y si es false es 2
    nutri_adecuada <- 1
  else 
    nutri_adecuada <- 2
  

  # -------------------SE EJECUTA IPSIM ----------------
  df_ipsim =
    func_ipsim(
      df_moulinette_meteo,
      df_moulinette_inoc,
      result$carga_fruct,
      result$cat_variedad,
      meses_fungicida,
      nutri_adecuada,
      result$floracion,
      result$inicio_cosecha,
      result$fin_cosecha,
      result$sombra
    )
  
  return(df_ipsim$riesgo)
  
  

}

if (length(args)==0) {
  stop("At least one argument must be supplied", call.=FALSE)
} else if (length(args)==1) {
  print(func_ipsim_app()) #llamar ipsim function definida arriba
}




