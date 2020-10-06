####################
#fonctions 
####################

#faltaria poner los tratamientos
costos.prod.tot <- function(sp, moi, nci, num.jornales) {
  costoInsumos <- moi[as.character(sp$nivel.manejo),"ci"]*nci[as.character(sp$nivel.costo.insumos),"factor"]*sp$area.prod
  (costoInsumos+sp$salario.jornal*num.jornales+sp$num.peones.perm*sp$salario.peon*12+sp$costos.prod.otros)*(100+sp$costos.indirectos)/100
}

ingresos.cafe <- function(area.prod,
                          rendimiento.esperado,
                          precio.cafe) {
  area.prod*rendimiento.esperado*precio.cafe
}

margen <- function(ingresos.total,
                   costos.prod.tot, 
                   gastos.alim.familia) { 
  ingresos.total-costos.prod.tot-gastos.alim.familia
}

margenminsost <- function(ingresos,gastoalim) {
  ingresos - gastoalim
}

txRoya <- function(sp,md,mf,mc){
  #besoin d'avoir mis la roya dans sp
  #txn: normal; txf: favorable; txd: desfavorable; txc: crisis
  #md, mf, mc= facteurs multiplicatifs du taux
  #ici changé p/R a eco-V9 (voir eco-V9b): si taux négatif (cad despues de cosecha), prendre taux normal
  txn <- txf <-txd <- txc <- ir <- 1:12
  for(i in 1:12) {ir[i] <- sp[[paste("inc.roya.",i,sep="")]]}
  for(i in 1:11) {
    txn[i] <- (ir[i+1]-ir[i])/ir[i]
    txd[i] <- ifelse(txn[i]>0,min(txn[i]*md,0.95), txn[i])
    txf[i] <- ifelse(txn[i]>0,min(txn[i]*mf,0.95), txn[i])
    txc[i] <- ifelse(txn[i]>0,min(txn[i]*mc,0.95), txn[i])
  }
  i <- 12
  txn[i] <- (ir[1]-ir[i])/ir[i]
  txd[i] <- ifelse(txn[i]>0,min(txn[i]*md,0.95), txn[i])
  txf[i] <- ifelse(txn[i]>0,min(txn[i]*mf,0.95), txn[i])
  txc[i] <- ifelse(txn[i]>0,min(txn[i]*mc,0.95), txn[i])
  data.frame(cbind(ir,txn,txd,txf,txc))
}

