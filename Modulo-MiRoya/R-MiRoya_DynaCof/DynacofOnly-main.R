rm(list = ls())
library(DynACof)
#**************************************
basicName <- "Aquiares"
basicName <- "LaFe_2014-2020"
#**************************************
fileNameMETEO <- paste("meteorology_", basicName, sep = "")
fileNameSIMU <- paste(getwd(), "/outputs/sim_", basicName, ".rda", sep = "")
Sys.setenv(TZ="UTC")

# ** to convert the Dates as "2015-01-01" (in case you get a date format error)
data <- read.table(paste(getwd(),"/inputs/",fileNameMETEO, ".csv", sep = ""), header = TRUE, sep = ";")
data[,3]<-as.Date(data[,3], format = "%d/%m/%Y")
write.table(data, file=paste(getwd(),"/inputs/",fileNameMETEO, ".txt", sep = ""), sep = ",",col.names = TRUE, row.names = FALSE)

fileNameMETEO <- paste("meteorology_", basicName, ".txt", sep = "")
sim <- DynACof(Period= as.POSIXct(c("2013-01-01", "2016-12-31")),
             Inpath = "inputs",
             FileName = list(Site = "site.R", Meteo =fileNameMETEO,
                             Soil = "soil.R",Coffee = "coffeeNoPruning.R"))

sim$Sim$Date <- sim$Meteo$Date
save(sim,file=fileNameSIMU)


plot(sim$Sim$LAI~sim$Meteo$Date,type="l",col="green",lwd=1,xlab="anios",ylab="LAI")

# on re-simule:

sim2 = dynacof_i(100:1000,sim2)

library(ggplot2)
# plot S et S_stepByStep
ggplot()+
  geom_point(data=sim$Sim,aes(x=sim$Meteo$Date,y=CM_Fruit),color="blue")+
  geom_point(data=sim$Sim,aes(x=sim$Meteo$Date,y=Harvest_Fruit),color="red")+
  
  geom_point(data=sim2$Sim,aes(x=sim2$Meteo$Date,y=CM_Fruit),color="purple")+
  geom_point(data=sim2$Sim,aes(x=sim2$Meteo$Date,y=Harvest_Fruit),color="orange")

