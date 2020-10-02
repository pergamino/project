library(ggplot2)

# datos_epidemio0 <- read.csv("D:/Mes Donnees/natacha/costa_rica/procagica/ipsim/datos_monitoreo/guatemala/incidencia-alt_media_guatemala_2019_suscept.csv")
# df_meteo <- read.csv("D:/Mes Donnees/natacha/costa_rica/procagica/ipsim/datos_monitoreo/guatemala/clima_alt_media_guatemala.csv")


# datos_epidemio0 <- read.csv("D:/Mes Donnees/natacha/costa_rica/procagica/ipsim/datos_monitoreo/el_salvador/media/el_salvador_2017_alt_media_suscept.csv")
# df_meteo <- read.csv("D:/Mes Donnees/natacha/costa_rica/procagica/ipsim/datos_monitoreo/el_salvador/media/clim_el_salvador_alt_media.csv")

datos_epidemio0 <- read.csv("D:/Mes Donnees/natacha/costa_rica/procagica/ipsim/datos_monitoreo/honduras/media/honduras_2017_alt_media_suscept.csv")
df_meteo <- read.csv("D:/Mes Donnees/natacha/costa_rica/procagica/ipsim/datos_monitoreo/honduras/media/clim_honduras_alt_media.csv")

# datos_epidemio0 <- read.csv("D:/Mes Donnees/natacha/costa_rica/procagica/ipsim/datos_monitoreo/honduras/2019_calixto/honduras_2019_epid_alt_media_suscept1.csv")
# df_meteo <- read.csv("D:/Mes Donnees/natacha/costa_rica/procagica/ipsim/datos_monitoreo/honduras/2019_calixto/clim_honduras_2019.csv")

# datos_epidemio0 <- read.csv("D:/Mes Donnees/natacha/costa_rica/procagica/quisqueya/QUISQUEYA/INCIDENCIA PLACETAS.csv")
# df_meteo <- read.csv("D:/Mes Donnees/natacha/costa_rica/procagica/quisqueya/QUISQUEYA/SAJOMA 2019 POR DIA_.csv")

# datos_epidemio0 <- read.csv("D:/Mes Donnees/natacha/costa_rica/procagica/ipsim/evaluation/data_eval - ALL/jacques/atima/epid_1995-0Cu_N.csv")
# df_meteo <- read.csv("D:/Mes Donnees/natacha/costa_rica/procagica/ipsim/evaluation/data_eval - ALL/jacques/atima/clim_POWER_SinglePoint_Daily_atima.csv")

# datos_epidemio0 <- read.csv("D:/Mes Donnees/natacha/costa_rica/procagica/ipsim/datos_monitoreo/guatemala/epid_guatemala_2018.csv")
# df_meteo <- read.csv("D:/Mes Donnees/natacha/costa_rica/procagica/ipsim/datos_monitoreo/guatemala/clim_guatemala_2018.csv")


# datos_epidemio0 <- read.csv("D:/Mes Donnees/natacha/costa_rica/procagica/ipsim/datos_monitoreo/honduras/cristian/la_fe/epid_la_fe_catuai.csv")
# df_meteo <- read.csv("D:/Mes Donnees/natacha/costa_rica/procagica/ipsim/datos_monitoreo/honduras/cristian/la_fe/clim_la_fe.csv")


# datos_epidemio0 <- read.csv("D:/Mes Donnees/natacha/costa_rica/procagica/ipsim/datos_monitoreo/nicaragua/2020/epid_monitoreo el cairo.csv")
# df_meteo <- read.csv("D:/Mes Donnees/natacha/costa_rica/procagica/ipsim/datos_monitoreo/nicaragua/2020/clim_ElCairo.csv")



# date_floracion <- as.Date("01/04/2017",format="%d/%m/%Y")
# date_ini_cosecha <- as.Date("01/10/2017",format="%d/%m/%Y")
# date_fin_cosecha <- as.Date("01/01/2018",format="%d/%m/%Y")

date_floracion <- as.Date("01/04/2017",format="%d/%m/%Y")
date_ini_cosecha <- as.Date("01/08/2017",format="%d/%m/%Y")
date_fin_cosecha <- as.Date("01/01/2018",format="%d/%m/%Y")

carga_fruct <- 2 # 1: alta, 2: media, 3: baja
variedad <- 1 # 1: susceptible, 2: mod. suscpet, 3: resistente
# quimicos <- 2 # 1: Si, 2: No
quimicos <- NA # c(1,1,1,2,2,2,2,2,2,2,2,2)
nutri_adecuada <- 1 # 1: Si, 2: No
sombra <- 3 # 1: alta, 2: media, 3: baja o pleno sol
poda <- c(4,4,1,4,4,4,4,4,4,1,1,1)

