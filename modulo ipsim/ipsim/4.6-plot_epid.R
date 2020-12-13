###############
# Plot datos epidemiologicos
###############
library(ggplot2)

func_plot_epid <- function(datos_epidemio){
  ggplot(data=datos_epidemio, aes(x=Fecha_median,y=incidencia))+
    geom_point(shape=1)+
    geom_smooth(se=F, color="darkgrey")+
    labs(x = "Fecha de monitoreo", y ="Incidencia")+
    scale_x_date(date_labels = "%d/%m/%y",
                 breaks=unique(datos_epidemio$Fecha_median))+
    theme_bw()
}