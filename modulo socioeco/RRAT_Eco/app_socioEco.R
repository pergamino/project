library(shiny)
library(shinydashboard)
library(ggplot2)
library(rhandsontable)
library(excelR)


#source("saveToDropBox.R")


ui <- dashboardPage(
  
  header <- dashboardHeader(title = "Pronosticos Economicos"),
  
  
  sidebar <- dashboardSidebar(
    sidebarMenu(
      menuItem("Sistema de producción", tabName = "sistemaProd", icon = icon("th")),
      menuItem("Roya historica", tabName = "royaHistorica", icon = icon("th")),
      menuItem("Mano de obra", tabName = "manoObra", icon = icon("th")),
      menuItem("Pronostico", tabName = "pronostico", icon = icon("th"))
    ),
    hr(),
    p("Guardar o Cargar el sistema"),
    p("de Producción actual:"),
    downloadButton("guardarButton", "Guardar"),
   # p("Carga Sistema de Producción"),
    #fileInput("actionButtonCargarSistemaProd", label = NULL)
    fileInput("actionButtonCargarSistemaProd", label="Cargar")
  ),
  
  
  body <- dashboardBody(
    
    tabItems(
     
      # Sistema de produccion ---------------------------------------------------
      
      tabItem(tabName = "sistemaProd",
              
              fluidRow(
                # ########  1ere colone  ######## 
                
                column(width = 4,
                       
                       # 1.1 : Tipología de productor
                       
                       box(
                         title = "Tipología de productor", height = 340, width = NULL, solidHeader = TRUE,
                         color = "green",background = "green",
                         
                         # content
                         
                         fluidRow(
                           column(width = 6,
                                  box(title = tags$p(style = "font-size: 70%;", "Región"), height = 125, width = NULL,background = "green",
                                      textInput("tiRegion",NULL,value="REGION",width="200px")
                                  ),
                                  box(title = tags$p(style = "font-size: 70%;", "Altitud promedio"),height = 125, width = NULL,background = "green",
                                      # textInput("alt",NULL,value=700,width="200px")
                                      numericInput("niAlt", label = NULL, value = 700)
                                  )
                           ),
                           column(width = 6,
                                  box(title = tags$p(style = "font-size: 70%;", "Tipo de productor"),height = 125, width = NULL,background = "green",
                                      textInput("tiTipoProductor",NULL,value="Familiar",width="200px")
                                  ),
                                  box(title = tags$p(style = "font-size: 70%;", "Num. fam. de este tipo en la zona"),height = 125, width = NULL,background = "green",
                                      # textInput("numFam",NULL,NULL,width="200px")
                                      numericInput("niNumFam", label = NULL, value = 3000)
                                  )
                           )
                         )
                       ),
                       
                       # 1.2 : Familia
                       
                       box(
                         title = "Familia", height = 340, width = NULL, solidHeader = TRUE,
                         color = "red",background = "red",
                         
                         # content
                         fluidRow(
                           column(width = 6,
                                  box(title = tags$p(style = "font-size: 70%;", "Tamaño de la familia (num pers)"),height = 125, width = NULL,background = "red",
                                      # textInput("tamFam",NULL,NULL,width="200px")
                                      numericInput("niTamFam", label = NULL, value = 5)
                                  ),
                                  box(title = tags$p(style = "font-size: 70%;", "Gasto de alimentacion familia ($/año)"),height = 125, width = NULL,background = "red",
                                      # textInput("gastAlim",NULL,NULL,width="200px")
                                      numericInput("niGastAlim", label = NULL, value = 1200)
                                  )
                           ),
                           column(width = 6,
                                  box(title = tags$p(style = "font-size: 70%;", "Ahorro u otros ingressos ($/año)"),height = 125, width = NULL,background = "red",
                                      # textInput("ahorOtroIngres",NULL,NULL,width="200px")
                                      numericInput("niAhorOtroIngres", label = NULL, value = 4000)
                                  ),
                                  box(title = tags$p(style = "font-size: 70%;", "Margen minima para sostenibilidad ($/año)"),height = 125, width = NULL,background = "red",
                                      # textInput("margSosten",NULL,NULL,width="200px")
                                      numericInput("niMargSosten", label = NULL, value = 4600)
                                  )
                           )
                         )
                         
                       )
                ),
                
                
                # 2eme colone ######## 
                
                
                
                column(width = 4,
                       
                       # 2.1: Producción de café
                       
                       box(
                         title = "Producción de café", height = 340, width = NULL, solidHeader = TRUE,
                         color = "olive",background = "olive",
                         
                         # content
                         
                         fluidRow(
                           column(width = 6,
                                  box(title = tags$p(style = "font-size: 70%;", "Area de producción (ha)"),height = 125, width = NULL,background = "olive",
                                      # textInput("areaProd",NULL,NULL,width="200px")
                                      numericInput("niAreaProd", label = NULL, value = 2)
                                  ),
                                  box(title = tags$p(style = "font-size: 70%;", "Rendimiento (q/ha) café oro"),height = 125, width = NULL,background = "olive",
                                      # textInput("redimCafeOro",NULL,NULL,width="200px")
                                      numericInput("niRedimCafeOro", label = NULL, value = 10)
                                  )
                           ),
                           column(width = 6,
                                  box(title = tags$p(style = "font-size: 70%;", "Precio de venta del café ($/q)"),height = 125, width = NULL,background = "olive",
                                      # textInput("precioVentaCafe",NULL,NULL,width="200px")
                                      numericInput("niPrecioVentaCafe", label = NULL, value = 50)
                                  ),
                                  box(title = tags$p(style = "font-size: 70%;", "Nivel de manejo"),height = 125, width = NULL,background = "olive",
                                      textInput("tiNivManejo",NULL,value="bajo",width="200px")
                                  )
                           )
                         )
                       ),
                       
                       # 2.2: Sistema de producción: costos
                       # !!!!!!!!!!!!!!!!
                       box(
                         title = "Sistema de producción: costos", height = 340, width = NULL, solidHeader = TRUE,
                         color = "yellow",background = "yellow",
                         
                         # content
                         fluidRow(
                           column(width = 6,
                                  box(title = tags$p(style = "font-size: 70%;", "Costo de 1 tratam. roya ($/ha)"),height = 125, width = NULL,background = "yellow",
                                      # textInput("costoTratam",NULL,NULL,width="200px")
                                      numericInput("niCostoTratam", label = NULL, value = 20)
                                  ),
                                  box(title = tags$p(style = "font-size: 70%;", "Nivel de costos de insumos"),height = 125, width = NULL,background = "yellow",
                                      textInput("tiNivCostoInsum",NULL,value="alto",width="200px")
                                  )
                           ),
                           column(width = 6,
                                  box(title = tags$p(style = "font-size: 70%;", "% Costos indirectos"),height = 125, width = NULL,background = "yellow",
                                      # textInput("costoIndirect",NULL,NULL,width="200px")
                                      numericInput("niCostoIndirect", label = NULL, value = 0)
                                  ),
                                  box(title = tags$p(style = "font-size: 70%;", "Otros costos de producción ($/año)"),height = 125, width = NULL,background = "yellow",
                                      # textInput("otroCostoProd",NULL,NULL,width="200px")
                                      numericInput("niOtroCostoProd", label = NULL, value = 0)
                                  )
                           )
                         )
                         
                       )
                ),
                
                
                
                #  ######## 3eme colone 
                
                
                column(width = 4,
                       
                       # 3.1: Sistema de producción: mano de obra
                       
                       box(
                         title = "Sistema de Producción : Mano de obra", height = 340, width = NULL, solidHeader = TRUE,
                         color = "orange",background = "orange",
                         
                         # content
                         
                         fluidRow(
                           column(width = 6,
                                  box(title = tags$p(style = "font-size: 70%;", "Numero de peones permanentes"),height = 125, width = NULL,background = "orange",
                                      # textInput("numPeones",NULL,NULL,width="200px")
                                      numericInput("niMumPeones", label = NULL, value = 0)
                                  ),
                                  box(title = tags$p(style = "font-size: 70%;", "Salario diario jornales ($/día)"),height = 125, width = NULL,background = "orange",
                                      # textInput("salarDiaJornal",NULL,NULL,width="200px")
                                      numericInput("niSalarDiaJornal", label = NULL, value = 5)
                                  )
                           ),
                           column(width = 6,
                                  box(title = tags$p(style = "font-size: 70%;", "Cosecha (días-hombre/q)"),height = 125, width = NULL,background = "orange",
                                      # textInput("cosecha",NULL,NULL,width="200px")
                                      numericInput("niCosecha", label = NULL, value = 4)
                                  ),
                                  box(title = tags$p(style = "font-size: 70%;", "Mano de obra familiar (ETC)"),height = 125, width = NULL,background = "orange",
                                      # textInput("manoObraFam",NULL,NULL,width="200px")
                                      numericInput("niManoObraFam", label = NULL, value = 1)
                                  )
                           )
                         )
                       ),
                       
                       # 3.2: Variables externas
                       
                       box(
                         title = "Variables externas", height = 340, width = NULL, solidHeader = TRUE,
                         color = "aqua",background = "aqua",
                         
                         # content
                         fluidRow(
                           column(width = 6,
                                  box(title = tags$p(style = "font-size: 70%;", "Canasta basica ($/mes/persona)"),height = 125, width = NULL,background = "aqua",
                                      # textInput("canastaBasica",NULL,NULL,width="200px")
                                      numericInput("niCanastaBasica", label = NULL, value = 80)
                                  ),
                                  box(title = tags$p(style = "font-size: 70%;", "Precio internacional café oro ($/q)"),height = 125, width = NULL,background = "aqua",
                                      # textInput("precioInternCafeOro",NULL,NULL,width="200px")
                                      numericInput("niPrecioInternCafeOro", label = NULL, value = 98)
                                  )
                           ),
                           column(width = 6,
                                  box(title = tags$p(style = "font-size: 70%;", "Sueldo minimo ciudad ($/mes)"),height = 125, width = NULL,background = "aqua",
                                      # textInput("sueldoMinCiudad",NULL,NULL,width="200px")
                                      numericInput("niSueldoMinCiudad", label = NULL, value = 300)
                                  ),
                                  box(title = tags$p(style = "font-size: 70%;", "Sueldo minimo campo ($/mes)"),height = 125, width = NULL,background = "aqua",
                                      # textInput("sueldoMinCampo",NULL,NULL,width="200px")
                                      numericInput("niSueldoMinCampo", label = NULL, value = 200)
                                  )
                           )
                         )
                         
                       )
                )
                
                
              ) 
              
      ), 
      
      
      # Roya historica ----------------------------------------------------------
      
      tabItem(tabName = "royaHistorica",
              
              # Box nombre de region y tipo de prod 
              
              fluidRow(
                
                box(color = "green",background = "green", width=25,
                    fluidRow(
                      column(width = 2,
                             textOutput("nombre_region"),
                             tags$head(tags$style("#nombre_region{color: black;
                                        font-size: 30px;
                                        font-style: bold;
                                        }"
                             )
                             )
                      ),
                      
                      column(width = 2,
                             textOutput("nombre_tipoProductor"),
                             tags$head(tags$style("#nombre_tipoProductor{color: black;
                                        font-size: 30px;
                                          font-style: bold;
                                          }"
                             )
                             )
                      )
                    )
                )
              ),
              
              
              # Box incidencia historica
              
              box(title = "Incidencia de la roya (promedio historico)",
                  # height = 340, width = NULL,
                  solidHeader = TRUE,
                  status = "warning",
                  
                  helpText("Haga clic en una celda para editarla"),
                  excelOutput("hot", width = 400, height = 400),
                  # rHandsontableOutput("hot"),
                  # uiOutput(rHandsontableOutput("hot")),
                  # uiOutput("DfRoyaHistUi"),
                  br(),
                  actionButton("actionButtonsaveDfRoyaHist", "Guardar tabla"),
                  br(),
                  fileInput("loadDfRoyaHist", label="Elija un archivo RDS",
                            multiple=T
                  )
              ),
              box(tableOutput("tableTest")),
              
              box(status="warning",plotOutput("plotRoyaHist"))
              
      ),
      
      
      # Mano de obra ------------------------------------------------------------
      
      
      tabItem(tabName = "manoObra",
              fluidRow(
                
                box(title = "Mano de obra familiar", 
                    # height = 340, width = NULL, 
                    solidHeader = TRUE,
                    color = "light-blue",
                    background = "light-blue",
                    
                    fluidRow(
                      
                      column(width = 4,
                             box(title="dias/mes MO familiar", color = "light-blue",
                                 background = "light-blue", width=25)
                             
                      ),
                      column(width = 4,
                             box(title=NULL, color = "teal",background = "teal", width=25,height = 50,
                                 numericInput("niDiasMesMOfam", label = NULL, value = 25)
                             )
                      )
                    )
                ),
                
                box(title = NULL, 
                    # height = 340, width = NULL, 
                    solidHeader = TRUE,
                    color = "light-blue",
                    background = "light-blue",
                    fluidRow(
                      column(width = 4,
                             box(title="Nivel de manejo", color = "light-blue",background = "light-blue", width=50,height = 100),
                             box(title="Ningun", color = "light-blue",background = "light-blue", width=25,height = 50),
                             box(title="Minimo", color = "light-blue",background = "light-blue", width=25,height = 50),
                             box(title="Bajo", color = "light-blue",background = "light-blue", width=25,height = 50),
                             box(title="Medio", color = "light-blue",background = "light-blue", width=25,height = 50),
                             box(title="Alto", color = "light-blue",background = "light-blue", width=25,height = 50)
                      ),
                      column(width = 4,
                             box(title="Mano de obra manejo (dias-hombres/ha)", color = "light-blue",background = "light-blue", width=50,height = 100),
                             box(title=NULL, color = "teal",background = "teal", width=25,height = 50,
                                 numericInput("ningunMO", label = NULL, value = NULL)
                             ),
                             box(title=NULL, color = "teal",background = "teal", width=25,height = 50,
                                 numericInput("minimoMO", label = NULL, value = NULL)
                             ),
                             box(title=NULL, color = "teal",background = "teal", width=25,height = 50,
                                 numericInput("bajoMO", label = NULL, value = NULL)
                             ),
                             box(title=NULL, color = "teal",background = "teal", width=25,height = 50,
                                 numericInput("medioMO", label = NULL, value = NULL)
                             ),
                             box(title=NULL, color = "teal",background = "teal", width=25,height = 50,
                                 numericInput("altoMO", label = NULL, value = NULL)
                             )
                      ),
                      column(width = 4,
                             box(title="Costos insumos nivel regular ($/ha)", color = "light-blue",background = "light-blue", width=50,height = 100),
                             box(title=NULL, color = "teal",background = "teal", width=25,height = 50,
                                 numericInput("ningunCI", label = NULL, value = NULL)
                             ),
                             box(title=NULL, color = "teal",background = "teal", width=25,height = 50,
                                 numericInput("minimoCI", label = NULL, value = NULL)
                             ),
                             box(title=NULL, color = "teal",background = "teal", width=25,height = 50,
                                 numericInput("bajoCI", label = NULL, value = NULL)
                             ),
                             box(title=NULL, color = "teal",background = "teal", width=25,height = 50,
                                 numericInput("medioCI", label = NULL, value = NULL)
                             ),
                             box(title=NULL, color = "teal",background = "teal", width=25,height = 50,
                                 numericInput("altoCI", label = NULL, value = NULL)
                             )
                      )
                      
                    )
                )
              )
      ),
      
      
      
      # Pronostico --------------------------------------------------------------
      
      
      tabItem(tabName = "pronostico",
              
              fluidRow(
                # column(width = 6,
                box(title="Vigilancia de incidencia de Roya",color = "navy",background ="navy", 
                    # width=100,height = 500,
                    fluidRow(
                      column(width = 4,
                             box(title=tags$p(style = "font-size: 70%;","Mes de la observacion de roya"),color = "teal",background ="teal", 
                                 width=20,height = 100,
                                 selectInput(inputId = "mesObs", label=NULL,
                                             choices=c("enero","febrero","marzo","abril","mayo","junio", "julio","agosto","setiembre","octubre","noviembre","diciembre"),width="200px")
                             )
                             
                      ),
                      column(width = 4,
                             box(title=tags$p(style = "font-size: 70%;","Incidencia Roya en %"),color = "blue",background = "blue",
                                 width=20,height = 100,
                                 numericInput("incObs",label=NULL,value=0,width="200px")
                             )
                             
                      ),
                      
                      column(width = 4,
                             box(title=tags$p(style = "font-size: 70%;","Condiciones para crecimiento de Roya"),color = "olive",background = "olive",
                                 width=20,height = 100,
                                 selectInput(inputId = "condPro", label=NULL,
                                             choices=c("desfavorable","normales", "favorable","muy favorables"),width="200px")
                             )
                      )
                      
                    ),
                    plotOutput("plotVigilancia")
                    
                ),
                
                # ),
                
                # column(width = 6, 
                box(
                  
                  box(title="Maximo de incidencia de Roya",
                      infoBoxOutput("MIRHistorico"),
                      infoBoxOutput("MIRPronostico"),
                      infoBoxOutput("MIRConManejoDeRoya")
                  ),
                  valueBoxOutput("ecoBox1"),
                  valueBoxOutput("ecoBox2")
                )
                
                # )
                
              )# fin fluidRow
              
      )# fin de tabItem Pronostico
      
      
    )# fin de tabItems
    
  ) # fin dashboardBody
) # fin dashboardPage



dashboardPage(
  header,
  sidebar,
  body
)

#https://getbootstrap.com/docs/3.3/components/ (glyphicons)



# Server ------------------------------------------------------------------

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

shinyApp(ui, server)


