# 0. Dependencias ------------------------------------------------------------------------------

if(!require("pacman")) install.packages("pacman")

p_load("dplyr")

p_load("purrr")

# 1. Creacion dataset completo (variables y pronosticos) ---------------------------------------

# 1.1. Carga y procesamiento de variables --------------------------------------------------------------------

datos_proc_var <- readRDS("datos/01_datos_proc_var.RDS")

nuevas_fechas  <- data.frame(fecha = seq(max(datos_proc_var$fecha),
                                         max(datos_proc_var$fecha) + 9, 1)) 

datos_modelos  <- datos_proc_var %>%
  full_join(nuevas_fechas, 
            by = "fecha") 

### Agregando secuencia a datos modelos

secuencia_datos_modelos <- seq(1, nrow(datos_modelos))

datos_modelos$secuencia <- secuencia_datos_modelos


# 1.2. Modelo aparicion de la lesion (infeccion) ------------------------------------------------------------

### Definir funcion del modelo

aparicion <- function(fecha, data, temp_min, amplitud_termica) { 
  
  amplitud_termica   <- amplitud_termica
  
  temp_min           <- temp_min 
  
  # Obtener indice de observacion
  
  observacion        <- which(data$fecha == fecha)  
  
  if(observacion < 25){ 
    
    # Probabilidad no aplica si no hay al menos 23 observaciones antes
    
    almacenar_vector <- NA  
    
  } else{
    
    promedio_lluvia_diaria      <- mean(data$lluvia_diaria[(observacion - 24):(observacion - 15)])
    
    promedio_temperatura_minima <- mean(temp_min[(observacion - 11):(observacion - 9)])
    
    promedio_amplitud_termica   <- mean(amplitud_termica[(observacion - 11):(observacion - 1)],
                                        na.rm =  TRUE)
    
    if(promedio_lluvia_diaria <= 4){ 
      
      x = - 13.58 + 0.40 * promedio_lluvia_diaria + 0.35 * promedio_temperatura_minima + 0.2 * promedio_amplitud_termica 
      
      almacenar_vector <- exp(x) / (1 + exp(x)) 
      
     } else{
      
      x = - 36.49 + 0.29 * promedio_lluvia_diaria - 0.014 * promedio_lluvia_diaria^(2) + 3.34 * promedio_temperatura_minima - 0.09 * promedio_temperatura_minima^(2) + 0.11 * promedio_amplitud_termica
      
      almacenar_vector <- exp(x) / (1 + exp(x)) 
     
     }
  }
}

### Generar los pronosticos para todas las posibles combinaciones de variables

mod_aparicion <- data.frame(mod_aparicion = sapply(datos_proc_var$fecha,
                                                   function(fecha,
                                                            temp_min,
                                                            amplitud_termica)
                                                   aparicion(fecha,
                                                             data     = datos_proc_var,
                                                             temp_min = datos_proc_var$temp_min,
                                                             amplitud_termica = datos_proc_var$amplitud_termica
                                                             )
                                                   ),
                     mod_aparicion_s_baja = sapply(datos_proc_var$fecha,
                                                   function(fecha,
                                                            temp_min,
                                                            amplitud_termica)
                                                            aparicion(fecha,
                                                                      data     = datos_proc_var,
                                                                      temp_min = datos_proc_var$temp_min_sombra,
                                                                      amplitud_termica = datos_proc_var$amplitud_term_s_baja
                                                                      )
                                                   ),
               mod_aparicion_s_alta_irreg = sapply(datos_proc_var$fecha,
                                                   function(fecha,
                                                            temp_min,
                                                            amplitud_termica)
                                                            aparicion(fecha,
                                                                      data     = datos_proc_var,
                                                                      temp_min = datos_proc_var$temp_min_sombra,
                                                                      amplitud_termica = datos_proc_var$amplitud_term_s_alta_irreg
                                                                      )
                                                   ),
                 mod_aparicion_s_alta_reg = sapply(datos_proc_var$fecha,
                                                   function(fecha,
                                                            temp_min,
                                                            amplitud_termica)
                                                            aparicion(fecha,
                                                                      data     = datos_proc_var,
                                                                      temp_min = datos_proc_var$temp_min_sombra,
                                                                      amplitud_termica = datos_proc_var$amplitud_term_s_alta_reg
                                                                      )
                                                   )
                            
                            
                            )

### Crear columna de indices "secuencia" (su proposito es solo ayudar al programador)

largo_mod_aparicion <- nrow(mod_aparicion) + 9

mod_aparicion       <- mod_aparicion %>% 
  mutate(secuencia = seq(from = 10, 
                         to = largo_mod_aparicion,
                         by = 1
                         )
         )


# 1.3. Modelo de esporulacion --------------------------------------------------------------------

### Definir funcion del modelo

