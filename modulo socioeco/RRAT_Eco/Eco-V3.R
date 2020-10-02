
source("Eco-func-V3.R")
#crear matrices (deben ser un input Shiny)

#costo de insumos (ci) y mano de obra (mo) por nivel de manejo (eso deberia ser una tabla)
moi <- matrix(c(0,5,10,15,20,0,50,100,200,350),nrow=5,ncol=2,dimnames=list(c("ninguno","minimo","bajo","medio","alto"),c("mo","ci")))

#factor multiplicativo por nivel de costo de insumos 
nci <- matrix(c(1.5,1,0.67),nrow=3,ncol=1,dimnames=list(c("alto","regular","bajo"),"factor"))

#inicializar matriz de roya (Shiny)
inc.roya <- data.frame(mes=1:12,periodo=c(rep("despues.cosecha",2), rep("antes.cosecha",7),rep("cosecha",3)),inc.historico=c(30,12,4,1,1,4,8,15,25,35,39,35))

#arrancamos con sp que tiene todos los parametros del sistema de producción, asi como las unidades como atributo de cada variable
sp <- data.frame(pais="GT",zona="USULUTAN",tipo.prod="familiar",altitud=700,num.familias=3000,tamano.familia=5,ingresos.otros=1500,gastos.alim.familia=1200,ingreso.min.sost=3500,area.prod=2,precio.cafe=100,rendimiento.esperado=12,nivel.manejo="bajo",costo.1tratamientoRoya=50,costos.indirectos=0,nivel.costo.insumos="regular",costos.prod.otros=0,num.peones.perm=0,salario.peon=150,dq.mo.cosecha=4,salario.jornal=5,mo.familiar=2)

#insertar roya histrorica y fenologia en el sistema de producción
for(i in 1:12){sp[[paste("inc.roya.",i,sep="")]] <- as.numeric(inc.roya[i,3])}
for(i in 1:12){sp[[paste("periodo.",i,sep="")]] <- as.character(inc.roya[i,2]) }

#calcular los incrementos de roya segun condiciones: n (normal/historico), d: defavorable, f: favorable, c: crisis
#esta matriz no se ve pero se actualiza cada vez que cambia la roya historica
txir <- txRoya(sp, md=0.5,mf=1.2, mc=1.6) #inc.roya.1..12 tiene que estar en sp para esta funcion; parametros md, mf, mc como en ecoV13b excel


#otros parametros
#quizas una tabla shiny para los parametros del modelo, accequible solo por admin - o dejamos todo dentro de R...

#numero de dias por mes que un miembro de la familia trabaja
sp$dm.mo.familiar <- 25 #input Shiny. Podra ser fijo en el modelo, o una variable del calculo de mano de obra

#quizas meter en mano.obra***
sp$num.mes.cosecha <- sum(inc.roya$periodo=="cosecha") #se necesita para el calculo de jornales

#precio de la tierra
sp$precio.tierra <- 5000 #input shiny. Depende de la zona*** El salario jornal podria depender de la zona, por el momento depende de cada sistema de producción

#variables externas (input Shiny)
sp$salario.min.ciudad <- 200
sp$salario.min.rural <- 150
sp$canasta.basica.pp <- 75
sp$precio.int.cafe <- 90 #en teoria cambia todo el tiempo; no lo uso aun pero deberia aparecer como in indicador precio gate/precio int


#para tests
sp$rendimiento.esperado <- 30
sp$num.peones.perm <- 1
sp$nivel.manejo <- "alto"
sp$nivel.costo.insumos <- "bajo"

#Output shiny
indic.sp <- indicEcoAll(sp,moi,nci,txir,mes=6,inc=5,"d",anio=1)

#el pronostico de roya se obtiene asi (todavia no esta en shiny)
proRoya(txir,mes=6,inc=5,doPlot=T)

#agregar unidades. 
#para obtener los attributos:
#attr(sp$altitud,"unidad")
#attr(indic.sp$punto.equilibrio,"unidad")
#usar estos codigos de pais: https://www.realifewebdesigns.com/web-marketing/abbreviations-countries.asp

unidades <- matrix(c("ha","qq","USD",
                     "mz","qq","CRC",
                     "mz","qq","NIO",
                     "ha","qq","HNL",
                     "ha","qq","USD",
                     "ha","qq","GQT",
                     "ha","qq","DOP"),nrow=7,ncol=3,byrow=T,dimnames=list(c("PA","CR","NI","HN","SV","GT","DO"),c("area.cafe","peso.cafe","dinero")))


#ahora si agregar unidades
sp <- setUnidades.sp(sp,unidades)
indic.sp <- setUnidades.indic(indic.sp,unidades)




