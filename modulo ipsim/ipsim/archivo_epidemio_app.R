# #################################
# Preparation fichier epidemio para eval de App 
###################################


fichier_epid_new <- function(datos_epidemio0){
  
  datos_epidemio0$fecha0 <- as.Date(as.character(datos_epidemio0$fecha),format = "%Y-%m-%d")
  datos_epidemio0$fecha2 <- as.POSIXlt(datos_epidemio0$fecha0)
  datos_epidemio0$num_mes <- as.numeric(strftime(datos_epidemio0$fecha2,format="%m"))
  datos_epidemio0$ano <- as.numeric(strftime(datos_epidemio0$fecha2,format="%Y"))
  datos_epidemio0$dia <- as.numeric(strftime(datos_epidemio0$fecha2,format="%d"))
  
  
  monitoreo_fecha_median <- aggregate(data.frame(Fecha_median=datos_epidemio0$fecha0),
                                      by=list(num_mes=datos_epidemio0$num_mes,ano=datos_epidemio0$ano),
                                      median,na.rm=T)
  
  # calculs des dates 15 jours avant le monitoreo
  monitoreo_fecha_median$Fecha_15_antes <- monitoreo_fecha_median$Fecha_median - 15
  monitoreo_fecha_median$id_fecha <- paste0(monitoreo_fecha_median$num_mes,"/",monitoreo_fecha_median$ano)
  
  datos_epidemio <- merge(datos_epidemio0,monitoreo_fecha_median,by=c("num_mes","ano"),all=T)
  datos_epidemio <- datos_epidemio[order(datos_epidemio[,"Fecha_median"]),]
  
  return(datos_epidemio)
  
}
