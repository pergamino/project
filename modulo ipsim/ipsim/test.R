# Test

source("0.1-archivo_epidemio.R")
source("0.2-moulinette_inoculum.R")
source("1-moulinette_meteo.R")
source("2-ipsim.R")
source("3-pronostico.R")
source("4.1-plot_pronostico.R")
source("4.2-plot_moulinette_meteo.R")
source("4.3-infoBox_alerta.R")

df_epid <- read.csv("honduras_2017_alt_media_suscept.csv")
df_meteo <- read.csv("clim_honduras_alt_media.csv")

df_epid_new <- fichier_epid_new(df_epid)

df_meteo <- read.csv("clim_honduras_alt_media.csv", header = T)

df_moulinette_meteo <- moulinette_meteo(df_meteo, df_epid_new)

df_moulinette_inoc <- moulinette_inoc(df_epid_new)

Input_fecha_flo <- as.Date("2017-04-01")
  
Input_fecha_ini_cosecha <- as.Date("2017-10-01")

Input_fecha_fin_cosecha <- as.Date("2018-01-01")

Input_carga_fruct <- 3

Input_sombra <- 3

Input_var <- 1

Input_quimicos <- c(1)

Input_nutri_adequada <- 1

output_moulinette <- df_moulinette_meteo
output_incidencia <- df_moulinette_inoc
carga_fruct <- Input_carga_fruct
variedad <- Input_var
quimicos <- Input_quimicos
nutri_adecuada <- Input_nutri_adequada
date_floracion <- Input_fecha_flo
date_ini_cosecha <- Input_fecha_ini_cosecha
date_fin_cosecha <- Input_fecha_fin_cosecha
sombra <- Input_sombra

df_ipsim <- func_ipsim(
  df_moulinette_meteo,
  df_moulinette_inoc,
  Input_carga_fruct,
  Input_var,
  Input_quimicos,
  Input_nutri_adequada,
  Input_fecha_flo,
  Input_fecha_ini_cosecha,
  Input_fecha_fin_cosecha,
  Input_sombra
)

df_prono <- func_prono(df_ipsim,
                        df_epid_new,
                        Input_var)

func_plot(
  df_prono,
  df_epid_new,
  Input_fecha_flo,
  Input_fecha_ini_cosecha,
  Input_fecha_fin_cosecha
)

df_data_prono <- df_prono
datos_epidemio <- df_epid_new
date_floracion <- Input_fecha_flo
date_ini_cosecha <- Input_fecha_ini_cosecha
date_fin_cosecha <- Input_fecha_fin_cosecha

df_infoBox <-func_infoBox(df_prono,
                          df_epid_new,
                          Input_fecha_flo,
                          Input_fecha_ini_cosecha,
                          Input_fecha_fin_cosecha)
