library(shiny)
library(shinydashboard)
library(shinycssloaders)
library(tableHTML)
library(dplyr)
library(shinyBS)
library(shinyWidgets)

source("1_analyse_RF.R")
source("2_plot_RF.R")
source("3_1_func_table_RF.R")
source("3_2_func_table_comb_var.R")
source("4_1_calcul_TM_con_datos_Np.R")
source("4_2_calcul_TME_fijo_sin_datos.R")
source("5_plot_TME.R")
source("6_calcul_TM_sequentiel.R")
source("7_plot_TME_all.R")

ui <- fluidPage(
  
  dashboardPage(
  
  
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
               
               menuSubItem('Variables más importantes',
                           tabName = "App1",
                           icon = icon('line-chart')),
               menuSubItem('Número de parcelas',
                           tabName = "App2",
                           icon = icon('hashtag'))
      ),
      menuItem("Análisis Sin Datos", tabName = "SinDatos", icon = icon("th")),
      
      
      menuItem("Información del modelo",tabName = "info",icon = icon("file"))
    )
    
  ),
  
  
  body <- 
    
    dashboardBody(
      
      tabItems(
        # First tab content
        tabItem(tabName = "App1",
                h3("Análisis de variables más importantes"),
                fluidRow(column(12,
                                tags$style(HTML('#run{background-color:orange}')),
                                
                                box(h4("Datos de monitoreo"),color = "light-blue",background = "navy",width = 4,
                                    fileInput("file_epid", label=h5("1. Ingresar un archivo CSV"),
                                              accept = c(
                                                "text/csv",
                                                "text/comma-separated-values,text/plain",
                                                ".csv")
                                    ),
                                    numericInput("ano_actual",
                                                 h5("2. Año actual"),
                                                 value=2019),
                                    
                                    
                                    br(),
                                    actionBttn("action",h5("Iniciar el análisis"),color = "success", style = "jelly",block = FALSE,size = "sm")
                                    
                                ),
                                
                                box(title = h4("Gráfico de variables más importantes", align = "center"),
                                   # color = "teal",background = "teal",
                                    withSpinner(plotOutput("plot_RF", height = 200)),
                                    width = 8)),
                         
                ),
                         
                        fluidRow(column(12,
                                    
                          box(title="Elegir las variables",width = 4,height = 300,
                              background  = "navy",
                              bsButton("q1", label = "", icon = icon("question"), style = "info", size = "extra-small"),
                              bsPopover(id = "q1",title ="Variables", content = paste0("Elija las variables más importantes de acuerdo con el gráfico anterior."),
                                        placement = "right", trigger = "focus", options = list(container = "body")),
                             selectInput(
                               inputId = "V1",
                               label = "Variable 1",
                               choices = c("Altura", "Variedad", "Regiones"),#, "Year"),
                               
                             ),
                             
                             
                             
                             selectInput(
                               inputId = "V2",
                               label = "Variable 2",
                               choices = c("Altura", "Variedad", "Regiones")#, "Year")
                             ),
                           
                             actionBttn("elegir",(h5("Mostrar Categorías")), color = "primary",style = "jelly",block = FALSE, size = "sm"),          
                         
                             
                         ),
                         
                         box(title = h4("Categorías", align = "center"),
                            # background  = "navy",
                             withSpinner(tableOutput("out_table_comb_var")),
                             width = 8))
                     )
                
        ),
        
        # Second tab content
        tabItem(tabName = "App2",
                h3("Número de parcelas"),
                
                fluidRow(
                  
                  tabBox(
                    id = "tabset2", height = "500px", width = "500px",
                    
                  tabsetPanel(
                    
                    tabPanel(tags$b("Parámetros"),
                             fluidRow(
                               column(10, h4("Eligir los parámetros",align = "center"),
                                      box(
                                        width = 6,background = "yellow",style='margin: 6px;',
                                        numericInput("num_detectabilidad",
                                                     h5("Umbral de detectabilidad"),
                                                     value = 1),
                                        numericInput("num_n",
                                                     h5("Número de plantas"),
                                                     value = 30),
                                        numericInput("num_TMF",
                                                     h5("Tamaño mínimo de parcelas"),
                                                     value = 10)
                                      
                               ),
          
                            
                                      box(color = "yellow",background = "light-blue",width = 6,
                                          title=tags$p(style = "font-size: 50%;"), #h5("Número de parcelas en el teritorio"),
                                          uiOutput("comb_var")),
                               
                               
                            )
                         )
                    ),
                    tabPanel(tags$b("Tamaño a realizar"),  
                             box(h4("Antes de pasar al monitoreo del mes en curso",align = "center"),plotOutput("plot_monit_esperado",height=500),
                                 width = 12,
                                 downloadButton("down_plot_monit_actual", "Download Plot")
                             )
                    ),
                    
                    tabPanel(tags$b("Datos monitoreo del mes"),
                        fluidRow(
                          fluidRow(
                             column(12 ,
                                 box(h4("Datos de monitoreo mes en curso"),color = "light-blue",background = "navy",width = 4,height=350,
                                     fileInput("file_epid2", label=h5("1. Ingresar un archivo CSV"),
                                               accept = c(
                                                 "text/csv",
                                                 "text/comma-separated-values,text/plain",
                                                 ".csv")),
                                 
                                 numericInput("ano_actual2",
                                              h5("2. Año actual"),
                                              value=2019),
                                 
                                 
                                 br(),
                                 actionBttn("action2",(h5("Iniciar el análisis")),color = "success", style = "jelly",block = FALSE, size = "sm")
                                 
                            
                             
                              )
                            )
                          )
                         )
                       ),
                    
                    
                    
                    
                    
                    
                    tabPanel(tags$b("Tamaño efectuado y necesario"),
                             fluidRow(
                               column(12,h4("Considerando el monitoreo del mes en curso",align = "center"),
                                
                                      box(
                                          plotOutput("plot_monit_actual",height=500),
                                          width = 5
                                     
                               ),
                               
                             
                                      box(uiOutput("table_TM_sequencial"),
                                          width = 6)
                               
                             )
                           )
                    ),
                    tabPanel(tags$b("Nueva ronda"),
                             fluidRow(
                               fluidRow(
                                 column(3 ,offset = 2 ,
                               box(uiOutput("table_TM_sequencial_NR"),width = 8)
                                 )
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
                  
                  actionBttn("resultados",(h5("Mostrar resultados")),color = "primary", style = "jelly",block = FALSE ,size = "sm")),
                  
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
)


dashboardPage(
  header,
  sidebar,
  body
)


server <- function(session, input, output) {
  
  # Con datos -----------------------
  df_epid <-  eventReactive(input$action,{
    req(input$file_epid)
    
    inFile_epid <- input$file_epid
    if (is.null(inFile_epid))
      return(NULL)
    
    read.csv(inFile_epid$datapath, header = T)
  })
  

  
  
  sub_df_epid1 <- eventReactive(input$action,{
    subset(df_epid(),!(Year %in% input$ano_actual))
  })
  
  
  analyse_RF <- eventReactive(input$action,{
    func_analyse_RF(sub_df_epid1())
  })
  
  
  plot <-  eventReactive(analyse_RF(),{
    func_plot_RF(analyse_RF())
    
  })
  
  
  output$plot_RF <- renderPlot({
    plot()
  })
  
  
  # output$plot_RF <- renderPlot({
  #   validate(
  #     need(sub_df_epid1(), "Estoy esperando los datos y el lanzamiento del analisis."
  #     )
  #   )
  #   func_plot_RF(analyse_RF())
  # })
  # 

  
  
  
  # choix des variables importantes
  var_important <- eventReactive(input$elegir,{
    data.frame(var_names=c(input$V1,input$V2))
  })
  
  table_RF <-  reactive({
    func_table_RF(var_important(), # analyse_RF()
                  sub_df_epid1(),
                  input$num_detectabilidad)
  })
  
  
  
  
  comb_var <-  reactive({
    validate(
      need(sub_df_epid1(), "Estoy esperando los datos y el lanzamiento del analisis."
      )
    )
    func_table_comb_var(table_RF())
  })
  
  output$out_table_comb_var <- renderTable({
    comb_var()
  })
  
  output$comb_var <- renderUI({
    aa <- lapply(comb_var()$FACTOR, function(i) {
      numericInput(paste0("num_",i),
                   h5(i),
                   value = 5000)
    })
    do.call(tagList,aa)
  })
  
  
  output$downloadDataRF <- downloadHandler(
    filename =function() {"table_RF.csv" },
    content = function(file) {
      write.csv(table_RF(), file, row.names=FALSE)
    }
  )
  
  output$downloadDataCB <- downloadHandler(
    filename =function() {"categorias.csv" },
    content = function(file) {
      write.csv(comb_var(), file, row.names=FALSE)
    }
  )
  
  
  df_Np <- reactive({
    data.frame(FACTOR=comb_var()$FACTOR,
               Np=sapply(comb_var()$FACTOR,function(i)
                 input[[paste0("num_",i)]]))
  })
  
  
  
  analyse_vgam <- reactive({
    
    withProgress(message = 'Cálculo en curso',
                 detail = 'Puede tomar un cafecito...', value = 0, {
                   TME(table_RF(),
                       df_Np(),
                       input$num_n,
                       input$num_TMF,
                       progress=TRUE)
                 })
  })
  
  
  output$plot_monit_esperado <- renderPlot({
    func_plot_TME(analyse_vgam())
  })
  
  ### !!!!!!!!!!!!!!!!! Activer le download du graph
  
  
  ### Comparaison avec les nouvelles donnees ------------------------
  
  ##nuevo ingreso datos 
  
  df_epid2 <-  eventReactive(input$action2,{
    req(input$file_epid2)
    
    inFile_epid2 <- input$file_epid2
    if (is.null(inFile_epid2))
      return(NULL)
    
    read.csv(inFile_epid2$datapath, header = T)
  })
  
  sub_df_epid2 <- eventReactive(input$action2,{
    subset(df_epid2(),Year==input$ano_actual2 & tipo_de_datos=="efectuado")
  })
  ###
  
  # sub_df_epid2 <- reactive({
  #   subset(df_epid2(),Year==input$ano_actual & tipo_de_datos=="efectuado") # inicial
  # })

  
  
  
  #MENSAJE boton 2 
  observeEvent(input$action2, {
    showModal(modalDialog(
      title = "Mensaje Importante",
      "Continuar a la siguiente pestaña ->"
    ))
  })
  #FIN 
  
  table_RF2 <-  reactive({
    func_table_RF(var_important(),
                  sub_df_epid2(),
                  input$num_detectabilidad)
  })
  
  
  analyse_vgam2 <- reactive({
    
    withProgress(message = 'Calculo del tamaño actual',
                 detail = 'Puede tomar un cafecito...', value = 0, {
                   TME(table_RF2(),
                       df_Np(),
                       input$num_n,
                       TM.F=0,#input$num_TMF,
                       progress=TRUE)
                 })
  })
  
  
  output$plot_monit_actual <- renderPlot({
    func_plot_TME_all(analyse_vgam(),
                      analyse_vgam2())
  })
  
  
  table_TM_sequencial_total <- reactive({
    TME_sequencial(analyse_vgam(),
                   analyse_vgam2())
  })
  
  
  funcListTable <- reactive({
    listTable <- NULL
    MES <- unique(table_TM_sequencial_total()$Mes)
    
    for(i in 1:length(MES)){
      sub <- subset(table_TM_sequencial_total(),Mes==i)
      listTable[[i]] <- sub
    }
    listTable
  })
  

  
  output$table_TM_sequencial <- renderUI({
    table_output_list <- lapply(1:length(funcListTable()), function(i) {
      try(
        renderTable({funcListTable()[[i]]})

      )
    })
  })

  
  
  ### Nueva ronda de monitoreo ------------------------
  
  
  #nuevo de acuerdo con el browse 2 
  
  sub_df_epid_NR <- reactive({
    subset(df_epid2(),tipo_de_datos %in% c("efectuado","nueva ronda")) # inicial
  })
  
# FIN 
  
  
  
  # sub_df_epid_NR <- reactive({
  #   subset(df_epid(),tipo_de_datos %in% c("efectuado","nueva ronda")) # inicial
  # })
  
  
  table_RF_NR <-  reactive({
    func_table_RF(var_important(), # analyse_RF()
                  sub_df_epid_NR(),
                  input$num_detectabilidad)
  })
  
  
  
  analyse_vgam_NR <- reactive({
    
    withProgress(message = 'Calculo del tamaño actual',
                 detail = 'Puede tomar un cafecito...', value = 0, {
                   TME(table_RF_NR(),
                       df_Np(),
                       input$num_n,
                       TM.F=0,#input$num_TMF,
                       progress=TRUE)
                 })
  })
  
  
  output$plot_monit_actual_NR <- renderPlot({
    func_plot_TME_all(analyse_vgam2(),
                      analyse_vgam_NR())
  })
  
  
  table_TM_sequencial_total_NR <- reactive({
    TME_sequencial(analyse_vgam2(),
                   analyse_vgam_NR())
  })
  
  
  ## n afficher que les resultats de nueva ronda
  
  
  
  #nuevo de acuerdo con el browse 2 
  sub_nueva_ronda <- reactive({
    subset(df_epid2(),tipo_de_datos =="nueva ronda")
  })
  
  table_RF_nueva_ronda <-  reactive({
    func_table_RF(var_important(), # analyse_RF()
                  sub_nueva_ronda(),
                  input$num_detectabilidad)
  })
  
  #FIn
  
  
  
  # sub_nueva_ronda <- reactive({
  #   subset(df_epid(),tipo_de_datos =="nueva ronda")
  # })
  # 
  # table_RF_nueva_ronda <-  reactive({
  #   func_table_RF(var_important(), # analyse_RF()
  #                 sub_nueva_ronda(),
  #                 input$num_detectabilidad)
  # })
  # 
  
  funcListTable_NR <- reactive({
    listTable <- NULL
    # MES <- unique(table_TM_sequencial_total_NR()$Mes)
    MES <- unique(table_RF_nueva_ronda()$Fec)
    
    for(i in 1:length(MES)){
      
      sub <- subset(table_TM_sequencial_total_NR(),
                    Mes==MES[i]) 
      # n afficher que les resultats de nueva ronda
      sub_table_RF_nueva_ronda <- subset(table_RF_nueva_ronda(),
                                         Fec==MES[i])
      CAT <- unique(sub_table_RF_nueva_ronda$comb_var)
      
      sub2 <- sub[sub$Categorias %in% CAT,]
      
      listTable[[i]] <- sub2
      
    }
    listTable
  })
  
  output$table_TM_sequencial_NR <- renderUI({
    table_output_list <- lapply(1:length(funcListTable_NR()), function(i) {
      try(
        renderTable({funcListTable_NR()[[i]]})
      )
    })
  })
  
  
  
  
  
  # Sin datos --------------------------
  
  resultados <- eventReactive(input$resultados,{
    TME.fijo(input$num_Pro_SD,
             input$num_n_SD,
             input$num_Inc_SD,
             input$num_eeInc_SD,
             input$num_agreg_SD,
             input$num_TMF_SD)
    
  })
  
  output$out_sin_datos <- renderTable({
   resultados()
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