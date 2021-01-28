rm(list = ls())
source("D:/cormas2019/R/func-MiRoya-DynaCof LAI.R")

#@@@@@@@@@  SALVADOR 2011-2018  @@@@@@@@@@@@@

load("D:/cormas2019/R/DynACof/sim_elsalvador_2011-2018_sinPoda.rda")
S$Sim$Date <- S$Meteo$Date
setDynacof(S)  #set S2
initializeSimulations("init1ParcelaSalvador", FALSE, 10)  #run independently 10 weeks

runYears(7)

plotLAIs(S, S2)

plotRoya()
