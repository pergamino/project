# **  Convert a meteo file for Dynacof  **
rm(list = ls())
library(lubridate)
Sys.setenv(TZ="UTC")
fileNameMETEO <- "meteorology_XX_alt_XX_2013-2015.txt"

meteo <- read.table(paste(getwd(),"/inputs/",fileNameMETEO, sep = ""), header = TRUE, sep = ",", dec=".")
for (k in 2:length(meteo)){
  meteo[,k] <- as.numeric(meteo[,k])
}
#meteo <- meteo[,-12]  #to remove the last column X
# By default, save the Dates as "2015-01-01" (in case you get a date format error)
write.table(meteo, file=paste(getwd(),"/inputs/",fileNameMETEO, sep = ""), sep = ",",col.names = TRUE, row.names = FALSE)

