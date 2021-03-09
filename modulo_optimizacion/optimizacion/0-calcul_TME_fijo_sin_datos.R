# Calcul du tamano de monitoreo sin datos

TME.fijo<-function(Pro, n, Inciden, ee.Inciden, agrega, TM.F, umbral=TRUE) {
###############################
###########################################################
#####           Parametros del modelo             #########
###########################################################
###########################################################
Z<-qnorm(1-Pro)
mu.p<-Inciden
ee.p<-ee.Inciden
					      				###coeficiente de correlaci?n intraclase
CV<-as.vector(ee.p/mu.p)							      				###Coeficiente de variaci?n del error
Pro<-Pro

n<-n								                        			###Total de plantas evaluadas x parcela
###########################################################
#########        Estimaci?n de N       ####################
###########################################################

if(isTRUE(umbral)) {
        if(is.null(agrega)) {
        NN <-  (1-mu.p)/(n*mu.p*CV^2)                 			##  Binomial
        NB<-	 'N.CV.B'
                            }  else {
                            Q<-agrega/(1+agrega)
                            NN <-  ((1-mu.p)*(1+(Q*(n-1))))/(n*mu.p*CV^2) 				    ##  BB
                            NB<-	 'N.CV.BB'
                                     }
                                     } else {
          if(is.null(agrega)) {
          NN<-  log(Pro)/(n*log(1-(mu.p+(Z*ee.p))))	            			##  Binomial
          NB<-  'N.B'        }  else {
                              Q<-agrega/(1+agrega)
                              NN<- ((-Q)*log(Pro)) / ((mu.p+(Z*ee.p))*log(1+(n*Q))) 		##  BB revisar la formula
                              NB<-	'N.BB'
                                      }
                                                }

           if(!is.null(TM.F)) { NN<-NN+TM.F} else {NN<-NN+10}
           if(is.null(agrega)) {LL<-list(Tamano=NN,Metodo.est=NB,Incidencia=Inciden, ee=ee.p,rho=NA,Q.Agregacion=NA)} else {
         LL<-list(Tamano=NN,Metodo.est=NB,Incidencia=Inciden, ee=ee.p,rho=agrega,Q.Agregacion=Q) }
		write.csv(do.call(data.frame, LL) , file="TM_fijo.csv")

         return(do.call(data.frame, LL) )
                                }
