##############
# Precipitationes
#############


func_temp <- function(output_moulinette,
                      df_meteo){
  
  library(grid)
  library(ggplot2)
  library(mondate)


  sub_df_meteo2 <- subset(df_meteo,
                          fecha0>=min(output_moulinette$fecha_15_dias_antes) &
                            fecha0<=max(output_moulinette$Fecha_monitoreo),
                          select=c(fecha0,tmean))
  sub_df_meteo2 <- droplevels(sub_df_meteo2)
  
  output_moulinette$var <- factor(output_moulinette$var)
  sub_dia_lat <- output_moulinette[output_moulinette$var == "Latencia",]
  sub_dia_lat <- droplevels(sub_dia_lat)
  sub_dia_lat$mid_date <- sub_dia_lat$fecha_15_dias_antes + as.numeric(sub_dia_lat$fecha_med_monitoreo-sub_dia_lat$fecha_15_dias_antes)/2
  
  
 # Plot
  
 p <-
   ggplot() +

   geom_line(data=sub_df_meteo2, aes(x=fecha0, y=tmean),color="red",
             size = 1) +
   
   geom_col(data=sub_dia_lat,
            aes(x = mid_date, y = num_dia*max(sub_df_meteo2$tmean)/max(sub_dia_lat$num_dia)), alpha=0.4,
            size = 1, stat="identity",fill="darksalmon",width= 15) + # width=15 dias

   scale_y_continuous(name = "Temperatura \ndiaria (mm)",breaks=seq(0,max(28,sub_df_meteo2$tmean,sub_dia_lat$num_dia), by = 2),
                      sec.axis = sec_axis(~.*max(sub_dia_lat$num_dia)/max(sub_df_meteo2$tmean),name = "Numero de dias\ncon temperatura\ndiaria entre\n20 y 26°C",
                                          breaks=seq(0,max(28,sub_df_meteo2$tmean,sub_dia_lat$num_dia), by = 2)))+
   labs(x = "Fecha de monitoreo")+
   scale_x_date(date_labels = "%d/%m/%y",
                breaks=unique(sub_dia_lat$fecha_med_monitoreo))+
   scale_fill_manual(name = "Procesos")+

   
   # umbrales
   
   # Tmin
   annotation_custom(
     grob = grid::textGrob(label = "Umbral 20°C :\nTmin para una\nlatencia corta", hjust=0, gp=gpar(col="red", cex=0.85)),
     xmin = as.Date(min(as.mondate(sub_df_meteo2$fecha0)) - 2.8), 
     xmax = as.Date(min(as.mondate(sub_df_meteo2$fecha0)) - 2.8), 
     ymin = 20, 
     ymax = 20
   ) +
   
   annotation_custom(
     grob = linesGrob(arrow=arrow(type="open", length=unit(2,"mm")), gp=gpar(col="red", lwd=3)), 
     xmin = as.Date(min(as.mondate(sub_df_meteo2$fecha0)) - 1.2), 
     xmax = as.Date(min(as.mondate(sub_df_meteo2$fecha0)) - 1), 
     ymin = 20, 
     ymax = 20
   )+
   
   
   # Tmax
   annotation_custom(
     grob = grid::textGrob(label = "Umbral 26°C :\nTmax para una\nlatencia corta", hjust=0, gp=gpar(col="red", cex=0.85)),
     xmin = as.Date(min(as.mondate(sub_df_meteo2$fecha0)) - 2.8), 
     xmax = as.Date(min(as.mondate(sub_df_meteo2$fecha0)) - 2.7), 
     ymin = 26, 
     ymax = 26
   )+
   
   annotation_custom(
     grob = linesGrob(arrow=arrow(type="open", length=unit(2,"mm")), gp=gpar(col="red", lwd=3)), 
     xmin = as.Date(min(as.mondate(sub_df_meteo2$fecha0)) - 1.2), 
     xmax = as.Date(min(as.mondate(sub_df_meteo2$fecha0)) - 1),  
     ymin = 26, 
     ymax = 26
   )+
   
   
   # Latencia larga (< 5 dias 20<T<26)
   
  annotation_custom(
    grob = grid::textGrob(label = "Latencia larga", gp=gpar(col="darkgreen", cex=1), rot=-90),
    xmin = as.Date(max(as.mondate(sub_df_meteo2$fecha0)) + 2.3), 
    xmax = as.Date(max(as.mondate(sub_df_meteo2$fecha0)) + 2.3), 
    ymin = 0*max(sub_df_meteo2$tmean)/max(sub_dia_lat$num_dia),
    ymax = 4.9*max(sub_df_meteo2$tmean)/max(sub_dia_lat$num_dia) 

   ) +
   
  annotation_custom(
     grob = linesGrob(gp=gpar(col="darkgreen", lwd=3)), 
     xmin = as.Date(max(as.mondate(sub_df_meteo2$fecha0)) + 2), 
     xmax = as.Date(max(as.mondate(sub_df_meteo2$fecha0)) + 2),  
     ymin = 0*max(sub_df_meteo2$tmean)/max(sub_dia_lat$num_dia), 
     ymax = 4.9*max(sub_df_meteo2$tmean)/max(sub_dia_lat$num_dia)
  ) +
   
   
   # Latencia media ([5-10] dias 20<T<26)
   
  annotation_custom(
     grob = grid::textGrob(label = "Latencia media", gp=gpar(col="orange", cex=1), rot=-90),
     xmin = as.Date(max(as.mondate(sub_df_meteo2$fecha0)) + 2.3), 
     xmax = as.Date(max(as.mondate(sub_df_meteo2$fecha0)) + 2.3), 
     ymin = 5.1*max(sub_df_meteo2$tmean)/max(sub_dia_lat$num_dia),
     ymax = 9.9*max(sub_df_meteo2$tmean)/max(sub_dia_lat$num_dia)
     
  ) +
   
  annotation_custom(
     grob = linesGrob(gp=gpar(col="orange", lwd=3)), 
     xmin = as.Date(max(as.mondate(sub_df_meteo2$fecha0)) + 2), 
     xmax = as.Date(max(as.mondate(sub_df_meteo2$fecha0)) + 2),  
     ymin = 5.1*max(sub_df_meteo2$tmean)/max(sub_dia_lat$num_dia), 
     ymax = 9.9*max(sub_df_meteo2$tmean)/max(sub_dia_lat$num_dia)
   ) +
   
   
   
   # Latencia breve (>10 dias 20<T<26)
   
  annotation_custom(
     grob = grid::textGrob(label = "Latencia breve", gp=gpar(col="red", cex=1), rot=-90),
     xmin = as.Date(max(as.mondate(sub_df_meteo2$fecha0)) + 2.3), 
     xmax = as.Date(max(as.mondate(sub_df_meteo2$fecha0)) + 2.3), 
     ymin = 10.1*max(sub_df_meteo2$tmean)/max(sub_dia_lat$num_dia),
     ymax = 16*max(sub_df_meteo2$tmean)/max(sub_dia_lat$num_dia)
     
  ) +
   
   annotation_custom(
     grob = linesGrob(gp=gpar(col="red", lwd=3)), 
     xmin = as.Date(max(as.mondate(sub_df_meteo2$fecha0)) + 2), 
     xmax = as.Date(max(as.mondate(sub_df_meteo2$fecha0)) + 2),  
     ymin = 10.1*max(sub_df_meteo2$tmean)/max(sub_dia_lat$num_dia), 
     ymax = 16*max(sub_df_meteo2$tmean)/max(sub_dia_lat$num_dia)
   )+
   
   
   
   theme_bw()+   

   theme(
     text = element_text(size=8),
     panel.grid.minor = element_blank(),
     axis.title.y = element_text(angle = 0,
                                 vjust = 1,
                                 hjust = 1,
                                 color="red",
                                 face = "bold",size=8),
     axis.title.y.right = element_text(angle = 0,
                                       vjust = 1,
                                       hjust = 1,
                                       color="black",
                                       face = "bold",size=8
                                       ),
     plot.margin = margin(0.1, 3.5, 0, 3.5, "cm"), # top, right, bottom, left
     legend.position = "bottom"
     
   )
 
 
 
 
 # Turn off panel clipping
  
  gt <- ggplot_gtable(ggplot_build(p))
  gt$layout$clip[gt$layout$name == "panel"] <- "off"
  grid.draw(gt)
  

}

