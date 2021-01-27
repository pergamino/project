source("cormas-func.R")
#ADDRESS <- "186.177.79.210"

#openVisualWorksAndCormas
openVisualWorks(GUI = F)
#r <- openCormas()

#------------------------#
#------- Test MiRoya -------#
#------------------------#
r <- openModel("MiRoya_Dynacof")
 
#Write a function to simulate the model
#--------------------------------------

simulateMiRoya <- function(duration) {
r <- setInit("init_4x9_Montecillos")
r <- setStep("stepDiario:")
r <- activateProbe("areaVerde","MiRoya")
r <- activateProbe("incidenciaRoya","MiRoya")
r <- activateProbe("incidenciaRoya_Alta","MiRoya")
r <- activateProbe("incidenciaRoya_Baja","MiRoya")
r <- activateProbe("incidenciaRoya_Baja","MiRoya")
r <- runSimu(duration)
lai <- getNumericProbe("areaVerde","MiRoya")
incidRoya <- getNumericProbe("incidenciaRoya","MiRoya")
incidRoyaAlta <- getNumericProbe("incidenciaRoya_Alta","MiRoya")
incidRoyaBaja <- getNumericProbe("incidenciaRoya_Baja","MiRoya")
res <- data.frame(lai, incidenceRoya = incidRoya, incidRoyaAlta, incidRoyaBaja, step=seq(0,length(lai)-1))
#rajouter une colonne donnant le type de modele:
#res$model <- modType
return(res)
}



#Do a simulation of the model (100 days)
#----------------------------
probes <- simulateMiRoya(100)

#plot a simulation
par(mfrow=c(1,2))
plot(probes$lai~ probes$step,type="l",col="green",lwd=1,ylim= c(0,1),xlab="time",ylab="LAI")
plot(probes$incidenceRoya~ probes$step,type="l",col="black",lwd=2)
lines(probes$incidRoyaAlta~ probes$step,type="l",col="blue",lwd=1)
lines(probes$incidRoyaBaja~ probes$step,type="l",col="red",lwd=1)

#   Envoyer une valeur ? Cormas
r <- setNumericAttributeValue("perderHojas:", "MiRoya", 50)
#   faire 7 step  (il doit bien exister un Repeat non ?)
for(i in 1:7) runOneStep()

#   Recup?rer la valeur d'un indicateur (ex: areaVerde)
area <- getNumericProbe("areaVerde","MiRoya")
#   Dessiner un nouveau graphique
step=seq(0,length(area)-1)
plot(area~ step,type="l",col="black",lwd=2, ylim=c(0,1), xlab="time",ylab="LAI")

