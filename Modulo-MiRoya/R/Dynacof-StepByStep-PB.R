# detach("package:DynACof", unload = TRUE)
# remotes::install_github("VEZY/DynACof")
rm(list = ls())
library("DynACof") 
Sys.setenv(TZ="UTC")


# Making a regular simulation using example data:
S0 <- dynacof_i(i = 1:999,Period= as.POSIXct(c("1979-01-01", "1990-01-01")))
# save(S0, file=paste(getwd(), "/outputs/simuDynacofRegular_S0.rda", sep = ""))
# load(paste(getwd(), "/outputs/simuDynacofRegular_S0.rda", sep = ""))


# On continue la simulation normalement:
S <- dynacof_i(i = 1000:nrow(S0$Meteo),S = S0)
# save(S, file=paste(getwd(), "/outputs/simuDynacofRegular.rda", sep = ""))
# load(paste(getwd(), "/outputs/simuDynacofRegular.rda", sep = ""))

# on re-simule à partir de 999 (S$Meteo$Date[1000] => "1981-09-26 UTC"):
# 1) a l'identique :
S_stepByStep <- dynacof_i(1000:nrow(S0$Meteo), S0)

# 2) ou avec modification:
S_stepByStep= S0
for(t in (1000:nrow(S0$Meteo))) {
  #S_stepByStep$Meteo$Tair[t]= S$Meteo$Tair[t] #- 0.5  # T = +3°C
  S_stepByStep$Sim$CM_Leaf[t-1] = (1-0.001) * S_stepByStep$Sim$CM_Leaf[t-1]  # -10% de feuille/jour
  S_stepByStep <- dynacof_i(i = t, S = S_stepByStep)
  print(t)
}
#plot LAI of 2 simulations
plot(S$Sim$LAI~ S$Meteo$Date,type="l",col="green",lwd=1,xlab="time",ylab="LAI")
lines(S_stepByStep$Sim$LAI~ S_stepByStep$Meteo$Date,type="l",col="red",lwd=1,xlab="time",ylab="LAI2")

plot(S$Sim$LAI~ S_stepByStep$Meteo$Date,type="l",col="green",lwd=1,xlab="time",ylab="LAI")
lines(S_stepByStep$Sim$LAI~ S_stepByStep$Meteo$Date,type="l",col="red",lwd=1,xlab="time",ylab="LAI2")

#nbre d'entre-noeuds :  S$Sim$LAI[i-1]*S$Sim$ratioNodestoLAI[i-1]
#reserves :
plot(S_stepByStep$Sim$CM_RE~ S_stepByStep$Meteo$Date,type="l",col="green",lwd=1,xlab="time",ylab="Reserves")
lines(S$Sim$CM_RE~ S$Meteo$Date,type="l",col="red",lwd=1,xlab="time",ylab="reserve2")

library(ggplot2)
# plot S et S_stepByStep
ggplot()+
  geom_point(data=S_stepByStep$Sim,aes(x=S_stepByStep$Meteo$Date,y=CM_Fruit),color="purple")+
  geom_point(data=S_stepByStep$Sim,aes(x=S_stepByStep$Meteo$Date,y=Harvest_Fruit),color="orange") +
  
  geom_point(data=S$Sim,aes(x=S$Meteo$Date,y=CM_Fruit),color="blue")+
  geom_point(data=S$Sim,aes(x=S$Meteo$Date,y=Harvest_Fruit),color="red")


