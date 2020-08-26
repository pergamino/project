# Analyse Random Forest

func_analyse_RF <- function(myData0){

library(randomForest)

  # ajouter les categories : superficie, Edad, categoria_prod, frecuencia_fungicidas, densidad_siembra, Sombra  
myData <- subset(myData0,select=c(Altura, Variedad, Regiones, Year,Incidencia))

myVarName="Incidencia"
  rfModel <- randomForest(Incidencia~., 
                        data = myData,
                        ntree=500,
                        importance = T,
                        do.trace=F)

# selection des 2 variables les plus importantes
var_importance <- as.data.frame(rfModel$importance)

importance_sorted <- var_importance[with(var_importance, order(-IncNodePurity)), ] # descending rel.inf

importance_sorted$var_names <- row.names(importance_sorted)

return(importance_sorted)

}

