source(paste(getwd(), "/cormas-func.R", sep = ""))
library(future)
library(ggplot2)
library(lubridate)
# detach("package:DynACof", unload = TRUE)
# install.packages("C:/Users/bommel/cormas2019/R/DynACof_1.2.0.tar.gz", repos = NULL, type="source")
#ou remotes::install_github("VEZY/DynACof") 
#remotes::install_github("VEZY/DynACof")
#install.packages("devtools")   pas oblige de faire un install
#devtools::install_github("VEZY/DynACof")  # taper 3 (None) 
library("DynACof")

initAndRunOneYear <- function(S0_simName) {
  load(paste(getwd(), "/outputs/", S0_simName, sep = ""))  #set S0
  S0$Sim$Date <- S0$Meteo$Date
  S=S0
  setDynacof(S)  #set S2
  cat("Date init: ", S$Meteo$year[1], " -> Date fin: ", S$Meteo$year[nrow(S$Meteo)])
 # if(!is.na(randomSeed)) { r <- setNumericAttributeValue("randomSeed:", "MiRoya_Dynacof", randomSeed)}
  if(!is.na(randomSeed)) { rand <- randomSeed} else { rand <- 0 }
  r <- setNumericAttributeValue("randomSeed:", "MiRoya_Dynacof", rand)
  #run independently 52 weeks    
  initFullSystem(S0_sim, cormasInit)
  runFirstYear()
}

setDynacof <- function(simDynacof) {
  simDynacof$Sim$sum_fruits <- 0
  S2 <<- simDynacof
  Sys.setenv(TZ="UTC")
  return(S2)}

#   ************ Initialize MiRoya *****************
initializeSimulations <- function(initName = "init1ParcelaSalvador700_1200", 
                                  reLoadModel = F) {
  openVisualWorks(GUI = F)
  system("cormas.exe")
  #r <- openCormas()
  if(reLoadModel) {openModel("MiRoya_Dynacof")}
  setInit(initName)
  r <- runSimu(0)
}
#@@@@@@@@@  INIT and Run 1 year @@@@@@@@@@@@@
initFullSystem <- function(S0_Name = "S0_Aquiares_2004-2016.rda", MiRoyaInit = "init1ParcelAquiares") {
  load(paste(getwd(), "/outputs/", S0_Name, sep = "")) #get S0
  S <<- S0
  S$Sim$Date <- S$Meteo$Date
  setDynacof(S)  #set S2 & UTC
  initializeSimulations(MiRoyaInit, FALSE) 
}

runFullSimulation <- function() {
  runYears( S$Meteo$year[nrow(S$Meteo)] - S$Meteo$year[1]) #sim = S2
}
runFirstYear <- function() {
  setStep("soloClimaSemanal:")  #the 1st year, run quickly just to update the climate
  currentStepMiRoya <<- 52
  currentStepDynacof <<- currentStepMiRoya * 7
  #  runFirstYear()
  r <- runSimu(currentStepMiRoya)
  currentStepDynacof <<- 366
  setNumericAttributeValue("setNumDia:", "MiRoya_Dynacof", currentStepDynacof)
  setNumericAttributeValue("lastDay:", "MiRoya_Dynacof", nrow(S$Meteo))
  setStep("stepSemanalDynacof:") #At the end of the first year, we set the correct control method for MiRoya
}

runFirstYearLAI <- function() {
  setStep("soloClimaSemanal:")  #the 1st year, run quickly just to update the climate
  # 1 anio
  for (week in 1:52) {
    S2 <<- runCompleteCycleLAI(currentStepDynacof, S2)
  }
  cat("1st Year ended: ", S2$Meteo$year[currentStepDynacof],". currentStepDynacof: ", currentStepDynacof, " MiRoya: ", currentStepMiRoya, "\n")  
}


