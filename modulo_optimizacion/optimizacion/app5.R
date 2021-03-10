library(shiny)
library(shinydashboard)
library(shinydashboardPlus)
library(shinycssloaders)
library(tableHTML)
library(dplyr)
library(plyr)
library(shinyBS)
library(shinyWidgets)

# Con datos
source("1-func_prep_datos.R")
source("2-names_func_table_comb_var.R")
source("3-calcul_TM_con_datos.R")

source("4-func_metrica.R")
source("5-plot_TME.R")

source("6-calcul_TM_sequentiel.R")
source("7-plot_TME_all.R")


# Sin datos
source("0-calcul_TME_fijo_sin_datos.R")

# text info page Paramtros

Button_pop1 <- paste(tags$b("Umbral de detectabilidad:"), 
                       "Es el umbral arriba del cual es fácil detectar la roya. Se recomienda usar 1% de incidencia. Cuando las incidencias estén debajo del umbral de detectabilidad, se incrementa el número de parcelas por monitorear para poder estimar adecuadamente la incidencia.",
                     "",
                     tags$b("Número de plantas por parcela:"),
                       "El aumentar el número de plantas monitoreadas por parcela facilita la detección de la roya y la estimación de incidencias bajas. Esto puede permitir reducir el número de parcelas por monitorear.",
                     "",
                     tags$b("Número de parcelas mínimo:"),
                       "Ese número se agrega al número de parcelas determinado por el modelo para evitar un número de parcelas por monitorear demasiado bajo. Se recomienda el número de 10, pero puede ser inferior.",
                       sep="<br>")

Button_pop2 <- paste("Estas son las opciones que tiene para la planificación anual del monitoreo de la roya en su país, según la categoría de parcela por monitorear y el mes.",
                     "Son opciones basadas en :",
                     "* Los promedios, medianas o máximos de los números de parcelas por monitorear por categoría y por mes, derivados de todos los años cargados.",
                     "* Los que se derivan de los datos del monitoreo de la roya de un año específico," , 
                      "",
                     "Seleccione la opción que más le conviene. Dentro de lo que hay que considerar para seleccionar la mejor opción están:",
                     "",
                     "1. su capacidad de monitoreo (cuantas parcelas puede efectivamente monitorear en términos de recursos humanos y económicos), ",
                     "",
                     "2. su capacidad de re-monitorear al poco tiempo, en caso que el monitoreo inicial resulte sub-dimensionado (ver pestaña “datos monitoreo del mes”).",
                     "",
                     "Distribuya las parcelas en su país para que éstas representen lo mejor posible la realidad.",
                     sep="<br>")


Button_pop3 <- paste("Si el resultado es OK para ciertas categorías de fincas, es que el número de parcelas que usted monitoreó, en el mes en curso para esas categorías es adecuado. Ya no tiene que monitorear más parcelas en estas categorías en el mes en curso.",
                     "",
"Si en algunas categorías, el resultado es un número, ese número es la cantidad de parcelas que debe monitorear de nuevo para tener una buena estimación de la incidencia en el mes en curso. Monitoreé ese número de parcelas en los próximos días y vuelva a cargar", 
tags$b("todos los datos del mes"), "(datos nuevos y anteriores)","para asegurarse que el monitoreo ahora es adecuado.",
sep="<br>")


Button_pop4 <- paste(tags$b("Las categorias de alturas se definen como siguiente:"),
                     "Altura muy alta : > 1500 m",
                     "Altura alta : 1100-1500 m",
                     "Altura media : 700-1100 m",
                     "Altura baja : <700 m",
                     sep="<br>")


