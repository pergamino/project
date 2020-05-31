
# Dependencias ------------------------------------------------------------

if(!require(dplyr)) install.packages(dplyr)
if(!require(lubridate)) install.packages(lubridate)


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

# Guardar el archivo de datos

saveRDS(datos_crudos, file = "datos/00_datos_crudos.RDS")