# ********* => run ONE Week  ******************************************************
runCompleteCycleLAI <- function(stepInit, S2) {
  # 1) set new LAI and greenNodes to MiRoya
  r <- setNumericAttributeValue("nuevoLAI:", "MiRoya_Dynacof", S2$Sim$LAI[currentStepDynacof])
  # 2)  run 1 stepSemanal in Cormas  (evolution of rust)
  f %<-% runOneStep()  #%<-% to turn the assignment into a future assignment (implicit futures).
  futureOf(f)
  while (!resolved(f[[1]])) { cat("-")}
  currentStepMiRoya <<- currentStepMiRoya + 1  # 3) Recuperer la valeur de areaVerdeLAI
  LAI_MiROya <<- getNumericProbe("areaVerdeLAI","MiRoya_Dynacof")
  i <- 0
  while (length(LAI_MiROya) - 1 < currentStepMiRoya) {
    #    cat(".")
    i <- i + 1
    LAI_MiROya <<- getNumericProbe("areaVerdeLAI","MiRoya_Dynacof")
    if(i > 400) {#currentStepMiRoya <<- currentStepMiRoya - 1
    cat(" i: ", i ,". currentStepMiRoya= ", currentStepMiRoya," Waiting for MiRoya ... /n")}
  }
  
  currentStepDynacof <<- currentStepDynacof + 7 
  return(S2)
}

#   ************ RUN X weeks  *****************
runWeeks <- function(numWeeks) {

    for (week in 1:numWeeks) {
      S2 <<- runCompleteCycle(currentStepDynacof, S2)
    }
  cat("Current date: ", mday(S2$Meteo$Date[currentStepDynacof]),"/",month(S2$Meteo$Date[currentStepDynacof]),"/", S2$Meteo$year[currentStepDynacof], "\n") 
}
#   ************ RUN X month  *****************
runMonths <- function(numMonths) {
  for (week in 1:(4*numMonths)) {
    S2 <<- runCompleteCycle(currentStepDynacof, S2)
    }
  while (mday(S2$Meteo$Date[currentStepDynacof]) < 23) {
    cat("Run 1 supplmentary week  ")
    S2 <<- runCompleteCycle(currentStepDynacof, S2)
  }
  cat("Current date: ", mday(S2$Meteo$Date[currentStepDynacof]),"/",month(S2$Meteo$Date[currentStepDynacof]),"/", S2$Meteo$year[currentStepDynacof], "\n") 
}
#   ************ RUN X Years  *****************
runYears <- function(numYears) {
  for (y in 1:numYears) {
    # 1 anio
    for (week in 1:52) {
      S2 <<- runCompleteCycle(currentStepDynacof, S2)
    }
    cat("numYear: ", y, " ended: ", S2$Meteo$year[currentStepDynacof],". currentStepDynacof: ", currentStepDynacof, " MiRoya: ", currentStepMiRoya, "\n")  
  }
}

