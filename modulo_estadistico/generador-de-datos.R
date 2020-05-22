# dependencias 

if(!require(dplyr)) install.packages(dplyr)
if(!require(lubridate)) install.packages(lubridate)

# definiendo vecto fecha

primera_fecha <- as_date("2019-05-22")

ultima_fecha <- as_date("2020-05-21")

fecha <- seq(primera_fecha, ultima_fecha,1)


datos_crudos <- data.frame("fecha" = fecha,
                           "lluvia_diaria" = vector(mode = "numeric", 
                                                    length = length(fecha)),
                           "temp_min" = vector(mode = "numeric", 
                                                    length = length(fecha)),
                           "temp_max" = vector(mode = "numeric", 
                                                    length = length(fecha)))



# creando fechas 

datos_crudos$lluvia_diaria <- rnorm(length(fecha), 5, 2)

datos_crudos$temp_max <- rnorm(length(fecha), 27, 3)

datos_crudos$temp_min <- rnorm(length(fecha), 22, 3)

datos_crudos$amplitud_termica <- datos_crudos$temp_max - datos_crudos$temp_min 

saveRDS(datos_crudos, file = "datos/datos_crudos.RDS")
