
func_metrica <- function(vgam.salida_ajust_all,
                         num_detect,
                         num_plantas,
                         TMF){
  
  library(plyr)
  

    # metrique des tamanos sur les differentes annees
  df_metrica <- plyr::ddply(vgam.salida_ajust_all, c("FACTOR","Num_mes"), summarise, 
                            Np=mean(Np),
                            Incidencia_mediana=mean(p),
                            Tamano_promedio=mean(TM_ajustado),
                            Tamano_mediano=median(TM_ajustado),
                            Tamano_maximo = max(TM_ajustado))
  

  
  # tamano pour chaque annee
  
  YEAR <- unique(vgam.salida_ajust_all$Year)
  df_metrica_all <- df_metrica
  
  for(yrr in 1:length(YEAR)){
    sub1 <- subset(vgam.salida_ajust_all,Year==YEAR[yrr])
    sub <- subset(sub1,select=c(FACTOR,Num_mes,p,TM_ajustado))
    colnames(sub)[colnames(sub)%in%"TM_ajustado"] <- paste0("Tamano_",unique(sub1$Year))
    colnames(sub)[colnames(sub)%in%"p"] <- paste0("Incidencia_",unique(sub1$Year))
    
    df_metrica_all <- merge(df_metrica_all,sub,by=c("FACTOR","Num_mes"),all=T)

  }
  
  
  df_metrica_all$num_detectabilidad <- num_detect
  df_metrica_all$num_plantas <- num_plantas
  df_metrica_all$tamano_min_parcelas <- TMF  
  
  return(df_metrica_all)

}
