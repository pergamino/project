rm(list = ls())
source("func-MiRoya-DynaCof.R")
  #parameters
  cormasInit <- "init1P_LaFe"
  S0_sim <- "S0_sim_LaFe_2014-2020.rda"  #Name of the basic simulation without rust
  randomSeed <- 3788179 #NA or a integer between 10.000 and 9.999.999

#@@@@@@@@@  La Fe 2014-2019  @@@@@@@@@@@@@
initAndRunOneYear(S0_sim)
# After this first year, 
    # either X years can be run
    # /// Run full simulation ///
runYears( S$Meteo$year[nrow(S$Meteo)] - S$Meteo$year[1]) # By default stepSemanalDynacof: (1 week of MiRoya) is called X times 

    # or several periods can be performed to enable manipulation such as fertilization, fungicida, or pruning
    # ///  Manipulation  ///
runWeeks(1)
runMonths(1)
runYears(1)

fertilization()
capacitacionFungicidas()  # increase Quality of Fungicide application by 10%
capacitacionCafetal()     # Do nothing
aplicarFungicidaSistemica()
aplicarFungicidaProtector()
usoFungicidaSistemica(1)
aplicarFungicida(0.9)
podaCafe_25() #pruning 25%
podaCafe_50() #pruning 50%
podaCafe(70)  #pruning 70%, (pruning is performed at the next step)

desactivateFertilization() #By default, the plot is fertilized

#  /////////// END of the SIMU  ////////////////////

#--   Do a simulation plan  --
#--------------------
rm(list = ls())
source("func-MiRoya-DynaCof.R")
  nombreParametro <- NA #"quick. Set NA for repeating stochastic simulations"
  shortNameParameter <- "no" 
  placeName <- "LaFe"
  cormasInit <- "init1Parcel_LaFe"
  randomSeed <- NA #3788179  #NA
  S0_sim <- "S0_sim_LaFe_2014-2020.rda"
  
  S0_file <- paste(getwd(), "/outputs/", S0_sim, sep = "")
  load(S0_file)
  S0$Sim$Date <- S0$Meteo$Date
  S=S0
  
  resultsRoya <- initMatrix(S)
  resultsLAI <- resultsRoya
  resultsSitios <- resultsRoya
  #autoCafPorCm <- resultsRoya
  
#  --- LOOP ---
  numSimu <- 0
  #for (param in 1:15){     #for(param in c(2,5,10,50,100,200,1000))  #for (param in sample(1000:100000, 20, replace=FALSE))  for (param in seq(from=1, to=2, by=0.05))
  for (param in 1:50){
    initAndRunOneYear(S0_sim)
    desactivateFertilization()
    parametro <- param
    if(!is.na(nombreParametro)) {
      r <- setNumericAttributeValue((paste(nombreParametro, ":", sep = "")), "MiRoya_Dynacof", parametro)
      cat("     ******** Parametro ", nombreParametro, " = ", parametro, " ******* \n")}
    #   run ONE SIMU
    runYears(S$Meteo$year[nrow(S$Meteo)] - S$Meteo$year[1]) #13
    
    resultsRoya <- storeMatrix(resultsRoya, "incidenciaRoya", shortNameParameter, parametro)
    resultsLAI <-  storeMatrixLAI(resultsLAI, shortNameParameter, parametro)
    resultsSitios <-  storeMatrix(resultsSitios, "porHoja_maxSitios", shortNameParameter, parametro)
    #autoCafPorCm <-  storeMatrix(autoCafPorCm, "infeccion_autoCafetoPorCm2", shortNameParameter, parametro)
    numSimu <- numSimu + 1
    cat("     ******** Simulation ", numSimu, " ended ******* \n")
  }  #  --- End of the loop
  write.csv(resultsRoya,file=paste(getwd(), "/outputs/incid", placeName, "_", shortNameParameter, ".csv", sep = ""))
  write.csv(resultsLAI,file=paste(getwd(), "/outputs/LAI-", placeName, "_", shortNameParameter, ".csv", sep = ""))
  write.csv(resultsSitios,file=paste(getwd(), "/outputs/Sitios-", placeName, "_", shortNameParameter, ".csv", sep = ""))
 # write.csv(autoCafPorCm,file=paste(getwd(), "/outputs/AutoInfecPorCm-", placeName, "_", shortNameParameter, ".csv", sep = ""))
  
  #End of the simulation plan
  #--------------------  
  
  
 # ***  Graphics ***  see Graphics.R