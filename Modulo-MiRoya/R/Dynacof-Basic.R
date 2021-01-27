
#remotes::install_github("VEZY/DynACof")
rm(list = ls())
library("DynACof")
Sys.setenv(TZ="UTC")
sim = DynACof(Period= as.POSIXct(c("1979-01-01", "1984-01-31")))
plot(sim$Meteo$Date,sim$Sim$LAI)

