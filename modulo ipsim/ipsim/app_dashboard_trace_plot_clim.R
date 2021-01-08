###############################
# IPSIM APP (dashboard)
# Date 20.03.2020
# Autor : Natacha MOTISI
###############################

# Modif 02/04/2020 : ajout moulinette inoculum
# Modif 29/06/2020 : 3 modeles a comparer, modele simple, intermediaire, complet
# Ajout de la variable Input_calidad_del_manejo() dans func_ipsim() pour adapter au modele simple


library(shiny)
library(shinydashboard)
library(shinyBS)
library(bsplus)
library(collapsibleTree)
library(gridExtra)
source("0.1-archivo_epidemio.R")
source("0.1-archivo_meteo.R")
source("0.2-moulinette_inoculum.R")
source("1-moulinette_meteo_display.R")
source("2-ipsim_modeloCompletoLecaniPodaDefol.R")
source("3-pronostico_trace.R")
source("4.1-plot_pronostico2.R")
# source("4.2-plot_moulinette_meteo_trace.R")
source("4.3-infoBox_alerta.R")
source("4.6-plot_precip.R")
source("4.6-plot_temp.R")
source("4.6-plot_epid.R")

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
        
        actionButton("show", "Obtener datos de modelo climático", style="margin:20px;"),
        
        tags$br(),
        
        actionButton("show2", "Obtener mis datos de App Pergamino", style="margin:20px;"),
        
        tags$br()
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
              label = "Nutrición suficiente",
              choices = c("Si", "No")
            )
            %>%
              shinyInput_label_embed(
                shiny_iconlink() %>%
                  bs_embed_popover(
                    title = "2 categorias",
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
                    content = paste("Alta : >60% sombra",
                                    "Media : 40-60% sombra",
                                    "Baja : <40% sombra")
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
            width = 4,
            dateInput(
              inputId = "fecha_flo",
              label = "Fecha de la floración",
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
        ),
        
        
          
          fluidRow(
            h5(
              align = "center",
              tags$p(style = "font-weight: bold;", "Mes de aplicacion de quimicos")
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
          
        
        fluidRow(
          h5(
            align = "center",
            tags$p(style = "font-weight: bold;", "Calidad de la poda")
            
          ), 
          
          column(
            width = 6,
            selectInput(
              inputId = "CaliPoda1",
              label = "Enero",
              choices = c("Total", "P50%", "P25%", "No"),
              selected = "No"
            ),
            selectInput(
              inputId = "CaliPoda2",
              label = "Febrero",
              choices = c("Total", "P50%", "P25%", "No"),
              selected = "No"
            ),
            selectInput(
              inputId = "CaliPoda3",
              label = "Marzo",
              choices = c("Total", "P50%", "P25%", "No"),
              selected = "No"
            ),
            selectInput(
              inputId = "CaliPoda4",
              label = "Abril",
              choices = c("Total", "P50%", "P25%", "No"),
              selected = "No"
            ),
            selectInput(
              inputId = "CaliPoda5",
              label = "Mayo",
              choices = c("Total", "P50%", "P25%", "No"),
              selected = "No"
            ),
            selectInput(
              inputId = "CaliPoda6",
              label = "Junio",
              choices = c("Total", "P50%", "P25%", "No"),
              selected = "No"
            )
          ),
          column(
            width = 6,
            selectInput(
              inputId = "CaliPoda7",
              label = "Julio",
              choices = c("Total", "P50%", "P25%", "No"),
              selected = "No"
            ),
            selectInput(
              inputId = "CaliPoda8",
              label = "Agosto",
              choices = c("Total", "P50%", "P25%", "No"),
              selected = "No"
            ),
            selectInput(
              inputId = "CaliPoda9",
              label = "Setiembre",
              choices = c("Total", "P50%", "P25%", "No"),
              selected = "No"
            ),
            selectInput(
              inputId = "CaliPoda10",
              label = "Octubre",
              choices = c("Total", "P50%", "P25%", "No"),
              selected = "No"
            ),
            selectInput(
              inputId = "CaliPoda11",
              label = "Noviembre",
              choices = c("Total", "P50%", "P25%", "No"),
              selected = "No"
            ),
            selectInput(
              inputId = "CaliPoda12",
              label = "Diciembre",
              choices = c("Total", "P50%", "P25%", "No"),
              selected = "No"
            )
          )
        )
        
    ),

      menuItem(
        "Graficos",
        tabName = "graph",
        icon = icon("bar-chart-o")
      ),
    menuItem(
      "Arbol de relaciones",
      tabName = "arbol",
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
        
        column(width = 12, style="height:100%;",
          box(width = 12, title = "El marco general para la evaluación multiatributo del riesgo 
              de aumento de la incidencia de la roya de la hoja del café",
              status = "warning",
              solidHeader = T,
              img(
                src = "Fig1.png",
                style="height:100%;"
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
            img(
              src = "Fig2.png",
              style="height:100%;"
            )
            )
        ),
      
      tabItem(
        tabName = "tab3",
        box(width = 300,
            title = "¿Cómo se construye el modelo? ",
            status = "warning",
            solidHeader = T,
            img(
              src = "Fig3.png",
              style = "height:100%;"
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
                             fluidRow(
                               column(width = 6,
                                      box(
                             tableOutput("table_epid")
                                      )),
                             column(width = 6,
                                    box(title="Sus datos epidemiologicos",width=12,
                                        plotOutput("plot_epid"))
                             )
                             )
                             ),
                    tabPanel("Datos climaticos",
                             fluidRow(
                             column(width = 3,
                                    box(
                             tableOutput("table_meteo")
                             )),
                             
                             column(width = 9,
                                    box(title="Temperatura y eficacia de la latencia",width=12,style="overflow:auto;",
                                        plotOutput("plot_temp")),
                                    box(title="Precipitaciones y eficacia de la aparicion de las hojas, la infeccion y el lavado de las esporas",width=12,style="overflow:auto;height:600px;",
                                        plotOutput("plot_precip"))
                             )
                             ))
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
            box(title="Riesgo de crecimiento de la roya",width=12,
              plotOutput("plot_alerta"),
              textOutput("txt_alerta")),

            infoBoxOutput("progressBox"),
            # box(title="Principales procesos involucrados en el calculo del riesgo",width=12,
            #     plotOutput("plot_meteo")) 
              ),
          tags$style("#progressBox {width:500px;}")
          
        )
      ),
      tabItem(
        tabName = "arbol",
        
        tags$div(style="width:100%;height:800px;background-color:#fff;border-style:solid;border-width:1px;overflow:auto;",collapsibleTreeOutput("plot_arbol",height = "1500px",
                              width = "1950px"),
            width = 12)
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
    
    
    df_meteo_new <- reactive({
      fichier_meteo_new(df_meteo())
    })
    
    
    
    df_moulinette_meteo <- reactive({
      moulinette_meteo(df_meteo_new(),
                       df_epid_new())
    })
    
    df_moulinette_inoc <- reactive({
      moulinette_inoc(df_epid_new())
    })
    

    
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
    
    Input_poda1 <- reactive({
      switch(
        input$CaliPoda1,
        "Total" = 1,
        "P50%" = 2,
        "P25%" = 3,
        "No" = 4
      )
    })
   
    Input_poda2 <- reactive({
      switch(
        input$CaliPoda2,
        "Total" = 1,
        "P50%" = 2,
        "P25%" = 3,
        "No" = 4
      )
    })
    
    
    Input_poda3 <- reactive({
      switch(
        input$CaliPoda3,
        "Total" = 1,
        "P50%" = 2,
        "P25%" = 3,
        "No" = 4
      )
    })
    
    Input_poda4 <- reactive({
      switch(
        input$CaliPoda4,
        "Total" = 1,
        "P50%" = 2,
        "P25%" = 3,
        "No" = 4
      )
    })
    
    
    Input_poda5 <- reactive({
      switch(
        input$CaliPoda5,
        "Total" = 1,
        "P50%" = 2,
        "P25%" = 3,
        "No" = 4
      )
    })
    
    
    Input_poda6 <- reactive({
      switch(
        input$CaliPoda6,
        "Total" = 1,
        "P50%" = 2,
        "P25%" = 3,
        "No" = 4
      )
    })
    
    Input_poda7 <- reactive({
      switch(
        input$CaliPoda7,
        "Total" = 1,
        "P50%" = 2,
        "P25%" = 3,
        "No" = 4
      )
    })
    
    Input_poda8 <- reactive({
      switch(
        input$CaliPoda8,
        "Total" = 1,
        "P50%" = 2,
        "P25%" = 3,
        "No" = 4
      )
    })
    
    Input_poda9 <- reactive({
      switch(
        input$CaliPoda9,
        "Total" = 1,
        "P50%" = 2,
        "P25%" = 3,
        "No" = 4
      )
    })
    
    
    Input_poda10 <- reactive({
      switch(
        input$CaliPoda10,
        "Total" = 1,
        "P50%" = 2,
        "P25%" = 3,
        "No" = 4
      )
    })
    
    Input_poda11 <- reactive({
      switch(
        input$CaliPoda11,
        "Total" = 1,
        "P50%" = 2,
        "P25%" = 3,
        "No" = 4
      )
    })
    
    
    Input_poda12 <- reactive({
      switch(
        input$CaliPoda12,
        "Total" = 1,
        "P50%" = 2,
        "P25%" = 3,
        "No" = 4
      )
    })
    
    Input_poda <- reactive({
      c(Input_poda1(),Input_poda2(),Input_poda3(),Input_poda4(),Input_poda5(),Input_poda6(),
        Input_poda7(),Input_poda8(),Input_poda9(),Input_poda10(),Input_poda11(),Input_poda12())
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
    
    Input_calidad_del_manejo <- reactive({
      switch(input$CaliManejo,
             "Optimo" = 1,
             "Regular" = 2,
             "Deficiente" =3)
    })
     
    

    
    # IPSIM ----------------
    
    # V2020-06--------------
    
    df_ipsim <- reactive({
      func_ipsim(
        df_moulinette_meteo(),
        df_moulinette_inoc(),
        Input_carga_fruct(),
        Input_var(),
        Input_quimicos(),
        Input_nutri_adequada(),
        Input_calidad_del_manejo(),
        Input_fecha_flo(),
        Input_fecha_ini_cosecha(),
        Input_fecha_fin_cosecha(),
        Input_sombra(),
        Input_poda()
      )
    })
    

    
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
    

    
    output$plot_arbol <- renderCollapsibleTree({
      df_arbol <- data.frame(df_ipsim()[[2]])
      collapsibleTreeNetwork(df_arbol, 
                             attribute = "ResultAttribut", 
                             fill="Color",
                             fontSize = 14,
                             linkLength = 200,
                             zoomable = TRUE,
                             collapsed = F)
    })
    
    # Info Box sobre el riesgo del mes en curso

    df_infoBox <- reactive({
      func_infoBox(df_prono(),
                   df_epid_new(),
                   Input_fecha_flo(),
                   Input_fecha_ini_cosecha(),
                   Input_fecha_fin_cosecha())
    })
    
    output$txt_alerta <- renderText({
      "Las letras en rojo significan:
       AF : La incidencia va aumentar fuertemente el proximo mes,
       A : La incidencia va aumentar el proximo mes,
       E : La incidencia es estable o va aumentar levemente el proximo mes,
       B : La inciencia va bajar el proximo mes"
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
    
    
    output$plot_temp <- renderPlot(width=900,height=340,{
      func_temp(df_moulinette_meteo(),
                df_meteo_new())
    })
    
    output$plot_precip <- renderPlot(width=908,height=600,{
      func_precip(df_moulinette_meteo(),
                  df_meteo_new())
    })
    
    output$plot_epid <- renderPlot({
      func_plot_epid(df_epid_new())
    })
    
    # output$plot_meteo <- renderPlot({
    #   func_plot_meteo(
    #     df_moulinette_meteo(),
    #     df_ipsim()
    #   )
    # })
    
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
    
    dataModal <- function(failed = FALSE) {
      modalDialog(
        title = "Obtener datos de modelo climático",
        size = "l",
        fluidRow(
          column(width=12,
                 tags$iframe(src="https://admin.redpergamino.net/clima", height=600, width="100%", border=0, style="border-style:none;")     
          )
        ),
        footer = tagList(
          modalButton("Cerrar")
        )
      )
    }
    
    dataModal2 <- function(failed = FALSE) {
      modalDialog(
        title = "Obtener mis datos de App Pergamino",
        size = "l",
        fluidRow(
          column(width=12,
                 tags$iframe(src="https://admin.redpergamino.net/Identity/Account/LoginData?ReturnUrl=DataVigilancia", height=600, width="100%", border=0, style="border-style:none;")     
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
    
    observeEvent(input$show2, {
      showModal(dataModal2())
    })
  }
  
  shinyApp(ui, server)
  