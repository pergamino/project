aparicion <- function(fecha,data){  #hay que tomar solo el valor del dia actual, sino va calcular siempre la probabilidad para todos los dias
  
  observacion <- which(data$fecha == fecha) #obtener indice de observacion 
  
  if(observacion < 25){
    
    almacenar_vector <- NA #probabilidad no aplica si no hay al menos 23 observaciones antes
    
  }
  else{
    
    promedio_lluvia_diaria <- mean(data$lluvia_diaria[(observacion-24):(observacion-15)])
    
    promedio_temperatura_minima <- mean(data$temp_min[(observacion-11):(observacion-9)])
    
    promedio_amplitud_termica <- mean(data$amplitud_termica[(observacion-11):(observacion-1)])
    
    if(promedio_lluvia_diaria <= 4){
      
      x = -13.58 + 0.40*promedio_lluvia_diaria + 0.35*promedio_temperatura_minima + 0.2*promedio_amplitud_termica 
      
      almacenar_vector <- exp(x)/(1+exp(x)) 
    }
    else{
      
      x = -39.49 + promedio_lluvia_diaria - 0.014*promedio_lluvia_diaria^2 + 3.34*promedio_temperatura_minima-0.09*promedio_temperatura_minima^2 + 0.11*promedio_amplitud_termica
      
      almacenar_vector <- exp(x)/(1+exp(x)) 
    }
  }
}

############ Modelo esporulación

esporulacion <- function(fecha,data){  
  
  observacion <- which(data$fecha == fecha) #obtener indice de observacion 
  
  if(observacion < 14){
    
    almacenar_vector <- NA #probabilidad no aplica si no hay al menos 14 observaciones antes
    
  }
  else{
    promedio_temperatura_maxima <- mean(data$temp_max[(observacion-13):(observacion-10)])
    
    promedio_lluvia_diaria_12_11 <- mean(data$lluvia_diaria[(observacion-10):(observacion-9)])
    
    promedio_amplitud_termica <- mean(data$amplitud_termica[(observacion-2)])
    
    promedio_lluvia_diaria_5_3 <- mean(data$lluvia_diaria[(observacion-3):(observacion-1)])
    
    modelo3 <- -18.68+1.29*(promedio_temperatura_maxima)-0.023*(promedio_temperatura_maxima)^2+0.019*promedio_lluvia_diaria_12_11-0.046*promedio_amplitud_termica+0.069*promedio_lluvia_diaria_5_3-0.0033*(promedio_lluvia_diaria_5_3)^2
    
    almacenar_vector <- exp(modelo3)/(1+exp(modelo3)) 
    
  }
}

####### Modelo primeras esporas

intensificacion <- function(fecha,data){  
  
  observacion <- which(data$fecha == fecha) #obtener indice de observacion 
  
  if(observacion < 2){
    
    almacenar_vector <- NA #probabilidad no aplica si no hay al menos 14 observaciones antes
    
  }
  else{
    tmax  <- data$temp_max[(observacion - 1)]
    
    almacenar_vector <- -0.0672 + 0.007 * tmax - 0.00012 * tmax ^(2)
    
  }
}

#data$probabilidad_lesion_en_10_dias <- sapply(data$fecha,aparicion)
#data$probabilidad_inicio_esporulacion <- sapply(data$fecha,esporulacion)
#data$pronostico_incremento_area_esporulada <- sapply(data$fecha,intensificacion)