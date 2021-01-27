#remotes::install_github("VEZY/DynACof")

rm(list = ls())
library("DynACof")
Sys.setenv(TZ="UTC")
S=DynACof(Period= as.POSIXct(c("1982-01-01", "1990-12-31")))

data("Aquiares")
#Aquiares
par(mfrow=c(1,2))
time=length(S$Sim$LAI)
plot(S$Sim$LAI~ S$Meteo$Date,type="l",col="green",lwd=1,xlab="anios",ylab="LAI")
plot(Aquiares$Tmax[1:time]~ S$Meteo$Date,type="l",col="red",lwd=1,ylab="temp")
lines(Aquiares$Tmin[1:time]~ S$Meteo$Date,type="l",col="blue",lwd=1)
plot(S$Sim$SoilWaterPot)
