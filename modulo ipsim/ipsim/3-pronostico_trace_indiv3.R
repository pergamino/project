# Sorties des pronstics d'IPSIM
#################################

# 2020-06-26 : Modif sur l'incidence
# on ne prend pas la moyenne de toutes les parcelles a chq date
# mais la mediane (la moyenne des 50% les plus semblables (des plus proches de la moyenne))



func_prono <- function(sortie_ipsim_ori,
                      datos_epidemio,
                      variedad){
  
  library(tidyverse)
  library(ggpubr)
  library(plyr)
  

  # Nb de points a attribuer a la croissance  
  # en fonction de l'incidence
  #########
  load("data_internes/data_tx_croiss_quantiles_incidence_variete_pays2.rdata")


  sortie_ipsim <- sortie_ipsim_ori[[1]]
  
  
  ##########################################
  
  #          DATA VS PRONOSTICS
  
  ##########################################

  sortie_ipsim$creci_prono <- NA
  
  # sortie_ipsim$catIncidence <- ifelse(sortie_ipsim$incidencia<5,"Incidencia baja (<5%)",
  #                                      ifelse(sortie_ipsim$incidencia>10,"Incidencia alta (>10%)",
  #                                             "Incidencia media (5-10%)"))
  # sortie_ipsim$catIncidence<-factor(sortie_ipsim$catIncidence,c("Incidencia baja (<5%)",
  #                                                                 "Incidencia media (5-10%)",
  #                                                                 "Incidencia alta (>10%)"))
  
  sortie_ipsim$catIncidence <- ifelse(sortie_ipsim$incidencia<5,"Incidencia baja (<5%)",ifelse(sortie_ipsim$incidencia<20,"Incidencia media (5-20%)","Incidencia alta (20-40%)"))
  sortie_ipsim$catIncidence<-factor(sortie_ipsim$catIncidence,c("Incidencia baja (<5%)","Incidencia media (5-20%)","Incidencia alta (20-40%)"))
  
  
  
  if(variedad==1){data_quant <- list_quant[["varSensi"]]}
  if(variedad==2){data_quant <- list_quant[["varModerSensi"]]}
  if(variedad==3){data_quant <- list_quant[["varResist"]]}
  
  for(n in 1: nrow(sortie_ipsim)){    
    
    sortie_ipsim$creci_prono[n] <- as.numeric(subset(data_quant,catIncidence==sortie_ipsim$catIncidence[n],
                                                      select=paste0("nb_pt_moy_cat",sortie_ipsim$riesgo[n])))
  }    
  
  
  sortie_ipsim$incidencia_ipsim <- NA
  
  for(s in 1:nrow(sortie_ipsim)){
    sortie_ipsim$incidencia_ipsim[s] <- max(0,sortie_ipsim$incidencia[s]+sortie_ipsim$creci_prono[s])
  }
  
  

  return(sortie_ipsim)
}