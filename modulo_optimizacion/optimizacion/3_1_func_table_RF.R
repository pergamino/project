# Creation de la nouvelle table pour le calcul du Tamano de Monitoreo

func_table_RF <- function (importance_sorted,
                           myData0,
                           n){
  
  # importance_sorted vient de 1_analyse
  # myData0 vient des donnees chargees: df_epid()

library(stringr)

# Calculs pour Variedad 
# on fait les calculs seulement si la variedad est selectionnee

if(importance_sorted$var_names[1]=="Variedad" | importance_sorted$var_names[2]=="Variedad"){
  
  aa <- as.data.frame(table(myData0$Variedad)>=10)
  names(aa) <- "effectif"
  aa$names <- row.names(aa)
  table_RF <- subset(myData0,Variedad %in% aa$names[aa$effectif=="TRUE"])
} else {
  table_RF <- myData0
}



# categories pour les varietes (groupes de variances) demander a fabienne et sylvain
# mod_gls <- gls(Incidencia~Variedad,data=myData0)

  table_RF$cat_alt <- ifelse(table_RF$Altura<=700,"Baja",
                             ifelse(table_RF$Altura<=1100,"Media",
                                    ifelse(table_RF$Altura<=1500,"Alta","Muy Alta")))

name1 <- ifelse(importance_sorted$var_names[1]=="Altura","cat_alt",
                ifelse(importance_sorted$var_names[1]=="Variedad",
                       "cat_Variedad",importance_sorted$var_names[1]))

name2 <- ifelse(importance_sorted$var_names[2]=="Altura","cat_alt",
                ifelse(importance_sorted$var_names[2]=="Variedad",
                       "cat_Variedad",importance_sorted$var_names[2]))

sub <- subset(table_RF,select=c(name1,name2))

# Etape 3: combinacion de categorias
abrev1 <- str_sub(importance_sorted$var_names[1],1,1)
abrev2 <- str_sub(importance_sorted$var_names[2],1,1)

table_RF$comb_var <- paste(abrev1,".",sub[,1],"_",abrev2,".",sub[,2],sep="")

# umbral de detectabilidad
table_RF$n <- n 

return(table_RF)

}