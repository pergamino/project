# Sorties des pronstics d'IPSIM
#################################


func_prono <- function(sortie_ipsim,
                      datos_epidemio,
                      variedad){
  
  library(tidyverse)
  library(plotly)
  library(ggpubr)
  

  # Nb de points a attribuer a la croissance  
  # en fonction de l'incidence
  #########
  load("data_internes/data_tx_croiss_quantiles_incidence_variete_pays.rdata")
  
  
  # Datos epidemiologicos
  ###########################
  
  sub <- aggregate(data.frame(incidencia=datos_epidemio$incidencia),
                   by=list(Fecha_median=datos_epidemio$Fecha_median,num_mes=datos_epidemio$num_mes,ano=datos_epidemio$ano),
                   mean,na.rm=T)
  
  # Sorties IPSIM
  #############################
  
  df_data_prono <- merge(sortie_ipsim,sub,by="Fecha_median",all=T)
  
  
  ##########################################
  
  #          DATA VS PRONOSTICS
  
  ##########################################
  df_data_prono$creci_obs <- NA
  df_data_prono$creci_prono <- NA
  
  df_data_prono$catIncidence <- ifelse(df_data_prono$incidencia<5,"Incidencia baja (<5%)",
                                       ifelse(df_data_prono$incidencia>10,"Incidencia alta (>10%)",
                                              "Incidencia media (5-10%)"))
  df_data_prono$catIncidence<-factor(df_data_prono$catIncidence,c("Incidencia baja (<5%)",
                                                                  "Incidencia media (5-10%)",
                                                                  "Incidencia alta (>10%)"))
  
  
  for(i in 2:nrow(df_data_prono)){
    df_data_prono$creci_obs[i] <- 30*(df_data_prono$incidencia[i]-df_data_prono$incidencia[i-1])/as.numeric(df_data_prono$Fecha_median[i]-df_data_prono$Fecha_median[i-1])
  }                           
  
  
  if(variedad==1){data_quant <- list_quant[["varSensi"]]}
  if(variedad==2){data_quant <- list_quant[["varModerSensi"]]}
  if(variedad==3){data_quant <- list_quant[["varResist"]]}
  
  for(n in 1: nrow(df_data_prono)){    
    
    df_data_prono$creci_prono[n] <- as.numeric(subset(data_quant,catIncidence==df_data_prono$catIncidence[n],
                                                      select=paste0("nb_pt_moy_cat",df_data_prono$riesgo[n])))
  }    
  
  
  df_data_prono$incidencia_ipsim <- NA
  
  for(s in 1:nrow(df_data_prono)){
    df_data_prono$incidencia_ipsim[s] <- max(0,df_data_prono$incidencia[s]+df_data_prono$creci_prono[s])
  }
  

  return(df_data_prono)
}