library(tidyr)
library(ggplot2)
library(plotly)
library(plyr)

#rm(list = ls())

fileObserv <- paste(getwd(), "/observations/", "epid_LaFe-Catuai_2017-2019.csv", sep = "")
data_epid1 <- read.csv(fileObserv,sep=";")
fileObserv <- paste(getwd(), "/observations/", "epid_LaFe-Lempira_2017-2019.csv", sep = "")
data_epid2 <- read.csv(fileObserv,sep=";")
#fileData   <- paste(getwd(), "/outputs/", "incidLaFe_pV_D-propV10%.csv", sep = "")
fileData   <- paste(getwd(), "/outputs/incid", placeName, "_", shortNameParameter, ".csv", sep = "")
data_simul <- read.csv(fileData)

# data epid
data_epid1$Modalite <- "Catuai"
data_epid2$Modalite <- "Lempira"

data_epid <- rbind(data_epid1,data_epid2)
data_epid$Date2 <- as.Date(data_epid$Date,format="%d/%m/%Y")
data_epid$sim_obs <- "Observation"
data_epid$var_AS <- data_epid$Modalite

# data simul
data_simul$Date2 <- as.Date(data_simul$Fechas,format="%Y-%m-%d")


# From wide to long
sub_data_simul <- subset(data_simul,select = c(4:ncol(data_simul)))

data_simul_long <- gather(sub_data_simul, Modalite, measurement, 
                          1:(ncol(sub_data_simul)-1), 
                          factor_key=TRUE)

data_simul_long$Incidencia <- data_simul_long$measurement*100

data_simul_long$sim_obs <- "Simulation"
data_simul_long$var_AS <- "AS"

data <- rbind(data_simul_long[,c("Date2","Modalite","Incidencia","sim_obs","var_AS")],
              data_epid[,c("Date2","Modalite","Incidencia","sim_obs","var_AS")])


# forme des points observes
shape_obs <- c(NA,1:length(unique(data_epid$Modalite)))

# identifier des simul specifiques
unique(data$Modalite) # permet de copier coller la modalite voulue

  # inscrire les modalites choisies dans le vecteur mod
mod <- c("pV_D.propV10._0.1","pV_D.propV10._0.5")

  
# graph
  ggplot(data,aes(x=Date2,y=Incidencia))+
  # simulations
  geom_line(data=subset(data,sim_obs=="Simulation"),mapping=aes(x=Date2,y=Incidencia,color=Modalite))+
  geom_line(data=subset(data,Modalite %in% mod),mapping=aes(x=Date2,y=Incidencia,color=Modalite, linetype=Modalite),size=1.5)+
  # scale_linetype_manual(values=c("twodash","longdash","solid"))+
  # observations
  geom_point(aes(shape=var_AS),size=2)+
  scale_shape_manual(values=shape_obs)+
  
  theme_bw()   +
 theme(legend.position="bottom",
       panel.grid.minor = element_blank(),
       panel.grid.major = element_blank())

  
  
# histogrammes

cdat2 <- ddply(data, c("Modalite"), summarise, 
                 mean_simul=mean(Incidencia))
  
sub_cdat <- subset(cdat2,Modalite!=c(unique(data_epid$Modalite)))

ggplot(data=sub_cdat, aes(x=Modalite, y=mean_simul,fill=Modalite)) +
  geom_bar(stat="identity") +
  theme_minimal()+
  theme(axis.text.x = element_text(angle=90),
        legend.position = "none")

