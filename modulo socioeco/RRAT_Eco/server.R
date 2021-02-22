server <- function(input, output, session) {
  
  # Tabla Sistema de produccion
  
  selRegiones <- reactive({
    if(is.null(importSistemaProd())){
      filter(regiones,idpais==filter(paises,pais==input$selPais)$cod_extra)$rrat5 
    }
  })
  
  selTipoProductor <- reactive({
    if(is.null(importSistemaProd())){
      filter(tipoproductor,cod_pais==filter(paises,pais==input$selPais)$cod_pais)$tipoproductor 
    }
  })
  
  selSistemaProduccion <- reactiveVal()
  
  observeEvent(input$selecFromDB, {
    showModal(dataModal())
  })
  
  dataModal <- function(failed = FALSE) {
    modalDialog(
      title = "Seleccionar perfiles productivos desde Base de Datos",
      size = "m",
      fluidRow(
        column(width=12,
               selectInput("selPerfil","Perfil productivo",varsocioeco$perfil,selected = NULL,multiple = FALSE,
                           selectize = TRUE, width = NULL, size = NULL
               )    
        )
      ),
      footer = tagList(
        modalButton("Cerrar")
      )
    )
  }
  
  #selSistemaProduccion0 <- reactive({
  #  if(is.null(importSistemaProd())){
  #    filter(varsocioeco,perfil==input$selPerfil)
  #  }
  #})
  
  observe({
    if(is.null(importSistemaProd())){
      if(!is.null(input$selPerfil)) {
        selSistemaProduccion(filter(varsocioeco,perfil==input$selPerfil))
        updateSelectInput(session,"selPais","País",paises$pais,selected = filter(varsocioeco,perfil==input$selPerfil)$pais)
        updateSelectInput(session,"selRegion","Región",filter(regiones,idpais==filter(paises,pais==input$selPais)$cod_extra)$rrat5,selected=filter(varsocioeco,perfil==input$selPerfil)$region)
        updateSelectInput(session,"tiTipoProductor","Tipo de productor",tipoproductor$tipoproductor,selected=filter(varsocioeco,perfil==input$selPerfil)$tipoprod)
        runjs("$('#selPais').prop('disabled',true)")
      }
    }
  })
  
  costoManejoPais <- reactiveVal()
  
  costoManejoPais1 <- reactive({
    costoManejoPais(filter(costomanejo,cod_pais==filter(paises,pais==input$selPais)$cod_pais))
    filter(costomanejo,cod_pais==filter(paises,pais==input$selPais)$cod_pais)
  })
  
  observe({
    costoManejoPais(costoManejoPais1())
  })
  
  unidadesPais <- reactive({
    filter(unidades,cod_pais==filter(paises,pais==input$selPais)$cod_pais)
  })
  
  pronostico <- reactive({
    if(input$pronostico=="Año en curso")
    {
      1
    }
    else
    {
      2
    }
  })
  
  observe({
    if(is.null(importSistemaProd())){
      updateSelectInput(session, "selRegion",
                      choices = selRegiones())
      }
    })
  
  observe({
    if(is.null(importSistemaProd())){
      updateSelectInput(session, "tiTipoProductor",
                        choices = selTipoProductor())
    }
  })
  
  observe({
    updateNumericInput(session,"niAlt",value=selSistemaProduccion()$altitud)
    updateTextInput(session,"tiTipoProductor",value=selSistemaProduccion()$tipoprod)
    updateNumericInput(session,"niNumFam",value=selSistemaProduccion()$numfamilias)
    updateNumericInput(session,"niTamFam",value=selSistemaProduccion()$tamanofamilia)
    updateNumericInput(session,"niGastAlim",label=paste("Gasto de alimentación familia (",unidadesPais()$unidaddinero,"/año)",sep=""),value=selSistemaProduccion()$gastosalimfamilia)
    updateNumericInput(session,"niAhorOtroIngres",label=paste("Ahorro u otros ingresos (",unidadesPais()$unidaddinero,"/año)",sep=""),value=selSistemaProduccion()$ingresosotros)
    updateNumericInput(session,"niMargSosten",label=paste("Márgen mínima para sostenibilidad (",unidadesPais()$unidaddinero,"/año)",sep=""),value=selSistemaProduccion()$ingresominsost)
    updateNumericInput(session,"niAreaProd",label=paste("Area de producción (",unidadesPais()$unidadarea,")",sep=""),value=selSistemaProduccion()$areaprod)
    updateNumericInput(session,"niRedimCafeOro",label=paste("Rendimiento café oro (",unidadesPais()$unidadmedidacafe,"/",unidadesPais()$unidadarea,")",sep=""),value=selSistemaProduccion()$rendimientoesperado)
    updateNumericInput(session,"niPrecioVentaCafe",label=paste("Precio de venta del café (",unidadesPais()$unidaddinero,"/",unidadesPais()$unidadmedidacafe,")",sep=""),value=selSistemaProduccion()$preciocafe)
    updateTextInput(session,"tiNivManejo",value=selSistemaProduccion()$nivelmanejo)
    updateNumericInput(session,"niCostoTratam",label=paste("Costo de 1 tratam. roya (",unidadesPais()$unidaddinero,"/",unidadesPais()$unidadarea,")",sep=""),value=selSistemaProduccion()$costo1tratamientoroya)
    updateTextInput(session,"tiNivCostoInsum",value=selSistemaProduccion()$nivelcostoinsumos)
    updateNumericInput(session,"niCostoIndirect",value=selSistemaProduccion()$costosindirectos)
    updateNumericInput(session,"niOtroCostoProd",label=paste("Otros costos de producción (",unidadesPais()$unidaddinero,"/año)",sep=""),value=selSistemaProduccion()$costosprodotros)
    updateNumericInput(session,"niMumPeones",value=selSistemaProduccion()$numpeonesperm)
    updateNumericInput(session,"niSalarDiaJornal",label=paste("Salario diario jornales (",unidadesPais()$unidaddinero,"/día)",sep=""),value=selSistemaProduccion()$salariopeon)
    updateNumericInput(session,"niCosecha",label=paste("Cosecha (días-hombre/",unidadesPais()$unidadmedidacafe,")",sep=""),value=selSistemaProduccion()$dqmocosecha)
    updateNumericInput(session,"niManoObraFam",value=selSistemaProduccion()$mofamiliar)
    updateNumericInput(session,"niCanastaBasica",label=paste("Canasta basica (",unidadesPais()$unidaddinero,"/mes/persona)",sep=""),value=selSistemaProduccion()$canastabasicapp)
    updateNumericInput(session,"niPrecioTierra",value=selSistemaProduccion()$preciotierra)
    updateNumericInput(session,"niSueldoMinCiudad",label=paste("Sueldo minimo ciudad (",unidadesPais()$unidaddinero,"/mes)",sep=""),value=selSistemaProduccion()$salariominciudad)
    updateNumericInput(session,"niSueldoMinCampo",label=paste("Sueldo minimo campo (",unidadesPais()$unidaddinero,"/mes)",sep=""),value=selSistemaProduccion()$salariominrural)
    updateNumericInput(session,"niDiasMesMOfam",value=selSistemaProduccion()$dmmofamiliar)
    #importSistemaProd(NULL)
  })
  
  observe({
    updateNumericInput(session,"ningunMO",value=filter(costoManejoPais(),manejo=="ninguno")$manoobra)
    updateNumericInput(session,"minimoMO",value=filter(costoManejoPais(),manejo=="minimo")$manoobra)
    updateNumericInput(session,"bajoMO",value=filter(costoManejoPais(),manejo=="bajo")$manoobra)
    updateNumericInput(session,"medioMO",value=filter(costoManejoPais(),manejo=="medio")$manoobra)
    updateNumericInput(session,"altoMO",value=filter(costoManejoPais(),manejo=="alto")$manoobra)
    
    updateNumericInput(session,"ningunCI",value=filter(costoManejoPais(),manejo=="ninguno")$costoinsumo)
    updateNumericInput(session,"minimoCI",value=filter(costoManejoPais(),manejo=="minimo")$costoinsumo)
    updateNumericInput(session,"bajoCI",value=filter(costoManejoPais(),manejo=="bajo")$costoinsumo)
    updateNumericInput(session,"medioCI",value=filter(costoManejoPais(),manejo=="medio")$costoinsumo)
    updateNumericInput(session,"altoCI",value=filter(costoManejoPais(),manejo=="alto")$costoinsumo)
  })
  
  output$box1 <- renderUI({
    box(title=paste("Mano de obra manejo (dias-hombres/",unidadesPais()$unidadarea,")",sep=""), color = "light-blue",background = "light-blue", width=50,height = 100)
  })
  
  output$box2 <- renderUI({
    box(title=paste("Costos insumos nivel regular (",unidadesPais()$unidaddinero,"/",unidadesPais()$unidadarea,")"), color = "light-blue",background = "light-blue", width=50,height = 100)
  })
  
  values <- reactiveValues()
  
  # Title Roya historica  -------------------------------
  
  output$nombre_region <- renderText({
    paste("Región: ",input$selRegion,sep="")
  })
  
  output$nombre_region_sp <- renderText({
    paste("Región: ",input$selRegion,sep="")
  })
  
  output$nombre_region_mo <- renderText({
    paste("Región: ",input$selRegion,sep="")
  })
  
  output$nombre_region_pro <- renderText({
    paste("Región: ",input$selRegion,sep="")
  })
  
  output$nombre_tipoProductor <- renderText({
    paste("Tipo de productor: ",input$tiTipoProductor,sep="")
  })
  
  output$nombre_tipoProductor_sp <- renderText({
    paste("Tipo de productor: ",input$tiTipoProductor,sep="")
  })
  
  output$nombre_tipoProductor_mo <- renderText({
    paste("Tipo de productor: ",input$tiTipoProductor,sep="")
  })
  
  output$nombre_tipoProductor_pro <- renderText({
    paste("Tipo de productor: ",input$tiTipoProductor,sep="")
  })
  
  # Plot Roya Historica --------------------------------
  
  ## Table roya historica
  DfRoyaHist <- reactiveVal()
  
  DfRoyaHist0 <- reactive({
    if(nrow(filter(royahistorica,region==input$selRegion) %>% select("Mes"=mes,"Incidencia"=incidencia,"Periodo"=periodo)>0)) {
      DfRoyaHist(filter(royahistorica,region==input$selRegion) %>% select("Mes"=mes,"Incidencia"=incidencia,"Periodo"=periodo))    
      filter(royahistorica,region==input$selRegion) %>% select("Mes"=mes,"Incidencia"=incidencia,"Periodo"=periodo)  
    } else {
      t <- data.frame(Mes=1:12,Incidencia=c(0,0,0,0,0,0,0,0,0,0,0,0),Periodo=c(rep("despues_cosecha",2), rep("antes_cosecha",7),rep("cosecha",3)))
      DfRoyaHist(t)
      t
    }
  })

  output$hot <- renderExcel({
    colonnes <- data.frame(readOnly = c(TRUE, FALSE, FALSE), width = 100)
    excelTable(DfRoyaHist0(), columns = colonnes)
  })
  
  #observe({
    
  #})
  
  DfRoyaHist2 <- eventReactive(input$hot,{
    dfroya <- excel_to_R(input$hot)
    dfroya$Incidencia <- as.numeric(as.character(dfroya$Incidencia))
    dfroya
  })
  
  observe({
    DfRoyaHist(DfRoyaHist2())
  })

  DfPourPlot <- reactive({
    values[["rv$DfRoyaHist"]]
  })
  
  ## Plot roya historica
  
  output$plotRoyaHist <- renderPlot({
    
    ggplot() +
      geom_line(data=DfRoyaHist(), aes(x=1:12,y=Incidencia),size=1, color="red")+
      scale_x_continuous(name = "",
                         breaks=seq(1, 12, 1),
                         labels=c("enero","febrero","marzo","abril","mayo", "junio", "julio",
                                  "agosto","setiembre","octubre","noviembre","diciembre"))+
      scale_y_continuous(name = "") +
      ggtitle("Incidencia de roya (promedio histórico)") +
      #theme_bw()+
      theme(
        plot.title = element_text(size=20, face="bold",hjust = 0.5),
        axis.text.x  = element_text(angle=45, vjust=0.5, size=16),
        axis.text.y  = element_text(size=16),
        legend.position="none",
        panel.grid.minor = element_blank(),
        strip.background = element_blank()) +
        theme(legend.title=element_blank())
  })

  # Pronostico -----------------------------------

  ## Plot roya Vigilancia (historico)
  ##ojo no se usa sp en este caso, pero debriamos hay que usar los campos de roya historico en SP
  
  mes <- reactive({
    switch(input$mesObs, "enero" = 1, "febrero" = 2, "marzo" = 3, "abril" = 4, "mayo" = 5, "junio" = 6, "julio" = 7, "agosto" = 8, "septiembre" = 9, "octubre" = 10, "noviembre" = 11, "diciembre" = 12)
  })
  
  condiciones <- reactive({
    switch(input$condPro,"desfavorable" = "d","normales" = "n", "favorable" = "f","muy favorables"="c")
  })

  output$plotVigilancia <- renderPlot({
    m <- mes(); mm1 <- mes()-1 #oups mm1 = 0 si mes=1...***
    par(xpd = T, mar = par()$mar + c(0,0,0,7))
    plot(cbind(1:12,proRoyaDF()$irPro.c),type='n', xlab="mes",ylab="incidencia",ylim = c(0,max(txir()$ir,proRoyaDF()$irPro.c)))
    if(mm1>0) {lines(cbind(1:12,proRoyaDF()$irPro.c)[1:mm1,],col="red",lwd=2)}
    if(mm1>0) {lines(cbind(1:12,proRoyaDF()$irPro.f)[1:mm1,],col="pink",lwd=2)}
    if(mm1>0) {lines(cbind(1:12,proRoyaDF()$irPro.n)[1:mm1,],col="grey",lwd=2)}
    if(mm1>0) {lines(cbind(1:12,proRoyaDF()$irPro.d)[1:mm1,],col="green",lwd=2)}
    lines(cbind(1:12,proRoyaDF()$irPro.c)[m:12,],col="red",lwd=2)
    lines(cbind(1:12,proRoyaDF()$irPro.f)[m:12,],col="pink",lwd=2)
    lines(cbind(1:12,proRoyaDF()$irPro.n)[m:12,],col="grey",lwd=2)
    lines(cbind(1:12,proRoyaDF()$irPro.d)[m:12,],col="green",lwd=2)
    lines(cbind(1:12,txir()$ir),col="black",lwd=2,lty='dotted')
    legend(12.5, 10,
           c("Muy favorable", "Favorable", "Normal", "Desfavorable", "Historico"),
           col = c("red", "pink", "grey", "green","black"),
           cex = 0.8,
           lwd = 1, lty = 1)
  })
  
  moi <- reactiveVal()
  
  moi0 <- reactive({
    moi(matrix(c(input$ningunMO,input$minimoMO,input$bajoMO,input$medioMO,input$altoMO,input$ningunCI,input$minimoCI,input$bajoCI,input$medioCI,input$altoCI),nrow=5,ncol=2,dimnames=list(c("ninguno","minimo","bajo","medio","alto"),c("mo","ci"))))
    matrix(c(input$ningunMO,input$minimoMO,input$bajoMO,input$medioMO,input$altoMO,input$ningunCI,input$minimoCI,input$bajoCI,input$medioCI,input$altoCI),nrow=5,ncol=2,dimnames=list(c("ninguno","minimo","bajo","medio","alto"),c("mo","ci")))
  })
  
  observe({
    moi(moi0())
  })
  
  inc.roya <- reactive({
    data.frame(mes=1:12,periodo=c(rep("despues.cosecha",2), rep("antes.cosecha",7),rep("cosecha",3)),inc.historico=DfRoyaHist()$Incidencia)
  })
  
  sp0 <- reactiveVal()
  sp1 <- reactive({
    spi <- data.frame(pais=input$selPais,
                      zona=input$selRegion,
                      tipo.prod=input$tiTipoProductor,
                      altitud=input$niAlt,
                      num.familias=input$niNumFam,
                      tamano.familia=input$niTamFam,
                      ingresos.otros=input$niAhorOtroIngres,
                      gastos.alim.familia=input$niGastAlim,
                      ingreso.min.sost=input$niMargSosten,
                      area.prod=input$niAreaProd,
                      precio.cafe=input$niPrecioVentaCafe,
                      rendimiento.esperado=input$niRedimCafeOro,
                      nivel.manejo=input$tiNivManejo,
                      costo.1tratamientoRoya=input$niCostoTratam,
                      costos.indirectos=input$niCostoIndirect,
                      nivel.costo.insumos=input$tiNivCostoInsum,
                      costos.prod.otros=input$niOtroCostoProd,
                      num.peones.perm=input$niMumPeones,
                      salario.peon=input$niSueldoMinCampo,
                      dq.mo.cosecha=input$niCosecha,
                      salario.jornal=input$niSalarDiaJornal,
                      mo.familiar=input$niManoObraFam,
                      dm.mo.familiar=input$niDiasMesMOfam,
                      precio.tierra=input$niPrecioTierra,
                      salario.min.ciudad=input$niSueldoMinCiudad,
                      salario.min.rural=input$niSueldoMinCampo,
                      canasta.basica.pp=input$niCanastaBasica,
                      precio.int.cafe=90,
                      rendimiento.esperado=input$niRedimCafeOro,
                      num.peones.perm=input$niMumPeones,
                      nivel.manejo=input$tiNivManejo,
                      nivel.costo.insumos=input$tiNivCostoInsum)
    spi
  })
  sp <- reactive({
    spi <- data.frame(pais=input$selPais,
                      zona=input$selRegion,
                      tipo.prod=input$tiTipoProductor,
                      altitud=input$niAlt,
                      num.familias=input$niNumFam,
                      tamano.familia=input$niTamFam,
                      ingresos.otros=input$niAhorOtroIngres,
                      gastos.alim.familia=input$niGastAlim,
                      ingreso.min.sost=input$niMargSosten,
                      area.prod=input$niAreaProd,
                      precio.cafe=input$niPrecioVentaCafe,
                      rendimiento.esperado=input$niRedimCafeOro,
                      nivel.manejo=input$tiNivManejo,
                      costo.1tratamientoRoya=input$niCostoTratam,
                      costos.indirectos=input$niCostoIndirect,
                      nivel.costo.insumos=input$tiNivCostoInsum,
                      costos.prod.otros=input$niOtroCostoProd,
                      num.peones.perm=input$niMumPeones,
                      salario.peon=input$niSueldoMinCampo,
                      dq.mo.cosecha=input$niCosecha,
                      salario.jornal=input$niSalarDiaJornal,
                      mo.familiar=input$niManoObraFam,
                      dm.mo.familiar=input$niDiasMesMOfam,
                      num.mes.cosecha=sum(inc.roya()$periodo=="cosecha"),
                      precio.tierra=input$niPrecioTierra,
                      salario.min.ciudad=input$niSueldoMinCiudad,
                      salario.min.rural=input$niSueldoMinCampo,
                      canasta.basica.pp=input$niCanastaBasica,
                      precio.int.cafe=90,
                      rendimiento.esperado=input$niRedimCafeOro,
                      num.peones.perm=input$niMumPeones,
                      nivel.manejo=input$tiNivManejo,
                      nivel.costo.insumos=input$tiNivCostoInsum)
    
    #insertar roya histrorica y fenologia en el sistema de producción
    for(i in 1:12){spi[[paste("inc.roya.",i,sep="")]] <- as.numeric(inc.roya()[i,3])}
    for(i in 1:12){spi[[paste("periodo.",i,sep="")]] <- as.character(inc.roya()[i,2]) }
    spi
  })
  
  observe({
    sp0(sp1())
  })
  
  txir <- reactive({ 
    txRoya(sp(), md=0.5,mf=1.2, mc=1.6) 
  })
  
  indic.sp <- reactive({ 
    indic <- indicEcoAll(sp(),moi(),nci,txir(),mes=mes(),inc=input$incObs,condiciones(),anio=pronostico())
    indic
  })
  
  proRoyaDF <- reactive({
    proRoya(txir(),mes=mes(),inc=input$incObs,doPlot=F)
  })
  
  observe({
    tryCatch({if(nrow(indic.sp())>0)
    {
      html("maxRoyaBase",paste(round(as.numeric(as.character(indic.sp()['linea.base','maxRoya']))), "%",sep = " "))
      #runjs(paste("window.alert('",round(as.numeric(as.character(indic.sp()['linea.base','maxRoya']))),"')",sep=""))
      if(indic.sp()["linea.base","periodo"]=="antes_cosecha"){
        runjs("$('#maxRoyaBase').css({'background-color':'#139feb','color':''});")
        if(round(as.numeric(as.character(indic.sp()["linea.base","maxRoya"]))) >= 3 & round(as.numeric(as.character(indic.sp()["linea.base","maxRoya"]))) < 5) {
          runjs("$('#maxRoyaBase').css({'background-color':'#5bff27', 'color':'#000');")
        }
        if(round(as.numeric(as.character(indic.sp()["linea.base","maxRoya"]))) >= 5 & round(as.numeric(as.character(indic.sp()["linea.base","maxRoya"]))) < 10) {
          runjs("$('#maxRoyaBase').css({'background-color':'#ffff0a','color':'#000'});")
        }
        if(round(as.numeric(as.character(indic.sp()["linea.base","maxRoya"]))) >= 10 & round(as.numeric(as.character(indic.sp()["linea.base","maxRoya"]))) < 20) {
          runjs("$('#maxRoyaBase').css({'background-color':'#fdb409','color':'#fff'});")
        }
        if(round(as.numeric(as.character(indic.sp()["linea.base","maxRoya"]))) >= 20) {
          runjs("$('#maxRoyaBase').css({'background-color':'#fb0007','color':'#fff'});")
        }
      } else {
        runjs("$('#maxRoyaBase').css({'background-color':'#139feb','color':'#fff'});")
        if(round(as.numeric(as.character(indic.sp()["linea.base","maxRoya"]))) >= 5 & round(as.numeric(as.character(indic.sp()["linea.base","maxRoya"]))) < 15) {
          runjs("$('#maxRoyaBase').css({'background-color':'#5bff27','color':'#000'});")
        }
        if(round(as.numeric(as.character(indic.sp()["linea.base","maxRoya"]))) >= 15 & round(as.numeric(as.character(indic.sp()["linea.base","maxRoya"]))) < 20) {
          runjs("$('#maxRoyaBase').css({'background-color':'#ffff0a','color':'#000'});")
        }
        if(round(as.numeric(as.character(indic.sp()["linea.base","maxRoya"]))) >= 20 & round(as.numeric(as.character(indic.sp()["linea.base","maxRoya"]))) < 30) {
          runjs("$('#maxRoyaBase').css({'background-color':'#fdb409','color':'#fff'});")
        }
        if(round(as.numeric(as.character(indic.sp()["linea.base","maxRoya"]))) >= 30) {
          runjs("$('#maxRoyaBase').css({'background-color':'#fb0007','color':'#fff'});")
        }
      }
      html("maxRoyaTendencial",paste(round(as.numeric(as.character(indic.sp()["tendencial","maxRoya"]))),"%",sep=" "))
      if(indic.sp()["linea.base","periodo"]=="antes_cosecha"){
        runjs("$('#maxRoyaTendencial').css({'background-color':'#139feb','color':'#fff'});")
        if(round(as.numeric(as.character(indic.sp()["tendencial","maxRoya"]))) >= 3 & round(as.numeric(as.character(indic.sp()["tendencial","maxRoya"]))) < 5) {
          runjs("$('#maxRoyaTendencial').css({'background-color':'#5bff27','color':'#000'});")
        }
        if(round(as.numeric(as.character(indic.sp()["tendencial","maxRoya"]))) >= 5 & round(as.numeric(as.character(indic.sp()["tendencial","maxRoya"]))) < 10) {
          runjs("$('#maxRoyaTendencial').css({'background-color':'#ffff0a','color':'#000'});")
        }
        if(round(as.numeric(as.character(indic.sp()["tendencial","maxRoya"]))) >= 10 & round(as.numeric(as.character(indic.sp()["tendencial","maxRoya"]))) < 20) {
          runjs("$('#maxRoyaTendencial').css({'background-color':'#fdb409','color':'#fff'});")
        }
        if(round(as.numeric(as.character(indic.sp()["tendencial","maxRoya"]))) >= 20) {
          runjs("$('#maxRoyaTendencial').css({'background-color':'#fb0007','color':'#fff'});")
        }
      } else {
        runjs("$('#maxRoyaTendencial').css({'background-color':'#139feb','color':'#fff'});")
        if(round(as.numeric(as.character(indic.sp()["tendencial","maxRoya"]))) >= 5 & round(as.numeric(as.character(indic.sp()["tendencial","maxRoya"]))) < 15) {
          runjs("$('#maxRoyaTendencial').css({'background-color':'#5bff27','color':'#000'});")
        }
        if(round(as.numeric(as.character(indic.sp()["tendencial","maxRoya"]))) >= 15 & round(as.numeric(as.character(indic.sp()["tendencial","maxRoya"]))) < 20) {
          runjs("$('#maxRoyaTendencial').css({'background-color':'#ffff0a','color':'#000'});")
        }
        if(round(as.numeric(as.character(indic.sp()["tendencial","maxRoya"]))) >= 20 & round(as.numeric(as.character(indic.sp()["tendencial","maxRoya"]))) < 30) {
          runjs("$('#maxRoyaTendencial').css({'background-color':'#fdb409','color':'#fff'});")
        }
        if(round(as.numeric(as.character(indic.sp()["tendencial","maxRoya"]))) >= 30) {
          runjs("$('#maxRoyaTendencial').css({'background-color':'#fb0007','color':'#fff'});")
        }
      }
      html("maxRoyaManejo",paste(round(as.numeric(as.character(indic.sp()["con.tratamiento.adaptativo","maxRoya"]))),"%",sep=" "))
      if(indic.sp()["linea.base","periodo"]=="antes_cosecha"){
        runjs("$('#maxRoyaManejo').css({'background-color':'#139feb','color':'#fff'});")
        if(round(as.numeric(as.character(indic.sp()["con.tratamiento.adaptativo","maxRoya"]))) >= 3 & round(as.numeric(as.character(indic.sp()["con.tratamiento.adaptativo","maxRoya"]))) < 5) {
          runjs("$('#maxRoyaManejo').css({'background-color':'#5bff27','color':'#000'});")
        }
        if(round(as.numeric(as.character(indic.sp()["con.tratamiento.adaptativo","maxRoya"]))) >= 5 & round(as.numeric(as.character(indic.sp()["con.tratamiento.adaptativo","maxRoya"]))) < 10) {
          runjs("$('#maxRoyaManejo').css({'background-color':'#ffff0a','color':'#000'});")
        }
        if(round(as.numeric(as.character(indic.sp()["con.tratamiento.adaptativo","maxRoya"]))) >= 10 & round(as.numeric(as.character(indic.sp()["con.tratamiento.adaptativo","maxRoya"]))) < 20) {
          runjs("$('#maxRoyaManejo').css({'background-color':'#fdb409','color':'#fff'});")
        }
        if(round(as.numeric(as.character(indic.sp()["con.tratamiento.adaptativo","maxRoya"]))) >= 20) {
          runjs("$('#maxRoyaManejo').css({'background-color':'#fb0007','color':'#fff'});")
        }
      } else {
        runjs("$('#maxRoyaManejo').css({'background-color':'#139feb','color':'#fff'});")
        if(round(as.numeric(as.character(indic.sp()["con.tratamiento.adaptativo","maxRoya"]))) >= 5 & round(as.numeric(as.character(indic.sp()["con.tratamiento.adaptativo","maxRoya"]))) < 15) {
          runjs("$('#maxRoyaManejo').css({'background-color':'#5bff27','color':'#000'});")
        }
        if(round(as.numeric(as.character(indic.sp()["con.tratamiento.adaptativo","maxRoya"]))) >= 15 & round(as.numeric(as.character(indic.sp()["con.tratamiento.adaptativo","maxRoya"]))) < 20) {
          runjs("$('#maxRoyaManejo').css({'background-color':'#ffff0a','color':'#000'});")
        }
        if(round(as.numeric(as.character(indic.sp()["con.tratamiento.adaptativo","maxRoya"]))) >= 20 & round(as.numeric(as.character(indic.sp()["con.tratamiento.adaptativo","maxRoya"]))) < 30) {
          runjs("$('#maxRoyaManejo').css({'background-color':'#fdb409','color':'#fff'});")
        }
        if(round(as.numeric(as.character(indic.sp()["con.tratamiento.adaptativo","maxRoya"]))) >= 30) {
          runjs("$('#maxRoyaManejo').css({'background-color':'#fb0007','color':'#fff'});")
        }
      }
      html("margenBase",paste(round(as.numeric(as.character(indic.sp()["linea.base","margen"]))),unidadesPais()$unidaddinero,sep=" "))
      if(round(as.numeric(as.character(indic.sp()["linea.base","margen"])))<0) {
        runjs("$('#margenBase').css({'background-color':'#fb0007','color':'#fff'});")
      } else if(round(as.numeric(as.character(indic.sp()["linea.base","margen"])))<round(as.numeric(as.character(indic.sp()["linea.base","umbral"])))) {
        runjs("$('#margenBase').css({'background-color':'#fdb409','color':'#fff'});")
      } else {
        runjs("$('#margenBase').css({'background-color':'#38ab07','color':'#fff'});")
      }
      html("margenTendencial",paste(round(as.numeric(as.character(indic.sp()["tendencial","margen"]))),unidadesPais()$unidaddinero,sep=" "))
      if(round(as.numeric(as.character(indic.sp()["tendencial","margen"])))<0) {
        runjs("$('#margenTendencial').css({'background-color':'#fb0007','color':'#fff'});")
      } else if(round(as.numeric(as.character(indic.sp()["tendencial","margen"])))<round(as.numeric(as.character(indic.sp()["linea.base","umbral"])))) {
        runjs("$('#margenTendencial').css({'background-color':'#fdb409','color':'#fff'});")
      } else {
        runjs("$('#margenTendencial').css({'background-color':'#38ab07','color':'#fff'});")
      }
      html("margenManejo",paste(round(as.numeric(as.character(indic.sp()["con.tratamiento.adaptativo","margen"]))),unidadesPais()$unidaddinero,sep=" "))
      if(round(as.numeric(as.character(indic.sp()["con.tratamiento.adaptativo","margen"])))<0) {
        runjs("$('#margenManejo').css({'background-color':'#fb0007','color':'#fff'});")
      } else if(round(as.numeric(as.character(indic.sp()["con.tratamiento.adaptativo","margen"])))<round(as.numeric(as.character(indic.sp()["linea.base","umbral"])))) {
        runjs("$('#margenManejo').css({'background-color':'#fdb409','color':'#fff'});")
      } else {
        runjs("$('#margenManejo').css({'background-color':'#38ab07','color':'#fff'});")
      }
      html("sanBase",round(as.numeric(as.character(indic.sp()["linea.base","san.pp"])),digits=1))
      if(round(as.numeric(as.character(indic.sp()["linea.base","san.pp"])),digits=1)<1.3) {
        runjs("$('#sanBase').css({'background-color':'#fb0007','color':'#fff'});")
      } else if(round(as.numeric(as.character(indic.sp()["linea.base","san.pp"])),digits=1)<1.7) {
        runjs("$('#sanBase').css({'background-color':'#ffff0a','color':'#000'});")
      } else if(round(as.numeric(as.character(indic.sp()["linea.base","san.pp"])),digits=1)<2.5) {
        runjs("$('#sanBase').css({'background-color':'#fdb409','color':'#fff'});")
      } else {
        runjs("$('#sanBase').css({'background-color':'#38ab07','color':'#fff'});")
      }
      html("sanTendencial",round(as.numeric(as.character(indic.sp()["tendencial","san.pp"])),digits=1))
      if(round(as.numeric(as.character(indic.sp()["tendencial","san.pp"])),digits=1)<1.3) {
        runjs("$('#sanTendencial').css({'background-color':'#fb0007','color':'#fff'});")
      } else if(round(as.numeric(as.character(indic.sp()["tendencial","san.pp"])),digits=1)<1.7) {
        runjs("$('#sanTendencial').css({'background-color':'#ffff0a','color':'#000'});")
      } else if(round(as.numeric(as.character(indic.sp()["tendencial","san.pp"])),digits=1)<2.5) {
        runjs("$('#sanTendencial').css({'background-color':'#fdb409','color':'#fff'});")
      } else {
        runjs("$('#sanTendencial').css({'background-color':'#38ab07','color':'#fff'});")
      }
      html("sanManejo",round(as.numeric(as.character(indic.sp()["con.tratamiento.adaptativo","san.pp"])),digits=1))
      if(round(as.numeric(as.character(indic.sp()["con.tratamiento.adaptativo","san.pp"])),digits=1)<1.3) {
        runjs("$('#sanManejo').css({'background-color':'#fb0007','color':'#fff'});")
      } else if(round(as.numeric(as.character(indic.sp()["con.tratamiento.adaptativo","san.pp"])),digits=1)<1.7) {
        runjs("$('#sanManejo').css({'background-color':'#ffff0a','color':'#000'});")
      } else if(round(as.numeric(as.character(indic.sp()["con.tratamiento.adaptativo","san.pp"])),digits=1)<2.5) {
        runjs("$('#sanManejo').css({'background-color':'#fdb409','color':'#fff'});")
      } else {
        runjs("$('#sanManejo').css({'background-color':'#38ab07','color':'#fff'});")
      }
      html("preciosostcafeBase",paste(round(as.numeric(as.character(indic.sp()["linea.base","precio.cafe.min.sost"])))," ",unidadesPais()$unidaddinero,"/",unidadesPais()$unidadmedidacafe,sep=""))
      html("preciosostcafeTendencial",paste(round(as.numeric(as.character(indic.sp()["tendencial","precio.cafe.min.sost"])))," ",unidadesPais()$unidaddinero,"/",unidadesPais()$unidadmedidacafe,sep=""))
      html("preciosostcafeManejo",paste(round(as.numeric(as.character(indic.sp()["con.tratamiento.adaptativo","precio.cafe.min.sost"])))," ",unidadesPais()$unidaddinero,"/",unidadesPais()$unidadmedidacafe,sep=""))
      html("ingresosBase",paste(round(as.numeric(as.character(indic.sp()["linea.base","ingresosTotal"]))),unidadesPais()$unidaddinero,sep=" "))
      html("ingresosTendencial",paste(round(as.numeric(as.character(indic.sp()["tendencial","ingresosTotal"]))),unidadesPais()$unidaddinero,sep=" "))
      html("ingresosManejo",paste(round(as.numeric(as.character(indic.sp()["con.tratamiento.adaptativo","ingresosTotal"]))),unidadesPais()$unidaddinero,sep=" "))
      html("valoragregadoBase",paste(round(as.numeric(as.character(indic.sp()["linea.base","valor.agregado"]))),unidadesPais()$unidaddinero,sep = " "))
      html("valoragregadoTendencial",paste(round(as.numeric(as.character(indic.sp()["tendencial","valor.agregado"]))),unidadesPais()$unidaddinero,sep = " "))
      html("valoragregadoManejo",paste(round(as.numeric(as.character(indic.sp()["con.tratamiento.adaptativo","valor.agregado"]))),unidadesPais()$unidaddinero,sep=" "))
      html("valoragregadoRBase",paste(round(as.numeric(as.character(indic.sp()["linea.base","valor.agregado.R"]))/1000000),"M",unidadesPais()$unidaddinero,sep = " "))
      html("valoragregadoRTendencial",paste(round(as.numeric(as.character(indic.sp()["tendencial","valor.agregado.R"]))/1000000),"M",unidadesPais()$unidaddinero,sep = " "))
      html("valoragregadoRManejo",paste(round(as.numeric(as.character(indic.sp()["con.tratamiento.adaptativo","valor.agregado.R"]))/1000000),"M",unidadesPais()$unidaddinero,sep = " "))
      
      html("costoopjornalBase",round(as.numeric(as.character(indic.sp()["linea.base","costo.op.jornal"])),digits = 1))
      if(round(as.numeric(as.character(indic.sp()["linea.base","costo.op.jornal"])),digits = 1)<3) {
        runjs("$('#costoopjornalBase').css({'background-color':'#38ab07','color':'#fff'});")
      } else if(round(as.numeric(as.character(indic.sp()["linea.base","costo.op.jornal"])),digits = 1)<5) {
        runjs("$('#costoopjornalBase').css({'background-color':'#ffff0a','color':'#000'});")
      } else {
        runjs("$('#costoopjornalBase').css({'background-color':'#fb0007','color':'#fff'});")
      }
      html("costoopjornalTendencial",round(as.numeric(as.character(indic.sp()["tendencial","costo.op.jornal"])),digits = 1))
      if(round(as.numeric(as.character(indic.sp()["tendencial","costo.op.jornal"])),digits = 1)<3) {
        runjs("$('#costoopjornalTendencial').css({'background-color':'#38ab07','color':'#fff'});")
      } else if(round(as.numeric(as.character(indic.sp()["tendencial","costo.op.jornal"])),digits = 1)<5) {
        runjs("$('#costoopjornalTendencial').css({'background-color':'#ffff0a','color':'#000'});")
      } else {
        runjs("$('#costoopjornalTendencial').css({'background-color':'#fb0007','color':'#fff'});")
      }
      html("costoopjornalManejo",round(as.numeric(as.character(indic.sp()["con.tratamiento.adaptativo","costo.op.jornal"])),digits = 1))
      if(round(as.numeric(as.character(indic.sp()["con.tratamiento.adaptativo","costo.op.jornal"])),digits = 1)<3) {
        runjs("$('#costoopjornalManejo').css({'background-color':'#38ab07','color':'#fff'});")
      } else if(round(as.numeric(as.character(indic.sp()["con.tratamiento.adaptativo","costo.op.jornal"])),digits = 1)<5) {
        runjs("$('#costoopjornalManejo').css({'background-color':'#ffff0a','color':'#000'});")
      } else {
        runjs("$('#costoopjornalManejo').css({'background-color':'#fb0007','color':'#fff'});")
      }
      html("costoopciudadBase",round(as.numeric(as.character(indic.sp()["linea.base","costo.op.ciudad"])),digits = 1))
      if(round(as.numeric(as.character(indic.sp()["linea.base","costo.op.jornal"])),digits = 1)<3) {
        runjs("$('#costoopciudadBase').css({'background-color':'#38ab07','color':'#fff'});")
      } else if(round(as.numeric(as.character(indic.sp()["linea.base","costo.op.jornal"])),digits = 1)<5) {
        runjs("$('#costoopciudadBase').css({'background-color':'#ffff0a','color':'#000'});")
      } else {
        runjs("$('#costoopciudadBase').css({'background-color':'#fb0007','color':'#fff'});")
      }
      html("costoopciudadTendencial",round(as.numeric(as.character(indic.sp()["tendencial","costo.op.ciudad"])),digits = 1))
      if(round(as.numeric(as.character(indic.sp()["tendencial","costo.op.jornal"])),digits = 1)<3) {
        runjs("$('#costoopciudadTendencial').css({'background-color':'#38ab07','color':'#fff'});")
      } else if(round(as.numeric(as.character(indic.sp()["tendencial","costo.op.jornal"])),digits = 1)<5) {
        runjs("$('#costoopciudadTendencial').css({'background-color':'#ffff0a','color':'#000'});")
      } else {
        runjs("$('#costoopciudadTendencial').css({'background-color':'#fb0007','color':'#fff'});")
      }
      html("costoopciudadManejo",round(as.numeric(as.character(indic.sp()["con.tratamiento.adaptativo","costo.op.ciudad"])),digits = 1))
      if(round(as.numeric(as.character(indic.sp()["con.tratamiento.adaptativo","costo.op.jornal"])),digits = 1)<3) {
        runjs("$('#costoopciudadManejo').css({'background-color':'#38ab07','color':'#fff'});")
      } else if(round(as.numeric(as.character(indic.sp()["con.tratamiento.adaptativo","costo.op.jornal"])),digits = 1)<5) {
        runjs("$('#costoopciudadManejo').css({'background-color':'#ffff0a','color':'#000'});")
      } else {
        runjs("$('#costoopciudadManejo').css({'background-color':'#fb0007','color':'#fff'});")
      }
      html("jornalesBase",paste(round(as.numeric(as.character(indic.sp()["linea.base","num.jornales"]))),"dias",sep = " "))
      html("jornalesTendencial",paste(round(as.numeric(as.character(indic.sp()["tendencial","num.jornales"]))),"dias",sep = " "))
      html("jornalesManejo",paste(round(as.numeric(as.character(indic.sp()["con.tratamiento.adaptativo","num.jornales"]))),"dias",sep = " "))
    }},
    warning = function(err) {},
    error = function(err) {},
    finally = function() {})
  })
  
  ### Descargas y Subidas ###
  output$sistemaDescargar <- downloadHandler(
    filename <- function(){
      paste(input$selPais,"_",input$selRegion,"_",Sys.Date(),".RData",sep="")
    },
    
    content = function(file) {
      sp <- sp0()
      rh <- DfRoyaHist()
      mo <- moi()
      sistemaProductivo <- list(sp,rh,mo)
      names(sistemaProductivo) <- c("sp","rh","mo")
      save(sistemaProductivo, file = file)
    }
  )
  
  #output$sistemaDescargar <- downloadHandler(
  #  filename <- function(){
  #    paste("sistemaproductivo.RData")
  #  },
    
  #  content = function(file) {
  #    sistemaProductivo <- sp0()
  #    save(sistemaProductivo, file = file)
  #  }
  #)
  
  #output$royaDescargar <- downloadHandler(
  #  filename <- function(){
  #    paste("royahistorica.RData")
  #  },
    
  #  content = function(file) {
  #    royaHistorica <- DfRoyaHist()
  #    save(royaHistorica, file = file)
  #  }
  #)
  
  #output$moDescargar <- downloadHandler(
  #  filename <- function(){
  #    paste("manoDeObra.RData")
  #  },
    
  #  content = function(file) {
  #    manoDeObra <- moi()
  #    save(manoDeObra, file = file)
  #  }
  #)
  
  importSistemaProd <- reactiveVal()
  
  observe({
    if ( is.null(input$sistemaUpload)) return(NULL)
    inFile <- input$sistemaUpload
    file <- inFile$datapath
    e = new.env()
    name <- load(file, envir = e)
    data <- e[[name]]
    datasp <- data.frame(data$sp)
    names(datasp) <- c("pais","region","tipoprod","altitud","numfamilias","tamanofamilia","ingresosotros","gastosalimfamilia","ingresominsost","areaprod","preciocafe","rendimientoesperado","nivelmanejo","costo1tratamientoroya","costosindirectos","nivelcostoinsumos","costosprodotros","numpeonesperm","salariopeon","dqmocosecha","salariojornal","mofamiliar","dmmofamiliar","preciotierra","salariominciudad","salariominrural","canastabasicapp")
    importSistemaProd(datasp)
    updateSelectInput(session,"selPais",selected=datasp[1]$pais)
    updateSelectInput(session,"selRegion",choices=filter(regiones,idpais==filter(paises,pais==datasp[1]$pais)$cod_extra)$rrat5,selected=datasp[2]$region)
    selSistemaProduccion(datasp)
    
    datarh <- data.frame(data$rh)
    DfRoyaHist(datarh)
    output$hot <- renderExcel({
      colonnes <- data.frame(readOnly = c(TRUE, FALSE, FALSE), width = 100)
      excelTable(DfRoyaHist(), columns = colonnes)
    })
    
    datamo <- data.frame(data$mo)
    updateNumericInput(session,"ningunMO",value=datamo["ninguno","mo"])
    updateNumericInput(session,"minimoMO",value=datamo["minimo","mo"])
    updateNumericInput(session,"bajoMO",value=datamo["bajo","mo"])
    updateNumericInput(session,"medioMO",value=datamo["medio","mo"])
    updateNumericInput(session,"altoMO",value=datamo["alto","mo"])
    
    updateNumericInput(session,"ningunCI",value=datamo["ninguno","ci"])
    updateNumericInput(session,"minimoCI",value=datamo["minimo","ci"])
    updateNumericInput(session,"bajoCI",value=datamo["bajo","ci"])
    updateNumericInput(session,"medioCI",value=datamo["medio","ci"])
    updateNumericInput(session,"altoCI",value=datamo["alto","ci"])
  })
  
  #observe({
  #  if ( is.null(input$royaUpload)) return(NULL)
  #  inFile <- input$royaUpload
  #  file <- inFile$datapath
  #  e = new.env()
  #  name <- load(file, envir = e)
  #  data <- e[[name]]
  #  data <- data.frame(data)
  #  DfRoyaHist(data)
  #  output$hot <- renderExcel({
  #    colonnes <- data.frame(readOnly = c(TRUE, FALSE, FALSE), width = 100)
  #    excelTable(DfRoyaHist(), columns = colonnes)
  #  })
  #})
  
  #observe({
  #  if ( is.null(input$moUpload)) return(NULL)
  #  inFile <- input$moUpload
  #  file <- inFile$datapath
  #  e = new.env()
  #  name <- load(file, envir = e)
  #  data <- e[[name]]
  #  data <- data.frame(data)
  #  updateNumericInput(session,"ningunMO",value=data["ninguno","mo"])
  #  updateNumericInput(session,"minimoMO",value=data["minimo","mo"])
  #  updateNumericInput(session,"bajoMO",value=data["bajo","mo"])
  #  updateNumericInput(session,"medioMO",value=data["medio","mo"])
  #  updateNumericInput(session,"altoMO",value=data["alto","mo"])
    
  #  updateNumericInput(session,"ningunCI",value=data["ninguno","ci"])
  #  updateNumericInput(session,"minimoCI",value=data["minimo","ci"])
  #  updateNumericInput(session,"bajoCI",value=data["bajo","ci"])
  #  updateNumericInput(session,"medioCI",value=data["medio","ci"])
  #  updateNumericInput(session,"altoCI",value=data["alto","ci"])
    
  #})
}
