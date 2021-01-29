rm(list = ls())
source("C:/Users/bommel/cormas2019/R/func-MiRoya-DynaCof LAI.R")

#@@@@@@@@@  SALVADOR 2013-2018  @@@@@@@@@@@@@

load("C:/Users/bommel/cormas2019/R/Outputs/sim_Linderos_2015-2020_alt_912.rda")
S$Sim$Date <- S$Meteo$Date
S$Sim <-subset(S$Sim, Date>="2015-01-01")
S$Meteo <- subset(S$Meteo, Date>="2015-01-01")
#data$Date[1], data$Date[length(data$Date)]
#S$Sim <-subset(S$Sim, Date>="2015-01-01")

setDynacof(S)  #set S2
initializeSimulations("init1ParcelLinderos", FALSE, 10)  #run independently 10 weeks

runYears(7)

plotLAIs(S, S2)

plotRoya()


library(ggplot2)

ggplot()+
  geom_point(data=S$Sim,aes(x=S$Sim$Date, y=CM_Fruit),color="blue")+
  geom_point(data=S$Sim,aes(x=S$Sim$Date, y=Harvest_Fruit,color="red"))+
  geom_point(data=S$Sim,aes(x=S$Sim$Date, y=Date_harvest),color="green")

ggplot()+
  geom_point(data=S2$Sim,aes(x=S2$Sim$Date, y=CM_Fruit),color="blue")+
  geom_point(data=S2$Sim,aes(x=S2$Sim$Date, y=Harvest_Fruit,color="red"))+
  geom_point(data=S2$Sim,aes(x=S2$Sim$Date, y=Date_harvest),color="green")

plot(S2$Sim$CM_Fruit)
plot(S2$Sim$Harvest_Fruit)
aa <- subset(S2$Sim, !is.na(Harvest_Fruit))
plot(aa$Harvest_Fruit)

ggplot()+
  geom_point(data=S2$Sim,aes(x=S2$Sim$Date, y=CM_Fruit),color="blue")+
  geom_point(data=aa,aes(x=aa$Date, y=Harvest_Fruit),color="red")+
  geom_point(data=S2$Sim,aes(x=S2$Sim$Date, y=Date_harvest),color="green")


#Do a simulation plan
#--------------------

  for (parametro in 3:100){
    load("C:/Users/bommel/cormas2019/R/Outputs/sim_elsalvador_2003-2018_alt_700-1200.rda")
    S$Sim$Date <- S$Meteo$Date
    S$Sim <-subset(S$Sim, Date>="2013-01-01")
    S$Meteo <- subset(S$Meteo, Date>="2013-01-01")
    setDynacof(S)  #set S2
    initializeSimulations("init1ParcelLinderos", FALSE, 10)  #run independently 10 weeks
    
    r <- setNumericAttributeValue("probaInfeccionViento:", "MiRoya_Dynacof", (parametro/200))
    cat("     ******** Parametro =", parametro/200)
    cat("                   *******
        ")
    runYears(1)
    
    incidRoya <- getNumericProbe("incidenciaRoya","MiRoya_Dynacof")
    if(!exists("results")) {results <- data.frame(step=seq(0,length(incidRoya)-1))
                            semanas <- S$Meteo$Date[seq(1, length(S$Meteo$Date), 7)]
                            semanas <- subset(semanas, semanas>="2013-01-01 UTC")
                            semanas <- semanas[1:length(incidRoya)]
                            results["Fechas"] <- semanas}
    results[paste("incid_",parametro/2, "%", sep = "")] <- incidRoya
  }
write.csv(results,file=paste("C:/Users/bommel/cormas2019/R/Outputs/resultsTEST", ".csv", sep = ""))
