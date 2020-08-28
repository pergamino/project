###############################
# IPSIM APP (dashboard)
# Date 20.03.2020
# Autor : Natacha MOTISI
###############################

# Modif 02/04/2020: ajout moulinette inoculum

library(shiny)
library(shinydashboard)
library(shinyBS)
library(bsplus)
library(leaflet)
library(RPostgreSQL)

source("0.1-archivo_epidemio.R")
source("0.2-moulinette_inoculum.R")
source("1-moulinette_meteo.R")
source("2-ipsim.R")
source("3-pronostico.R")
source("4.1-plot_pronostico.R")
source("4.2-plot_moulinette_meteo.R")
source("4.3-infoBox_alerta.R")


ui <- dashboardPage(
  header <-
    dashboardHeader(title = "Pronostico del riesgo epidemiologico de la roya",
                    titleWidth = 450),
  
  # Sidebar --------------
  
  sidebar <- dashboardSidebar(
    width = 450,
    sidebarMenu(
      menuItem(
        "¿Qué es Ipsim?",
        tabName = "info",
        icon = icon("cog", lib = "glyphicon"),
        
        menuSubItem(
          "En pocas palabras",
          tabName = "tab1",
          icon = icon("list-alt")
        ),
        menuSubItem(
          "El ciclo de vida de la roya",
          tabName = "tab2",
          icon = icon("list-alt")
        ),
        menuSubItem(
          "¿Cómo se construye el modelo?",
          tabName = "tab3",
          icon = icon("list-alt")
        )
      ),
      
      menuItem(
        "Upload datos",
        tabName = "UploadDatos",
        icon = icon("table"),
        
        fileInput(
          "file_epid",
          label = "Upload datos epidemiologicos",
          accept = c("text/csv",
                     "text/comma-separated-values,text/plain",
                     ".csv")
          
        ),
        
        fileInput(
          "file_meteo",
          label = "Upload datos climaticos",
          accept = c("text/csv",
                     "text/comma-separated-values,text/plain",
                     ".csv")
        ),
        
        actionButton("show", "Obtener datos de modelo climático")
        
      ),
      
      menuItem(
        "Datos Cargadas",
        tabName = "datosCargadas",
        icon = icon("table")
      ),
      
      menuItem(
        "Variables del sistema",
        tabName = "varSist",
        icon = icon("dashboard"),
        
        fluidRow(
          column(
            width = 6,
            selectInput(
              inputId = "V",
              label = "Variedad",
              choices = c("Susceptible", "Moderamente susceptible", "Resistente")
            )
          ),
          
          column(
            width = 6,
            use_bs_popover(),
            selectInput(
              inputId = "CF",
              label = "Carga fructifera",
              choices = c("Alta", "Media", "Baja"),
              selected="Baja"
            )
            
            %>%
              shinyInput_label_embed(
                shiny_iconlink() %>%
                  bs_embed_popover(
                    title = "3 categorias",
                    content = paste("Alta : >40q/ha;",
                                    "Media : 17-40q/ha;",
                                    "Baja : <17q/ha")
                    ,
                    placement = "right",
                    tags$style(".popover{
                               min-width: 700px;
                               }")
                )
                    )
            
                  )
          ),
        
        fluidRow(
          column(
            width = 6,
            selectInput(
              inputId = "NAd",
              label = "Nutricion adecuada",
              choices = c("Si", "No")
            )
            %>%
              shinyInput_label_embed(
                shiny_iconlink() %>%
                  bs_embed_popover(
                    title = "3 categorias",
                    content = paste("Si : NPKMgS",
                                    "No : menos que NPKMgS")
                    ,
                    placement = "right",
                    tags$style(".popover{
                               min-width: 700px;
                               }")
                )
                    )
                  ),
          
          column(
            width = 6,
            selectInput(
              inputId = "SOMB",
              label = "Sombra",
              choices = c("Alta", "Media", "Baja o pleno sol"),
              selected="Baja o pleno sol"
            )
            
            %>%
              shinyInput_label_embed(
                shiny_iconlink() %>%
                  bs_embed_popover(
                    title = "3 categorias",
                    content = paste("Alta : >40% sombra",
                                    "Media : 20-40% sombra",
                                    "Baja : <20% sombra")
                    ,
                    placement = "right",
                    tags$style(".popover{
                               min-width: 700px;
                               }")
                )
                    )
                  )
              ),
        
        # hr(),
        
        fluidRow(
          h5(
            align = "center",
            tags$p(style = "font-weight: bold;", "Mes de aplicacion de quimicos:")
          ),
          column(
            width = 6,
            checkboxGroupInput(
              inputId = "Q1",
              label = NULL,
              choices =   c(
                "Enero"     = "1",
                "Febrero"   = "2",
                "Marzo"     = "3",
                "Abril"     = "4",
                "Mayo"      = "5",
                "Junio"     = "6"
              )
            )
            
          ),
          
          column(
            width = 6,
            checkboxGroupInput(
              inputId = "Q2",
              label = NULL,
              choices = c(
                "Julio"     = "7",
                "Agosto"    = "8",
                "Setiembre" = "9",
                "Octubre"   = "10",
                "Noviembre" = "11",
                "Diciembre" = "12"
              )
            )
          )
        ),
        
        
        # hr(),
        
        fluidRow(
          column(
            width = 4,
            dateInput(
              inputId = "fecha_flo",
              label = "Fecha de la floracion",
              value = "2017-04-01"
            )
          ),
          
          column(
            width = 4,
            dateInput(
              inputId = "fecha_ini_cosecha",
              label = "Fecha del inicio de la cosecha",
              value = "2017-10-01"
            )
          ),
          
          column(
            width = 4,
            dateInput(
              inputId = "fecha_fin_cosecha",
              label = "Fecha de la fin de la cosecha",
              value = "2018-01-01"
            )
          )
        )
          ),
      # menuItem(
      #   "Salidas de Ipsim",
      #   tabName = "salidas",
      #   icon = icon("list-alt")
      #   
      #   
      # ),
      menuItem(
        "Graficos",
        tabName = "graph",
        icon = icon("bar-chart-o")
      ),
      box(title = "Colores de alerta",status="warning",height=420,width=250,
          img(src = "colorAlertas.png",height=350,width=340)
      )
        )
  ),
  
  
  # Body --------------
  
  body <- dashboardBody(tags$style(
    HTML(
      '.popover-title {color:black;}
      .popover-content {color:black;}
      .main-sidebar {z-index:&;}'
    )
    ),
    
    
    tabItems(
      tabItem(
        tabName = "tab1",
        h2("Injury Profile Simulator"),
        fluidRow(
        #   column(width = 6,
        # box(
        #   title = "El modelo Ipsim",
        #   status = "info",
        #   solidHeader = TRUE, width=12
        #   
        # )
        #   ),
        
        column(width = 12,
          box(width = 200,
              title = "El marco general para la evaluación multiatributo del riesgo 
              de aumento de la incidencia de la roya de la hoja del café",
              status = "warning",
              solidHeader = T,
              column(12,align="center",
                img(
                  src = "Fig1.png", width='80%'
                )
              )
          )
        )
        )
        ),
        
        tabItem(
          tabName = "tab2",
          box(width = 300,
            title = "El ciclo de vida de la roya ",
            status = "warning",
            solidHeader = T,
            column(12,align="center",
              img(
                src = "Fig2.png",
                width = "80%"
              )
            )
            )
        ),
      
      tabItem(
        tabName = "tab3",
        box(width = 300,
            title = "¿Cómo se construye el modelo? ",
            status = "warning",
            solidHeader = T,
            column(12,align="center",
              img(
                src = "Fig3.png",
                width = "80%"
              )
            )
        )
      ),  

        
        tabItem(tabName = "datosCargadas",
                fluidRow(
                  tabBox(
                    id = "tabset",
                    height = "500px",
                    width = "500px",
                    tabPanel("Datos epidemiologicos",
                             tableOutput("table_epid")),
                    tabPanel("Datos climaticos",
                             tableOutput("table_meteo"))
                  )
                )),
        
        
        # tabItem(tabName = "salidas",
        #         fluidRow(
        #           tabBox(
        #             id = "tabset",
        #             height = "500px",
        #             width = "500px",
        #             tabPanel("Moulinette clima",
        #                      tableOutput("moulinette")),
        #             tabPanel("Tendencias de crecimiento",
        #                      tableOutput("ipsim"))
        #           )
        #         )),
        
        
        tabItem(
          tabName = "graph",
          fluidRow(
            column(width = 6,
            box(title="Riesgo de crecimiento de la  roya",width=12,
              plotOutput("plot_alerta")),

            infoBoxOutput("progressBox")
              ),
            
            column(width = 6,
            box(title="Riesgos ligados al clima y las variables del sistema",width=12,
              plotOutput("plot_meteo"))
          ),
          tags$style("#progressBox {width:500px;}")
          
        )
      )
    ))
)
  
  
  
  dashboardPage(header,
                sidebar,
                body)
  
  
  server <- function(input, output) {
    # INFO
    
    
    
    # DATOS EPIDEMIOLOGICOS -------------
    
    df_epid <- reactive({
      inFile_epid <- input$file_epid
      
      if (is.null(inFile_epid))
        return(NULL)
      read.csv(inFile_epid$datapath, header = T)
    })
    
    output$table_epid <- renderTable({
      df_epid()
    })
    
    
    
    df_epid_new <- reactive({
      fichier_epid_new(df_epid())
    })
    
    
    # MOULINETTE METEO ----------------
    
    df_meteo <- reactive({
      inFile_meteo <- input$file_meteo
      
      if (is.null(inFile_meteo))
          return(NULL)
      read.csv(inFile_meteo$datapath, header = T)
    })
    
    
    output$table_meteo <- renderTable({
      df_meteo()
    })
    
    
    df_moulinette_meteo <- reactive({
      moulinette_meteo(df_meteo(),
                       df_epid_new())
    })
    
    df_moulinette_inoc <- reactive({
      moulinette_inoc(df_epid_new())
    })
    
    # output$moulinette <- renderTable({
    #   func_table_moulinette(df_moulinette_meteo())
    # })
    
    
    # Inputs var del sistema ----------------
    
    Input_fecha_flo <- reactive({
      input$fecha_flo
    })
    
    Input_fecha_ini_cosecha <- reactive({
      input$fecha_ini_cosecha
    })
    
    Input_fecha_fin_cosecha <- reactive({
      input$fecha_fin_cosecha
    })
    
    Input_carga_fruct <- reactive({
      switch(input$CF,
             "Alta" = 1,
             "Media" = 2,
             "Baja" = 3)
    })
    
    Input_sombra <- reactive({
      switch(
        input$SOMB,
        "Alta" = 1,
        "Media" = 2,
        "Baja o pleno sol" = 3
      )
    })
    
    Input_var <- reactive({
      switch(
        input$V,
        "Susceptible" = 1,
        "Moderamente susceptible" = 2,
        "Resistente" = 3
      )
    })
    
    
    
    Input_quimicos <- reactive({
      Q <- c(input$Q1, input$Q2)
      if (is.null(Q)) {
        return(NA)
      } else {
        as.vector(as.numeric(Q))
      }
    })
    
    Input_nutri_adequada <- reactive({
      switch(input$NAd,
             "Si" = 1,
             "No" = 2)
    })
    
    # IPSIM ----------------
    
    df_ipsim <- reactive({
      func_ipsim(
        df_moulinette_meteo(),
        df_moulinette_inoc(),
        Input_carga_fruct(),
        Input_var(),
        Input_quimicos(),
        Input_nutri_adequada(),
        Input_fecha_flo(),
        Input_fecha_ini_cosecha(),
        Input_fecha_fin_cosecha(),
        Input_sombra()
      )
    })
    
    # output$ipsim <- renderTable({
    #   func_table_ipsim(df_ipsim())
    # })
    
    
    df_prono <- reactive({
      func_prono (df_ipsim(),
                  df_epid_new(),
                  Input_var()
                  )
    })
    
    # Sorties Graphiques -------------
    
    # output$plot_alerta <- renderPlotly({
    output$plot_alerta <- renderPlot({
      func_plot(
        df_prono(),
        df_epid_new(),
        Input_fecha_flo(),
        Input_fecha_ini_cosecha(),
        Input_fecha_fin_cosecha()
      )
    })
    
    
    # Info Box sobre el riesgo del mes en curso
    
    # # Mes del ano
    # df_mes <- data.frame(num_mes = c(1:12),
    # nombre_mes = c("Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", "Agosto", "Setiembre", "Octubre", "Noviembre", "Diciembre")
    # )
    # 
    # 
    # # Riesgo del mes en curso
    # 
    # ano_en_curso <- reactive({
    #   subset(df_prono(),ano==max(ano))
    # })
    # 
    # mes_en_curso <- reactive({
    #   max(ano_en_curso()$num_mes)
    # })
    # 
    # nombre_mes_en_curso <- reactive({
    #   df_mes$nombre_mes[df_mes$num_mes==mes_en_curso()]
    # })
    # 
    # riesgo_del_mes <- reactive({
    #   ano_en_curso()$riesgo[ano_en_curso()$num_mes==mes_en_curso()]
    # })
    # 
    # df_riesgo <-  data.frame(riesgo=c(1:4),
    #                          nom_riesgo=c("aumentar fuertemente","aumentar",
    #                                       "matente estable o va aumentar levemente",
    #                                       "bajar")
    # )
    # 
    # incidencia_va <- reactive({
    #   df_riesgo$nom_riesgo[df_riesgo$riesgo==riesgo_del_mes()]
    # })
    
    df_infoBox <- reactive({
      func_infoBox(df_prono(),
                   df_epid_new(),
                   Input_fecha_flo(),
                   Input_fecha_ini_cosecha(),
                   Input_fecha_fin_cosecha())
    })
    
    
    output$progressBox <- renderInfoBox({
      infoBox(
        title=paste("Mes en curso:", df_infoBox()$nombre_mes_en_curso), 
        value=HTML(paste(df_infoBox()$incidencia_va,"el próximo mes",
                         br(),
                         "Color de alerta del mes en curso:", df_infoBox()$col_alerta_del_mes,
                         br(),
                         "Color de alerta del proximo mes:", df_infoBox()$col_alerta_proximo_mes)),
        icon = icon("list"),
        color = "purple"
      )
    })
    
    # output$plot_prono_txt <- renderPlot({
    #   func_plot_prono_txt(df_prono())
    # })
    
    output$plot_meteo <- renderPlot({
      func_plot_meteo(
        df_moulinette_meteo(),
        df_ipsim()
      )
    })
    
    # 27/06/2019 : download Data + plot --------------
    #
    # output$downloadData <- downloadHandler(
    #   filename = function() {
    #     paste(input$CF,
    #           "_",
    #           input$V,
    #           "_",
    #           input$Q,
    #           "_",
    #           input$NAd,
    #           ".csv",
    #           sep = "")
    #   },
    #   content = function(file) {
    #     write.csv(df_ipsim(), file)
    #   }
    # )
    
    # output$downloadPlot <- downloadHandler(
    #   filename = function() {
    #     paste(input$CF,
    #           "_",
    #           input$V,
    #           "_",
    #           input$Q,
    #           "_",
    #           input$NAd,
    #           ".png",
    #           sep = "")
    #   },
    #   content = function(file) {
    #     ggsave(
    #       file,
    #       plot = func_plot(
    #         df_ipsim(),
    #         df_epid_new(),
    #         Input_fecha_flo(),
    #         Input_fecha_ini_cosecha(),
    #         Input_fecha_fin_cosecha()
    #       ),
    #       device = "png"
    #     )
    #
    #   }
    # )
    
    # EM
    dataModal <- function(failed = FALSE) {
      modalDialog(
        title = "Obtener datos de modelo climático",
        size = "l",
        fluidRow(
          column(width=7,
                 leafletOutput(outputId = "selection", height = 400),
                 ),
          column(width=5,
                 div(style='height:400px; overflow-y: scroll',
                  tableOutput("table_clima")
                 )
          )
        ),
        footer = tagList(
          downloadButton("downloadData", "Download"),
          modalButton("Cerrar")
        )
      )
    }
    observeEvent(input$show, {
      showModal(dataModal())
      output$selection <- renderLeaflet({
        leaflet() %>% # the full data frame will be used
          addProviderTiles("Esri.WorldStreetMap") %>%
          setView(lng=-83.5,lat=13.1,zoom=5)
      })
    })
    
    observeEvent(input$selection_click, { 
      p <- input$selection_click  # typo was on this line
      con <- dbConnect(PostgreSQL(), dbname = "pergamino", user = "admin",
                       host = "localhost",
                       password = "%Rsecret#")
      sql <- paste("select cast(fecha as varchar) as fecha, precipitacion, temperatura from datosmodeloclima where gid in (select gid from climasamplingpoints order by st_distance(st_geogfromtext('POINT(",p$lng[1]," ",p$lat[1],")'),geom) limit 1)",sep="")
      rs <- dbGetQuery(con,sql)
      mydata <<- shiny::reactive(rs)
      dbDisconnect(con)
      output$table_clima <- renderTable(mydata())
      output$downloadData <- downloadHandler(
        filename = function() {
          paste("datosclimaticos.csv")
        },
        content = function(file) {
          write.csv(mydata(), file, row.names = TRUE)
        }
      )
    })
  }
  
  shinyApp(ui, server)
  