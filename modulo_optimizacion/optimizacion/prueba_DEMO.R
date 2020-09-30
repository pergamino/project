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
        menuItem("Análisis Sin Datos", tabName = "SinDatos", icon = icon("th"))
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
                                      
                                      
                                      selectInput("periodo", h5("2.Periodo de estudio"), 
                                                  choices = c(''),multiple = TRUE),
                                      
                                      selectInput("select_col",
                                                  h5("3.Seleccionar columnas de interés"),
                                                  choices= c(''), multiple= TRUE),
                                      
                                      br(),
                                      actionBttn("action",h4("Iniciar el análisis"),color = "warning", style = "simple")
                                      
                                  ),
                                  
                                  box(title = h4("Gráfico de variables más importantes", align = "center"),
                                      #color = "teal",background = "teal",
                                      withSpinner(plotOutput("plot_RF", height = 250)),
                                      width = 8),
                                  
                                  textOutput("var_imp")
                                  
                  ),
                  ),
                  
                  fluidRow(column(12,
                                  
                                  
                                  box(title="Elegir variables más importantes",width = 4,
                                      background  = "light-blue",
                                      bsButton("q1", label = "", icon = icon("question"), style = "info", size = "extra-small"),
                                      bsPopover(id = "q1",title ="Variables", content = paste0("Elija las variables más importantes de acuerdo con el gráfico anterior."),placement = "right", trigger = "focus", options = list(container = "body")),
                                      selectInput(
                                        inputId = "V1",
                                        label = "Variable 1",
                                        choices = names(data), multiple= FALSE
                                        
                                      ),
                                      
                                      
                                      
                                      selectInput(
                                        inputId = "V2",
                                        label = "Variable 2",
                                        #choices = c("Altura", "Variedad", "Regiones", "Year")
                                        choices = names(data), multiple= FALSE
                                      ),
                                      
                                      
                                      
                                      
                                      
                                      
                                  ),
                                
                                  box(title = "Categorías",
                                      # background  = "light-blue",
                                      withSpinner(tableOutput("out_table_comb_var")),
                                      width = 8))
                  )
          ),
          
          # Second tab content
          tabItem(tabName = "App2",
                  h3("Número de parcelas"),
                  fluidRow( 
                    
                    tabBox(
                      id = "tabset2", width = "500px",
                      
                      
                      tabPanel(h4("Parámetros"),
                               fluidRow(
                                 column(width = 6,
                                        box(
                                          numericInput("num_detectabilidad",
                                                       h5("Umbral de detectabilidad"),
                                                       value = 1),
                                          numericInput("num_n",
                                                       h5("Numero de plantas"),
                                                       value = 30),
                                          numericInput("num_TMF",
                                                       h5("Tamano minimo de parcelas"),
                                                       value = 10)
                                        )
                                 ),
                                 
                                 column(width = 6,
                                        box(color = "yellow",background = "yellow",
                                            title=tags$p(style = "font-size: 130%;", "Numero de parcelas en el teritorio"),
                                            uiOutput("comb_var"))
                                 )
                               )
                      ),
                      
                      tabPanel(h4("Tamaño a realizar"),  
                               box("Antes de pasar al monitoreo del mes",plotOutput("plot_monit_esperado",height=500),
                                   width = 12,
                                   downloadButton("down_plot_monit_actual", "Download Plot")
                               )
                      ),
                      tabPanel(h4("Tamaño efectuado y necesario"),
                               fluidRow(
                                 column(width = 5,
                                        box("Considerando el monitoreo del mes",
                                            plotOutput("plot_monit_actual",height=500),
                                            width = 12
                                        )
                                 ),
                                 
                                 column(width = 7,
                                        box(uiOutput("table_TM_sequencial"),
                                            width = 12)
                                 )
                               )
                      ),
                      tabPanel(h4("Nueva ronda"),
                               fluidRow(
                                 box(uiOutput("table_TM_sequencial_NR"))
                               )
                      )
                      
                    )
                  )
          ),
          
          tabItem(tabName = "SinDatos",
                  h2("Parámetros"),
                  
                  fluidRow( 
                    
                    box(numericInput("num_Pro_SD",
                                     h5("Nivel de significancia"),
                                     value = 0.01),
                        numericInput("num_n_SD", 
                                     h5("Numero de plantas"), 
                                     value = 30),
                        numericInput("num_Inc_SD", 
                                     h5("Incidencia"), 
                                     value = 0.05),
                        numericInput("num_eeInc_SD", 
                                     h5("Error estandar asociado a la media de la incidencia"), 
                                     value = 0.01),
                        numericInput("num_agreg_SD", 
                                     h5("Agregacion espacial"), 
                                     value = 0.1),
                        numericInput("num_TMF_SD", 
                                     h5("Tamano fijo de parcelas"), 
                                     value = 10),
                        width = 4),
                    box("Resultados",tableOutput("out_sin_datos"),
                        width = 6)
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
  data <-  reactive({
    #req(input$file_epid)
    
    
    inFile_epid <- input$file_epid
    if (is.null(inFile_epid))
      return(NULL)
    
    read.csv(inFile_epid$datapath, header = T)
  })
  
  
  observeEvent(data(), {
    updateSelectInput(session, "periodo", choices = unique(data()$Year))
  })
  
  observeEvent(data(), {
    updateSelectInput(session, "select_col", choices=colnames(data()))
  })
  
  
  df_epid <- eventReactive(input$select_col,{
    subset(data(),Year %in% unlist(input$periodo))
  })
  
  sub_df_epid1 <- eventReactive({
    input$select_col
    df_epid()
  }, {
    
    df_epid()[, colnames(df_epid()) %in% input$select_col]
    
  })
  
  
  
  #   #df_epid
  #   # sub_df_epid1<- eventReactive({
  #    #input$action
  #    #input$select_col
  #    
  #    
  #    
  #  }, {
  #    
  #    req( df_epid())
  #    if(is.null(input$select_col) || input$select_col == "")
  #      df_epid() else 
  #        df_epid()[, colnames( df_epid()) %in% input$select_col]
  #    
  # })
  
  
  analyse_RF <- eventReactive(input$action,{
    func_analyse_RF(sub_df_epid1())
  })
  
  
  plot <- eventReactive(analyse_RF(),{
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
  
  #mensaje de plot graficos mas importantes
  
  
  texto <- eventReactive(plot(),{
    paste("Las dos variables más importantes son las que se encuentran en los extremos de la barra sombreada horizontal del gráfico.")
    
  })
  
  output$var_imp <- renderText({
    texto()
  })
  
  
  
  #mostrar opciones de variables a elegir 
  
  df_epid_sin <-  reactive({
    df_epid()[!(colnames(df_epid()) == "Year")]  #no seleccionar la variable de ano / tomar en cuenta que nombre de columna puede cambiar. 
    
  })
  
  
  
  #observeEvent(df_epid_sin(), {
  # updateSelectInput(session, "V1", choices=colnames(df_epid_sin()))
  #})
  
  #observeEvent(df_epid_sin(), {
  # updateSelectInput(session, "V2", choices=colnames(df_epid_sin()))
  #})
  
  
  observeEvent(input$action, {
    updateSelectInput(session, "V1", choices=colnames(df_epid_sin()))
  })
  
  observeEvent(input$action, {
    updateSelectInput(session, "V2", choices=colnames(df_epid_sin()))
  })
  
  
  
  
  # choix des variables importantes
  var_important <- reactive({
    data.frame(var_names=c(input$V1,input$V2))
  })
  
  table_RF <-  reactive({
    func_table_RF(var_important(), # analyse_RF()
                  sub_df_epid1(),
                  input$num_detectabilidad)          
  })
  
  
  comb_var <-  eventReactive(input$V2,{
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
    
    withProgress(message = 'Calculo en curso',
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
  
  
  sub_df_epid2 <- reactive({
    subset(df_epid(),Year==input$ano_actual & tipo_de_datos=="efectuado") # inicial
  })
  
  
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
  
  
  sub_df_epid_NR <- reactive({
    subset(df_epid(),tipo_de_datos %in% c("efectuado","nueva ronda")) # inicial
  })
  
  
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
  
  
  # n afficher que les resultats de nueva ronda
  sub_nueva_ronda <- reactive({
    subset(df_epid(),tipo_de_datos =="nueva ronda")
  })
  
  table_RF_nueva_ronda <-  reactive({
    func_table_RF(var_important(), # analyse_RF()
                  sub_nueva_ronda(),
                  input$num_detectabilidad)
  })
  
  
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
  output$out_sin_datos <- renderTable({
    TME.fijo(input$num_Pro_SD,
             input$num_n_SD,
             input$num_Inc_SD,
             input$num_eeInc_SD,
             input$num_agreg_SD,
             input$num_TMF_SD)
  })
  
  
}

shinyApp(ui, server)