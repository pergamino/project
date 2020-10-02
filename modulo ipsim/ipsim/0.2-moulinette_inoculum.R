##########################
# Moulinette Inoculum IPSIM
##########################

# 14/08/2020 : Effet Lecanicillium : Niveau d'inoculum calcule en 
# fonction de l'incidence (inoculo antes del parasitismo)
# Pour cela on prend les niveaux d'incidence de 
# Efecto de la incidencia sobre la eficacia de las fungicidas


# 09/06/2020 : Efecto de la incidencia sobre la eficacia de las fungicidas
# eficacia buena : si la aplicacion de fungicidas se realisa cuando la incidencia <10%
# eficacia regular : si la aplicacion de fungicidas se realisa cuando la incidencia [10-30%]
# eficacia mala : si la aplicacion de fungicidas se realisa cuando la incidencia >30%


# 03/06/2020 : Efecto de la incidencia sobre la defoliacion
# efecto bajo de la incidencia sobre la defoliacion (<10% de defolaicion mensual) si la inc < 23%
# efecto medio de la incidencia sobre la defoliacion (10-20% de defolaicion mensual) si  23% < inc < 46%
# efecto alto de la incidencia sobre la defoliacion (>20% de defolaicion mensual) si la inc > 46%


# 02/04/2020 : Niveau d'inoculum calcule en fonction de l'incidence



moulinette_inoc <- function(datos_epidemio){

  
  output_inoc <- NULL
  output_incDefoliacion <- NULL
  output_incEficaciaFung <- NULL
  output_inoc_antes_lavado <- NULL
  output_incidencia <- NULL
  
  
  for (ino in 1:length(unique(datos_epidemio$Fecha_median))){
  # print(ino)
    
# Inoculum (por el modelo completo)
# Depiende de la incidencia a la fecha
#######################################
    sub_epid <- subset(datos_epidemio,Fecha_median==unique(datos_epidemio$Fecha_median)[ino])
    
    tab_inc_mediana <-     aggregate(data.frame(inc_mediana=sub_epid$incidencia),
                                     by=list(Fecha_median=sub_epid$Fecha_median),
                                     FUN=median)
    
    tab_inc_mediana$ipsim <- ifelse(tab_inc_mediana$inc_mediana<5,"Inoculum bajo",
                                    ifelse(tab_inc_mediana$inc_mediana>10,"Inoculum alto","Inoculum medio"))
    
    tab_inc_mediana$cat <- ifelse(tab_inc_mediana$inc_mediana<5,1,
                                  ifelse(tab_inc_mediana$inc_mediana>10,3,2))
    
    tab_inc_mediana$var <- "Inoculum"

    
    output_inoc <- rbind(output_inoc,tab_inc_mediana)
    
    
    # Efecto de la incidencia sobre la eficacia de las fungicidas
    # Depiende de la incidencia a la fecha
    #######################################

    
    tab_inc_mediana$ipsim <- ifelse(tab_inc_mediana$inc_mediana<10,"Incidencia baja",
                                    ifelse(tab_inc_mediana$inc_mediana>30,"Incidencia alta","Incidencia media"))
    
    tab_inc_mediana$cat <- ifelse(tab_inc_mediana$inc_mediana<10,3,
                                  ifelse(tab_inc_mediana$inc_mediana>30,1,2))
    
    
    tab_inc_mediana$var <- "Efecto de la incidencia sobre la eficacia de las fungicidas"
    
    output_incEficaciaFung <- rbind(output_incEficaciaFung, tab_inc_mediana)
    
    
    
    # Efecto de Lecanicillium
    # Depiende de la incidencia a la fecha
    # Para calcular la cantidad de esporas despues del parasitismo y antes del lavado
    #######################################
    
    # Son los mismos niveles que arriba:
    # Efecto de la incidencia sobre la eficacia de las fungicidas
    
    tab_inc_mediana$ipsim <- ifelse(tab_inc_mediana$inc_mediana<10,"Inoculo bajo",
                                    ifelse(tab_inc_mediana$inc_mediana>30,"Inoculo alto","Inoculo medio"))
    
    tab_inc_mediana$cat <- ifelse(tab_inc_mediana$inc_mediana<10,1,
                                  ifelse(tab_inc_mediana$inc_mediana>30,3,2))
    
    
    
    tab_inc_mediana$var <- "Inoculo disponible antes del parasitismo"
    
    output_inoc_antes_lavado <- rbind(output_inoc_antes_lavado, tab_inc_mediana)

    
    
  
  # Efecto de la incidencia sobre la defoliacion
  # Depiende de la incidencia a la fecha
  #######################################
    
    # Equation utilisee a partir des donnees de defoliation de Descombros 1994
    
    defoliacion <- 30*(0.0125*tab_inc_mediana$inc_mediana + 0.2186)
    
    tab_inc_mediana$ipsim <- ifelse(defoliacion<=6,"Efecto bajo de la incidencia sobre la defoliacion",
                                ifelse(defoliacion>20,"Efecto alto de la incidencia sobre la defoliacion",
                                       "Efecto medio de la incidencia sobre la defoliacion"))
    
    tab_inc_mediana$cat <- ifelse(defoliacion<=6,1,
                              ifelse(defoliacion>20,3,2))
    
    tab_inc_mediana$var <- "Efecto de la incidencia sobre la defoliacion"
      
    output_incDefoliacion <- rbind(output_incDefoliacion, tab_inc_mediana)
    


    output_incidencia <- rbind(output_inoc,output_inoc_antes_lavado,
                               output_incDefoliacion,output_incEficaciaFung)

}

  return(output_incidencia)
  
}