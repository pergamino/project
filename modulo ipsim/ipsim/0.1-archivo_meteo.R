###############
# Preparation des donnees meteo 
################

fichier_meteo_new <- function(df_meteo0){
  
df_meteo0$fecha0 <- as.Date(as.character(df_meteo0$fecha),format = "%d/%m/%Y")
df_meteo0$fecha2 <- as.POSIXlt(df_meteo0$fecha0)
# j ai change "mes" en "num_mes"
df_meteo0$num_mes <- as.numeric(strftime(df_meteo0$fecha2,format="%m"))
df_meteo0$ano <- as.numeric(strftime(df_meteo0$fecha2,format="%Y"))
df_meteo0$dia <- as.numeric(strftime(df_meteo0$fecha2,format="%d"))
df_meteo0$id_fecha <- paste0(df_meteo0$num_mes,"/",df_meteo0$ano)

df_meteo <- df_meteo0[order(df_meteo0[,"fecha0"]),]

return(df_meteo)

}





