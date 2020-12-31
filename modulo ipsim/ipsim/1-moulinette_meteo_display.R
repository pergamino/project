##########################
# Moulinette meteo IPSIM
##########################

# Perdidas de esporas por lluvia
# Numero des dias por mes con lluvia >= 10mm
######################################

moulinette_meteo <- function(df_meteo,
                             datos_epidemio){


  # Selection dans le fichier meteo des periodes 15 jours avant le monitoring 
  lavado <- NULL
  infec <- NULL
  latencia <- NULL
  ap_hojas <- NULL
  Precip <- NULL
  Tmean <- NULL
  
  
  # boucle sur les annees
  
  id_fech <- unique(datos_epidemio$id_fecha)
 
  for (i in 1:length(unique(datos_epidemio$Fecha_median))){
    # print(i)
    sub_monitoreo_fecha_median <- subset(datos_epidemio,id_fecha==id_fech[i])
    
    sub_df_meteo <- subset(df_meteo,
                           df_meteo$fecha0>=unique(sub_monitoreo_fecha_median$Fecha_15_antes) &
                             df_meteo$fecha0<=unique(sub_monitoreo_fecha_median$Fecha_median),
                           select=c("fecha0","precip","tmean"))
    
    sub_df_meteo$fecha_15_dias_antes <- unique(sub_monitoreo_fecha_median$Fecha_15_antes)
    sub_df_meteo$fecha_med_monitoreo <- unique(sub_monitoreo_fecha_median$Fecha_median)
    
    

    # Lavado de esporas ----------------
    # num de dias por mes con lluvia >= 10mm
    ########################################
    
    precip_sup_10 <- aggregate(data.frame(num_dia=sub_df_meteo$precip),
                               by=list(Fecha_monitoreo=as.character(sub_df_meteo$fecha_med_monitoreo),
                                 fecha_15_dias_antes=sub_df_meteo$fecha_15_dias_antes,
                                       fecha_med_monitoreo=sub_df_meteo$fecha_med_monitoreo),
                               FUN=function(x) sum(x>=10,na.rm=T))
    
    precip_sup_10$ipsim <- ifelse(precip_sup_10$num_dia<3,"Lavado insuficiente",
                                  ifelse(precip_sup_10$num_dia>5,"Lavado eficiente","Lavado regular"))
    
    
    precip_sup_10$cat <- ifelse(precip_sup_10$num_dia<3,1,
                                ifelse(precip_sup_10$num_dia>5,3,2))
    
    precip_sup_10$var <- "Lavado"
    
   # Perdidas_de_esporas_por_lluvia 1: Lavado insuficiente, 2: lavado regular, 3: Lavado eficiente
    precip_sup_10$col <- ifelse(precip_sup_10$cat==1,"red",ifelse(precip_sup_10$cat==2,"grey","green")) 
    
    lavado <- rbind(lavado, precip_sup_10)
    
    
    # Infeccion de hojas por mojadura ---------------
    # Germinacion y penetracion de la hoja ligadas a la mojadura de la hoja
    # num de dias por mes con lluvia >= 5mm
    ########################################
    
    precip_sup_5 <- aggregate(data.frame(num_dia=sub_df_meteo$precip),
                              by=list(Fecha_monitoreo=as.character(sub_df_meteo$fecha_med_monitoreo),
                                # fecha=sub_df_meteo$id_fecha,
                                fecha_15_dias_antes=sub_df_meteo$fecha_15_dias_antes,
                                      fecha_med_monitoreo=sub_df_meteo$fecha_med_monitoreo),
                              FUN=function(x) sum(x>=5,na.rm=T))
    
    precip_sup_5$ipsim <- ifelse(precip_sup_5$num_dia>7,"Infeccion alta",
                                 ifelse(precip_sup_5$num_dia<3,"Infeccion baja","Infeccion media"))
    
    precip_sup_5$cat <- ifelse(precip_sup_5$num_dia>7,1,
                               ifelse(precip_sup_5$num_dia<3,3,2))
    
    precip_sup_5$var <- "Infeccion"
    
    # Infeccion_de_hojas_por_mojadura 1: Alta, 2: Media, 3: Baja
    precip_sup_5$col <- ifelse(precip_sup_5$cat==1,"red",ifelse(precip_sup_5$cat==2,"grey","green"))
    
    infec <- rbind(infec, precip_sup_5)
    
    
    # Periodo de latencia --------------------
    # Duracion de latencia
    # Num de dias por mes con temperatura ideal (+/-3C cerca de 23C) para la colonizacion en la hoja
    #########################################
    
    numdias_cerca_23 <- aggregate(data.frame(num_dia=sub_df_meteo$tmean),
                                  by=list(Fecha_monitoreo=as.character(sub_df_meteo$fecha_med_monitoreo),
                                          # fecha=sub_df_meteo$id_fecha,
                                    fecha_15_dias_antes=sub_df_meteo$fecha_15_dias_antes,
                                          fecha_med_monitoreo=sub_df_meteo$fecha_med_monitoreo),
                                  FUN=function(x) sum(x>=20 & x<=26,na.rm=T))
    
    numdias_cerca_23$ipsim <- ifelse(numdias_cerca_23$num_dia>10,"Latencia breve",
                                     ifelse(numdias_cerca_23$num_dia<5,"Latencia larga","Latencia media"))
    
    numdias_cerca_23$cat <- ifelse(numdias_cerca_23$num_dia>10,1,
                                   ifelse(numdias_cerca_23$num_dia<5,3,2))
    
    numdias_cerca_23$var <- "Latencia"
    
    # Periodo_de_latencia_por_temperatura 1: Latencia breve, 2: Latencia media, 3:Latencia larga
    numdias_cerca_23$col <- ifelse(numdias_cerca_23$cat==1,"red",ifelse(numdias_cerca_23$cat==2,"grey","green"))
    
    latencia <- rbind(latencia, numdias_cerca_23)

    
    # Crecimiento vegetativo --------------
    # Aparicion de hojas
    # Num de dias con mas de 1mm de lluvia por la aparicion de las hojas
    #########################################
    
    precip_sup_1 <- aggregate(data.frame(num_dia=sub_df_meteo$precip),
                              by=list(Fecha_monitoreo=as.character(sub_df_meteo$fecha_med_monitoreo),
                                      # fecha=sub_df_meteo$id_fecha,
                                fecha_15_dias_antes=sub_df_meteo$fecha_15_dias_antes,
                                      fecha_med_monitoreo=sub_df_meteo$fecha_med_monitoreo),
                              FUN=function(x) sum(x>=1,na.rm=T))
    
    precip_sup_1$ipsim <- ifelse(precip_sup_1$num_dia>=10,"Favorable a el crecimiento vegetativo",
                                 ifelse(precip_sup_1$num_dia<5,"Desavorable a el crecimiento vegetativo",
                                        "Moderadamente favorable a el crecimiento vegetativo"))
    
    precip_sup_1$cat <- ifelse(precip_sup_1$num_dia>=10,1,
                               ifelse(precip_sup_1$num_dia<5,3,2))
    
    precip_sup_1$var <- "Aparicion_hojas"
    
    # Efecto del clima sobre la aparicion de la hojas 1: Favorable a el crecimiento, 2: Moderadamente favorable a el crecimiento 3: Desfavorable a el crecimiento
    precip_sup_1$col <- ifelse(precip_sup_1$cat==1,"green",ifelse(precip_sup_1$cat==2,"grey","red"))
    
    ap_hojas <- rbind(ap_hojas, precip_sup_1)

    
    
    
    # # Mean precip y temperatura -------------
    # ##############
    # 
    # # precipitacion
    # 
    # precip_mean <- aggregate(data.frame(num_dia=sub_df_meteo$precip),
    #                           by=list(Fecha_monitoreo=as.character(sub_df_meteo$fecha_med_monitoreo),
    #                                   fecha_15_dias_antes=sub_df_meteo$fecha_15_dias_antes,
    #                                   fecha_med_monitoreo=sub_df_meteo$fecha_med_monitoreo),
    #                           mean)
    # 
    # precip_mean$ipsim <- NA
    # 
    # precip_mean$cat <- NA
    # 
    # precip_mean$var <- "Precipitacion_promedia"
    # 
    # precip_mean$col <- NA
    # 
    # Precip <- rbind(Precip, precip_mean)
    # 
    # 
    # # temperatura   
    # tmean_mean <- aggregate(data.frame(num_dia=sub_df_meteo$tmean),
    #                          by=list(Fecha_monitoreo=as.character(sub_df_meteo$fecha_med_monitoreo),
    #                                  fecha_15_dias_antes=sub_df_meteo$fecha_15_dias_antes,
    #                                  fecha_med_monitoreo=sub_df_meteo$fecha_med_monitoreo),
    #                          mean)
    # 
    # tmean_mean$ipsim <- NA
    # 
    # tmean_mean$cat <- NA
    # 
    # tmean_mean$var <- "Temperatura_promedia"
    # 
    # # Efecto del clima sobre la aparicion de la hojas 1: Favorable a el crecimiento, 2: Moderadamente favorable a el crecimiento 3: Desfavorable a el crecimiento
    # tmean_mean$col <- NA
    # 
    # Tmean <- rbind(Tmean, tmean_mean)
    
    
    # Sortie -------------
    output_moulinette <- rbind(lavado,infec,latencia,ap_hojas)
    
    
  }
  
return(output_moulinette)

}