proRoya <- function(tx, mes, inc, doPlot=T){
  #tx est obtenu avec fonction txRoya; mes: mes observacion; inc: incidencia observada este mes
  #calculer les 12 mois en fn de la courbe
  irPro <- 1:12
  irPro[mes] <- inc
  for (i in mes:11){irPro[i+1] <- ifelse(i==mes, inc*(1+tx$txn[i]),irPro[i]*(1+tx$txn[i]))}
  if(mes==12) {irPro[12] <- inc}
  irPro[1] <- irPro[12]*(1+tx$txn[12])
  if(mes==1) {irPro[1] <- inc; irPro[2] <- irPro[1]*(1+tx$txn[1])}
  if(mes==2) {irPro[2] <- inc}
  if(mes>=3) {for (i in 1:(mes-2)){irPro[i+1] <- irPro[i]*(1+tx$txn[i])}}

  irPro.n <- irPro
  
  for (i in mes:11){irPro[i+1] <- ifelse(i==mes, inc*(1+tx$txd[i]),irPro[i]*(1+tx$txd[i]))}
  if(mes==12) {irPro[12] <- inc}
  irPro[1] <- irPro[12]*(1+tx$txd[12])
  if(mes==1) {irPro[1] <- inc; irPro[2] <- irPro[1]*(1+tx$txd[1])}
  if(mes==2) {irPro[2] <- inc}
  if(mes>=3) {for (i in 1:(mes-2)){irPro[i+1] <- irPro[i]*(1+tx$txd[i])}}
  irPro.d <- irPro
  
  for (i in mes:11){irPro[i+1] <- ifelse(i==mes, inc*(1+tx$txf[i]),irPro[i]*(1+tx$txf[i]))}
  if(mes==12) {irPro[12] <- inc}
  irPro[1] <- irPro[12]*(1+tx$txf[12])
  if(mes==1) {irPro[1] <- inc; irPro[2] <- irPro[1]*(1+tx$txf[1])}
  if(mes==2) {irPro[2] <- inc}
  if(mes>=3) {for (i in 1:(mes-2)){irPro[i+1] <- irPro[i]*(1+tx$txf[i])}}
  irPro.f <- irPro
  
  for (i in mes:11){irPro[i+1] <- ifelse(i==mes, inc*(1+tx$txc[i]),irPro[i]*(1+tx$txc[i]))}
  if(mes==12) {irPro[12] <- inc}
  irPro[1] <- irPro[12]*(1+tx$txc[12])
  if(mes==1) {irPro[1] <- inc; irPro[2] <- irPro[1]*(1+tx$txc[1])}
  if(mes==2) {irPro[2] <- inc}
  if(mes>=3) {for (i in 1:(mes-2)){irPro[i+1] <- irPro[i]*(1+tx$txc[i])}}
  irPro.c <- irPro
  irProAll <- data.frame(cbind(irPro.n,irPro.d,irPro.f,irPro.c))
  #plot
  if(doPlot){
    m <- mes; mm1 <- mes-1 #oups mm1 = 0 si mes=1...***
    plot(cbind(1:12,irProAll$irPro.c),type='n', xlab="mes",ylab="incidencia",ylim = c(0,max(tx$ir,irProAll$irPro.c)))
    if(mm1>0) {lines(cbind(1:12,irProAll$irPro.c)[1:mm1,],col="red",lwd=2)}
    if(mm1>0) {lines(cbind(1:12,irProAll$irPro.f)[1:mm1,],col="pink",lwd=2)}
    if(mm1>0) {lines(cbind(1:12,irProAll$irPro.n)[1:mm1,],col="grey",lwd=2)}
    if(mm1>0) {lines(cbind(1:12,irProAll$irPro.d)[1:mm1,],col="green",lwd=2)}
    lines(cbind(1:12,irProAll$irPro.c)[m:12,],col="red",lwd=2)
    lines(cbind(1:12,irProAll$irPro.f)[m:12,],col="pink",lwd=2)
    lines(cbind(1:12,irProAll$irPro.n)[m:12,],col="grey",lwd=2)
    lines(cbind(1:12,irProAll$irPro.d)[m:12,],col="green",lwd=2)
    lines(cbind(1:12,tx$ir),col="black",lwd=2,lty='dotted')
  }
  irProAll
}

numJornales <- function(sp, rend, moi,print=F){
  cosecha <- sp$area.prod*rend
  mo.cosecha.tot <- sp$dq.mo.cosecha*cosecha
  mo.cosecha.fam <- sp$num.mes.cosecha*sp$dm.mo.familiar*(sp$mo.familiar+sp$num.peones.perm)
  mo.cosecha.jor <- max(0,mo.cosecha.tot-mo.cosecha.fam)
  mo.manejo.tot <- moi[as.character(sp$nivel.manejo),"mo"]*sp$area.prod
  mo.manejo.fam <- (12-sp$num.mes.cosecha)*sp$dm.mo.familiar
  mo.manejo.jor <- max(0,mo.manejo.tot-mo.manejo.fam)
  if(print) {print(data.frame(mo.cosecha.tot,mo.cosecha.fam,mo.cosecha.jor,mo.manejo.tot,mo.manejo.fam,mo.manejo.jor))}
  mo.cosecha.jor+mo.manejo.jor
}

mesNum <- function(textMes){
  temp <- data.frame(cbind(1:12,c("enero","febrero","marzo","abril","mayo","junio", "julio","agosto","setiembre","octubre","noviembre","diciembre")))
  names(temp) <- c("numMes","textMes")
  as.numeric(as.character(temp$numMes[temp[,2]==textMes]))
}

condPro <- function(condiciones){
  temp <- data.frame(c("d","n","f","c"),c("desfavorable","normales", "favorable","muy favorables"))
  names(temp) <- c("cond","condiciones")
  as.character(temp$cond[temp[,2]==condiciones])
}


maxRoyaHist <- function(sp) {max(sp$inc.roya.1,sp$inc.roya.2,sp$inc.roya.3,sp$inc.roya.4,sp$inc.roya.5,sp$inc.roya.6,sp$inc.roya.7,sp$inc.roya.8,sp$inc.roya.9,sp$inc.roya.10,sp$inc.roya.11,sp$inc.roya.12)}  

