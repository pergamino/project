##############
# Precipitationes
#############


func_precip <- function(output_moulinette,
                        df_meteo){
  
  library(grid)
  library(ggplot2)
  library(mondate)
  
  
  sub_df_meteo2 <- subset(df_meteo,
                          fecha0>=min(output_moulinette$fecha_15_dias_antes) &
                            fecha0<=max(output_moulinette$Fecha_monitoreo),
                          select=c(fecha0,precip))
  sub_df_meteo2 <- droplevels(sub_df_meteo2)
  
  
  output_moulinette$var <- factor(output_moulinette$var)
  levels(output_moulinette$var)[levels(output_moulinette$var)=="Aparicion_hojas"] <- "Aparicion de las hojas" # con lluvia diaria > 1mm
  sub_dia_lav <- output_moulinette[output_moulinette$var %in% c("Lavado","Infeccion","Aparicion de las hojas"),]
  sub_dia_lav <- droplevels(sub_dia_lav)
  sub_dia_lav$mid_date <- sub_dia_lav$fecha_15_dias_antes + as.numeric(sub_dia_lav$fecha_med_monitoreo-sub_dia_lav$fecha_15_dias_antes)/2
  
  
  cols <- c("#999900","#FF3333", "#3366FF") #"darksalmon","honeydew"

  
# Plot
 
 p <-
   ggplot() +
   
   geom_line(data=sub_df_meteo2, aes(x=fecha0, y=precip),
           size = 0.7, color="blue") +
   geom_col(data=sub_dia_lav,
            aes(x = mid_date, 
                y = num_dia*max(sub_df_meteo2$precip)/max(sub_dia_lav$num_dia), 
                fill=var), alpha=0.4,position = "dodge",width = 15) + # size=1, position = "dodge"
   
   scale_y_continuous(name = "Lluvia \ndiaria (mm)",breaks=seq(0,max(10,sub_df_meteo2$precip,sub_dia_lav$num_dia), by = 2),
                      sec.axis = sec_axis(~.*max(sub_dia_lav$num_dia)/max(sub_df_meteo2$precip),name = "Numero de dias\ncon lluvia\ndiaria > umbral\ndel proceso",
                                          breaks=seq(0,max(10,sub_df_meteo2$precip,sub_dia_lav$num_dia), by = 2)))+
   labs(x = "Fecha de monitoreo")+
   scale_x_date(date_labels = "%d/%m/%y",
                breaks=unique(sub_dia_lav$fecha_med_monitoreo))+
   scale_fill_manual(name = "Procesos",values=cols)+
   
   
   # Umbrales
   
   # aparicion hojas
   annotation_custom(
     grob = grid::textGrob(label = "Umbral 1 mm\npara la aparicion\nde las hojas", hjust=0, gp=gpar(col="red", cex=0.7)),
     xmin = as.Date(min(as.mondate(sub_df_meteo2$fecha0)) - 2.3), 
     xmax = as.Date(min(as.mondate(sub_df_meteo2$fecha0)) - 2.2), 
     ymin =1, 
     ymax = 1
   )+
   
   annotation_custom(
     grob = linesGrob(arrow=arrow(type="open", length=unit(2,"mm")), gp=gpar(col="red", lwd=3)), 
     xmin = as.Date(min(as.mondate(sub_df_meteo2$fecha0)) - 1.0), 
     xmax = as.Date(min(as.mondate(sub_df_meteo2$fecha0)) - 0.8),
     ymin = 1, 
     ymax = 1
   )+
   
   
   # infeccion
   annotation_custom(
     grob = grid::textGrob(label = "Umbral 5 mm\npara la infeccion", hjust=0, gp=gpar(col="red", cex=0.7)),
     xmin = as.Date(min(as.mondate(sub_df_meteo2$fecha0)) - 2.3), 
     xmax = as.Date(min(as.mondate(sub_df_meteo2$fecha0)) - 2.2), 
     ymin =5, 
     ymax = 5
   )+
   
   annotation_custom(
     grob = linesGrob(arrow=arrow(type="open", length=unit(2,"mm")), gp=gpar(col="red", lwd=3)), 
     xmin = as.Date(min(as.mondate(sub_df_meteo2$fecha0)) - 1.0), 
     xmax = as.Date(min(as.mondate(sub_df_meteo2$fecha0)) - 0.8),
     ymin = 5, 
     ymax = 5
   )+
   
   
   # lavado
   annotation_custom(
     grob = grid::textGrob(label = "Umbral 10 mm\npara la infeccion", hjust=0, gp=gpar(col="red", cex=0.7)),
     xmin = as.Date(min(as.mondate(sub_df_meteo2$fecha0)) - 2.3), 
     xmax = as.Date(min(as.mondate(sub_df_meteo2$fecha0)) - 2.2), 
     ymin =10, 
     ymax = 10
   )+
   
   annotation_custom(
     grob = linesGrob(arrow=arrow(type="open", length=unit(2,"mm")), gp=gpar(col="red", lwd=3)), 
     xmin = as.Date(min(as.mondate(sub_df_meteo2$fecha0)) - 1.0), 
     xmax = as.Date(min(as.mondate(sub_df_meteo2$fecha0)) - 0.8),
     ymin = 10, 
     ymax = 10
   )+
   
   
   # Procesos
   
   # Desfav. Aparicion hojas (< 5 dias lluvia >1mm)
   
   annotation_custom(
     grob = grid::textGrob(label = "Desfavorable ap. hojas", gp=gpar(col="red", cex=1), rot=-90),
     xmin = as.Date(max(as.mondate(sub_df_meteo2$fecha0)) + 2), 
     xmax = as.Date(max(as.mondate(sub_df_meteo2$fecha0)) + 2), 
     ymin = 0*max(sub_df_meteo2$precip)/max(sub_dia_lav$num_dia),
     ymax = 4.9*max(sub_df_meteo2$precip)/max(sub_dia_lav$num_dia) 
     
   )+
   
   annotation_custom(
     grob = linesGrob(gp=gpar(col="red", lwd=3)), 
     xmin = as.Date(max(as.mondate(sub_df_meteo2$fecha0)) + 1.8), 
     xmax = as.Date(max(as.mondate(sub_df_meteo2$fecha0)) + 1.8),  
     ymin = 0*max(sub_df_meteo2$precip)/max(sub_dia_lav$num_dia), 
     ymax = 4.9*max(sub_df_meteo2$precip)/max(sub_dia_lav$num_dia)
   )+
   
   
   
   # Moderam. fav. aparicion hojas ([5-10] dias lluvia >1mm)
   
   annotation_custom(
     grob = grid::textGrob(label = "Moderadamente fav. ap. hojas", gp=gpar(col="orange", cex=1), rot=-90),
     xmin = as.Date(max(as.mondate(sub_df_meteo2$fecha0)) + 2), 
     xmax = as.Date(max(as.mondate(sub_df_meteo2$fecha0)) + 2), 
     ymin = 5.1*max(sub_df_meteo2$precip)/max(sub_dia_lav$num_dia),
     ymax = 9.9*max(sub_df_meteo2$precip)/max(sub_dia_lav$num_dia)
     
   )+
   
   annotation_custom(
     grob = linesGrob(gp=gpar(col="orange", lwd=3)), 
     xmin = as.Date(max(as.mondate(sub_df_meteo2$fecha0)) + 1.8), 
     xmax = as.Date(max(as.mondate(sub_df_meteo2$fecha0)) + 1.8),  
     ymin = 5.1*max(sub_df_meteo2$precip)/max(sub_dia_lav$num_dia), 
     ymax = 9.9*max(sub_df_meteo2$precip)/max(sub_dia_lav$num_dia)
   )+
   
   
   
   # Fav. ap. hojas (>10 dias 20<T<26)
   
   annotation_custom(
     grob = grid::textGrob(label = "Favorable ap. hojas", gp=gpar(col="darkgreen", cex=1), rot=-90),
     xmin = as.Date(max(as.mondate(sub_df_meteo2$fecha0)) + 2), 
     xmax = as.Date(max(as.mondate(sub_df_meteo2$fecha0)) + 2), 
     ymin = 10.1*max(sub_df_meteo2$precip)/max(sub_dia_lav$num_dia),
     ymax = 16*max(sub_df_meteo2$precip)/max(sub_dia_lav$num_dia)
     
   )+
   
   annotation_custom(
     grob = linesGrob(gp=gpar(col="darkgreen", lwd=3)), 
     xmin = as.Date(max(as.mondate(sub_df_meteo2$fecha0)) + 1.8), 
     xmax = as.Date(max(as.mondate(sub_df_meteo2$fecha0)) + 1.8),  
     ymin = 10.1*max(sub_df_meteo2$precip)/max(sub_dia_lav$num_dia), 
     ymax = 16*max(sub_df_meteo2$precip)/max(sub_dia_lav$num_dia)
   )+
   
   
   
   # Infeccion baja (<3 dias lluvia >5mm)
   
   annotation_custom(
     grob = grid::textGrob(label = "Infeccion baja", gp=gpar(col="darkgreen", cex=1), rot=-90),
     xmin = as.Date(max(as.mondate(sub_df_meteo2$fecha0)) + 2.5), 
     xmax = as.Date(max(as.mondate(sub_df_meteo2$fecha0)) + 2.5), 
     ymin = 0*max(sub_df_meteo2$precip)/max(sub_dia_lav$num_dia),
     ymax = 2.9*max(sub_df_meteo2$precip)/max(sub_dia_lav$num_dia) 
     
   )+
   
   annotation_custom(
     grob = linesGrob(gp=gpar(col="darkgreen", lwd=3)), 
     xmin = as.Date(max(as.mondate(sub_df_meteo2$fecha0)) + 2.3), 
     xmax = as.Date(max(as.mondate(sub_df_meteo2$fecha0)) + 2.3),  
     ymin = 0*max(sub_df_meteo2$precip)/max(sub_dia_lav$num_dia), 
     ymax = 2.9*max(sub_df_meteo2$precip)/max(sub_dia_lav$num_dia)
   )+
   
   
   
   # Infeccion media ([3-7] dias lluvia >5mm)
   
   annotation_custom(
     grob = grid::textGrob(label = "Infeccion media", gp=gpar(col="orange", cex=1), rot=-90),
     xmin = as.Date(max(as.mondate(sub_df_meteo2$fecha0)) + 2.5), 
     xmax = as.Date(max(as.mondate(sub_df_meteo2$fecha0)) + 2.5), 
     ymin = 3.1*max(sub_df_meteo2$precip)/max(sub_dia_lav$num_dia),
     ymax = 6.9*max(sub_df_meteo2$precip)/max(sub_dia_lav$num_dia)
     
   )+
   
   annotation_custom(
     grob = linesGrob(gp=gpar(col="orange", lwd=3)), 
     xmin = as.Date(max(as.mondate(sub_df_meteo2$fecha0)) + 2.3), 
     xmax = as.Date(max(as.mondate(sub_df_meteo2$fecha0)) + 2.3),  
     ymin = 3.1*max(sub_df_meteo2$precip)/max(sub_dia_lav$num_dia), 
     ymax = 6.9*max(sub_df_meteo2$precip)/max(sub_dia_lav$num_dia)
   )+
   
   
   
   # Infeccion alta (>7 dias lluvia >5mm)
   
   annotation_custom(
     grob = grid::textGrob(label = "Infeccion alta", gp=gpar(col="red", cex=1), rot=-90),
     xmin = as.Date(max(as.mondate(sub_df_meteo2$fecha0)) + 2.5), 
     xmax = as.Date(max(as.mondate(sub_df_meteo2$fecha0)) + 2.5), 
     ymin = 7.1*max(sub_df_meteo2$precip)/max(sub_dia_lav$num_dia),
     ymax = 16*max(sub_df_meteo2$precip)/max(sub_dia_lav$num_dia)
     
   )+
   
   annotation_custom(
     grob = linesGrob(gp=gpar(col="red", lwd=3)), 
     xmin = as.Date(max(as.mondate(sub_df_meteo2$fecha0)) + 2.3), 
     xmax = as.Date(max(as.mondate(sub_df_meteo2$fecha0)) + 2.3),  
     ymin = 7.1*max(sub_df_meteo2$precip)/max(sub_dia_lav$num_dia), 
     ymax = 16*max(sub_df_meteo2$precip)/max(sub_dia_lav$num_dia)
   )+
   
   
   
   # Lavado insuficiente (<3 dias lluvia >10mm)
   
   annotation_custom(
     grob = grid::textGrob(label = "Lavado insuficiente", gp=gpar(col="red", cex=1), rot=-90),
     xmin = as.Date(max(as.mondate(sub_df_meteo2$fecha0)) + 3), 
     xmax = as.Date(max(as.mondate(sub_df_meteo2$fecha0)) + 3), 
     ymin = 0*max(sub_df_meteo2$precip)/max(sub_dia_lav$num_dia),
     ymax = 2.9*max(sub_df_meteo2$precip)/max(sub_dia_lav$num_dia) 
     
   )+
   
   annotation_custom(
     grob = linesGrob(gp=gpar(col="red", lwd=3)), 
     xmin = as.Date(max(as.mondate(sub_df_meteo2$fecha0)) + 2.8), 
     xmax = as.Date(max(as.mondate(sub_df_meteo2$fecha0)) + 2.8),  
     ymin = 0*max(sub_df_meteo2$precip)/max(sub_dia_lav$num_dia), 
     ymax = 2.9*max(sub_df_meteo2$precip)/max(sub_dia_lav$num_dia)
   )+
   
   
   
   # Lavado regular ([3-5] dias lluvia >10mm)
   
   annotation_custom(
     grob = grid::textGrob(label = "Lavado regular", gp=gpar(col="orange", cex=1), rot=-90),
     xmin = as.Date(max(as.mondate(sub_df_meteo2$fecha0)) + 3), 
     xmax = as.Date(max(as.mondate(sub_df_meteo2$fecha0)) + 3), 
     ymin = 3.1*max(sub_df_meteo2$precip)/max(sub_dia_lav$num_dia),
     ymax = 5.9*max(sub_df_meteo2$precip)/max(sub_dia_lav$num_dia)
     
   )+
   
   annotation_custom(
     grob = linesGrob(gp=gpar(col="orange", lwd=3)), 
     xmin = as.Date(max(as.mondate(sub_df_meteo2$fecha0)) + 2.8), 
     xmax = as.Date(max(as.mondate(sub_df_meteo2$fecha0)) + 2.8),  
     ymin = 3.1*max(sub_df_meteo2$precip)/max(sub_dia_lav$num_dia), 
     ymax = 5.9*max(sub_df_meteo2$precip)/max(sub_dia_lav$num_dia)
   )+
   
   
   
   # Lavado suficiente (>5 dias lluvia >10mm)
   
   annotation_custom(
     grob = grid::textGrob(label = "Lavado suficiente", gp=gpar(col="darkgreen", cex=1), rot=-90),
     xmin = as.Date(max(as.mondate(sub_df_meteo2$fecha0)) + 3), 
     xmax = as.Date(max(as.mondate(sub_df_meteo2$fecha0)) + 3), 
     ymin = 6.1*max(sub_df_meteo2$precip)/max(sub_dia_lav$num_dia),
     ymax = 16*max(sub_df_meteo2$precip)/max(sub_dia_lav$num_dia)
     
   )+
   
   annotation_custom(
     grob = linesGrob(gp=gpar(col="darkgreen", lwd=3)), 
     xmin = as.Date(max(as.mondate(sub_df_meteo2$fecha0)) + 2.8), 
     xmax = as.Date(max(as.mondate(sub_df_meteo2$fecha0)) + 2.8),  
     ymin = 6.1*max(sub_df_meteo2$precip)/max(sub_dia_lav$num_dia), 
     ymax = 16*max(sub_df_meteo2$precip)/max(sub_dia_lav$num_dia)
   )+
   
   
   
   theme_bw()+   

   theme(
     text = element_text(size=8),
     panel.grid.minor = element_blank(),
     axis.title.y = element_text(angle = 0,
                                 vjust = 1,
                                 hjust = 1,
                                 color="blue",
                                 face = "bold",size=8),
     axis.title.y.right = element_text(angle = 0,
                                       vjust = 1,
                                       hjust = 0,
                                       color="black",
                                       face = "bold",size=8
                                       ),
     plot.margin = margin(0.1, 3.5, 0, 3.0, "cm"), # top, right, bottom, left
     legend.position = "bottom"
     
   )
 
 
 
 
 # Turn off panel clipping
  
  gt <- ggplot_gtable(ggplot_build(p))
  gt$layout$clip[gt$layout$name == "panel"] <- "off"
  grid.draw(gt)
  

  
}

