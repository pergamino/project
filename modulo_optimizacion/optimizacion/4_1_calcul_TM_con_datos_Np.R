# calcul du tamano de monitoreo a partir des donnees

TME<-function(data, 
              df_Np,
              n,
              TM.F,
              progress=FALSE) {
  
  
  
  library(ggplot2)
  library(VGAM) 
  # print(getwd())
  agregacion=NULL
  Pro=0.01

  ncol.HR=12 # Hojas con Roya
  ncol.HT=11 # Hojas Evaluadas
  lfactor=17 # comb_var
  ncol.Fec=5 # Numero del mes
  ###Tabla con umbrales de riesgo teniendo en comun los meses (Fec) y categorias
  umbral <- subset(data,select=c(comb_var,Fec,n))

  # CAT<-unique(data[,lfactor])
  CAT<-unique(data$comb_var)
  
  SALIDAS<-list()
  for(j in 1:length(CAT)) {
    
    Sys.sleep(1)
    if(progress)
      incProgress(1/length(CAT))
    
    # dts<-data.frame(Fec=subset(data,data[,lfactor]==CAT[j])[,ncol.Fec],
    #                 HR=subset(data,data[,lfactor]==CAT[j])[,ncol.HR],
    #                 HE=subset(data,data[,lfactor]==CAT[j])[,ncol.HT])
    
    dts<-data.frame(Fec=subset(data,comb_var==CAT[j],select=Fec),
                    HR=subset(data,comb_var==CAT[j],select=Hojas.con.Roya),
                    HE=subset(data,comb_var==CAT[j],select=Hojas.Evaluadas))
    names(dts) <- c("Fec","HR","HE")
    
    FEC<-unique(dts$Fec)
    
    sal<-data.frame(matrix(nrow=length(FEC), ncol=8))
    colnames(sal)<-c('N.obs', 'Fec','TM', 'Metodo.est','p','ee','rho','Q.agregacion')
    
    
    ###########################################################
    ###########################################################
    ####			ESTIMACION DEL MODELO    ################
    ###########################################################
    ###########################################################
    
    
    #FEC<-unique(dts$Fec)
    
    
    for(i in 1:length(FEC)) {	#i=1
      
      pp<-subset(dts, Fec==FEC[i])
      if(length(pp[,1]) > 5 & var(pp$HR/pp$HE)>0 ) {
        fit <- vglm(cbind(HR, HE-HR) ~ 1, betabinomial, trace = TRUE, data=pp)
        
        ###########################################################
        ###########################################################
        #####           Parametros del modelo             #########
        ###########################################################
        ###########################################################
        Z<-qnorm(1-Pro)
        
        ee.logit<-as.vector(predict(fit, se.fit=T)$se.fit[1,1])         ###Error en escala logistica
        mu.p<-as.vector(fit@fitted.values[1])								           	###Media de la incidencia
        LS<-as.vector(logit(logit(mu.p)+(Z*ee.logit) , inverse=TRUE))	  ###Limite superior de la incidencia
        ee.p<-as.vector((LS-mu.p)/Z)							      				        ###Error de la incidencia
        r.p<-as.vector(fit@misc$rho[1])						      				        ###coeficiente de correlacion intraclase
        CV<-as.vector(ee.p/mu.p)							      				            ###Coeficiente de variacion del error
        Pro<-Pro
        Q<-r.p/(1+r.p)
        n<-n								                        			              ###Total de plantas evaluadas x parcela
        
        ###########################################################
        ###########################################################
        ###########################################################
        #########        Estimaci?n de N       ####################
        ###########################################################
        ###########################################################
        ###########################################################
        sal[i,1]<-length(pp[,1])
        
        #####cuando la mu es cero ### umb=NA
        ### seteando umbral o valor de decisi?n de formulas
        if(!is.null(umbral)) {  pppp<-subset(umbral, umbral[,1]==CAT[j])
        umb<-na.omit((pppp[pppp[,2]==FEC[i],])[,3])
        if(is.na(umb) || length(umb)==0) print('Error en categor?a o fecha de la tabla de umbrales')
        # if(umb>1) as.vector(umb<-umb/100)
        if(umb[1]>1) as.vector(umb<-umb/100)
        } else {umb<-0.05; print('Usando el umbral del  5 % de incidencia') }
        
        ###Seteando Q agregacion
        if(!is.null(agregacion)) { agregacion<-agregacion
        } else {agregacion<-0.10; print('Usando la regla del 0.10 de agregacion para definir si usar tama?os de muestra con binomial o beta-binomial') }
        
        
        
        
        # if(mu.p<=umb) {
          if(mu.p<=umb[1]) {
          if(Q<=agregacion) {
            sal[i,3]<-  log(Pro)/(n*log(1-(mu.p+(Z*ee.p))))	            			##  Binomial
            sal[i,4]<-  'N.B'
          } else if (Q>agregacion){
            sal[i,3]<- ((-r.p)*log(Pro)) / ((mu.p+(Z*ee.p))*log(1+(n*r.p))) 		##  BB revisar la formula
            sal[i,4]<-	'N.BB'
          }
          
        }
        else if(mu.p>umb[1]) {
          # else if(mu.p>umb) {
          ###Coeficiente de variaci?n #####
          if(Q<=agregacion) {
            sal[i,3] <-  (1-mu.p)/(n*mu.p*CV^2)                 				    ##  Binomial
            sal[i,4]<-	 'N.CV.B'
          } else if (Q>agregacion){
            
            sal[i,3] <-  ((1-mu.p)*(1+(Q*(n-1))))/(n*mu.p*CV^2) 				    ##  BB
            sal[i,4]<-	 'N.CV.BB'
          }
        }
        if(!is.null(TM.F)) TM.F<-TM.F else {TM.F=10 }
        sal[i,3] <-   sal[i,3]+TM.F
        sal[i,5] <-   mu.p
        sal[i,6] <-   ee.p
        sal[i,7] <-   r.p
        sal[i,8] <-	  Q
      } else {				###Si el tama?o de muestra no es suficiente para un ajuste del modelo NA
        sal[i,1] <-length(pp[,1])
        sal[i,3] <-   TM.F
        sal[i,4] <-  'Fijo'
        sal[i,5] <-   NA
        sal[i,6] <-   NA
        sal[i,7] <-   NA
        sal[i,8] <-   NA
      }
      
    }
    sal$Fec<-FEC
    sal$FACTOR<-CAT[j]
    SALIDAS[[j]]<-sal
    print(j)
  }
  
  vgam.salida<-do.call(rbind, SALIDAS)
  
  # Calcul du nombre de parcelles ajsut? au nombre de parcelles r?elles dans la zone (TM_ajustado)

  # df_Np <- data.frame(FACTOR=sort(CAT),Np=categorias)
  
  vgam.salida_ajust <- merge(vgam.salida,df_Np,by="FACTOR")
  
  vgam.salida_ajust$TM_ajustado <- vgam.salida_ajust$TM*vgam.salida_ajust$Np/(vgam.salida_ajust$Np-1+vgam.salida_ajust$TM)

  
  # write.csv(vgam.salida, file=paste(name.sal[1], 'csv', sep='.'))
  return(vgam.salida_ajust)
}