#tratamiento despues de consecha y antes de floración?
#ojo si initcosecha en enero o febrero*** tambine  no hay tratamiento durante la cosecha
#on pourrait aussi seulement calculer el numero de meses cuando el mes esta antes cosecha***

costoTratamientoRoya <- function(sp,nci,mes,cond,estrategiaTratamiento="adaptativo") {
  #calcular en base 1 tratamiento cada 1.5 mes hasta cosecha no importa las condiciones. o si las condiciones son defavorables no tratar el mes en curso pero si los siguientes!!
  #no hay trataopento durante la cosecha
  temp <- which("cosecha"==c(sp$periodo.1,sp$periodo.2,sp$periodo.3,sp$periodo.4,sp$periodo.5,sp$periodo.6,sp$periodo.7,sp$periodo.8,sp$periodo.9,sp$periodo.10,sp$periodo.11,sp$periodo.12))
  initCosecha <- min(temp[temp>4]) #la cosecha no puede iniciar antes de abril
  numTratamiento <- ifelse(estrategiaTratamiento == "sistematico", max(0,round((initCosecha-mes)/1.5,0)), ifelse(cond=="d",max(0,round((initCosecha-mes-1)/1.5,0)),max(0,round((initCosecha-mes)/1.5,0))))
  numTratamiento*sp$costo.1tratamientoRoya*nci[as.character(sp$nivel.costo.insumos),"factor"]*sp$area.prod
}


#je mélange un peu... systématique maintienst la rouille au niveau du mois en cours, adaptativo 
indicEco <- function(sp,moi,nci,txir,mes,inc,cond,anio, escenario="tendencial"){
  pronosticoRoya <- proRoya(txir,mes,inc,doPlot=F)
  estrategiaTratamiento <- ifelse(endsWith(escenario,"adaptativo"),"adaptativo",ifelse(endsWith(escenario,"sistematico"),"sistematico","ninguno"))
  if(escenario=="linea.base"){rendimientoEsperado <- sp$rendimiento.esperado; maxRoya <- maxRoyaHist(sp)}
  if(escenario=="tendencial") {maxRoya <- max(pronosticoRoya[[paste("irPro",cond,sep=".")]]); rendimientoEsperado <- sp$rendimiento.esperado*(1-(maxRoya-max(txir$ir))*anio/200)}
  if(startsWith(escenario, "con.tratamiento.")) {maxRoya <- inc; rendimientoEsperado <- sp$rendimiento.esperado*(1-(inc-max(txir$ir))*anio/200)} #aqui la roya se queda al nivel donde esta hasta la cosecha...
  
  #if(escenario=="con.tratamiento.sistematico") {maxRoya <- inc; rendimientoEsperado <- sp$rendimiento.esperado*(1-(maxRoya-max(txir$ir))*anio/200)} #aqui la roya se queda al nivel donde esta hasta la cosecha...
  #if(escenario=="con.tratamiento.adaptativo") {maxRoya <- max(pronosticoRoya[["irPro.d"]]); rendimientoEsperado <- sp$rendimiento.esperado*(1-(maxRoya-max(txir$ir))*anio/200)} #aqui la roya se queda al nivel donde esta hasta la cosecha...

  ingresosCafe <- ingresos.cafe(sp$area.prod, rendimientoEsperado, sp$precio.cafe)
  ingresosTotal <- ingresosCafe+sp$ingresos.otros
  num.jornales <- numJornales(sp,rendimientoEsperado,moi)
  costoTratamRoya <- ifelse(estrategiaTratamiento=="ninguno", 0,costoTratamientoRoya(sp,nci,mes,cond,estrategiaTratamiento))
  costosProdTot <- costos.prod.tot(sp, moi, nci, num.jornales)+costoTratamRoya
  
  #ahora los indicadores derivados-haremosla linea base y con manejo despues
  rentab.cafe <- ingresosCafe-costosProdTot
  margen <- margen(ingresosTotal,costosProdTot, sp$gastos.alim.familia)
  umbral <- margenminsost(sp$ingreso.min.sost,sp$gastos.alim.familia)
  valor.agregado <- margen+sp$gastos.alim.familia+num.jornales*sp$salario.jornal+sp$num.peones.perm*sp$salario.peon*12
  valor.agregado.R <- valor.agregado*sp$num.familias
  margen.alim.pp <- (margen+sp$gastos.alim.familia)/sp$tamano.familia
  san.pp <- margen.alim.pp/(sp$canasta.basica.pp*12)
  costo.op.jornal <- ifelse(margen.alim.pp > 0, sp$dm.mo.familiar*sp$salario.jornal*12/margen.alim.pp, Inf)
  costo.op.rural <- ifelse(margen.alim.pp > 0, sp$salario.min.rural*12/margen.alim.pp, Inf)
  costo.op.ciudad <- ifelse(margen.alim.pp > 0, sp$salario.min.ciudad*12/margen.alim.pp, Inf)
  precio.cafe.min.sost <- (sp$ingreso.min.sost-sp$ingresos.otros+costosProdTot)/(rendimientoEsperado*sp$area.prod)
  precio.cafe.min.prod <- costosProdTot/(rendimientoEsperado*sp$area.prod)
  costo.op.tierra <- sp$precio.tierra*0.03-rentab.cafe/sp$area.prod
  punto.equilibrio <- (sp$precio.tierra*0.03+costosProdTot/sp$area.prod)/rendimientoEsperado #cuanto hay que vender el cafe para que costo.op.tierra=0
  periodo <- switch(mes,sp$periodo.1,sp$periodo.2,sp$periodo.3,sp$periodo.4,sp$periodo.5,sp$periodo.6,sp$periodo.7,sp$periodo.8,sp$periodo.9,sp$periodo.10,sp$periodo.11,sp$periodo.12)
  data.frame(cbind(pais=as.character(sp$pais), zona=as.character(sp$zona), tipo.prod=as.character(sp$tipo.prod), periodo, umbral, maxRoya, rendimientoEsperado, ingresosCafe,costosProdTot, estrategiaTratamiento, costoTratamRoya, rentab.cafe, num.jornales, ingresosTotal, margen,
        valor.agregado,valor.agregado.R,margen.alim.pp,san.pp,costo.op.jornal,costo.op.rural,costo.op.ciudad,precio.cafe.min.prod,
        precio.cafe.min.sost,costo.op.tierra,punto.equilibrio))
}
#calcular valores "sostenible" etc para los niveles a partir de los valores... o preparar una fuccion

