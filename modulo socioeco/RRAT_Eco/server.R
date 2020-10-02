server <- function(input, output, session) {
  
  # Tabla Sistema de produccion
  
  selRegiones <- reactive({
    filter(regiones,idpais==filter(paises,pais==input$selPais)$cod_extra)$rrat5 
  })
  
  selSistemaProduccion <- reactive({
    filter(varsocioeco,region==input$selRegion)
  })
  
  costoManejoPais <- reactive({
    filter(costomanejo,cod_pais==filter(paises,pais==input$selPais)$cod_pais)
  })
  
  observe({
    updateSelectInput(session, "selRegion",
                      choices = selRegiones()
  )})
  
  observe({
    updateNumericInput(session,"niAlt",value=selSistemaProduccion()$altitud)
    updateTextInput(session,"tiTipoProductor",value=selSistemaProduccion()$tipoprod)
    updateNumericInput(session,"niNumFam",value=selSistemaProduccion()$numfamilias)
    updateNumericInput(session,"niTamFam",value=selSistemaProduccion()$tamanofamilia)
    updateNumericInput(session,"niGastAlim",value=selSistemaProduccion()$gastosalimfamilia)
    updateNumericInput(session,"niAhorOtroIngres",value=selSistemaProduccion()$ingresosotros)
    updateNumericInput(session,"niMargSosten",value=selSistemaProduccion()$ingresominsost)
    updateNumericInput(session,"niAreaProd",value=selSistemaProduccion()$areaprod)
    updateNumericInput(session,"niRedimCafeOro",value=selSistemaProduccion()$rendimientoesperado)
    updateNumericInput(session,"niPrecioVentaCafe",value=selSistemaProduccion()$preciocafe)
    updateTextInput(session,"tiNivManejo",value=selSistemaProduccion()$nivelmanejo)
    updateNumericInput(session,"niCostoTratam",value=selSistemaProduccion()$costo1tratamientoroya)
    updateTextInput(session,"tiNivCostoInsum",value=selSistemaProduccion()$nivelcostoinsumos)
    updateNumericInput(session,"niCostoIndirect",value=selSistemaProduccion()$costosindirectos)
    updateNumericInput(session,"niOtroCostoProd", value=selSistemaProduccion()$costosprodotros)
    updateNumericInput(session,"niMumPeones",value=selSistemaProduccion()$numpeonesperm)
    updateNumericInput(session,"niSalarDiaJornal",value=selSistemaProduccion()$salariopeon)
    updateNumericInput(session,"niCosecha",value=selSistemaProduccion()$dqmocosecha)
    updateNumericInput(session,"niManoObraFam",value=selSistemaProduccion()$mofamiliar)
    updateNumericInput(session,"niCanastaBasica",value=selSistemaProduccion()$canastabasicapp)
    updateNumericInput(session,"niPrecioTierra",value=selSistemaProduccion()$preciotierra)
    updateNumericInput(session,"niSueldoMinCiudad",value=selSistemaProduccion()$salariominciudad)
    updateNumericInput(session,"niSueldoMinCampo",value=selSistemaProduccion()$salariominrural)
    updateNumericInput(session,"niDiasMesMOfam",value=selSistemaProduccion()$dmmofamiliar)
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
  
  values <- reactiveValues()
  
  
  # Title Roya historica  -------------------------------
  
  output$nombre_region <- renderText({
    paste("Región: ",input$selRegion,sep="")
  })
  
  output$nombre_tipoProductor <- renderText({
    paste("Tipo de productor: ",input$tiTipoProductor,sep="")
  })
  
  # Plot Roya Historica --------------------------------
  
  ## Table roya historica
  
  DfRoyaHist = reactive({
     filter(royahistorica,region==input$selRegion) %>% select("Mes"=mes,"Incidencia"=incidencia,"Periodo"=periodo)
  })

  output$hot <- renderExcel({
    colonnes <- data.frame(readOnly = c(TRUE, FALSE, FALSE), width = 100)
    excelTable(DfRoyaHist(), columns = colonnes)
  })
  
  observeEvent(input$hot,{DfRoyaHist <- excel_to_R(input$hot)})
  
  DfPourPlot <- reactive({
    values[["rv$DfRoyaHist"]]
  })
  
  ## Plot roya historica
  
  output$plotRoyaHist <- renderPlot({
    
    ggplot() +
      geom_line(data=DfRoyaHist(), aes(x=1:12,y=Incidencia),size=2,linetype = "dashed")+
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
  })
  
  moi <- reactive({
    matrix(c(input$ningunMO,input$minimoMO,input$bajoMO,input$medioMO,input$altoMO,input$ningunCI,input$minimoCI,input$bajoCI,input$medioCI,input$altoCI),nrow=5,ncol=2,dimnames=list(c("ninguno","minimo","bajo","medio","alto"),c("mo","ci")))
  })
  
  inc.roya <- reactive({
    data.frame(mes=1:12,periodo=c(rep("despues.cosecha",2), rep("antes.cosecha",7),rep("cosecha",3)),inc.historico=DfRoyaHist()$Incidencia)
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
                      precio.int.cafe=input$niPrecioVentaCafe,
                      rendimiento.esperado=input$niRedimCafeOro,
                      num.peones.perm=input$niMumPeones,
                      nivel.manejo=input$tiNivManejo,
                      nivel.costo.insumos=input$tiNivCostoInsum)
    
    #insertar roya histrorica y fenologia en el sistema de producción
    for(i in 1:12){spi[[paste("inc.roya.",i,sep="")]] <- as.numeric(inc.roya()[i,3])}
    for(i in 1:12){spi[[paste("periodo.",i,sep="")]] <- as.character(inc.roya()[i,2]) }
    
    spi
  })
  
  txir <- reactive({ 
    txRoya(sp(), md=0.5,mf=1.2, mc=1.6) 
  })
  
  indic.sp <- reactive({ 
    indic <- indicEcoAll(sp(),moi(),nci,txir(),mes=mes(),inc=input$incObs,condiciones(),anio=1)
    indic
  })
  
  proRoyaDF <- reactive({
    proRoya(txir(),mes=mes(),inc=input$incObs,doPlot=F)
  })
  
  output$salida <- renderPrint({ indic.sp() })
}