esporulacion <- function(fecha, data, temp_max, amplitud_termica){ 
  
  temp_max           <- temp_max
  
  amplitud_termica   <- amplitud_termica
  
  # Obtener indice de observacion 
  
  observacion        <- which(data$fecha == fecha) 
  
  if(observacion < 14){
    
    # Probabilidad no aplica si no hay al menos 14 observaciones antes
    
    almacenar_vector <- NA 
    
  } else{
    
    promedio_temperatura_maxima  <- mean(temp_max[(observacion - 13):(observacion - 10)])
    
    promedio_lluvia_diaria_12_11 <- mean(data$lluvia_diaria[(observacion - 10):(observacion - 9)])
    
    promedio_amplitud_termica    <- mean(amplitud_termica[(observacion - 2)])
    
    promedio_lluvia_diaria_5_3   <- mean(data$lluvia_diaria[(observacion - 3):(observacion - 1)])
    
    x <- - 18.68 + 1.29 * promedio_temperatura_maxima - 0.023 * promedio_temperatura_maxima^(2) + 0.019 * promedio_lluvia_diaria_12_11 - 0.046 * promedio_amplitud_termica + 0.069 * promedio_lluvia_diaria_5_3 - 0.0033 * promedio_lluvia_diaria_5_3^(2)
    
    almacenar_vector <- exp(x)/(1 + exp(x)) 
    
  }
}

### Generar los pronosticos para todas las posibles combinaciones de variables

mod_esporulacion <- data.frame(mod_esporulacion = sapply(datos_proc_var$fecha,
                                                         function(fecha,
                                                                  temp_max,
                                                                  amplitud_termica)
                                                                  esporulacion(fecha,
                                                                               data     = datos_proc_var,
                                                                               temp_max = datos_proc_var$temp_max,
                                                                               amplitud_termica = datos_proc_var$amplitud_termica
                                                                               )
                                                         ),
                        mod_esporulacion_s_baja = sapply(datos_proc_var$fecha,
                                                         function(fecha,
                                                                  temp_max,
                                                                  amplitud_termica)
                                                                  esporulacion(fecha,
                                                                               data     = datos_proc_var,
                                                                               temp_max = datos_proc_var$temp_max_s_baja,
                                                                               amplitud_termica = datos_proc_var$amplitud_term_s_baja
                                                                               )
                                                         ),
                  mod_esporulacion_s_alta_irreg = sapply(datos_proc_var$fecha,
                                                         function(fecha,
                                                                  temp_max,
                                                                  amplitud_termica)
                                                                  esporulacion(fecha,
                                                                               data     = datos_proc_var,
                                                                               temp_max = datos_proc_var$temp_max_s_alta_irreg,
                                                                               amplitud_termica = datos_proc_var$amplitud_term_s_alta_irreg
                                                                               )
                                                         ),
                    mod_esporulacion_s_alta_reg = sapply(datos_proc_var$fecha,
                                                         function(fecha,
                                                                  temp_max,
                                                                  amplitud_termica)
                                                                  esporulacion(fecha,
                                                                               data     = datos_proc_var,
                                                                               temp_max = datos_proc_var$temp_max_s_alta_reg,
                                                                               amplitud_termica = datos_proc_var$amplitud_term_s_alta_reg
                                                                               )
                                                         )
                              )

### Crear columna de indices "secuencia" (su proposito es solo ayudar al programador) 

largo_mod_esporulacion <- nrow(mod_esporulacion) + 2

mod_esporulacion       <- mod_esporulacion %>% 
  mutate(secuencia = seq(from = 3, 
                         to   = largo_mod_esporulacion,
                         by   = 1))


# 1.4. Modelo de intensificacion ------------------------------------------------------------------

### Definir funcion del modelo

intensificacion <- function(fecha,data, temp_max){
  
  temp_max           <- temp_max 
  
  # Obtener indice de observacion
  
  observacion        <- which(data$fecha == fecha)  
  
  if(observacion < 2){
    
    # Probabilidad no aplica si no hay al menos 14 observaciones antes
    
    almacenar_vector <- NA 
    
  } else{
    
    tmax             <- temp_max[(observacion - 1)]
    
    almacenar_vector <- - 0.0672 + 0.007 * tmax - 0.00012 * tmax ^(2)
    
  }
}

### Generar los pronosticos para todas las posibles combinaciones de variables