indicEcoAll <- function(sp,moi,nci,txir,mes,inc,cond,anio) {
  temp <- rbind(
    indicEco(sp,moi,nci,txir,mes,inc,cond,anio,escenario="linea.base")
    ,
    indicEco(sp,moi,nci,txir,mes,inc,cond,anio,escenario="tendencial")#tendencial esta bien
    ,
    indicEco(sp,moi,nci,txir,mes,inc,cond,anio,escenario="con.tratamiento.sistematico") #pequena diferencia...
    ,
    indicEco(sp,moi,nci,txir,mes,inc,cond,anio,escenario="con.tratamiento.adaptativo") #pequena diferencia...
  )
  row.names(temp) <- c("linea.base","tendencial","con.tratamiento.sistematico","con.tratamiento.adaptativo")
  temp
}


rlookup <- function(df,rowname,colname) {
  df[[colname]][row.names(df)==rowname]
}

setUnidades.sp <- function(sp,pais, unidades.mat){
  pais <- as.character(sp$pais[1])
  attr(sp$pais, "unidad") <- ""
  attr(sp$zona, "zona") <- ""
  attr(sp$tipo.prod, "unidad") <- ""
  attr(sp$altitud,"unidad") <- "msnm"
  attr(sp$num.familias,"unidad") <- "familias"
  attr(sp$tamano.familia,"unidad") <- "personas"
  attr(sp$ingresos.otros,"unidad") <- paste(unidades[pais,"dinero"],"/año",sep="")
  attr(sp$gastos.alim.familia,"unidad") <- paste(unidades[pais,"dinero"],"/año",sep="")
  attr(sp$ingreso.min.sost,"unidad") <- paste(unidades[pais,"dinero"],"/año",sep="")
  attr(sp$area.prod,"unidad") <- unidades[pais,"area.cafe"]
  attr(sp$precio.cafe,"unidad") <- paste(unidades[pais,"dinero"],"/",unidades[pais,"peso.cafe"],sep="")
  attr(sp$rendimiento.esperado,"unidad") <- paste(unidades[pais,"peso.cafe"],"/",unidades[pais,"area.cafe"],sep="")
  attr(sp$costo.1tratamientoRoya,"unidad") <- paste(unidades[pais,"dinero"],"/trat",sep="")
  attr(sp$costos.indirectos,"unidad") <- "%"
  attr(sp$costos.prod.otro,"unidad") <- paste(unidades[pais,"dinero"],"/año",sep="")
  attr(sp$num.peones.perm,"unidad") <- "peon(es)"
  attr(sp$dq.mo.cosecha,"unidad") <- paste("d.h/",unidades[pais,"peso.cafe"],sep="")
  attr(sp$salario.jornal,"unidad") <- paste(unidades[pais,"dinero"],"/dia",sep="")
  attr(sp$dm.mo.familiar,"unidad") <- "ETC"
  #variables externas
  attr(sp$salario.min.ciudad,"unidad") <- paste(unidades[pais,"dinero"],"/mes",sep="")
  attr(sp$salario.min.rural,"unidad") <- paste(unidades[pais,"dinero"],"/mes",sep="")
  attr(sp$canasta.basica.pp,"unidad") <- paste(unidades[pais,"dinero"],"/persona/mes",sep="")
  attr(sp$precio.int.cafe,"unidad") <- paste(unidades[pais,"dinero"],"/",unidades[pais,"peso.cafe"],sep="")
  sp
}