# ********* run a COMPLETE cycle of one week, in Cormas then in Dynacof ***********
# ********* => run ONE Week  ******************************************************
runCompleteCycle <- function(stepInit, S2) {
# 1) set new LAI and greenNodes to MiRoya
  r <- setNumericAttributeValue("nuevoLAI:", "MiRoya_Dynacof", S2$Sim$LAI[currentStepDynacof])
  
# 2)  run 1 stepSemanal in Cormas  (evolution of rust)
  f %<-% runOneStep()  #%<-% to turn the assignment into a future assignment (implicit futures).
  futureOf(f)
  while (!resolved(f[[1]])) { cat("-")}
  currentStepMiRoya <<- currentStepMiRoya + 1
# 3) Get the new value of areaVerdeLAI from MiRoya
  Sys.sleep(0.2)
  LAI_MiROya <<- getNumericProbe("areaVerdeLAI","MiRoya_Dynacof")
  i <- 0
  while (length(LAI_MiROya) - 1 < currentStepMiRoya) {
    i <- i + 0.2
    Sys.sleep(0.2)
    cat("waiting ", i, "s... ")
    LAI_MiROya <<- getNumericProbe("areaVerdeLAI","MiRoya_Dynacof")
    if (i > 8) {
      cat(" i: ", i ,". length(LAI_MiROya) - 1= ",length(LAI_MiROya) - 1," currentStepMiRoya= ",currentStepMiRoya," Waiting for MiRoya ... \n")
      if (i > 10) { 
        LAI_MiROya <<- getNumericProbe("areaVerdeLAI","MiRoya_Dynacof")
      }
      if (i > 100) { 
        LAI_MiROya <<- getNumericProbe("areaVerdeLAI","MiRoya_Dynacof")
        currentStepMiRoya <<- currentStepMiRoya - 1
        cat(" !!! Reducing currentStepMiRoya: ",currentStepMiRoya," !!! Still Waiting for MiRoya ... \n")
      }
    }
  }
  cat("OK. \n")
  
# 4)  Change CM_Leaf in Dynacof
  #cat("Change CM_Leaf in Dynacof\n")
  if(S2$Sim$LAI[currentStepDynacof] > 0) {
    proportion <- (LAI_MiROya[currentStepMiRoya+1] - S2$Sim$LAI[currentStepDynacof])/ S2$Sim$LAI[currentStepDynacof]
  } else {proportion <- 0} 
  
  if(!is.na(proportion)) {
    if(proportion < -1) {proportion <- -1}
    S2$Sim$CM_Leaf[currentStepDynacof - 1] <- ((1+proportion) * S2$Sim$CM_Leaf[currentStepDynacof-1])
  } 
  
#  5) Run 1 week in Dynacof ***
  production <<- NA
  for(t in currentStepDynacof:(currentStepDynacof+6)) {
    S2 <- dynacof_i(t, S2, verbose = FALSE)

    #cat(" step t =", t)
    if(!is.na(S2$Sim$Date_harvest[t])) {   	#doy = date of harvest
      production <<- S2$Sim$Harvest_Fruit[t] #gC m-2 de sol
      production <<- production * 10000/1000 / 46 # Quintal /ha
    }
    #carga fructifera = green nodes/tree
    if(S2$Sim$BudBreak[t]>0) {S2$Sim$sum_fruits[t] <<- S2$Sim$sum_fruits[t-1]+S2$Sim$BudBreak[t]}
    
    if(S2$Parameters$D_pruning == S2$Meteo$DOY[t]) { # la poda vient d avoir lieu. On remet a 0 pour interactif
      S2$Parameters$LeafPruningRate <-  0
      S2$Parameters$WoodPruningRate <-  0
    }

  }
  currentStepDynacof <<- currentStepDynacof + 7 
  #  5) Set new Cosecha    
  if(!is.na(production)) {
    r <- setNumericAttributeValue("nuevaCosecha:", "MiRoya_Dynacof", production) #en Quintal/ha
    cat("prod[",t,"]= ", production," Q/ha", "\n")
  } 
  
  #r <- setNumericAttributeValue("numFrutos:", "MiRoya_Dynacof", S2$Sim$sum_fruits[currentStepDynacof-1]) 
  r <- setNumericAttributeValue("numNodos:", "MiRoya_Dynacof", S2$Sim$LAI[currentStepDynacof] * S2$Sim$ratioNodestoLAI[currentStepDynacof])  #charge fruitiere. 
  # ratioNodestoLAI = Number of fruiting nodes per LAI unit
  # pheno = 0 (nothing), 1 (maturation), ou 2 (harvest)
  pheno <- ifelse(S2$Sim$BudBreak>0,1,ifelse(!is.na(S2$Sim$Harvest_Fruit),2,0))
  r <- setNumericAttributeValue("fenologiaDynacof:", "MiRoya_Dynacof", pheno[currentStepDynacof - 1])
  r <- setNumericAttributeValue("cargaFrutal:", "MiRoya_Dynacof", S2$Sim$CM_Fruit[currentStepDynacof - 1] * 10/46) #quintal/ha
  return(S2)
}


 
 #@@@@@@@@@@@ PLOTS @@@@@@@@@@@@@@@@@@@@@@@@@@@@
 #plot roya of a simulation
 plotRoya <- function() {
   incidRoya <- getNumericProbe("incidenciaRoya","MiRoya_Dynacof")
   results <- data.frame(incidenceRoya = incidRoya, step=seq(0,length(incidRoya)-1))
   plot(results$incidenceRoya~ results$step, type="l",col="black",lwd=2,xlab="steps",ylab="incidencia roya")
 }
 #plot LAI of both simulations
 plotLAIs <- function(sim1, sim2) {
   ggplot()+
     geom_line(data=sim1$Sim[1:currentStepDynacof,],
               aes(x=Date,y=LAI),color="green")+
     labs(x="Dias")+
     geom_line(data=sim2$Sim[1:currentStepDynacof,],aes(x=Date,y=LAI),color="red")+
     theme_minimal()
 }

 #@@@@@@@@@@  Store  @@@@@@@@@@@@@@@
 