mod_intensificacion <- data.frame(mod_intensificacion = sapply(datos_proc_var$fecha,
                                                               function(fecha,
                                                                        temp_max)
                                                                        intensificacion(fecha,
                                                                                        data     = datos_proc_var,
                                                                                        temp_max = datos_proc_var$temp_max
                                                                                        )
                                                               ),
                           mod_intensificacion_s_baja = sapply(datos_proc_var$fecha,
                                                               function(
                                                                 fecha,
                                                                 temp_max)
                                                                 intensificacion(fecha,
                                                                                 data     = datos_proc_var,
                                                                                 temp_max = datos_proc_var$temp_max_s_baja
                                                                                 )
                                                               ),
                     mod_intensificacion_s_alta_irreg = sapply(datos_proc_var$fecha,
                                                               function(fecha,
                                                                        temp_max)
                                                                        intensificacion(fecha,
                                                                                        data     = datos_proc_var,
                                                                                        temp_max = datos_proc_var$temp_max_s_alta_irreg
                                                                                        )
                                                               ),
                       mod_intensificacion_s_alta_reg = sapply(datos_proc_var$fecha,
                                                               function(fecha,
                                                                        temp_max)
                                                                        intensificacion(fecha,
                                                                                        data     = datos_proc_var,
                                                                                        temp_max = datos_proc_var$temp_max_s_alta_reg
                                                                                        )
                                                               )
                     )

### Crear columna de indices "secuencia" (su proposito es solo ayudar al programador)

largo_mod_intensificacion <- nrow(mod_intensificacion) + 4

mod_intensificacion       <- mod_intensificacion %>% 
  mutate(secuencia = seq(from = 5, 
                         to   = largo_mod_intensificacion,
                         by   = 1
                         )
         )

# 1.5. Creacion dataset ---------------------------------------

### Fucionar la tabla de variables con todas las posibles combinaciones de los tres modelos 

datos_pronosticos <- datos_modelos %>% 
  left_join(mod_aparicion, by = "secuencia") %>% 
  left_join(mod_esporulacion, by = "secuencia") %>% 
  left_join(mod_intensificacion, by = "secuencia") 

### Guardar dataset completo

saveRDS(datos_pronosticos, file = "datos/02_datos_pronosticos.RDS")


# 2. Creacion dataset con ultimos pronosticos generados ---------------------------------------

### Definir funcion para obtener ultimos pronosticos 

obteniendo_ultimo_pronostico <- function(data, nombre_modelo) {
  
  data %>% 
    select(fecha, nombre_modelo)    %>% 
    na.omit() %>% 
    tail(1)   %>% 
    rename("valor" = nombre_modelo) %>% 
    mutate(modelo  = nombre_modelo)
  
  }

### Obtener últimos pronosticos de todas la posibles combinaciones de variables de los 3 modelos

datos_pron_finales <- rbind(obteniendo_ultimo_pronostico(datos_pronosticos, "mod_aparicion"),
                            obteniendo_ultimo_pronostico(datos_pronosticos, "mod_aparicion_s_baja"),
                            obteniendo_ultimo_pronostico(datos_pronosticos, "mod_aparicion_s_alta_irreg"),
                            obteniendo_ultimo_pronostico(datos_pronosticos, "mod_aparicion_s_alta_reg"),
                            obteniendo_ultimo_pronostico(datos_pronosticos, "mod_esporulacion"),
                            obteniendo_ultimo_pronostico(datos_pronosticos, "mod_esporulacion_s_baja"),
                            obteniendo_ultimo_pronostico(datos_pronosticos, "mod_esporulacion_s_alta_irreg"),
                            obteniendo_ultimo_pronostico(datos_pronosticos, "mod_esporulacion_s_alta_reg"),
                            obteniendo_ultimo_pronostico(datos_pronosticos, "mod_intensificacion"),
                            obteniendo_ultimo_pronostico(datos_pronosticos, "mod_intensificacion_s_baja"),
                            obteniendo_ultimo_pronostico(datos_pronosticos, "mod_intensificacion_s_alta_irreg"),
                            obteniendo_ultimo_pronostico(datos_pronosticos, "mod_intensificacion_s_alta_reg")
                            ) 


### Crear esqueleto del dataframe y guardar ultimos pronosticos 

datos_pron_finales <- datos_pron_finales %>% 
  mutate(prom_lluvia_a    = vector(length = 12, mode = "numeric"),
         prom_lluvia_b    = vector(length = 12, mode = "numeric"),
         temp_min         = vector(length = 12, mode = "numeric"),
         temp_max         = vector(length = 12, mode = "numeric"),
         amplitud_termica = vector(length = 12, mode = "numeric")) 

observacion = which(datos_proc_var$fecha == Sys.Date())

data        = datos_proc_var


# 2.1 Modelo aparicion de la lesion (infeccion) -----------------------------------------------

### Promedio lluvia de posibles ultimos pronosticos

datos_pron_finales$prom_lluvia_a[1] <-
  mean(data$lluvia_diaria[(observacion - 24):(observacion - 15)])

datos_pron_finales$prom_lluvia_a[2] <-
  mean(data$lluvia_diaria[(observacion - 24):(observacion - 15)])

datos_pron_finales$prom_lluvia_a[3] <-
  mean(data$lluvia_diaria[(observacion - 24):(observacion - 15)])

