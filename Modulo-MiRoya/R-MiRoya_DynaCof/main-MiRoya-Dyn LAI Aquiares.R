rm(list = ls())
source("func-MiRoya-DynaCof.R")

#@@@@@@@@@  AQUIARES 2009-2016  @@@@@@@@@@@@@
initFullSystem(S0_Name = "S0_Aquiares_2009-2016.rda", MiRoyaInit = "init1P_Aquiares_2009_2016")
runFirstYear()

# ///  Manipulation  ///   3774238085684 3774238301191 0.02 0.01
runYears(1)
runMonths(1)
runWeeks(1)

fertilization()
capacitacionFungicidas()  # increaseQFungicida by 10%
capacitacionCafetal()     # ne fait rien
aplicarFungicidaSistemica()
aplicarFungicidaProtector()
podaCafe_25()
podaCafe_50()
#  *****************************************************

# ***  Comparing 2 simulations (without & with rust)
load(paste(getwd(), "/outputs/SFullNoRust_Aquiares_2009-2016.rda", sep = "")) # = SFullNoRust
SFullNoRust$Sim$Date <- SFullNoRust$Meteo$Date
plotLAIs(SFullNoRust, S2)
for(t in 1:(currentStepDynacof)) {
    if(!is.na(S2$Sim$Date_harvest[t])) {   
      production <<- S2$Sim$Harvest_Fruit[t] #gC m-2 de sol
      cat("prod[",t,"]= ", production, "\n")
    }
  }

plotRoya()

# Pour connaitre la date actuelle : S2$Sim$Date[currentStepDynacof]
S$Sim <-subset(S$Sim, Date<=S2$Sim$Date[currentStepDynacof])
S2$Sim <-subset(S2$Sim, Date<=S2$Sim$Date[currentStepDynacof])
library(ggplot2)
ggplot()+
  geom_point(data=S2$Sim,aes(x=S2$Sim$Date, y=CM_Fruit),color="blue")+
  geom_point(data=S2$Sim,aes(x=S2$Sim$Date, y=Harvest_Fruit,color="red"))  
+
  geom_point(data=S$Sim,aes(x=S$Sim$Date, y=CM_Fruit),color="purple")+
  geom_point(data=S$Sim,aes(x=S$Sim$Date, y=Harvest_Fruit,color="orange"))
#sum_fruits:
ggplot()+
       geom_point(data=S2$Sim,aes(x=S2$Sim$Date, y=CM_Fruit),color="blue")+
       geom_point(data=S2$Sim,aes(x=S2$Sim$Date, y=Harvest_Fruit,color="red"))  +
       geom_point(data=S2$Sim,aes(x=S2$Sim$Date, y=sum_fruits/10,color="orange"))

S2$Sim$year <- S$Meteo$year
S3 <-subset(S2$Sim, Date>=S2$Sim$Date[1000])
S3 <-subset(S2$Sim, (S2$Sim$year >= 2017))
S3 <-subset(S3, (S3$year < 2018))
ggplot()+
       geom_point(data=S3,aes(x=S3$Date, y=CM_Fruit),color="blue")+
       geom_point(data=S3,aes(x=S3$Date, y=Harvest_Fruit,color="red"))  +
       geom_point(data=S3,aes(x=S3$Date, y=sum_fruits/10,color="orange"))

S$Sim$sum_fruits <- 0
for (i in 2: nrow(S$Sim)){
  if(S$Sim$BudBreak[i]>0) {S$Sim$sum_fruits[i] <- S$Sim$sum_fruits[i-1]+S$Sim$BudBreak[i]}
}
S$Sim$year <- S$Meteo$year
S3 <-subset(S$Sim, (S$Sim$year >= 2013))
S3 <-subset(S3, (S3$year < 2018))
ggplot()+
  geom_point(data=S3,aes(x=S3$Date, y=CM_Fruit),color="blue")+
  geom_point(data=S3,aes(x=S3$Date, y=Harvest_Fruit,color="red"))  +
  geom_point(data=S3,aes(x=S3$Date, y=sum_fruits/10,color="orange"))

plot(S2$Sim$Harvest_Fruit)
aa <- subset(S2$Sim, !is.na(Harvest_Fruit))
plot(aa$Harvest_Fruit)

ggplot()+
  geom_point(data=S2$Sim,aes(x=S2$Sim$Date, y=CM_Fruit),color="blue")+
  geom_point(data=aa,aes(x=aa$Date, y=aa$Harvest_Fruit,color="red"))+
  geom_point(data=S2$Sim,aes(x=S2$Sim$Date, y=Date_harvest),color="green")

#Do a simulation plan
#-----------------------------------------------------------#
rm(list = ls())
source("func-MiRoya-DynaCof.R")

nombreParametro <- "coefLaplace"
shortNameParameter <- "coefLaplace4"
placeName <- "Aquiares"
S0_sim <- "S0_Aquiares_2009-2016.rda" 
cormasInit <- "init1ParcelAquiares"

#runFullSimulation()
S0_file <- paste(getwd(), "/outputs/", S0_sim, sep = "")
load(S0_file)
S0$Sim$Date <- S0$Meteo$Date
S=S0

