# calcul du tamano de monitoreo a partir des donnees

TME_sequencial <- function(data2, #df_planification, #analyse_vgam,
                           # metrica,
                           analyse_vgam2) {
  library(DT)
  library(data.table)

# calculo tamano efectuado
  subVgam1 <- plyr::ddply(data2, c("FACTOR","Num_mes"), 
                          summarise, 
                          TM_efectuado=length(Fecha)
                          )
  
# tamano necesario
  subVgam2 <- subset(analyse_vgam2,select=c(FACTOR,Num_mes,TM_ajustado))
  subVgam2$TM_ajustado2 <- ceiling(subVgam2$TM_ajustado)
  
# diferencia entre tamanos efectuado y necesario
    monitSequencial <- merge(subVgam1,subVgam2,by=c("FACTOR","Num_mes"))
    monitSequencial$monit_pendiente <- ifelse(monitSequencial$TM_efectuado>=monitSequencial$TM_ajustado2,
                                             "OK!",ceiling(monitSequencial$TM_ajustado2-monitSequencial$TM_efectuado))
  
    monitSequencial <- subset(monitSequencial,select=c("FACTOR","Num_mes","TM_efectuado",
                                                       "TM_ajustado2","monit_pendiente"))

    colnames(monitSequencial) <- c("Categorias",
                                  "Mes",
                                  "Num. parcelas efectuado", # effectue pport a planification
                                  "Num. parcelas necesario", # necessaire pport aux donnees de lannee en cours
                                  "Num. parcelas pendiente")
    
  return(monitSequencial)
}