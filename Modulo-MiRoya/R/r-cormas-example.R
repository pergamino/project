source("cormas-func.R")
#ADDRESS <- "186.177.79.210"

#openVisualWorksAndCormas
openViwualWorks(GUI = T)
r <- openCormas()

#------------------------#
#---- Test ECEC Model----#
#------------------------#
r <- openModel("ECEC")
r <- setInit("homogeneousEnv")
r <- setStep("step:")
r <- activateProbe("restrainedSize","ECEC")
r <- activateProbe("unrestrainedSize","ECEC")
r <- runSimu()
res <- getNumericProbe("restrainedSize","ECEC")
unres <- getNumericProbe("unrestrainedSize","ECEC")
plot(res,unres, type="l")

#------------------------#
#------- Test SIS -------#
#------------------------#
r <- openModel("SIS")

#Write a function to simulate the model
#--------------------------------------

simulateSIS <- function(modType = "noSpaceNoMemory", period = 5) {
r <- setNumericAttributeValue("infectiousPeriod", "Host",period)
r <- setStep("step:")
if (modType == "space") {r <- setStep("stepSpatial:")}
if (modType == "noSpace") {r <- setStep("stepMeanInfPeriod:")}
	r <- setInit("initNoGui")
	r <- activateProbe("nI","SIS")
	r <- activateProbe("pI","SIS")
	r <- activateProbe("nS","SIS")
	r <- activateProbe("pS","SIS")
	r <- runSimu(duration = 50)
	nI <- getNumericProbe("nI","SIS")
	pI <- getNumericProbe("pI","SIS")
	nS <- getNumericProbe("nS","SIS")
	pS <- getNumericProbe("pS","SIS")
res <- data.frame(ni=nI, ns = nS, pi = pI, ps= pS,step=seq(0,length(pI)-1))
res$model <- modType
return(res)
}



#Do a simulaiton of the model
#----------------------------
res <- simulateSIS(period = 100)

#plot a simulation
plot(res$pi~ res$step,type="l",col="red",lwd=1,ylim=c(0,1),xlab="time",ylab="hosts")
lines(res$ni~ res$step,type="l",col="red",lwd=2)
lines(res$ps~ res$step,type="l",col="green",lwd=1,ylim=c(0,1))
lines(res$ns~ res$step,type="l",col="green",lwd=2)


#Do a simulation plan
#--------------------
res <- simulateSIS("particles")
res$model <- "aggregated"
res <- select(res,step,model,pi,ps)
plot(res$pi~res$step,type="l",col="red",lwd=1,ylim=c(0,1),xlab="time",ylab="hosts")
lines(res$ps~res$step,type="l",col="green",lwd=1,ylim=c(0,1))

totalres <- res %>%  rename(I = pi, S =ps) %>%
					gather("indicator","value",3:4)

for (mod in c("space","noSpace")) {
for (rep in 1:30){
 res <- simulateSIS(mod)
lines(res$ni~res$step,type="l",col="red",lwd=0.2)
lines(res$ns~res$step,type="l",col="green",lwd=0.2)
 res <- select(res,step,model,ni,ns) %>% 
		 rename(I = ni, S =ns) %>% 
			gather("indicator","value",3:4)
totalres <- union(totalres, res)
print(paste("rep", rep, "of model", mod))
}
}

totalres$indicator <- as.factor(totalres$indicator)
totalres$model <- as.factor(totalres$model)
totalres$stepf <- as.factor(totalres$step)
totalres$model <- factor(totalres$model,
	c("aggregated",
		"noSpace",
		"space"))

write.table(totalres, "totalres.csv")

#Plot results of simulation plan
#-------------------------------

#time series
#------------
totalres %>% group_by(model,stepf,indicator,step) %>% 
		summarise(av=median(value),
	min=quantile(value,0.1),
	max=quantile(value,0.9)) %>%
	 ggplot(aes(x= step,linetype=model,color=indicator)) +
	geom_line(aes(y=av),size=1) + geom_ribbon(aes(ymin=min, ymax=max,fill=model), alpha=0.1,size=0.3) + 
	ylab("Proportion of the hosts population") + ggsave("ts2.png",width=14,height=7)

#Phases?
#------------

#Distributions finales?
#------------





