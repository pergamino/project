
# Dependencias ------------------------------------------------------------

if(!require("pacman")) install.packages("pacman")

p_load("dplyr")

procesar_variables <- function() {
  # Procesamiento de variables --------------------------------------------------------------------
  
  datos <- readRDS("datos/00_datos_crudos.RDS")
  
  # Temperatura minima
  
  temp_min_sombra <- 1.23 + 0.94 * datos$temp_min
  
  # Temperatura maxima
  
  temp_max_s_baja <- 6.56 + 0.77 * datos$temp_max
  
  temp_max_s_alta_irreg <- 5.18 + 0.77 * datos$temp_max
  
  temp_max_s_alta_reg <- 4.23 + 0.77 * datos$temp_max
  
  # Amplitud termica
  
  amplitud_termica <- datos$temp_max - datos$temp_min
  
  amplitud_term_s_baja <- temp_max_s_baja - temp_min_sombra
  
  amplitud_term_s_alta_irreg <- temp_max_s_alta_irreg - temp_min_sombra
  
  amplitud_term_s_alta_reg <- temp_max_s_alta_reg - temp_min_sombra
  
  
  # Guardar datos -----------------------------------------------------------
  
  datos_proc_var <- cbind(datos, 
                          temp_min_sombra, 
                          temp_max_s_baja, 
                          temp_max_s_alta_irreg, 
                          temp_max_s_alta_reg, 
                          amplitud_termica,
                          amplitud_term_s_baja,
                          amplitud_term_s_alta_irreg,
                          amplitud_term_s_alta_reg)
  
  saveRDS(datos_proc_var, file = "datos/01_datos_proc_var.RDS")
}

  