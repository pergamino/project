rm(list = ls())
source("C:/Users/bommel/cormas2019/R/func-MiRoya-DynaCof LAI.R")

#@@@@@@@@@  AQUIARES 2003-2016  @@@@@@@@@@@@@

load("C:/Users/bommel/cormas2019/R/Outputs/sim_Aquiares.rda")
S$Sim$Date <- S$Meteo$Date
S$Sim <-subset(S$Sim, Date>="2003-01-01")
S$Meteo <- subset(S$Meteo, Date>="2003-01-01")

setDynacof(S)  #set S2
#run independently 10 weeks
initializeSimulations("init1ParcelAquiares", FALSE, 1, stepName="stepSemanalDynacof:")
#initializeSimulations("init1ParcelAquiares", FALSE, 10, stepName="stepSemanalDynacofConTratamiento:")

#setNumericAttributeValue("calidadFungicida:", "MiRoya_Dynacof", 0.5)
runYears(2)

plotLAIs(S, S2)

plotRoya()

#  ********** OLD !!!
rm(list = ls())

load("C:/Users/Pierre BOMMEL/Google Drive/vw7.6nc/cormas/R/DynACof/sim_Aquiares.rda")
S2 <- S
source("C:/Users/Pierre BOMMEL/Google Drive/vw7.6nc/cormas/R/cormas-func.R")
library(future)
library(ggplot2)

# detach("package:DynACof", unload = TRUE)
# install.packages("C:/Users/Pierre BOMMEL/Google Drive/vw7.6nc/cormas/R/DynACof_1.2.0.tar.gz", repos = NULL, type="source")
# pas obligé de faire un install
library("DynACof")
Sys.setenv(TZ="UTC")

# Making a regular simulation using example data:
#  S= DynACof(Period= as.POSIXct(c("1979-01-01", "1980-01-01")))
# S= DynACof(Period = as.POSIXct(c("1979-01-01", "1980-12-31")),
#            Inpath = "MiRoya-Dynacof/DynACof-master/inputs", WriteIt = T, Outpath = "output",
#            Simulation_Name = "Test1",
#            FileName = list(Site = "site.R", Meteo ="meteorologyAquiares.txt",
#                            Soil = "soil.R",Coffee = "coffee.R", Tree = NULL))
#  save(S, file= "simuDynacof.rda")
currentStepMiRoya <- 14
currentStepDynacof <- currentStepMiRoya * 7

#@@@@@@@@@@@ PLOTS @@@@@@@@@@@@@@@@@@@@@@@@@@@@
#plot roya of a simulation
plotRoya <- function() {
  incidRoya <- getNumericProbe("incidenciaRoya","MiRoya_Dynacof")
  # incidRoyaAlta <- getNumericProbe("incidenciaRoya_Alta","MiRoya_Dynacof")
  # incidRoyaBaja <- getNumericProbe("incidenciaRoya_Baja","MiRoya_Dynacof")
  results <- data.frame(incidenceRoya = incidRoya, step=seq(0,length(incidRoya)-1))
  r <- plot(results$incidenceRoya~ results$step, type="l",col="black",lwd=2,xlab="steps",ylab="incidencia roya")
  # r <- lines(results$incidRoyaAlta~ results$step,type="l",col="blue",lwd=2)
  # r <- lines(results$incidRoyaBaja~ results$step,type="l",col="red",lwd=2)
}
#plot LAI of both simulations
plotLAIs <- function(sim1, sim2) {
  ggplot()+
    geom_line(data=sim1$Sim[1:currentStepDynacof,],
              aes(x=c(1:currentStepDynacof),y=LAI),color="green")+
    labs(x="Dias")+
    geom_line(data=sim2$Sim[1:currentStepDynacof,],aes(x=1:currentStepDynacof,y=LAI),color="red")+
    theme_minimal()
  }
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@


#   ************ RUN 100 STEPS *****************
#openVisualWorksAndCormas
openVisualWorks(GUI = F)
#r <- openCormas()

