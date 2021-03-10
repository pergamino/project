# Dependencias ------------------------------------------------------------------------------

library(shiny)
library(shinydashboard)
library(shinyjs)
library(dplyr)
library(tableHTML)
library(shinyBS)
library(kableExtra)
library(knitr)
library(fontawesome)
library(writexl)
library(dygraphs)
library(xts)
#library(leaflet)


# Interfaz de usuario ------------------------------------------------------------------------------

shinyUI(
    
    # Se trabaja con Shinydashboard
    
    dashboardPage(
        
        # Cabecera del dashboard
        
        dashboardHeader(title = "Pergamino"),
        
        # Barra lateral del dashboard
        
        dashboardSidebar(
            sidebarMenu(
                menuItem("Módulo Estadístico", 
                         tabName = "estadistico", 
                         icon = icon("chart-bar")
                         ),
                menuItem("Datos Modelo Clima", 
                         tabName = "datos", 
                         icon = icon("download")
                )
                ),
                tags$div(style="padding:15px;",actionLink("show", "Información", style="margin:20px;")),
                tags$div(style="width: 215px;color: white;text-align: center;padding: 15px;",
                     HTML("<br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><b>Créditos:</b><br>Isabelle Merle, isabelle.merle@protonmail.com <br>
                        <br>
                        Jacques Avelino,  jacques.avelino@cirad.fr  <br>
                        Fabienne Ribeyre, fabienne.ribeyre@cirad.fr <br>
                        Grupo Dabia, https://www.grupodabia.com/nosotros/ "))
            ),
        
        # Cuerpo del dashboard --------------------------------------------------------------
        
        dashboardBody(
            
            # Configuracion de colores
            
            tags$style(".small-box.bg-yellow { background-color: #F6F500 !important; color: #FFFFFF !important; }"),
            tags$style(".small-box.bg-red { background-color: #E71E1E !important; color: #FFFFFF !important; }"),
            tags$style(".small-box.bg-orange { background-color: #FF8F19 !important; color: #FFFFFF !important; }"),
            tags$style(".small-box.bg-green { background-color: #45CC46 !important; color: #FFFFFF !important; }"),
            tags$style(".small-box.bg-purple { background-color: #BD68B4 !important; color: #FFFFFF !important; }"),
            tags$style(".small-box.bg-lime { background-color: #BBBBBB !important; color: #FFFFFF !important; }"),
            tags$style(HTML(".small-box {height: 125px}")),
            tags$style(HTML(".small-box {width: 330px}")),
            tags$style(HTML(".small-box {margin: 5px}")),
            tags$style(HTML(".box {width: 600px}")),
            useShinyjs(),
            
            # Popovers: Información sobre clasificacion por color de las probabilidades
            # y sobre las variables inputadas en los modelos
            
            bsPopover(
                id        = "semaforo",
                title     = "Referencia para la probabilidad",
                content   = "Rojo = Alta, Naranja = Regular, Amarillo =  Baja, Verde = Muy baja",
                trigger   = "hover",
                placement = "top",
                options   = list(container = "body")
            ),
            bsPopover(
                id        = "prom_lluvia",
                title     = "Detalle",
                content   = " Promedio de lluvia diaria en el periodo entre 33 y 24 días antes de la fecha para la cual se pronostica la aparición de la lesión",
                trigger   = "hover",
                placement = "top",
                options   = list(container = "body")
            ),
            bsPopover(
                id        = "prom_temp_min",
                title     = "Detalle",
                content   = "Promedio de la temperatura mínima del aire en el periodo entre 20 y 18 días antes de la fecha para la cual se pronostica la aparición de la lesión ",
                trigger   = "hover",
                placement = "top",
                options   = list(container = "body")
            ),
            bsPopover(
                id        = "prom_amp_term",
                title     = "Detalle",
                content   = "Promedio de la amplitud térmica diaria en el periodo entre 20 y 10 días antes de la fecha para la cual se pronostica la aparición de la lesión",
                trigger   = "hover",
                placement = "top",
                options   = list(container = "body")
            ), 
            bsPopover(
                id        = "prom_temp_max",
                title     = "Detalle",
                content   = "El promedio de la temperatura máxima del aire en el periodo entre 15 y 12 días antes de la fecha para la cual se pronostica la aparición de las primeras esporas",
                trigger   = "hover",
                placement = "top",
                options   = list(container = "body")
            ),
            bsPopover(
                id        = "prom_lluvia_2",
                title     = "Detalle",
                content   = "El promedio de la lluvia diaria en el periodo entre 12 y 11 días antes de la fecha para la cual se pronostica la aparición de las primeras esporas",
                trigger   = "hover",
                placement = "top",
                options   = list(container = "body")
            ),
            bsPopover(
                id        = "amp_term",
                title     = "Detalle",
                content   = "La amplitud térmica del día 4 antes de la fecha para la cual se pronostica la aparición de las primeras esporas",
                trigger   = "hover",
                placement = "top",
                options   = list(container = "body")),
            bsPopover(
                id        = "prom_lluvia_3 ",
                title     = "Detalle",
                content   = "El promedio de la lluvia diaria en el periodo entre 5 y 3 días antes de la fecha para la cual se pronostica la aparición de las primeras esporas",
                trigger   = "hover",
                placement = "top",
                options   = list(container = "body")
            ),
            bsPopover(
                id        = "temp_max",
                title     = "Detalle",
                content   = "La temperatura máxima del aire 5 días antes de la fecha para la cual se pronostica el incremento del área esporulada ",
                trigger   = "hover",
                placement = "top",
                options   = list(container = "body")
            ),
            bsPopover(
                id        = "p_modelo1",
                title     = "Detalle",
                content   = "Probabilidad de aparición de una lesión en un punto específico de la hoja de café a los 10 días",
                trigger   = "hover",
                placement = "top",
                options   = list(container = "body")
            ),
            bsPopover(
                id        = "p_modelo2",
                title     = "Detalle",
                content   = "Probabilidad de aparición de las primeras esporas en las lesiones de roya a los 3 días",
                trigger   = "hover",
                placement = "top",
                options   = list(container = "body")
            ),
            bsPopover(
                id        = "p_modelo3",
                title     = "Detalle",
                content   = "Pronóstico del incremento del área esporulada por lesión a los 5 días",
                trigger   = "hover",
                placement = "top",
                options   = list(container = "body")
            ),
            
            # contenido de tabs
            tabItems(
            tabItem(
                tabName   = "estadistico",
                h2(tags$b("Contenido del módulo estadístico")),
                h2(paste("Día de consulta:", Sys.Date()
                )
                ),
                fluidRow(
                    # ???
                    
                    tags$style(make_css(list('.box', 
                                             c('font-size', 'font-family', 'color'), 
                                             c('16px', 'arial', 'black')
                    )
                    )
                    ),
                    
                    # Caja de subsecciones: Inicio, Información del modelo y Graficos
                    
                    tabBox(
                        id = "tabbox1", width = "1000px",
                        
                        # Subseccion 1: Seleccion de variante de modelos y semaforo --------------------------------------------------------
                        
                        tabPanel("Inicio",
                                 
                                 # Tabla de seleccion de las variantes de la temperatura y los
                                 # modelos (INPUT)
                                 
                                 fluidRow(
                                     box(
                                         title       = HTML(paste("Datos variables climáticas",icon('cloud-sun'))),
                                         status      = "success",
                                         solidHeader = TRUE,
                                         ui <- fluidPage(
                                             
                                             # Input: Select a file ----
                                             fileInput("archivo_clima", "Seleccione el archivo CSV de clima:",
                                                       multiple = FALSE,
                                                       accept = c("text/csv",
                                                                  "text/comma-separated-values,text/plain",
                                                                  ".csv")),
                                             radioButtons("sep", "Separador",
                                                          choices = c(Coma = ",",
                                                                      Puntocoma = ";",
                                                                      Tab = "\t"),
                                                          selected = ","),
                                             actionButton("ejecutar", "Ejecutar modelo")
                                             
                                         )
                                     ),
                                     box(
                                         title       = tags$p("Ajuste de temperatura", style = "font-size: 100%"),
                                         status      = "success",
                                         solidHeader = TRUE,
                                         radioButtons(
                                             inputId  = "sombra",
                                             label    = "Seleccione si la parcela de café cuenta con sombra:",
                                             choices  = c("Sí hay sombra", "No hay sombra")
                                         ),
                                         radioButtons(
                                             inputId  = "arboles",
                                             label    = "Seleccione la altura de los árboles que producen sombra:",
                                             choices  = c("Mayor o igual a 7 metros con sombra irregular",
                                                          "Mayor o igual a 7 metros con sombra regular",
                                                          "Menor a 7 metros")
                                         )
                                     )

                                 ),
                                 
                                 # Semaforo de las probabilidades generadas a partir de la fecha 
                                 # actual (fp) para los tres modelos (OUTPUT)
                                 
                                 fluidRow(
                                     tableOutput("semaforo")
                                 )
                        ),
                        
                        # Subseccion 2: Variables, probabilidades e historico --------------------------------------------------------
                        
                        tabPanel(
                            "Información del modelo",
                            
                            # Lista desplegable para seleccionar el modelo de las variables
                            # a desplegar (INPUT)
                            
                            fluidRow(
                                column(width = 7,
                                       box(
                                           title       = tags$p("Modelo", style = "font-size: 125%"),
                                           status      = "primary",
                                           solidHeader = TRUE,
                                           selectInput(
                                               inputId  = "modelo",
                                               label    = "Seleccione el modelo",
                                               choices  = c("Modelo de infección", 
                                                            "Modelo de inicio de la esporulación", 
                                                            "Modelo de intensificación de la esporulación"
                                               ),
                                               selected = "Modelo de infección"
                                           )
                                       )
                                ),
                                column(
                                    width = 5,
                                    align = "center",
                                    fluidRow(
                                        
                                    )
                                    
                                )
                            ),
                            
                            # Valueboxes: variables del modelo seleccionado (OUTPUT)
                            
                            fluidRow(
                                titlePanel(tags$blockquote("Variables del modelo",
                                                           style = "font-size: 90%"
                                )
                                ),
                                titlePanel(tags$blockquote(tags$em("Para más información pase el cursor sobre las variables"),
                                                           style = "font-size: 70%"
                                )
                                ),
                                valueBoxOutput("prom_lluvia"),
                                valueBoxOutput("prom_temp_min"),
                                valueBoxOutput("prom_amp_term"),
                                valueBoxOutput("prom_temp_max"),
                                valueBoxOutput("amp_term"),
                                valueBoxOutput("temp_max"),
                                valueBoxOutput("prom_lluvia_2"),
                                valueBoxOutput("prom_lluvia_3")
                            ),
                            
                            # Valueboxes: pronostico de probabilidad del modelo seleccionado (OUTPUT)
                            
                            fluidRow(
                                title = tags$p("Probabilidad del modelo seleccionado",
                                               "font-size: 125%"),
                                valueBoxOutput("p_modelo1"),
                                valueBoxOutput("p_modelo2"),
                                valueBoxOutput("p_modelo3")
                            ),
                            
                            # Botones de descarga: histórico de pronosticos de los modelos
                            # según variante de temperatura seleccionada (OUTPUT)
                            
                            fluidRow(
                                column(
                                    width = 12,
                                    align = "left",
                                    downloadButton("csv", "Descargar CSV"),
                                    downloadButton("excel", "Descargar Excel")
                                )
                            ),
                            
                            # Tabla: histórico de pronosticos de los modelos según variante de 
                            # temperatura seleccionada (OUTPUT)
                            
                            fluidRow(
                                column(
                                    width = 12,
                                    align = "center",
                                    tableOutput("historico")
                                )
                            )
                        ),
                        
                        # Subseccion 3: Grafico del historico --------------------------------------------------------
                        
                        tabPanel(
                            "Gráficos",
                            
                            # Grafico de serie de tiempo: histórico de pronosticos de los modelos 
                            # según variante de temperatura seleccionada (OUTPUT)
                            
                            fluidRow(
                                dygraphOutput("grafico_modelo_aparicion"),
                                dygraphOutput("grafico_modelo_esporulacion"),
                                dygraphOutput("grafico_modelo_intensificacion")
                            )
                        )
                    )
                )
            ),
            tabItem(
                tabName   = "datos",
                h2(tags$b("Descargar datos de clima")),
                fluidRow(
                    ui <- fluidPage(
                        tags$iframe(
                            src = "https://admin.redpergamino.net/clima", 
                            width = "100%",
                            height = "1200",
                            scrolling = 'auto',
                            id = 'frame',
                        )
                    )
                )
            )
            
            )

            )
         )
      )