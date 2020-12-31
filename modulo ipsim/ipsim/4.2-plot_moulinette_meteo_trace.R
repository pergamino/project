# 02/04/2020 : ajout Cantidad_esporas
# 10/06/2020 : ajout de la suscpetibilidad del hospedero

func_plot_meteo <- function(output_moulinette,
                            sortie_ipsim_ori){
  
  library(ggplot2)
  
  sortie_ipsim <- sortie_ipsim_ori[[1]]
  
  sub_ipsim <- subset(sortie_ipsim, select=-c(riesgo,categoria,inicial_categoria))
  ipsim_long <- gather(sub_ipsim, var, cat, Perdidas_esporas:Suscept_hospedero, factor_key=TRUE)
  ipsim_long$modelo <- "Effecto clima + sombra"
  
  
  # on inverse les categories infeccion, Aparicion_hojas et defoliacion 
  # pour la representation graphique
  # pour avoir cat 1: faible, 2: moyen, 3:fort
  ipsim_long$newCat <- ipsim_long$cat
  
  ipsim_long$newCat[ipsim_long$var=="Infeccion" & ipsim_long$cat==1] <- 3
  ipsim_long$newCat[ipsim_long$var=="Infeccion" & ipsim_long$cat==3] <- 1
  
  ipsim_long$newCat[ipsim_long$var=="Aparicion_hojas" & ipsim_long$cat==1] <- 3
  ipsim_long$newCat[ipsim_long$var=="Aparicion_hojas" & ipsim_long$cat==3] <- 1
  
  ipsim_long$newCat[ipsim_long$var=="Defoliacion" & ipsim_long$cat==1] <- 3
  ipsim_long$newCat[ipsim_long$var=="Defoliacion" & ipsim_long$cat==3] <- 1
  
  ipsim_long$newCat[ipsim_long$var=="Suscept_hospedero" & ipsim_long$cat==1 ] <- 3
  ipsim_long$newCat[ipsim_long$var=="Suscept_hospedero" & ipsim_long$cat %in% c(3,4)] <- 1
  
  
  sub_meteo <- subset(output_moulinette,select=c(fecha_med_monitoreo,cat,var))
  names(sub_meteo)[1] <- "Fecha_median"
  sub_meteo$var[sub_meteo$var=="Lavado"] <- "Perdidas_esporas"
  sub_meteo$Sombra <- 3 # baja o pleno sol
  sub_meteo$modelo <- "Effecto clima"
  

  sub_meteo$newCat <- sub_meteo$cat
  
  sub_meteo$newCat[sub_meteo$var=="Infeccion" & sub_meteo$cat==1] <- 3
  sub_meteo$newCat[sub_meteo$var=="Infeccion" & sub_meteo$cat==3] <- 1
  
  sub_meteo$newCat[sub_meteo$var=="Aparicion_hojas" & sub_meteo$cat==1] <- 3
  sub_meteo$newCat[sub_meteo$var=="Aparicion_hojas" & sub_meteo$cat==3] <- 1
  
  
  microclima <- rbind(sub_meteo,ipsim_long)
  
  microclima$var <- factor(microclima$var, levels = c("Inoc_antes_lavado", 
                                                      "Perdidas_esporas", 
                                                      "Cantidad_esporas",
                                                      "Infeccion",
                                                      "Latencia",
                                                      "Suscept_hospedero",
                                                      "Aparicion_hojas",
                                                      "Defoliacion"))
  
  var.labs <- c("Aparicion de hojas", "Infeccion", "Latencia",
                "Cantidad de esporas despues del parasitismo",
                "Perdidas de esporas por lavado",
                "Defoliacion","Cantidad de esporas despues del parasitismo y del lavado", 
                "Susceptibilidad del hospedero")
  names(var.labs) <- c("Aparicion_hojas", "Infeccion", "Latencia", 
                       "Inoc_antes_lavado","Perdidas_esporas",
                       "Defoliacion","Cantidad_esporas","Suscept_hospedero")
  
  ggplot() +
    # geom_point(data=microclima, mapping=aes(x=Fecha_median, y=1, size=newCat, colour=modelo),
    #            pch="O")+ # pch="O"shape=21

    geom_point(data=microclima[microclima$modelo=="Effecto clima + sombra",], 
               mapping=aes(x=Fecha_median, y=1, size=newCat),
               pch="O")+ # pch="O"shape=21
    
    facet_wrap(~var,ncol=1,
    labeller = labeller(var=var.labs))+
    scale_colour_manual(values = c("goldenrod1","khaki4"))+
    labs(x = "Fecha de monitoreo")+
    scale_x_date(date_labels = "%d/%m/%y",
                 breaks=unique(microclima$Fecha_median))+
    # scale_y_discrete(name=NULL,breaks=NULL,labels=NULL)+
    ylim(c(0.9,1.1))+
    scale_radius(breaks = c(1,2,3), 
                          labels=c("Baja","Media","Alta"), name="Fuerza del processo")+
    # ggtitle("Riesgo ligado al clima")+
    theme_bw()+
    theme(
      # legend.position="none",
      panel.grid.minor = element_blank(),
      panel.grid.major.y = element_blank(),
      axis.title.y = element_blank(),
      axis.text.y = element_blank(),
      axis.title.x = element_text(size=12),
      axis.text.x = element_text(size=12,angle = 90,face="bold"),
      text = element_text(size=15),
      axis.ticks = element_blank(),
      strip.background = element_blank(),
      strip.text.x = element_text(size = 13,face="bold"))+
    theme(legend.title=element_text(size=12,face="bold"),
          legend.text=element_text(size=12))
    
}



