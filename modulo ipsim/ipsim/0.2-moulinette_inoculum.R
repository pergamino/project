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

  output_incDefoliacion <- NULL
  output_incInoc <- NULL
  output_incidencia <- NULL
  
  
  for (ino in 1:length(unique(datos_epidemio$Fecha_median))){
  # print(ino)
    
  sub_epid <- subset(datos_epidemio,Fecha_median==unique(datos_epidemio$Fecha_median)[ino])
    
  tab_inc_mediana <- aggregate(data.frame(inc_mediana=sub_epid$incidencia),
                               by=list(Fecha_median=sub_epid$Fecha_median),
                               FUN=median)
    
# Cantidad de inoculo - Depiende de la incidencia a la fecha
# calcula la cant. de inoculo para la eficacia del parasitismo y la eficacia de las fungicidas  
#######################################

    tab_inc_mediana$ipsim <- ifelse(tab_inc_mediana$inc_mediana<10,"Inoculum bajo",
                                    ifelse(tab_inc_mediana$inc_mediana>30,"Inoculum alto","Inoculum medio"))

    tab_inc_mediana$cat <- ifelse(tab_inc_mediana$inc_mediana<10,1,
                                  ifelse(tab_inc_mediana$inc_mediana>30,3,2))

    tab_inc_mediana$var <- "Inoculo"


    output_incInoc <- rbind(output_incInoc,tab_inc_mediana)
    
      
  
  # Efecto de la incidencia sobre la defoliacion
  # Depiende de la incidencia a la fecha
  #######################################
    
    # Equation utilisee a partir des donnees de Avelino : defoliation de Descombros 1994
    
    defoliacion <- 30*(0.0125*tab_inc_mediana$inc_mediana + 0.2186)
    
    tab_inc_mediana$ipsim <- ifelse(defoliacion<=6.558,"Efecto bajo de la incidencia sobre la defoliacion",
                                ifelse(defoliacion>20,"Efecto alto de la incidencia sobre la defoliacion",
                                       "Efecto medio de la incidencia sobre la defoliacion"))
    
    tab_inc_mediana$cat <- ifelse(defoliacion<=6.558,1,
                              ifelse(defoliacion>20,3,2))
    
    tab_inc_mediana$var <- "Efecto de la incidencia sobre la defoliacion"
      
    output_incDefoliacion <- rbind(output_incDefoliacion, tab_inc_mediana)
    


    output_incidencia <- rbind(output_incInoc,
                               output_incDefoliacion)

}

  return(output_incidencia)
  
}