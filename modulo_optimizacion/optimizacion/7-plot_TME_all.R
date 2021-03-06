# Graph des tamano de monitoreo en fonction des combinaisons

func_plot_TME_all <- function(analyse_vgam2){
  library(plyr)
  library(ggthemes)
  library(RColorBrewer)

  

dfSortedActual <- arrange(analyse_vgam2, Num_mes, desc(FACTOR))

dfCumsumActual <- ddply(dfSortedActual, "Num_mes",
                   transform, label_TM_cum=cumsum(TM_ajustado))
dfCumsumActual$TM_arr <- ceiling(dfCumsumActual$TM_ajustado)


getPalette = colorRampPalette(brewer.pal(9, "Set1"))
colourCount = length(unique(dfCumsumActual$FACTOR))


# Plot
ggplot() +
  geom_bar(data=dfCumsumActual, aes(x=Num_mes, y=TM_ajustado, fill=FACTOR),stat="identity",alpha = 0.6)+
  geom_text(data=dfCumsumActual,aes(x=Num_mes, y=label_TM_cum, label=TM_arr), vjust=1,
            color="grey14", size = 4)+
  scale_fill_manual(values = getPalette(colourCount)) +
  scale_x_continuous(name = "Meses de monitoreo",
                     breaks=seq(1, 12, 1),
                     labels=c("Ene","Feb","Mar","Abr","May","Jun",
                              "Jul","Aug","Sep","Oct","Nov","Dec"))+
  scale_y_continuous(name = "Numero de parcelas necesario", 
                     breaks=seq(0, max(dfCumsumActual$label_TM_cum+100), 100)
                     )+
  theme_classic()
}

