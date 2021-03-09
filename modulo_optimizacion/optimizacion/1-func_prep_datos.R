# Creation de la nouvelle table pour le calcul du Tamano de Monitoreo

func_prep_datos <- function (myData0,
                             num_detect){


  myData0$cat_alt <- ifelse(myData0$Altura<=700,"Baja",
                            ifelse(myData0$Altura<=1100,"Media",
                                   ifelse(myData0$Altura<=1500,"Alta","Muy Alta")))
  
  myData0$FACTOR <- paste("Variedad",myData0$Cat_Variedad," - Altura",myData0$cat_alt)
  
  # umbral de detectabilidad
  myData0$num_detect <- num_detect 


return(myData0)

}