datos_pron_finales$prom_lluvia_a[4] <-
  mean(data$lluvia_diaria[(observacion - 24):(observacion - 15)])


### Temperatura minima de posibles ultimos pronosticos

datos_pron_finales$temp_min[1] <- 
         mean(data$temp_min[(observacion - 11):(observacion - 9)])

datos_pron_finales$temp_min[2] <- 
  mean(data$temp_min_sombra[(observacion - 11):(observacion - 9)])

datos_pron_finales$temp_min[3] <- 
  mean(data$temp_min_sombra[(observacion - 11):(observacion - 9)])

datos_pron_finales$temp_min[4] <- 
    mean(data$temp_min_sombra[(observacion-11):(observacion - 9)])


### Amplitud termica de posibles ultimos pronosticos

datos_pron_finales$amplitud_termica[1] <-
            mean(datos_proc_var$amplitud_termica[(observacion - 11):(observacion - 1)])

datos_pron_finales$amplitud_termica[2] <-
        mean(datos_proc_var$amplitud_term_s_baja[(observacion - 11):(observacion - 1)])

datos_pron_finales$amplitud_termica[3] <-
  mean(datos_proc_var$amplitud_term_s_alta_irreg[(observacion - 11):(observacion - 1)])

datos_pron_finales$amplitud_termica[4] <-
    mean(datos_proc_var$amplitud_term_s_alta_reg[(observacion - 11):(observacion - 1)])


# 2.2. Modelo espoluracion ---------------------------------------------------------------------

### 1er Promedio de lluvia de posibles ultimos pronosticos

datos_pron_finales$prom_lluvia_a[5] <- 
  mean(data$lluvia_diaria[(observacion - 10):(observacion - 9)])

datos_pron_finales$prom_lluvia_a[6] <- 
  mean(data$lluvia_diaria[(observacion - 10):(observacion - 9)])

datos_pron_finales$prom_lluvia_a[7] <- 
  mean(data$lluvia_diaria[(observacion - 10):(observacion - 9)])

datos_pron_finales$prom_lluvia_a[8] <- 
  mean(data$lluvia_diaria[(observacion - 10):(observacion - 9)])


### 2do Promedio de lluvia de posibles ultimos pronosticos

datos_pron_finales$prom_lluvia_b[5] <- 
  mean(data$lluvia_diaria[(observacion - 3):(observacion - 1)])

datos_pron_finales$prom_lluvia_b[6] <- 
  mean(data$lluvia_diaria[(observacion - 3):(observacion - 1)])

datos_pron_finales$prom_lluvia_b[7] <- 
  mean(data$lluvia_diaria[(observacion - 3):(observacion - 1)])

datos_pron_finales$prom_lluvia_b[8] <- 
  mean(data$lluvia_diaria[(observacion - 3):(observacion - 1)])

### Temperatura maxima de posibles ultimos pronosticos

datos_pron_finales$temp_max[5] <-  
               mean(data$temp_max[(observacion - 13):(observacion - 10)])

datos_pron_finales$temp_max[6] <-  
        mean(data$temp_max_s_baja[(observacion - 13):(observacion - 10)])

datos_pron_finales$temp_max[7] <-  
  mean(data$temp_max_s_alta_irreg[(observacion - 13):(observacion - 10)])

datos_pron_finales$temp_max[8] <-  
    mean(data$temp_max_s_alta_reg[(observacion - 13):(observacion - 10)])

### amplitud termica de posibles ultimos pronosticos

datos_pron_finales$amplitud_termica[5] <-  
            mean(data$amplitud_termica[(observacion - 13):(observacion - 10)])

datos_pron_finales$amplitud_termica[6] <-  
        mean(data$amplitud_term_s_baja[(observacion - 13):(observacion - 10)])

datos_pron_finales$amplitud_termica[7] <-  
  mean(data$amplitud_term_s_alta_irreg[(observacion - 13):(observacion - 10)])

datos_pron_finales$amplitud_termica[8] <-  
    mean(data$amplitud_term_s_alta_reg[(observacion - 13):(observacion - 10)])


# 2.3. Modelo intensificacion --------------------------------------------------------------------

### Temperatura maxima de posibles ultimos pronosticos

datos_pron_finales$temp_max[9]  <- data$temp_max[(observacion - 1)]

datos_pron_finales$temp_max[10] <- data$temp_max_s_baja[(observacion - 1)]

datos_pron_finales$temp_max[11] <- data$temp_max_s_alta_irreg[(observacion - 1)]

datos_pron_finales$temp_max[12] <- data$temp_max_s_alta_reg[(observacion - 1)]


# 2.4. Creacion dataset --------------------------------------------------------------------

saveRDS(datos_pron_finales, file = "datos/03_datos_pron_finales.RDS")
