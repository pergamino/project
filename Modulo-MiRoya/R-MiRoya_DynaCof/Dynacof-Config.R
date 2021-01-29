library(DynACof)
rm(list = ls())
Sys.setenv(TZ="UTC")
#setwd("C:/Users/bommel/cormas2019/R/")
S0 = dynacof_i(i = 1:365, Period= as.POSIXct(c("2003-01-01", "2016-12-31")),
             Inpath = "inputs",
             FileName = list(Site = "Site.R",
                             Meteo = "meteorology_elsalvador_2003-2018_alt_700-1200.txt",
                             Soil = "Soil.R",
                             Coffee = "CoffeeNoPruning.R",
                             #Coffee = "coffeePruning",
                             Tree = NULL))
plot(S0$Meteo$Date,S0$Sim$LAI)
 save(S0, file=paste(getwd(), "/outputs/S0_sim_elsalvador_2003-2018_alt_700-1200.rda", sep = ""))
# save(S0, file=paste(getwd(), "/outputs/simuDynacofRegularSinPoda_S0.rda", sep = ""))
# load(paste(getwd(), "/outputs/simuDynacofRegularConPoda_S0.rda", sep = ""))
 
 SFull = dynacof_i(i = 1:4740, Period= as.POSIXct(c("2003-01-01", "2016-12-31")),
                Inpath = "inputs",
                FileName = list(Site = "Site.R",
                                Meteo = "meteorology_elsalvador_2003-2018_alt_700-1200.txt",
                                Soil = "Soil.R",
                                Coffee = "CoffeeNoPruning.R",
                                #Coffee = "coffeePruning",
                                Tree = NULL))
 save(SFull, file=paste(getwd(), "/outputs/SFull_sim_elsalvador_2003-2018_alt_700-1200.rda", sep = ""))
# On simule normalement:
S <- dynacof_i(i = 366:nrow(S0$Meteo),S = S0)
# save(S, file=paste(getwd(), "/outputs/simuDynacofAquiaresSinPoda_full.rda", sep = ""))

#S0 = DynACof(Period= as.POSIXct(c("2003-01-01", "2016-12-31")),
#              Inpath = "inputs",
#              FileName = list(Site = "Site.R",
#                              Meteo = "meteorology_Aquiares.txt",
#                              Soil = "Soil.R",
#                              Coffee = "CoffeeNoPruning.R",
#                              Tree = NULL))
plot(S$Meteo$Date,S$Sim$LAI)
cat("Date init: ", S$Meteo$year[1], " -> Date fin: ", S$Meteo$year[nrow(S$Meteo)])
# save(S0, file=paste(getwd(), "/outputs/simuDynacofAquiaresSinPoda_S0.rda", sep = ""))
# load(paste(getwd(), "/outputs/simuDynacofAquiaresSinPoda_S0.rda", sep = ""))
