
# 1. Planificacion anual
rm(list = ls())
# myData0 <- read.csv("D:/Mes Donnees/natacha/costa_rica/procagica/app_opti_edwin/datos_csv/essais/Nicaragua2021.csv")
myData0 <- read.csv("D:/Mes Donnees/natacha/costa_rica/procagica/app_opti_edwin/datos_csv/essais/0-datos_hist_nicaragua.csv")
num_detect=1


df_Np <- data.frame(FACTOR=comb_var$FACTOR,Np=5000)

progress=FALSE
TM.F=NULL
n=30

num_plantas <- 30
TMF <- 10


metrica <- "Tamano_2017"


# 2. num parcelas mes en curso
rm(list = ls())

df_planif <- read.csv("D:/Mes Donnees/natacha/costa_rica/procagica/app_opti_edwin/datos_csv/essais/3-planificacion_anual_metricas2017-2018-2019.csv")
df_planification <- df_planif
data2 <- read.csv("D:/Mes Donnees/natacha/costa_rica/procagica/app_opti_edwin/datos_csv/essais/2-monit_actual_nicaragua_03-2021.csv")
myData0 <- data2
  
num_detect <- unique(df_planif$num_detectabilidad)
progress=FALSE

# !!!! il faut prendre le unique factor

# sub_df_planif <- subset(df_planif,select=c("FACTOR","Num_parcelas"))
# 
# df_Np <- merge(comb_var,sub_df_planif,by="FACTOR",all.y = F)

df_Np <- ddply(df_planif, c("FACTOR"), summarise, 
               Np=mean(Np))

num_plantas <- unique(df_planif$num_plantas)
TMF <- unique(df_planif$tamano_min_parcelas)

analyse_vgam2 <- vgam.salida_ajust_all
metrica <- "Tamano_promedio" #"Tamano_2019"  # colnames(df_planif[grep("Tamano",colnames(df_planif))])
