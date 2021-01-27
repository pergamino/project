rm(list = ls())
source("D:/cormas2019/R/func-MiRoya-DynaCof LAI.R")

#@@@@@@@@@  SALVADOR 2013-2018  Sup 1200m @@@@@@@@@@@@@

load("D:/cormas2019/R/DynACof/sim_elsalvador_2003-2018_alt_sup1200.rda")
S$Sim$Date <- S$Meteo$Date
S$Sim <-subset(S$Sim, Date>="2013-01-01")
S$Meteo <- subset(S$Meteo, Date>="2013-01-01")

setDynacof(S)  #set S2
initializeSimulations("init1ParcelaSalvadorSup1200", FALSE, 10)  #run independently 10 weeks

runYears(7)

plotLAIs(S, S2)

plotRoya()
