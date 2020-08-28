# fichier <- c("ElSalvador_new2","Honduras","Panama","RDominicana")
# num <- 1
# myData00 <- read.csv(paste0("D:/Mes Donnees/natacha/costa_rica/procagica/edwin/datos_csv/",fichier[num],".csv"),h=T,sep=",")
# 
# ano=2019

myData0 <- read.csv("D:/Mes Donnees/natacha/costa_rica/procagica/app_opti_edwin/datos_csv/nicaragua/Nicaragua2019.csv")
# myData0 <- read.csv("D:/Mes Donnees/natacha/costa_rica/procagica/app_opti_edwin/datos_csv/honduras/1-Honduras_a_realizar.csv")

n=30

V1 <- c("Altura", "Variedad", "Regiones", "Year")
V2 <- c("Altura", "Variedad", "Regiones", "Year")
importance_sorted <- data.frame(var_names=c(V1[1],V2[2]))


df_Np <- data.frame(FACTOR=comb_var$FACTOR,Np=5000)

Pro=0.01
n=30
agregacion=0.01
TM.F=NULL
progress=FALSE

data <- table_RF


# 1er round: calculs sur les annees de reference
# myData0 <- subset(myData00,!(Year %in% ano))
load("tableRF_ref.rdata")
tableRF <- table_RF
rm(table_RF)

# 2eme round : calculs sur l'annee en cours
# myData0 <- subset(myData00,Year==ano)
load("importance_sorted.rdata")

load("tableRF2.rdata")
tableRF2 <- table_RF
rm(table_RF)

load("df_Np.rdata")

data <- tableRF2
Pro=0.01
n=30
agregacion=0.01
TM.F=NULL
num_cat1=500
num_cat2=500
num_cat3=500
num_cat4=500
num_cat5=500
num_cat6=500
num_cat7=500
num_cat8=500
num_cat9=500
num_cat10=500
progress=FALSE

load("analyse_vgam.rdata")
analyse_vgam <- vgam.salida_ajust
load("analyse_vgam2.rdata")
analyse_vgam2 <- vgam.salida_ajust
load("analyse_vgam3.rdata")
analyse_vgam3 <- vgam.salida_ajust_proj

