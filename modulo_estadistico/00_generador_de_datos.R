
# Dependencias ------------------------------------------------------------

if(!require(dplyr)) install.packages(dplyr)
if(!require(lubridate)) install.packages(lubridate)
library(RPostgreSQL)

generar_datos <- function(input) {
  if( !is.null(input$archivo_clima)  ){
      tryCatch(
        {
              datos_crudos <- read.csv(input$archivo_clima$datapath,
                                       header = TRUE,
                                       fileEncoding="UTF-8-BOM",
                                       sep = input$sep,
                                       quote = '"')
              
              if("precipitacion" %in% colnames(datos_crudos) && "tempmin" %in% colnames(datos_crudos) && "tempmax" %in% colnames(datos_crudos) && "fecha" %in% colnames(datos_crudos)  )
              {
                names(datos_crudos)[names(datos_crudos) == "precipitacion"] <- "lluvia_diaria"
                names(datos_crudos)[names(datos_crudos) == "tempmin"] <- "temp_min"
                names(datos_crudos)[names(datos_crudos) == "tempmax"] <- "temp_max"
                names(datos_crudos)[names(datos_crudos) == "fecha"] <- "fecha"
                
                datos_crudos$fecha <- as_date(format(strptime(as.character(datos_crudos$fecha), "%m/%d/%y" ),"%Y-%m-%d")) #cambiar formato de fechas 
                
                saveRDS(datos_crudos, file = "datos/00_datos_crudos.RDS")
                
                #print(input$archivo_clima$datapath)
                
                print("Modelo ejecutado con nuevos datos crudos de clima")
                showNotification("Modelo ejecutado correctamente.",type = "message")
                return(1)
              }else{
                showNotification("Error con el formato del archivo. Debe tener datos de tempmax, tempmin y precipitacion",type = "error")
                return(-1)
                #stop(safeError("Error: no coincide con el formato requerido."))
              }
              

        },
        error = function(e) {
          # return a safeError if a parsing error occurs
          showNotification("Error al leer el archivo. Revise el formato.",type = "error")
          return(-1)
          #stop(safeError(e))
        }
      )

    
  }else{
      #create connection object
      con <- dbConnect(drv =PostgreSQL(), 
                       user="admin", 
                       password="%Rsecret#",
                       host="localhost", 
                       port=5432, 
                       dbname="pergamino")
      
      #cadena para hacer la consulta del clima segun la coordenada de lote
      consulta <- paste("select fecha, precipitacion as lluvia_diaria, tempmin as temp_min, tempmax as temp_max from datosmodeloclima where gid in (select gid from climasamplingpoints order by st_distance(st_geogfromtext('POINT(",lngG," ",latG,")'),geom) limit 1)",sep="")
      
      #realizar la consulta en la tabla clima
      rs_clima <- dbGetQuery(con,consulta)
      
      dbDisconnect(con)   #disconnect from database
      
      
      print("Con datos de clima de un punto aleatorio de la region")
      
      # Creacion del set de datos artificiales ----------------------------------
          
      # Setear la semilla para las variables aleatorias
      
      set.seed(140)
      
      # Definir vector/columna fecha
      
      primera_fecha <- as_date("2019-01-01")
      
      ultima_fecha  <- Sys.Date()
      
      fecha         <- seq(primera_fecha, ultima_fecha, 1)
      
      # Crear esqueleto del dataframe y guardar en este las fechas creadas
      
      datos_crudos  <- data.frame("fecha"         = fecha,
                                  "lluvia_diaria" = vector(mode   = "numeric", 
                                                           length = length(fecha)),
                                  "temp_min"      = vector(mode   = "numeric", 
                                                           length = length(fecha)),
                                  "temp_max"      = vector(mode   = "numeric", 
                                                           length = length(fecha)))
      
      
      
      # Crear en el datos aleatoriamente 
      
      datos_crudos$lluvia_diaria <- rnorm(length(fecha), 5, 2)
      
      datos_crudos$temp_max      <- rnorm(length(fecha), 27, 3)
      
      datos_crudos$temp_min      <- rnorm(length(fecha), 22, 3)
      
      showNotification("El modelo se ha ejecutado con datos del clima de un sitio aleatorio.",type = "warning")
      return(1)
      
      # Guardar el archivo de datos
      
      saveRDS(rs_clima, file = "datos/00_datos_crudos.RDS")
  }
}




