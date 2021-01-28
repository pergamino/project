rm(list = ls())
source("func-MiRoya-DynaCof LAI.R")

#@@@@@@@@@  AQUIARES 2003-2016  @@@@@@@@@@@@@
load(paste(getwd(), "/outputs/simuDynacofRegularSinPoda_S0.rda", sep = ""))
S=S0
S$Sim$Date <- S$Meteo$Date
 S$Sim <-subset(S$Sim, Date>="2003-01-01")
 S$Meteo <- subset(S$Meteo, Date>="2003-01-01")
 cat("Date init: ", S$Meteo$year[1], " -> Date fin: ", S$Meteo$year[nrow(S$Meteo)])
setDynacof(S)  #set S2 & UTC
  #plot(S2$Meteo$Date,S2$Sim$LAI)
initializeSimulations("init1ParcelAquiares", FALSE, initDuration = 52)  #run independently 1 weeks



# 1)   Change nuevoLAI of MiRoya (at t = currentStepMiRoya)
r <- setNumericAttributeValue("nuevoLAI:", "MiRoya_Dynacof", S2$Sim$LAI[currentStepDynacof])

# 2)  run 1 stepSemanal in Cormas  (evolution of rust)
currentStepMiRoya <<- currentStepMiRoya + 1
f %<-% runOneStep()  #%<-% to turn the assignment into a future assignment (implicit futures).
futureOf(f)
while (!resolved(f[[1]])) { cat("-")}
# Recuperer la valeur de areaVerdeLAI
LAI_MiROya <<- getNumericProbe("areaVerdeLAI","MiRoya_Dynacof") #retourne un vecteur de toutes les valeurs de LAI
while (length(LAI_MiROya) - 1 < currentStepMiRoya) {
  cat(".")
  LAI_MiROya <<- getNumericProbe("areaVerdeLAI","MiRoya_Dynacof")
}

# 3)  Change CM_Leaf in Dynacof
proportion <- (LAI_MiROya[currentStepMiRoya+1] - S2$Sim$LAI[currentStepDynacof]) / S2$Sim$LAI[currentStepDynacof]
if(!is.na(proportion)) { 
 # if(proportion < 0) {
    if(proportion < -1) {proportion <- -1}
    S2$Sim$CM_Leaf[currentStepDynacof - 1] = (1+proportion) * S2$Sim$CM_Leaf[currentStepDynacof-1]
    cat(" LAI = ", (proportion)* 100, "% - ", "\n")}
  #}  

#  4) Run 1 week in Dynacof ***
production <<- NA
#S2 <- dynacof_i(i = 366, S2, verbose = TRUE)
currentStepDynacof <- 366
for(t in currentStepDynacof:(currentStepDynacof+7)) {
 # for(t in 366:(currentStepDynacof+7)) {
  S2 <- dynacof_i(i = t, S2, verbose = TRUE)
  
  if(!is.na(S$Sim$Date_harvest[t])) {   	#doy = date of harvest
    production <<- S2$Sim$CM_Fruit[t]
    cat("prod[",t,"]= ", production, "\n")
    production <<- production * S$Parameters$CC_Fruit * 10000/1000 #kg de cerise sechees (sechage a 12%) / ha
    production <<- production /1000   #en Tonne/ha de cerise sechees
  }
} 
currentStepDynacof <<- currentStepDynacof+7

#  5) Set new Cosecha    
if(!is.na(production)) {
  r <- setNumericAttributeValue("nuevaCosecha:", "MiRoya_Dynacof", production) #en Tonne/ha
} 









#S2 <<- runCompleteCycle(currentStepDynacof, S2)
S2 <<- runCompleteCycle2(S2)
runYears(1)

plotLAIs(S, S2)

plotRoya()

# Pour connaitre la date actuelle : S2$Sim$Date[currentStepDynacof]
S$Sim <-subset(S$Sim, Date<=S2$Sim$Date[currentStepDynacof])
S2$Sim <-subset(S2$Sim, Date<=S2$Sim$Date[currentStepDynacof])
library(ggplot2)
ggplot()+
  geom_point(data=S2$Sim,aes(x=S2$Sim$Date, y=CM_Fruit),color="blue")+
  geom_point(data=S2$Sim,aes(x=S2$Sim$Date, y=Harvest_Fruit,color="red"))+
  
  geom_point(data=S$Sim,aes(x=S$Sim$Date, y=CM_Fruit),color="purple")+
  geom_point(data=S$Sim,aes(x=S$Sim$Date, y=Harvest_Fruit,color="orange"))

plot(S2$Sim$Harvest_Fruit)
aa <- subset(S2$Sim, !is.na(Harvest_Fruit))
plot(aa$Harvest_Fruit)

ggplot()+
  geom_point(data=S2$Sim,aes(x=S2$Sim$Date, y=CM_Fruit),color="blue")+
  geom_point(data=aa,aes(x=aa$Date, y=aa$Harvest_Fruit,color="red"))+
  geom_point(data=S2$Sim,aes(x=S2$Sim$Date, y=Date_harvest),color="green")
