# modif : 31/03/2020 : Taux de croiss pronostiques en fonction des incidences
# modif : 28/04/20 : taux de croiss =f(varietes, pays)


func_plot <- function(df_data_prono,
                      datos_epidemio,
                      date_floracion,
                      date_ini_cosecha,
                      date_fin_cosecha){
  
  library(ggplot2)
  library(tidyverse)
  library(plotly)
  library(ggpubr)
  library(mondate)
  
  # Definitions couleurs alertes
  ####################
  col_alerta <- factor(c("Azul","Verde","Amarillo","Naranja","Rojo"),
                       levels=c("Azul","Verde","Amarillo","Naranja","Rojo"))



  # Definition des periodes 
  #################
  date_init <- as.Date(as.mondate(df_data_prono$Fecha_median[1]) - 1)
  date_fin <- as.Date(as.mondate(df_data_prono$Fecha_median[nrow(df_data_prono)]) + 1)

  # pour faire les fleches de pronostic
  
  df_data_prono$end30 <- c(df_data_prono$Fecha_median[-1],date_fin)
  df_data_prono$end30_2 <- as.Date(as.mondate(df_data_prono$Fecha_median) + 1)
  
  # plot des zones d'alertes
  ############
  
  rect0 <- data.frame(xstart = min(date_init,date_floracion), xend = date_floracion,
                      ystart = c(0,5,15,20,30), yend = c(5,15,20,30,(max(35,datos_epidemio$incidencia,
                                                                         df_data_prono$incidencia_ipsim,
                                                                         na.rm=T))),
                      col = col_alerta)
  
  rect1 <- data.frame(xstart = date_floracion, xend = date_ini_cosecha,
                      ystart = c(0,2.5,5,10,20), yend = c(2.5,5,10,20,(max(35,datos_epidemio$incidencia,
                                                                           df_data_prono$incidencia_ipsim,
                                                                           na.rm=T))),
                      col = col_alerta)
  
  rect2 <- data.frame(xstart = date_ini_cosecha, xend = date_fin_cosecha,
                      ystart = c(0,5,15,20,30), yend = c(5,15,20,30,(max(35,datos_epidemio$incidencia,
                                                                         df_data_prono$incidencia_ipsim,
                                                                         na.rm=T))),
                      col = col_alerta)
  
  rect3 <- data.frame(xstart = date_fin_cosecha, xend = max(date_fin+30,date_fin_cosecha),
                      ystart = c(0,2.5,5,10,20), yend = c(2.5,5,10,20,(max(35,datos_epidemio$incidencia,
                                                                           df_data_prono$incidencia_ipsim,
                                                                           na.rm=T))),
                      col = col_alerta)
  


  
  # Incidencia acumulada
  # df_data_prono$inc_cum <- NA
  # df_data_prono$inc_cum[1] <- df_data_prono$incidencia[1]
  # for(v in 2:nrow(df_data_prono)){
  #   df_data_prono$inc_cum[v] <- df_data_prono$inc_cum[v-1] + df_data_prono$creci_prono[v]
  # }
    

  
  ###############
  # Estimation JG
  ###############
ggplot() +
    geom_rect(data=rect0, aes(xmin=xstart, xmax=xend, ymin=ystart,
                              ymax=yend, fill=col, alpha =0.2)) +
    geom_rect(data=rect1, aes(xmin=xstart, xmax=xend, ymin=ystart,
                              ymax=yend, fill=col, alpha =0.2)) +
    geom_rect(data=rect2, aes(xmin=xstart, xmax=xend, ymin=ystart,
                              ymax=yend, fill=col, alpha =0.2)) +
    geom_rect(data=rect3, aes(xmin=xstart, xmax=xend, ymin=ystart,
                              ymax=yend, fill=col, alpha =0.2)) +

    scale_fill_manual(values = c("cornflowerblue", "chartreuse2",
                                 "gold1","darkorange","firebrick1"))+

    geom_boxplot(data=datos_epidemio, aes(x=Fecha_median, y=incidencia, group=Fecha_median),
                 size=0.75, fill="white",alpha=0.2)+
    geom_point(data=df_data_prono, mapping=aes(x=Fecha_median, y=incidencia_mean), size=4, shape=21) + # , fill="white"

    geom_segment(data=df_data_prono, mapping=aes(x=Fecha_median, y=incidencia_median,
                                                 xend=end30_2, yend=incidencia_ipsim),
                 arrow=arrow(length = unit(3, "mm"),type='closed'), size=1.5, color="red") +

    geom_text(data=df_data_prono,mapping=aes(x=Fecha_median, y=max(datos_epidemio$incidencia)),
                                             label = df_data_prono$inicial_categoria,
                                             fontface="bold",color="red", size=5)+ # ,vjust = "top"

    scale_y_continuous(name = "Incidencia",
                       breaks=seq(0, max(datos_epidemio$incidencia),5),
                       limits=c(0,max(35,datos_epidemio$incidencia,
                                      df_data_prono$incidencia_ipsim)))+
    labs(x = "Fecha de monitoreo")+
    scale_x_date(date_labels = "%d/%m/%y",
                 breaks=unique(datos_epidemio$Fecha_median))+

    theme_bw()+
    theme(
      legend.position="none",
      panel.grid.minor = element_blank(),
      strip.background = element_blank())+
    theme(legend.title=element_blank(),
          axis.text.x = element_text(size=12,angle = 90,face="bold"))
  

}
