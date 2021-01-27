# detach("package:DynACof", unload = TRUE)
# remotes::install_github("VEZY/DynACof")
rm(list = ls())
library("DynACof") 
Sys.setenv(TZ="UTC")

# Making a regular simulation using example data:
S0 <- dynacof_i(i = 1:365,Period= as.POSIXct(c("1979-01-01", "1990-01-01")))
# save(S0, file=paste(getwd(), "/outputs/demo_S0.rda", sep = ""))
# load(paste(getwd(), "/outputs/demo_S0.rda", sep = ""))


# On simule normalement:
S <- dynacof_i(i = 366:nrow(S0$Meteo),S = S0)
# save(S, file=paste(getwd(), "/outputs/demo_S.rda", sep = ""))
# load(paste(getwd(), "/outputs/demo_S.rda", sep = ""))

# on re-simule à partir de 1000 (S$Meteo$Date[1000] => "1981-09-26 UTC"):
S_stepByStep4= S_stepByStep3= S_stepByStep2= S_stepByStep= S0
for(t in (366:800)) {
  # 1) a l'identique :
  S_stepByStep <- dynacof_i(i = t, S_stepByStep)
  print(t)
}
plot(S_stepByStep$Sim$LAI~ S_stepByStep$Meteo$Date,type="l",col="green",lwd=1,xlab="time",ylab="LAI")
#for(t in (1000:nrow(S0$Meteo))) {
for(t in (366:1000)) {
  # 1) a l'identique :
 # S_stepByStep <- dynacof_i(i = t, S_stepByStep)
  
  # 2) ou avec modification:
 # S_stepByStep2$Meteo$Tair[t]= S$Meteo$Tair[t]+ 3
 # S_stepByStep2 <- dynacof_i(i = t, S_stepByStep2)
  
  S_stepByStep3$Sim$CM_Leaf[t-1] = (1-0.001) * S_stepByStep3$Sim$CM_Leaf[t-1]
  S_stepByStep3 <- dynacof_i(i = t, S_stepByStep3)
  print(t)
  
 # if(S0$Meteo$DOY[t] < 365 && S0$Meteo$DOY[t] > 200){
 #   S_stepByStep4$Sim$CM_Leaf[t-1] = (1-0.01) * S_stepByStep4$Sim$CM_Leaf[t-1]
 # }
 # S_stepByStep4 <- dynacof_i(i = t, S_stepByStep4)
 # print(t)
}

#plot LAI of 2 simulations
plot(S$Sim$LAI~ S$Meteo$Date,type="l",col="green",lwd=1,xlab="time",ylab="LAI")
lines(S_stepByStep$Sim$LAI~ S_stepByStep$Meteo$Date,col="red")
lines(S_stepByStep2$Sim$LAI~ S_stepByStep2$Meteo$Date,col="blue")
lines(S_stepByStep3$Sim$LAI~ S_stepByStep3$Meteo$Date,col="black")
lines(S_stepByStep4$Sim$LAI~ S_stepByStep4$Meteo$Date,col="blue", lty=2)

#nbre d'entre-noeuds :  S$Sim$LAI[i-1]*S$Sim$ratioNodestoLAI[i-1]
#reserves :
plot(S$Sim$CM_RE~ S$Meteo$Date,type="l",col="green",lwd=1,xlab="time",ylab="Reserves")
lines(S_stepByStep$Sim$CM_RE~ S_stepByStep$Meteo$Date,type="l",col="red")
lines(S_stepByStep2$Sim$CM_RE~ S_stepByStep2$Meteo$Date,type="l",col="blue")
lines(S_stepByStep3$Sim$CM_RE~ S_stepByStep3$Meteo$Date,type="l",col="black")

plot(S$Sim$CM_Leaf~ S$Meteo$Date,type="l",col="green",lwd=1,xlab="time",ylab="CM_Leaf")
lines(S_stepByStep$Sim$CM_Leaf~ S_stepByStep$Meteo$Date,type="l",col="red")
lines(S_stepByStep2$Sim$CM_Leaf~ S_stepByStep2$Meteo$Date,type="l",col="blue")
lines(S_stepByStep3$Sim$CM_Leaf~ S_stepByStep3$Meteo$Date,type="l",col="black")

library(ggplot2)
# plot S et S_stepByStep
ggplot()+
  geom_point(data=S$Sim,aes(x=S$Meteo$Date,y=CM_Fruit),color="blue")+
  geom_point(data=S$Sim,aes(x=S$Meteo$Date,y=Harvest_Fruit),color="red")+

  geom_point(data=S_stepByStep3$Sim,aes(x=S_stepByStep3$Meteo$Date,y=CM_Fruit),color="purple")+
  geom_point(data=S_stepByStep3$Sim,aes(x=S_stepByStep3$Meteo$Date,y=Harvest_Fruit),color="orange")