initMatrix <- function(S) {
   aMatrix <<- data.frame(step=seq(0,trunc(length(S$Meteo$Date)/7)-1))
     semanas <- S$Meteo$Date[seq(1, length(S$Meteo$Date), 7)]
     #semanas <- subset(semanas, semanas>="2009-01-01 UTC")
     semanas <- semanas[1:trunc(length(S$Meteo$Date)/7)]
     aMatrix["Fechas"] <- semanas
   return(aMatrix)
 }
 
 storeMatrix <- function(aMatrix, probeName, nameParam, valueP) { 
   vector <- getNumericProbe(probeName,"MiRoya_Dynacof")
   if(nrow(aMatrix) < length(vector)) {
     vector <- head(vector, nrow(aMatrix) - length(vector))}
   while(nrow(aMatrix) > length(vector)) {
     vector <- append(vector, 0)}
   aMatrix[paste(nameParam, "_", valueP, sep = "")] <- vector
   return(aMatrix)
 }
 
 storeMatrixLAI <- function(aMatrix, nameParam, valueP) { 
   if(nrow(aMatrix) < length(vector)) {
     LAI_MiROya <<- head(LAI_MiROya, nrow(aMatrix) - length(LAI_MiROya))}
   while(nrow(aMatrix) > length(LAI_MiROya)) {
     LAI_MiROya <<- append(LAI_MiROya, 0)}
   aMatrix[paste(nameParam, "_", valueP, sep = "")] <- LAI_MiROya
   return(aMatrix)
 }
 
 # //////////  interaction   //////////
 fertilization <- function() { 
   setNumericAttributeValue("fertilization:", "MiRoya_Dynacof", 1) 
 }
 
 desactivateFertilization <- function() { 
   setNumericAttributeValue("fertilization:", "MiRoya_Dynacof", -1) 
 }
 
 usoFungicidaSistemica <- function(val0o1 = 1) { #1=sistemico, 0=protector
   setNumericAttributeValue("usoFungicidaSistemica:", "MiRoya_Dynacof", val0o1) # val = 0 => fungicida protector ; val = 1 => fungicida sistemico 
 }
 aplicarFungicida <- function(calidad = 1) { #Quality between 0 and 1
   setNumericAttributeValue("aplicarFungicida:", "MiRoya_Dynacof", calidad) # tratarSinCapacidad. val = Qualidad
 }
 
 aplicarFungicidaSistemica <- function() { 
   setNumericAttributeValue("aplicarFungicida:", "MiRoya_Dynacof", 1) # tratarSinCapacidad. val = 1 = sistemica
 }
 aplicarFungicidaProtector <- function() { 
   setNumericAttributeValue("aplicarFungicida:", "MiRoya_Dynacof", 0) # tratarSinCapacidad. val = 0 = protector
 }
  capacitacionCafetal <- function() { 
   #ne fait rien
  } 
  capacitacionFungicidas <- function() {     # increase Quality Fungicida by 10%
    setNumericAttributeValue("increaseQFungicida:", "MiRoya_Dynacof", 10)
  } 
  
  podaCafe <- function(proportion = 100) {    # pruning X% (cf. 0-Coffee.R)
    S2$Parameters$MeanAgePruning  <<-  1      # Change minimum Age pruning at 1 year instead of 5
    S2$Parameters$LeafPruningRate <<-  proportion/100     # instead of 60% 
    S2$Parameters$WoodPruningRate <<-  proportion/200     # instead of 1/3
    S2$Parameters$D_pruning <<- S2$Meteo$DOY[currentStepDynacof] + 1
    cat('Poda_', S2$Parameters$LeafPruningRate * 100, ' %. Doy: ', S2$Meteo$DOY[currentStepDynacof], 'datePr: ', S2$Parameters$D_pruning )
  } 
  podaCafe_25 <- function() { 
    podaCafe(25)
  } 
  podaCafe_50 <- function() { 
    podaCafe(50)
  } 
  

  
 