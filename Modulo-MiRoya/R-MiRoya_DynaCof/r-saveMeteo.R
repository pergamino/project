# **  Convert a meteo file for Dynacof  **
rm(list = ls())

shortFileName <- "meteo_Aquiares - 2009-2016.txt"

aFile <- paste(getwd(), "/inputs/", shortFileName, sep = "")
meteo <- read.table(aFile, header= TRUE, sep=",")

date2 <- as.Date(meteo$Date, format="%d/%m/%Y")
date3 <- as.Date(meteo$Date, format="%Y-%m-%d")
#meteo$Date <- as.Date(meteo$Date, format="%Y-%m-%d")
#meteo$Date <- as.Date(meteo$Date, format="%d/%m/%Y")
#meteo <- subset(meteo,Date>="2011-01-01")
# #copie colle de l'annee 2016 pour 2018
#   sub <- subset(meteo, Date>="2016-01-01" & Date<"2017-01-01")
#   sub$Date2 <- sub$Date + (2 * 365)
#   sub$Date <- sub$Date2
#   sub2 <- subset(sub,select=-(Date2))
#     # pour selectionner des lignes spécifiques
#     #sub2 <- subset(meteo,year %in% c(2011,2013,2015))
#   library(lubridate)
#   library(magrittr)
#   sub2 <-sub2[-1,]
#   #sub2$Date <- ymd(sub2$Date)
#   sub2$year <- year(sub2$Date)
#   sub2$DOY <- yday(sub2$Date)
#   meteo <- rbind(meteo,sub2)
write.csv(meteo, file = aFile, row.names = FALSE)
#write.csv(meteo, file = "meteorology_LaFe_2014-2020_alt_1000.csv", row.names = FALSE)
