
source("00_generador_de_datos.R")
source("01_procesador_de_variables.R")
source("02_generador_de_pronosticos.R")

addLink <- function(x) {
  fa("circle", fill = x, height = "60px")
}