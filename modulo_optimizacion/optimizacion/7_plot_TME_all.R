# Graph des tamano de monitoreo en fonction des combinaisons

func_plot_TME_all <- function(analyse_vgam,
                               analyse_vgam2){
  
library(plyr)

salidaHistorica <- subset(analyse_vgam,Fec %in% unique(analyse_vgam2$Fec))
salidaActual <- analyse_vgam2

incMediaHistorica <- aggregate(data.frame(p=salidaHistorica$p),
                               by=list(Fec=salidaHistorica$Fec),
                               mean,na.rm=T)
incMediaHistorica$group_inc <- "Incidencia Historica"

incMediaActual <-  aggregate(data.frame(p=salidaActual$p),
                        by=list(Fec=salidaActual$Fec),
                        mean,na.rm=T)
incMediaActual$group_inc <- "Incidencia Actual"

incMedia <- rbind(incMediaHistorica,incMediaActual)

dfSortedActual <- arrange(salidaActual, Fec, desc(FACTOR))


dfCumsumActual <- ddply(dfSortedActual, "Fec",
                   transform, label_TM_cum=cumsum(TM_ajustado))
dfCumsumActual$TM_arr <- ceiling(dfCumsumActual$TM_ajustado)

# !!!!! Ajuster echelle incidence echelle parcelle

# Plot
ggplot() +
  geom_bar(data=dfCumsumActual, aes(x=Fec, y=TM_ajustado, fill=FACTOR),stat="identity")+
  geom_text(data=dfCumsumActual,aes(x=Fec, y=label_TM_cum, label=TM_arr), vjust=1,
            color="white", size=3.5)+
  scale_colour_gradientn(colours=rainbow(4))+
  geom_line(data=incMedia, aes(x=Fec,y=p*100*max(dfCumsumActual$label_TM_cum)/(max(incMedia$p)*100),
                               group=group_inc,colour=group_inc),size=5, shape=15)+
  geom_point(data=incMedia, aes(x=Fec,y=p*100*max(dfCumsumActual$label_TM_cum)/(max(incMedia$p)*100),
                                group=group_inc,colour=group_inc),size=5, shape=15)+
  scale_color_manual("Incidencia\nmedia",values=c("red","black"))+
  scale_x_continuous(name = "Meses de monitoreo",
                     breaks=seq(1, 12, 1),
                     labels=c("Ene","Feb","Mar","Abr","May","Jun",
                              "Jul","Aug","Sep","Oct","Nov","Dec"))+
  scale_y_continuous(name = "Numero de parcelas", 
                     breaks=seq(0, max(dfCumsumActual$label_TM_cum+100), 100),
                     sec.axis = sec_axis(~.*(max(incMedia$p)*100)/max(dfCumsumActual$label_TM_cum), name = "Incidencia",
                     breaks=seq(0, max(incMedia$p)*100, ceiling(max(incMedia$p)*100/10))))+
  theme_minimal()

}