resultsRoya <- initMatrix(S)
resultsLAI <- resultsRoya
resultsSitios <- resultsRoya
autoCafPorCm <- resultsRoya
randomSeed <-1000  #NA
#for (param in 1:15){     
#for(param in c(2,5,10,50,100,200,300,400,500,750,1000,2000,10000)){
for (param in seq(from=0, to=0.3, by=0.01)){
  
  parametro <- param #/ 100 
  
  initFullSystem(S0_sim, cormasInit)
  runFirstYear()
  desactivateFertilization()
  #if(!is.na(randomSeed)) { r <- setNumericAttributeValue("randomSeed:", "MiRoya_Dynacof", randomSeed)}
  
  r <- setNumericAttributeValue((paste(nombreParametro, ":", sep = "")), "MiRoya_Dynacof", parametro)
  cat("     ******** Parametro ", nombreParametro, " = ", parametro, " ******* \n")
  
  #   run ONE SIMU
  runYears(S$Meteo$year[nrow(S$Meteo)] - S$Meteo$year[1]) #13
  
  resultsRoya <- storeMatrix(resultsRoya, "incidenciaRoya", shortNameParameter, parametro)
  resultsSitios <-  storeMatrix(resultsSitios, "porHoja_maxSitios", shortNameParameter, parametro)
  #resultsAlloInf <-  storeMatrix(resultsAlloInf, "infeccion_allo", shortNameParameter, parametro)
  autoCafPorCm <-  storeMatrix(autoCafPorCm, "infeccion_autoCafetoPorCm2", shortNameParameter, parametro)
  resultsLAI <-  storeMatrixLAI(resultsLAI, shortNameParameter, parametro)
}
write.csv(resultsRoya,file=paste(getwd(), "/outputs/incid", placeName, "_", shortNameParameter, ".csv", sep = ""))
write.csv(resultsLAI,file=paste(getwd(), "/outputs/LAI-", placeName, "_", shortNameParameter, ".csv", sep = ""))
write.csv(resultsSitios,file=paste(getwd(), "/outputs/Sitios-", placeName, "_", shortNameParameter, ".csv", sep = ""))
write.csv(autoCafPorCm,file=paste(getwd(), "/outputs/AutoInfecPorCm-", placeName, "_", shortNameParameter, ".csv", sep = ""))



#End of the simulation plan
#--------------------  







# runOneWeek()  ne fonctionne pas, alors que ça devrait ! Obliger de mettre S2 en argument...
S2 <<- runCompleteCycle(currentStepDynacof, S2)
# ici, détail de runCompleteCycle  ****************************
r <- setNumericAttributeValue("nuevoLAI:", "MiRoya_Dynacof", S2$Sim$LAI[currentStepDynacof])
# 2)  run 1 stepSemanal in Cormas  (evolution of rust)
currentStepMiRoya <<- currentStepMiRoya + 1
f %<-% runOneStep()  #%<-% to turn the assignment into a future assignment (implicit futures).
futureOf(f)
while (!resolved(f[[1]])) { cat("-")}
# Recuperer la valeur de areaVerdeLAI
LAI_MiROya <<- getNumericProbe("areaVerdeLAI","MiRoya_Dynacof")
i <- 0
while (length(LAI_MiROya) - 1 < currentStepMiRoya) {
  cat(".")
  i <- i + 1
  LAI_MiROya <<- getNumericProbe("areaVerdeLAI","MiRoya_Dynacof")
  if(i > 55) {currentStepMiRoya <<- currentStepMiRoya - 1}
}
cat(" LAI_MiROya= ", LAI_MiROya[currentStepMiRoya+1])

# 3)  Change CM_Leaf in Dynacof
if(S2$Sim$LAI[currentStepDynacof] > 0) {
  proportion <- (LAI_MiROya[currentStepMiRoya+1] - S2$Sim$LAI[currentStepDynacof])/ S2$Sim$LAI[currentStepDynacof]
} else {proportion <- 0} 

if(!is.na(proportion)) {
  if(proportion < -1) {proportion <- -1}
  S2$Sim$CM_Leaf[currentStepDynacof - 1] = (1+proportion) * S2$Sim$CM_Leaf[currentStepDynacof-1]
  cat(" LAI = ", (proportion)* 100, "% - ", "\n")
} 

#  4) Run 1 week in Dynacof ***
production <<- NA
for(t in currentStepDynacof:(currentStepDynacof+6)) {
  S2 <<- dynacof_i(t, S2, verbose = FALSE)
  if(!is.na(S2$Sim$Date_harvest[t])) {   	#doy = date of harvest
    production <<- S2$Sim$Harvest_Fruit[t] #gC m-2 de sol
    cat("prod[",t,"]= ", production, "\n")
    production <<- production * S$Parameters$CC_Fruit * 10000/1000 #kg de cerise sechees (sechage a 12%) / ha
    production <<- production /1000   #en Tonne/ha de cerise sechees
  }
}
currentStepDynacof <<- currentStepDynacof + 7 