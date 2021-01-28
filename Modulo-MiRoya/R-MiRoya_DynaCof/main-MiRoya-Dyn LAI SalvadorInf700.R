rm(list = ls())
source("C:/Users/bommel/cormas2019/R/func-MiRoya-DynaCof LAI.R")
#@@@@@@@@@  SALVADOR 2013-2018  inf 700m @@@@@@@@@@@@@

load("C:/Users/bommel/cormas2019/R/DynACof/sim_elsalvador_2003-2018_alt_inf700.rda")
S$Sim$Date <- S$Meteo$Date
S$Sim <-subset(S$Sim, Date>="2013-01-01")
S$Meteo <- subset(S$Meteo, Date>="2013-01-01")

setDynacof(S)  #set S2
initializeSimulations("init1ParcelaSalvadorInf700", TRUE, 10)  #run independently 10 weeks

runYears(7)

plotLAIs(S, S2)

plotRoya()

S$Sim <-subset(S$Sim, Date<=S2$Sim$Date[currentStepDynacof-1])
S2$Sim <-subset(S2$Sim, Date<=S2$Sim$Date[currentStepDynacof-1])
library(ggplot2)
ggplot()+
  geom_point(data=S$Sim,aes(x=S$Sim$Date, y=CM_Fruit),color="purple")+
  geom_point(data=S$Sim,aes(x=S$Sim$Date, y=Harvest_Fruit,color="orange"))+
  
  geom_point(data=S2$Sim,aes(x=S2$Sim$Date, y=CM_Fruit),color="blue")+
  geom_point(data=S2$Sim,aes(x=S2$Sim$Date, y=Harvest_Fruit,color="red"))

