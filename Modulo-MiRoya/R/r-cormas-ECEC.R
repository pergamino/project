source("cormas-func.R")
#ADDRESS <- "186.177.79.210"

#openVisualWorksAndCormas
openViwualWorks(GUI = T)
r <- openCormas()

#------------------------#
#---- Test ECEC Model----#
#------------------------#
openModel("ECEC")
setInit("homogeneousEnv")
setStep("step:")
activateProbe("restrainedSize","ECEC")
activateProbe("unrestrainedSize","ECEC")
runSimu(100)

for(t in 1:100) {
  runOneStep()
}

res <- getNumericProbe("restrainedSize","ECEC")
unres <- getNumericProbe("unrestrainedSize","ECEC")

results <- data.frame(unRestrained=unres, restrained = res, step=seq(0,length(res)-1))
#plot a simulation
plot(results$unRestrained~ results$step, type="l",col="red",lwd=2,xlab="steps",ylab="Foragers")
lines(results$restrained~ results$step,type="l",col="blue",lwd=2)
