server <- function(input, output, session) {
  
  # Tabla Sistema de produccion
  
  values <- reactiveValues()
  
  # observeEvent(input$guardarButton, {
  #   
  #   toto <-reactiveValuesToList(input)
  #   inputNames <- names(toto)
  #   # buttons <- grep("^actionButton",inputNames,value=TRUE)
  #   # toto[buttons] <- NULL
  #   guardar <- grep("^(ni|ti)",inputNames,value=T)
  #   toto <- toto[guardar]
  #   toto$hot <- rv$DfRoyaHist
  #   print(toto)
  #   saveRDS(toto,file="toto.RDS")
  # })
  output$guardarButton <- downloadHandler("suArchivo.rds", function(file) {
    toto <-reactiveValuesToList(input)
    inputNames <- names(toto)
    guardar <- grep("^(ni|ti)",inputNames,value=T)
    toto <- toto[guardar]
    toto$hot <- rv$DfRoyaHist
    saveRDS(toto,file=file)
  },"application/octet-stream")
  
  
  # ## Charger les donnees de sistema de prod
  
  observeEvent(input$actionButtonCargarSistemaProd, {
    toto <- readRDS(input$actionButtonCargarSistemaProd$datapath)
    niNames <- grep("^ni",names(toto),value=T)
    for(ni in niNames){
      updateNumericInput(session,inputId = ni,value = toto[[ni]])
    }
    
    tiNames <- grep("^ti",names(toto),value=T)
    for(ti in tiNames){
      updateNumericInput(session,inputId = ti,value = toto[[ti]])
    }
    rv$DfRoyaHist <- toto$hot
    
  })
  
  # uploadDfAll <- reactive({
  #   inFile <- input$loadDfRoyaHist
  #   
  #   if (is.null(inFile))
  #     return(NULL)
  #   
  #  readRDS(inFile$datapath)
  # })
  
  # Title Roya historica  -------------------------------
  
  output$nombre_region <- renderText({
    input$region
  })
  
  output$nombre_tipoProductor <- renderText({
    input$tipoProductor
  })
  
  
  
  # Plot Roya Historica --------------------------------
  
  
  ## Table roya historica
  
  rv <- reactiveValues(
    DfRoyaHist = {
      data.frame(
        Mes=c("enero","febrero","marzo","abril","mayo", "junio", "julio",
              "agosto","setiembre","octubre","noviembre","diciembre"),
        Incidencia=c(20,12,4,1,1,4,8,15,25,35,39,40),
        Cosecha = TRUE
      )
    }
  )
  
  
  
  # # observe({
  # data <- reactive({
  #   
  #   if (!is.null(input$hot)) {
  #     rv$DfRoyaHist = hot_to_r(input$hot)
  #   } else {
  #     if (is.null(values[["rv$DfRoyaHist"]])){
  #       rv$DfRoyaHist <- rv$DfRoyaHist
  #     } else {
  #       rv$DfRoyaHist <- values[["rv$DfRoyaHist"]]
  #     }
  #   }
  #   values[["rv$DfRoyaHist"]] <- rv$DfRoyaHist
  #   rv$DfRoyaHist
  # })
  
  output$hot <- renderExcel({
    colonnes <- data.frame(readOnly = c(TRUE, FALSE, FALSE), width = 100)
    excelTable(rv$DfRoyaHist, columns = colonnes)
  })
  
  observeEvent(input$hot,{rv$DfRoyaHist <- excel_to_R(input$hot)})
  
  # output$tableTest <- renderTable({
  #   uploadDfAll()[[2]]
  # })
  # 
  
  # output$hot <- renderRHandsontable({
  #   rv$DfRoyaHist <- data()
  #   if(!is.null(rv$DfRoyaHist))
  #     rhandsontable(rv$DfRoyaHist, rowHeaders = NULL,stretchH = "all")
  # })
  
  
  
  DfPourPlot <- reactive({
    values[["rv$DfRoyaHist"]]
  })
  
  
  ## Plot roya historica
  
  output$plotRoyaHist <- renderPlot({
    
    ggplot() +
      geom_line(data=rv$DfRoyaHist, aes(x=1:12,y=Incidencia),size=2,linetype = "dashed")+
      scale_x_continuous(name = "",
                         breaks=seq(1, 12, 1),
                         labels=c("enero","febrero","marzo","abril","mayo", "junio", "julio",
                                  "agosto","setiembre","octubre","noviembre","diciembre"))+
      scale_y_continuous(name = "")+
      ggtitle("Incidencia de roya (promedio historico)")+
      theme_bw()+
      theme(
        plot.title = element_text(size=20, face="bold",hjust = 0.5),
        axis.text.x  = element_text(angle=45, vjust=0.5, size=16),
        axis.text.y  = element_text(size=16),
        legend.position="none",
        panel.grid.minor = element_blank(),
        strip.background = element_blank())+
      theme(legend.title=element_blank())
    
    
  })
  
  
  
  
  # Pronostico -----------------------------------
  
  
  ## Plot roya Vigilancia (historico)
  ##ojo no se usa sp en este caso, pero debriamos hay que usar los campos de roya historico en SP
  
  
  output$plotVigilancia <- renderPlot({
    ggplot() +
      geom_line(data=rv$DfRoyaHist, aes(x=1:12,y=Incidencia),size=2,linetype = "dashed")+
      scale_x_continuous(name = "",
                         breaks=seq(1, 12, 1),
                         labels=c("enero","febrero","marzo","abril","mayo", "junio", "julio",
                                  "agosto","setiembre","octubre","noviembre","diciembre"))+
      scale_y_continuous(name = "")+
      ggtitle("Incidencia de roya")+
      theme_bw()+
      theme(
        plot.title = element_text(size=20, face="bold",hjust = 0.5),
        axis.text.x  = element_text(angle=45, vjust=0.5, size=16),
        axis.text.y  = element_text(size=16),
        legend.position="none",
        panel.grid.minor = element_blank(),
        strip.background = element_blank())+
      theme(legend.title=element_blank())
  })
  
  #agregar las otras curvas.  La funcion pronosticoRoya  produce las curvas cuando se usa doPlot=T
  #pronosticoRoya <- proRoya(txir,mes=2,inc=5,doPlot=T) #ok por fin...
  
  
  
  #aqui los box con los valores de indicadores (no es eficiente deberiamios calcular una sola vez)
  #ojo no esta usando las tablas de eontrada shiny creo...
  
  output$ecoBox1 <- renderValueBox({
    m <- mesNum(input$mesObs)
    i <- as.numeric(input$incObs)
    temp <- indicEco(sp, moi, nci, txir,m,i,condPro(input$condPro),anio=1)
    valor <- as.character(round(as.numeric(as.character(temp$costo.op.jornal)),2))
    valueBox(valor,"Costo de oportunidad jornaleo", icon = icon("leaf", lib = "glyphicon"),
             color = "yellow"
    )
  })
  
  output$ecoBox2 <- renderValueBox({
    m <- mesNum(input$mesObs)
    i <- as.numeric(input$incObs)
    temp <- indicEco(sp,moi, nci,txir,m,i,condPro(input$condPro),anio=1)
    valor <- as.character(round(as.numeric(as.character(temp$precio.cafe.min.sost)),2))
    valueBox(valor,"Precio.cafe.sost", icon = icon("new-window", lib = "glyphicon"),
             color = "blue"
    )
  })
  
}
