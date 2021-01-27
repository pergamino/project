rm(list = ls())
library(DynACof)
#**************************************
setwd("C:/Users/bommel/cormas2019/R/")
#basicName <- "LaFe_2015-2020_alt_1000"
basicName <- "elsalvador_2003-2018_alt_700-1200"
#**************************************
fileNameMETEO <- paste("inputs/meteorology_", basicName, sep = "")
fileNameSIMU <- paste(getwd(), "/outputs/sim_", basicName, ".rda", sep = "")
Sys.setenv(TZ="UTC")

# to convert the Dates as "2015-01-01"
data <- read.table(paste(fileNameMETEO, ".txt", sep = ""), header = TRUE, sep = ",")
data[,1]<-as.Date(data[,3], format = "%d/%m/%Y")
fileNameMETEO <- paste(fileNameMETEO, ".txt", sep = "")
write.table(data, file=fileNameMETEO, sep = ",",col.names = TRUE, row.names = FALSE)

fileNameMETEO <- paste("meteorology_", basicName, ".txt", sep = "")
S <- DynACof(Period= as.POSIXct(c("2003-01-01", "2016-12-31")),
             Inpath = "C:/Users/Pierre Bommel/Dropbox/cormas2020/R/inputs",
             FileName = list(Site = "site.R", Meteo ="meteorology_Aquiares.txt",
                             Soil = "soil.R",Coffee = "coffeeNoPruning.R"))
S$Sim$Date <- S$Meteo$Date
save(S,file=fileNameSIMU)

#S$Sim <-subset(S$Sim, Date>="2013-01-01")
#S$Meteo <- subset(S$Meteo, Date>="2013-01-01")
sim2 <- S
for(t in (3*365):(5*365)) {
      sim2 <- dynacof_i(t, sim2, verbose = TRUE)
}

plot(S$Sim$LAI)
lines(sim2$Sim$LAI~ sim2$Meteo$Date,type="l",col="red",lwd=1,xlab="time",ylab="LAI2")


#Sim= DynACof(Period= as.POSIXct(c("1979-01-01", "1980-12-31")))
sim2 <- S
# On commence le couplage au 100e jour:
sim2$Sim$NPP_Fruit[100:length(sim2$Sim$NPP_Fruit)]= 0
sim2$Sim$Overriped_Fruit[100:length(sim2$Sim$NPP_Fruit)]= 0
sim2$Sim$CM_Fruit[100:length(sim2$Sim$NPP_Fruit)]= 0
sim2$Sim$Harvest_Fruit[100:length(sim2$Sim$NPP_Fruit)]= NA_real_

# on re-simule:

sim2 = dynacof_i(100:1000,sim2)

library(ggplot2)
# plot S et S_stepByStep
ggplot()+
  geom_point(data=S$Sim,aes(x=S$Meteo$Date,y=CM_Fruit),color="blue")+
  geom_point(data=S$Sim,aes(x=S$Meteo$Date,y=Harvest_Fruit),color="red")+
  
  geom_point(data=sim2$Sim,aes(x=sim2$Meteo$Date,y=CM_Fruit),color="purple")+
  geom_point(data=sim2$Sim,aes(x=sim2$Meteo$Date,y=Harvest_Fruit),color="orange")

