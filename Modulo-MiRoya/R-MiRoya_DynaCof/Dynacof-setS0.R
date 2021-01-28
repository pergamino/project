# Purpose: run 2 simulations: 
#     - one (S0) of one year in order to boot up the system and 
#     - one (SFullNoRust) to have a complete simulation without rust, to compare it with one with MiRoya
# Those 2 simulations are saved into the /outputs/ folder.

library(DynACof)
rm(list = ls())
#  **** Parameters ****
meteo_fileName <-  "meteorology_elsalvador_2003-2017_alt_sup1200.txt" #"meteo_Aquiares - 2009-2016.txt"

meteo_fileName <-  "meteo_Aquiares - 2009-2016.txt"

dateInit <- "2009-01-01"  
dateFin <- "2016-12-31"   
pruning = "CoffeeNoPruning.r" #"CoffeeNoPruning.R"  #coffeePruning
S0_name <- "S0_elsalvador_2003-2018_alt_sup1200.rda"  #"S0_Aquiares_2009-2016.rda"
S0_name <- "S0_Aquiares_2009-2016.rda"
SFull_name <- "sim_elsalvador_2003-2018_alt_sup1200.rda"
#  **** ---------- ****

Sys.setenv(TZ="UTC")
# Convert meteo file for Dynacof
aFile <- paste(getwd(), "/inputs/", meteo_fileName, sep = "")
meteo <- read.table(aFile, header= TRUE, sep=",")
write.csv(meteo, file = aFile, row.names = FALSE)

#Simulate just 1 year
S0 = dynacof_i(i = 1:365, Period= as.POSIXct(c(dateInit, dateFin)),
             Inpath = "inputs",
             FileName = list(Site = "Site.R",
                             Meteo = meteo_fileName,
                             Soil = "Soil.R",
                             Coffee = pruning,
                             Tree = NULL))
plot(S0$Meteo$Date,S0$Sim$LAI)
 save(S0, file=paste(getwd(), "/outputs/", S0_name, sep = ""))
# load(paste(getwd(), "/outputs/simuDynacofRegularConPoda_S0.rda", sep = ""))
S0$Parameters$Fertilization <- 3
# Run a full simulation without rust:
SFullNoRust <- dynacof_i(i = 366:nrow(S0$Meteo),S = S0)
# save(S, file=paste(getwd(), "/outputs/simuDynacofAquiaresSinPoda_full.rda", sep = ""))
plot(SFullNoRust$Meteo$Date,SFullNoRust$Sim$LAI)
plot(SFullNoRust$Meteo$Date,SFullNoRust$Sim$CM_Fruit *10/46)
#cat("Date init: ", SFullNoRust$Meteo$year[1], " -> Date fin: ", SFullNoRust$Meteo$year[nrow(SFullNoRust$Meteo)])
save(SFullNoRust, file=paste(getwd(), "/outputs/", SFull_name, sep = ""))
# load(paste(getwd(), "/outputs/simuDynacofAquiaresSinPoda_S0.rda", sep = ""))
