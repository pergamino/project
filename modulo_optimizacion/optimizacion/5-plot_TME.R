# Graph des tamano de monitoreo en fonction des combinaisons

# func_plot_TME <- function(vgam.salida_ajust){
  
func_plot_TME <- function(df_metrica_all,
                          metrica){
  
library(plyr)
library(ggthemes)
library(RColorBrewer)
library(tidyr)  

# Affichage de la courbe d incidence
  
  if(metrica %in% c("Tamano_promedio","Tamano_mediano","Tamano_maximo")) {
    sub <- subset(df_metrica_all,select=c(FACTOR,Num_mes,Incidencia_mediana))
    colnames(sub) <- c("FACTOR","Num_mes","incidencia")
  } else {
    
    anio <- stringr::str_remove(metrica,"Tamano_")
    col_nam <- paste0("Incidencia_",anio)
    
    sub <- df_metrica_all[,c("FACTOR","Num_mes",col_nam)]
    colnames(sub) <- c("FACTOR","Num_mes","incidencia")
  }
  
  
  
incMedia <-  aggregate(data.frame(p=sub$incidencia),
                        by=list(Num_mes=sub$Num_mes),
                        mean,na.rm=T)


# Affichage des barres de tamano
df_tamano <- df_metrica_all[,c("FACTOR","Num_mes",metrica)]
df_tamano <- df_tamano %>% drop_na()


df_sorted <- arrange(df_tamano, Num_mes, desc(FACTOR))
colnames(df_sorted) <- c("FACTOR","Num_mes","Tamano")

df_cumsum <- ddply(df_sorted, "Num_mes",
                   transform, label_TM_cum=cumsum(Tamano))
         
df_cumsum$TM_arr <- ceiling(df_cumsum$Tamano)


getPalette = colorRampPalette(brewer.pal(9, "Set1"))
colourCount = length(unique(df_cumsum$FACTOR))

# Plot
ggplot() +
  geom_bar(data=df_cumsum, aes(x=Num_mes, y=Tamano, fill= FACTOR), stat="identity",alpha = 0.6)+
  geom_text(data=df_cumsum,aes(x=Num_mes, y=label_TM_cum, label=TM_arr), vjust=1,
            color="grey14", size = 4)+
  scale_fill_manual(values = getPalette(colourCount))+
  geom_line(data=incMedia, aes(x=Num_mes,y=p*100*max(df_cumsum$label_TM_cum)/(max(!is.nan(incMedia$p))*100)),
            size=1.5, colour = "dodgerblue4")+
  ggtitle(metrica)+
  scale_x_continuous(name = "Meses de monitoreo",
                     breaks=seq(1, 12, 1),
                     labels=c("Ene","Feb","Mar","Abr","May","Jun",
                              "Jul","Aug","Sep","Oct","Nov","Dec"))+
  scale_y_continuous(name = "Numero de parcelas", 
                     breaks=seq(0, max(df_cumsum$label_TM_cum+50), 100),
                     sec.axis = sec_axis(~.*(max(!is.nan(incMedia$p))*100)/max(df_cumsum$label_TM_cum), name = "Incidencia",
                     breaks=seq(0, max(!is.nan(incMedia$p))*100, ceiling(max(!is.nan(incMedia$p))*100/10))))+
  theme_classic()
 
       
}

