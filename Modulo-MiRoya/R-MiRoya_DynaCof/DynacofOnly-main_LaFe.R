rm(list = ls())
library(DynACof)
#**************************************
basicName <- "LaFe_2014-2020"
#**************************************
fileNameMETEO <- paste("meteorology_", basicName, sep = "")
fileNameSIMU <- paste(getwd(), "/outputs/sim_", basicName, ".rda", sep = "")
Sys.setenv(TZ="UTC")

fileNameMETEO <- paste("meteorology_", basicName, ".txt", sep = "")

# Run a simulation without pruning
sim <- DynACof(Period= as.POSIXct(c("2013-01-01", "2020-12-31")),
             Inpath = "inputs",
             FileName = list(Site = "site.R", Meteo =fileNameMETEO,
                             Soil = "soil.R",Coffee = "coffeeNoPruning.R"))

# Run a simulation with pruning
sim2 <- DynACof(Period= as.POSIXct(c("2013-01-01", "2020-12-31")),
               Inpath = "inputs",
               FileName = list(Site = "site.R", Meteo =fileNameMETEO,
                               Soil = "soil.R",Coffee = "coffeePruning.R"))
#plot LAI of 2 simulations

plot(sim$Sim$LAI~ sim$Meteo$Date,type="l",col="red",lwd=1,xlab="time",ylab="LAI")
lines(sim2$Sim$LAI~ sim2$Meteo$Date,col="green")