setUnidades.indic <- function(indic.sp,unidades.mat){
    pais <- as.character(indic.sp$pais[1])
    attr(sp$pais, "unidad") <- ""
    attr(sp$zona, "zona") <- ""
    attr(sp$tipo.prod, "unidad") <- ""
    attr(indic.sp$maxRoya,"unidad") <- "%"
    attr(indic.sp$rendimientoEsperado,"unidad") <- paste(unidades[pais,"peso.cafe"],"/",unidades[pais,"area.cafe"],sep="")
    attr(indic.sp$ingresosCafe,"unidad") <- paste(unidades[pais,"dinero"],"/año",sep="")
    attr(indic.sp$costosProdTot,"unidad") <- paste(unidades[pais,"dinero"],"/año",sep="")
    attr(indic.sp$estrategiaTratamiento,"unidad") <- 
    attr(indic.sp$costoTratamRoya,"unidad") <- paste(unidades[pais,"dinero"],"/año",sep="")
    attr(indic.sp$rentab.cafe,"unidad") <- paste(unidades[pais,"dinero"],"/año",sep="")
    attr(indic.sp$num.jornales,"unidad") <- "ETC"
    attr(indic.sp$ingresosTotal,"unidad") <- paste(unidades[pais,"dinero"],"/año",sep="")
    attr(indic.sp$margen,"unidad") <- paste(unidades[pais,"dinero"],"/año",sep="")
    attr(indic.sp$valor.agregado,"unidad") <- paste(unidades[pais,"dinero"],"/año",sep="")
    attr(indic.sp$valor.agregado.R,"unidad") <- paste(unidades[pais,"dinero"],"/año",sep="")
    attr(indic.sp$margen.alim.pp,"unidad") <- paste(unidades[pais,"dinero"],"/año",sep="")
    attr(indic.sp$san.pp,"unidad") <- ""
    attr(indic.sp$costo.op.jornal,"unidad") <- ""
    attr(indic.sp$costo.op.rural,"unidad") <- ""
    attr(indic.sp$costo.op.ciudad,"unidad") <- ""
    attr(indic.sp$precio.cafe.min.prod,"unidad") <- paste(unidades[pais,"dinero"],"/",unidades[pais,"peso.cafe"],sep="")
    attr(indic.sp$precio.cafe.min.sost,"unidad") <- paste(unidades[pais,"dinero"],"/",unidades[pais,"peso.cafe"],sep="")
    attr(indic.sp$costo.op.tierra,"unidad") <- paste(unidades[pais,"dinero"],"/año",sep="")
    attr(indic.sp$punto.equilibrio,"unidad") <- paste(unidades[pais,"dinero"],"/",unidades[pais,"peso.cafe"],sep="")
    indic.sp
}