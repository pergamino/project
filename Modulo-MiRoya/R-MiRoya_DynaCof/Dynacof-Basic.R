
#remotes::install_github("VEZY/DynACof")
rm(list = ls())
library("DynACof")
Sys.setenv(TZ="UTC")
sim = DynACof(Period= as.POSIXct(c("1979-01-01", "1985-12-31")))
plot(sim$Meteo$Date,sim$Sim$LAI)
# or
plot(sim$Sim$LAI~ sim$Meteo$Date,type="l",col="green",lwd=1,xlab="anios",ylab="LAI")