#------------------------#
#------- Test MiRoya -------#
#------------------------#
openModel("MiRoya_Dynacof")

setInit("initUnaParcelaAquiares")
setStep("stepSemanalDynacof:")
#activateProbe("areaVerde","MiRoya_Dynacof")
r <- runSimu(currentStepMiRoya)
#   On rajoute 1 semaine pour ?tre raccord entre les 2 mod?les
r <- setNumericAttributeValue("nuevoLAI:", "MiRoya_Dynacof", S2$Sim$LAI[currentStepDynacof])
currentStepMiRoya <<- currentStepMiRoya + 1
f <-runOneStep()
#   Run 1 week in Dynacof
for(t in currentStepDynacof:(currentStepDynacof+7)) {
  S2 <- dynacof_i(t,S2)
}
currentStepDynacof <<- currentStepDynacof+7
#  *********************************************

# ********* run one COMPLETE cycle, in Cormas then in Dynacof ***********
 runCompleteCycle <- function(stepInit, sim2) {

  #   Changer nuevoLAI ? MiRoya (? t = currentStepMiRoya)
  r <- setNumericAttributeValue("nuevoLAI:", "MiRoya_Dynacof", sim2$Sim$LAI[stepInit])
  #   run 1 stepSemanal dans Cormas  (evolution de la rouille)
  currentStepMiRoya <<- currentStepMiRoya + 1
  f %<-% runOneStep()  #%<-% to turn the assignment into a future assignment (implicit futures).
  futureOf(f)
  while (!resolved(f[[1]])) { cat("...")}
  # Recup?rer la valeur de areaVerdeLAI
  alloc_MiROya <<- getNumericProbe("allocRoyaPorLAIcafeto_dynacof","MiRoya_Dynacof")
  while (length(alloc_MiROya) - 1 < currentStepMiRoya) {
    cat("...")
    alloc_MiROya <<- getNumericProbe("allocRoyaPorLAIcafeto_dynacof","MiRoya_Dynacof")
   }

  #   Run 1 week in Dynacof
  cat(" alloc = ", alloc_MiROya[currentStepMiRoya], " - ", "\n")
  for(t in currentStepDynacof:(currentStepDynacof+7)) {
    sim2$Sim$allocRoya[t] <- alloc_MiROya[currentStepMiRoya]
    sim2 <- dynacof_i(t,sim2,verbose = FALSE)
    }
  currentStepDynacof <<- currentStepDynacof+7
  return(sim2)
 }
# *****************************************************

# *****************************************************
 # 12 mois
 for (j in 1:12) {
   # 1 mois
    for (t in 1:4) {
      S2 <- runCompleteCycle(currentStepDynacof, S2)
      }


 }
 plotLAIs(S, S2)



   plotRoya()


   for (t in 1:50) {
     S2 <- dynacof_i(currentStepDynacof, S2)
     currentStepDynacof <<- currentStepDynacof+7
   }

  hojasMuertasPorRoya <- getNumericProbe("hojasMuertasPorRoya","MiRoya_Dynacof")
  hojasMuertasSinRoya <- getNumericProbe("hojasMuertasSinRoya","MiRoya_Dynacof")
  results <- data.frame(hojasMuertasPorRoya, hojasMuertasSinRoya, step=seq(0,length(hojasMuertasPorRoya)-1))
  r <- plot(results$hojasMuertasPorRoya~ results$step, type="l", ylim=c(0,100), col="orange",lwd=2,xlab="steps",ylab="muertas por roya")
  r <- lines(results$hojasMuertasSinRoya~ results$step,type="l",col="green",lwd=2)

  S$Sim$temps <- c(S$Sim$Cycle[1]:currentStepDynacof)


#  plot(S$Sim[1:currentStepDynacof,]$LAI,type="l",col="green",xlim=c(1,currentStepDynacof), lwd=1,xlab="time",ylab="LAI")
#  lines(S2$Sim[1:currentStepDynacof,]$LAI,type="l",col="red",lwd=1,xlab="time",ylab="LAI2")