ui <- dashboardPage(
    
    header <- dashboardHeader(
      tags$li(class = "dropdown",
              tags$style(".main-header {max-height: 65px}"),
              tags$style(".main-header .logo {height: 65px}")
      ),
      
      title = h4("Optimización del Monitoreo de la Roya")), 
    
    
    sidebar <- dashboardSidebar(
      
      # Adjust the sidebar
      tags$style(".left-side, .main-sidebar {padding-top: 70px}"),
      
      sidebarMenu(
        
        menuItem("Análisis Con Datos", tabName = "ConDatos1", icon = icon("dashboard"),
                 
                 menuSubItem("Planificación anual",
                             tabName = "planif_anual",
                             icon = icon("table")
                             ),
                 menuSubItem("Monitoreo del mes",
                             tabName = "monit_mes",
                             icon = icon('hashtag'))
        ),
        menuItem("Análisis Sin Datos", tabName = "SinDatos", icon = icon("th"))
      
      ),
      tags$div(style="padding:15px;text-align:center;",actionLink("show", "Ver guía de uso", style="margin:20px;")),
      tags$div(style="width: 215px;color: white;text-align: center;padding: 15px;",
               HTML("<br><br><br><br><br><br><br><br><br><br><br><br><br><b>Créditos:</b><br>Edwin Treminio, Edwin.Treminio@catie.ac.cr <br><br>
              Sergio Vílchez, svilchez@catie.ac.cr <br>
              Natacha Motisi, natacha.motisi@cirad.fr <br>
              Fernando Casanoves, casanoves@catie.ac.cr <br>
              Jacques Avelino,  jacques.avelino@cirad.fr "))
    ),
    
    
    body <- 
      
      dashboardBody(
        
        tabItems(

          # First tab content
          tabItem(tabName = "ConDatos1",box(h3("Análisis de variables más importantes"))),
          
          # 2nd tab content
          tabItem(tabName = "planif_anual",
                  h3("Planificación anual"),
                  
                  fluidRow(

                    tabBox(
                      id = "tabset1", height = "500px", width = "500px",

                      tabsetPanel(

                        tabPanel(tags$b("Datos y parametros"),
                                 fluidRow(
                                   column(6,
                                          box(h4("Carga datos historicós para la planificación anual"),
                                              color = "light-blue",background = "navy",width = 6,
                                              fileInput("file_epid", label=h5("1. Ingresar un archivo CSV"),
                                                        accept = c(
                                                          "text/csv",
                                                          "text/comma-separated-values,text/plain",
                                                          ".csv")
                                              )
                                          ),

                                          box(title = tags$p("Defina los parámetros siguientes",
                                                             style = "font-size: 150%;"),
                                              bsButton("q1", label = "", icon = icon("question"), style = "info", size = "extra-small"),
                                              bsPopover(id = "q1",title ="Parámetros",
                                                        content = Button_pop1,
                                                        placement = "right", trigger = "focus",
                                                        options = list(container = "body")),
                                              width = 6,background = "yellow",style='margin: 6px;',
                                              numericInput("num_detectabilidad",
                                                           h5("Umbral de detectabilidad"),
                                                           value = 1),
                                              numericInput("num_plantas",
                                                           h5("Número de plantas"),
                                                           value = 30),
                                              numericInput("num_TMF",
                                                           h5("Tamaño mínimo de parcelas"),
                                                           value = 10)
                                          )

                                          ),

                                   
                                          box(color = "yellow",background = "light-blue",width = 6,
                                              title=tags$p("Defina el número de parcelas existentes en cada categoría de parcelas",
                                                           style = "font-size: 150%;"),
                                              bsButton("q4", label = "", icon = icon("question"), style = "info", size = "extra-small"),
                                              bsPopover(id = "q4",title ="Categorias de alturas",
                                                        content = Button_pop4,
                                                        placement = "right", trigger = "focus",
                                                        options = list(container = "body")),
                                              uiOutput("comb_var1")
                                              )
                                   
                                 )
                        ),
                        
                        tabPanel(tags$b("Tamaño a realizar"),  
                                 box(title=tags$b("Elija las opciones de planificación"), background = "navy",
                                     
                                     bsButton("q2", label = "", icon = icon("question"), style = "info", size = "extra-small"),
                                     bsPopover(id = "q2",title ="Opciones de planificación anual",
                                               content = Button_pop2,
                                               placement = "right", trigger = "focus", 
                                               options = list(container = "body")),
                                     
                                     uiOutput("choose_metric1")
                                 ),
                                 
                                 box(title=tags$b("Carga los graficos y los datos de planificación"),
                                   downloadButton("downPlotPlanificacion", "Carga grafico"),
                                     downloadButton("downloadDataMetric","Carga datos planificación")),
                                 
                                 box(title=tags$b("Planificación anual del monitoreo"),background = "teal", width = 12,
                                     withSpinner(plotOutput("plot_planificacion",height=500))
                                     
                                 )
                        )

                      )
                    )
                  )

                  ),
          
          
          # 3rd tab content
          tabItem(tabName = "monit_mes",
          h3("¿ El monitoreo ha sido suficiente ?"),
                  
                  fluidRow(
                    
                    tabBox(
                      id = "tabset2", height = "500px", width = "500px",
                      
                      tabsetPanel(
                        
                        tabPanel(tags$b("Datos de planificación y del monitoreo del mes"),
                                 fluidRow(
                                   fluidRow(
                                     column(12 ,
                                            box(h4("Carga datos"),color = "light-blue",
                                                background = "navy",width = 4,height=350,
                                               
                                                
                                                fileInput("file_planif", 
                                                          label=h5("1. Ingresar el archivo de planifcación anual (.csv)"),
                                                          accept = c(
                                                            "text/csv",
                                                            "text/comma-separated-values,text/plain",
                                                            ".csv")),
                                                
                                                fileInput("file_epid2", 
                                                          label=h5("2. Ingresar el archivo del monitoreo del mes en curso (.csv)"),
                                                          accept = c(
                                                            "text/csv",
                                                            "text/comma-separated-values,text/plain",
                                                            ".csv"))
                                                # ,
                                                # br(),
                                                # actionBttn("action2",(h5("Iniciar el análisis")),color = "success", style = "jelly",block = FALSE, size = "sm")
                                             
                                            )
                                          
                                     )
                                   )
                                 )
                        ),
                        
                        
                        tabPanel(tags$b("Tamaño efectuado y necesario"),
                                 fluidRow(
                                   column(12,
                                          box(title="Monitoreo necesario",
                                              status = "primary", solidHeader = TRUE,
                                              width = 6,
                                              withSpinner(plotOutput("plot_monit_actual",height=500))
                                            
                                          ),
                                          
                                          box(title="Verifica que los monitoreos mensuales han sido eficientes o si requieren de complementarse con más parcelas",
                                              background = "purple",
                                              width = 6,
                                              bsButton("q3", label = "", icon = icon("question"), style = "info", size = "extra-small"),
                                              bsPopover(id = "q3",title ="Resultados",
                                                        content = Button_pop3,
                                                        placement = "right", trigger = "focus",
                                                        options = list(container = "body")),
                                              uiOutput("table_TM_sequencial"))
                                          
                                   )
                                 )
                        )
                       
                      )
                    )
                  )
          ),
          
          tabItem(tabName = "SinDatos",
                  h2("Parámetros"),
                  
                  fluidRow( 
                    column(12,
                           
                           box(background = "yellow",
                               numericInput("num_Pro_SD",
                                            h5("Nivel de significancia"),
                                            value = 0.01),
                               numericInput("num_n_SD", 
                                            h5("Número de plantas"), 
                                            value = 30),
                               numericInput("num_Inc_SD", 
                                            h5("Incidencia"), 
                                            value = 0.05),
                               numericInput("num_eeInc_SD", 
                                            h5("Error estándar asociado a la media de la incidencia"), 
                                            value = 0.01),
                               numericInput("num_agreg_SD", 
                                            h5("Agregación espacial"), 
                                            value = 0.1),
                               numericInput("num_TMF_SD", 
                                            h5("Tamaño fijo de parcelas"), 
                                            value = 10),
                               width = 5,
                               
                               # actionBttn("resultados",(h5("Mostrar resultados")),color = "primary", style = "jelly",block = FALSE ,size = "sm")
                               ),
                           
                           box(title = tags$b("Resultados"),tableOutput("out_sin_datos"),
                               width = 7)
                    )
                  )
          ),
          tabItem(tabName = "info",
                  # h2("Documento técnico del modelo",align = "center"),
                  
                  fluidRow( 
                    column(7,
                           titlePanel(tags$blockquote("Modelo optimización del monitoreo de la Roya: 
                                                    Documento técnico del modelo",
                                                      style = "font-size: 70%"
                           )),
                           downloadButton("downloadData", "Descargar Documento", class = "butt1"),
                           tags$head(tags$style(".butt1{background-color:orange;} .butt1{color: black;} .butt1{font-family: Courier New}")),  
                    )
                  )
                  
          )
        )
      )
  )

#dashboardPage(
#  header,
#  sidebar,
#  body
#)


server <- function(session, input, output) {
  
  # Con datos -----------------------
  data <-  reactive({
    #req(input$file_epid)
    
    
    inFile_epid <- input$file_epid
    if (is.null(inFile_epid))
      return(NULL)
    
    read.csv(inFile_epid$datapath, header = T)
  })
  
  dataModal <- function(failed = FALSE) {
    modalDialog(
      title = "Guía de uso",
      size = "l",
      fluidRow(
        column(width=12,
               HTML("<embed src='guia.pdf' type='application/pdf' internalinstanceid='44' title='' width='100%' height='890'>")      
        )
      ),
      footer = tagList(
        modalButton("Cerrar")
      )
    )
  }
  
  observeEvent(input$show, {
    showModal(dataModal())
  })
  

  
  datos0 <-  reactive({
    func_prep_datos(data(),
                   input$num_detectabilidad)
  })
  
  comb_var1 <-  reactive({
    func_table_comb_var(datos0())
  })
  


  output$comb_var1 <- renderUI({
    aa <- lapply(comb_var1()$FACTOR, function(i) {
      numericInput(paste0("num_",i),
                   h5(i),
                   value = 5000)
    })
    do.call(tagList,aa)
  })
  
  
  
  df_Np1 <- reactive({
    data.frame(FACTOR=comb_var1()$FACTOR,
               Np=sapply(comb_var1()$FACTOR,function(i)
                 input[[paste0("num_",i)]]))
  })
  

  analyse_vgam <- reactive({
    
    withProgress(message = 'Calculo en curso',
                 detail = 'Puede tomar un cafecito...', value = 0, {
                   TME(datos0(),
                       df_Np1(),
                       input$num_plantas,
                       input$num_TMF,
                       progress=TRUE)
                 })
  })
  
  
  df_metrica_all <- reactive({
    func_metrica(analyse_vgam(),
                 input$num_detectabilidad,
                 input$num_plantas,
                 input$num_TMF)
  })
  
  output$choose_metric1 <- renderUI({
    selectInput(inputId = "metrica1",
                label = "Elija las opciones",
                choices = colnames(df_metrica_all())[grep("Tamano",colnames(df_metrica_all()))])
    
  })
  
  
  output$plot_planificacion <- renderPlot({
    func_plot_TME(df_metrica_all(),
                  input$metrica1)
  })
  
  
  # Download table
  
  output$downloadDataMetric <- downloadHandler(
    filename =function() {"planificacion_anual_metricas.csv" },
    content = function(file) {
      write.csv(df_metrica_all(), file, row.names=FALSE)
    }
  )
  
  # Download plot
  plotInput <- function(){
    func_plot_TME(df_metrica_all(),
                  input$metrica1)
  }
  
  output$downPlotPlanificacion <- downloadHandler(
    filename = function() {
      paste0(input$metrica1,".png")
    },
    content = function(file) {
      ggsave(file, plot = plotInput(),
             width = 20, height = 20, units = "cm",
             device = "png") # width = 500, height = 500 
    }
  )
  

  
  
  ### Comparaison avec les nouvelles donnees ------------------------
  
 
  # Importer les donnees de planification
  
  df_planif <-  reactive({ # eventReactive(input$action2,{
    req(input$file_planif)
    
    inFile_planif <- input$file_planif
    if (is.null(inFile_planif))
      return(NULL)
    
    read.csv(inFile_planif$datapath, header = T)
  })
  
  
  ##nuevo ingreso datos 
  # Importer les donnees de monitoreo de lannee en cours
  
  df_epid2 <-  reactive({ # eventReactive(input$action2,{
    req(input$file_epid2)
    
    inFile_epid2 <- input$file_epid2
    if (is.null(inFile_epid2))
      return(NULL)
    
    read.csv(inFile_epid2$datapath, header = T)
  })
  


  
  #MENSAJE boton 2 
  observeEvent(input$action2, {
    showModal(modalDialog(
      title = "Mensaje Importante",
      "Continuar a la siguiente pestaña ->"
    ))
  })
  
  
  datos2 <-  reactive({
    func_prep_datos(df_epid2(),
                    unique(df_planif()$num_detectabilidad))
  })
  

  df_Np2 <- reactive({
    ddply(df_planif(), c("FACTOR"), summarise, 
                Np=mean(Np))
  })
  

  analyse_vgam2 <- reactive({
    
    withProgress(message = 'Calculo del tamaño actual',
                 detail = 'Puede tomar un cafecito...', value = 0, {
                   TME(datos2(),
                       df_Np2(),
                       unique(df_planif()$num_plantas),
                       unique(df_planif()$tamano_min_parcelas),
                       progress=TRUE)
                 })
  })
  
  
  output$plot_monit_actual <- renderPlot({
    func_plot_TME_all(analyse_vgam2())
  })
  
  
  table_TM_sequencial_total <- reactive({
    TME_sequencial(datos2(), 
                   analyse_vgam2())
  })
  
  
  funcListTable <- reactive({
    listTable <- NULL
    MES <- unique(table_TM_sequencial_total()$Mes)
    
    for(i in 1:length(MES)){
      sub <- subset(table_TM_sequencial_total(),Mes==MES[i])
      listTable[[i]] <- sub
    }
    listTable
  })
  
  output$table_TM_sequencial <- renderUI({
    # table_output_list <- 
      lapply(1:length(funcListTable()), function(i) {
      try(
        renderTable({funcListTable()[[i]]})
      )
    })
  })
  
  

  
  # Sin datos --------------------------
  output$out_sin_datos <- renderTable({
    TME.fijo(input$num_Pro_SD,
             input$num_n_SD,
             input$num_Inc_SD,
             input$num_eeInc_SD,
             input$num_agreg_SD,
             input$num_TMF_SD)
  })
  
  
  # Download document 
  
  output$downloadData <- downloadHandler(
    filename = "manual_de_usuario.pdf",
    content = function(file) {
      file.copy("doc/guia.pdf", file)
    }
  )  
  
  
  
}

shinyApp(ui, server)