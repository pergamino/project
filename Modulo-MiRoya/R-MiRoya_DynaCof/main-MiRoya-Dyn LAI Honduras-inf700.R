rm(list = ls())
source("D:/cormas2019/R/func-MiRoya-DynaCof LAI.R")

#@@@@@@@@@  HONDURAS 2011-2018 inf 700m @@@@@@@@@@@@@

#load("D:/cormas2019/R/DynACof/sim_honduras_2011-2018_sinPoda.rda")
load("D:/cormas2019/R/DynACof/sim_honduras_2003-2018_alt_inf700.rda")
S$Sim$Date <- S$Meteo$Date
S$Sim <-subset(S$Sim, Date>="2011-01-01")
S$Meteo <- subset(S$Meteo, Date>="2011-01-01")

setDynacof(S)  #set S2
initializeSimulations("initUnaParcelaHonduras_inf700", FALSE, 10)  #run independently x weeks

runYears(8)

plotLAIs(S, S2)
plotRoya()

#  ***   Analyse sensibilite   ***
result <- NULL
resultSeeds <- NULL
for (rep in 1:50){
  cat(" Simu = ", rep, "\n")
  load("D:/cormas2019/R/DynACof/sim_honduras_2011-2018_sinPoda.rda")
  S$Sim$Date <- S$Meteo$Date
  setDynacof(S) 
  initializeSimulations("initUnaParcelaHonduras", FALSE, 10)  #run independently 10 weeks
  seed <- getNumericProbe("randomSeed","MiRoya_Dynacof")
  try(runYears(8))
  incidRoya <- getNumericProbe("incidenciaRoya","MiRoya_Dynacof")
  result <- rbind(result,incidRoya)
  resultSeeds <- rbind(resultSeeds,seed)
}
#plot roya of a simulation
  resultsPlot <- data.frame(incidenceRoya = incidRoya, step=seq(0,length(incidRoya)-1))
  plot(resultsPlot$incidenceRoya~ resultsPlot$step, type="l",col="black",lwd=2,xlab="steps",ylab="incidencia roya")
