rm(list = ls())
source("func-MiRoya-DynaCof.R")
#parameters
cormasInit <- "init1P_SalvadorSup1200"
S0_sim <- "sim_elsalvador_2003-2018_alt_sup1200.rda"  #Name of the basic simulation without rust
S0_sim <- "sim_elsalvador_20.rda"
randomSeed <- 3788179 #NA or a integer between 10.000 and 9.999.999

#@@@@@@@@@  SALVADOR 2013-2018  Sup 1200m @@@@@@@@@@@@@
load(paste(getwd(), "/outputs/", S0_sim, sep = ""))
initAndRunOneYear(S0_sim)
# After this first year, 
# either X years can be run
# /// Run full simulation ///
runYears( S$Meteo$year[nrow(S$Meteo)] - S$Meteo$year[1]) # By default stepSemanalDynacof: (1 week of MiRoya) is called X times 

rm(list = ls())
source("func-MiRoya-DynaCof.R")


load("D:/cormas2019/R/DynACof/sim_elsalvador_2003-2018_alt_sup1200.rda")
S$Sim$Date <- S$Meteo$Date
S$Sim <-subset(S$Sim, Date>="2013-01-01")
S$Meteo <- subset(S$Meteo, Date>="2013-01-01")

setDynacof(S)  #set S2
initializeSimulations("init1ParcelaSalvadorSup1200", FALSE, 10)  #run independently 10 weeks

runYears(7)

plotLAIs(S, S2)

plotRoya()
