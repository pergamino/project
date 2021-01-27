source("cormas-func.R")
#ADDRESS <- "186.177.79.210"

#openVisualWorksAndCormas
openViwualWorks(GUI = F)
r <- openCormas()

#------------------------#
#------- Test SIS -------#
#------------------------#
r <- openModel("SIS")
 
#Write a function to simulate the model
#--------------------------------------

simulateSIS <- function(modType, period) {
#r <- setNumericAttributeValue("infectiousPeriod", "Host",period)
r <- setStep("e_InfectiousPeriod:")
#if (modType == "space") {r <- setStep("stepSpatial:")}
#if (modType == "noSpace") {r <- setStep("stepMeanInfPeriod:")}
r <- setInit("initNoGui")
r <- activateProbe("aggregINFECTED","SIS")
r <- activateProbe("aggregSUSCEP","SIS")
r <- activateProbe("indivINFECTED","SIS")
r <- activateProbe("indivSUSCEPT","SIS")
r <- runSimu(duration = period)
nI <- getNumericProbe("aggregINFECTED","SIS")
pI <- getNumericProbe("indivINFECTED","SIS")
nS <- getNumericProbe("aggregSUSCEP","SIS")
pS <- getNumericProbe("indivSUSCEPT","SIS")
results <- data.frame(aggI=nI, aggS = nS, agentI = pI, agentS= pS,step=seq(0,length(pI)-1))
#rajouter une colonne donnant le type de modele
#res$model <- modType
return(results)
}

#Do a simulation of the model
#----------------------------
probes <- simulateSIS(modType = "noSpaceNoMemory", period = 150)

#plot the simulation
plot(probes$agentI~ probes$step,type="l",col="red",lwd=1,ylim=c(0,1),xlab="time",ylab="hosts")
lines(probes$aggI~ probes$step,type="l",col="red",lwd=2)
lines(probes$agentS~ probes$step,type="l",col="green",lwd=1,ylim=c(0,1))
lines(probes$aggS~ probes$step,type="l",col="green",lwd=2)





