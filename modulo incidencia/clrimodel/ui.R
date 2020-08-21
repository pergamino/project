# User interface definition file for the Shiny application

library(shiny)
library(ggplot2)
library(shinydashboard)
library(shinyBS)


# header
header <- dashboardHeader(title = "Pronóstico de incidencia de roya",titleWidth = 350)

# Sidebar --------------
sidebar<-dashboardSidebar(
  width = 350,
  sidebarMenu(id='sidebar',
    menuItem("Incidencia", tabName = "clri", icon = icon("viruses")),
    menuItem("Información", tabName = "info", icon = icon("info"))
  )
)


############    Body    ######################

body <- dashboardBody(
  # Also add some custom CSS to make the title background area the same
  # color as the rest of the header.
  tags$head(tags$style(HTML('
        .skin-red .main-header .logo {
          background-color: #dd4b39;
        }
        .skin-red .main-header .logo:hover {
          background-color: #dd4b39;
        }
      '))),
  valueBoxOutput("approvalBox", width=12),
  
  tabItems(
    tabItem(tabName = "clri",
            h2("Pronóstico de incidencia de roya"),
            
            p('Esta aplicación le permite predecir la incidencia de la roya del café a partir del clima, la sombra, el manejo, la información sobre el crecimiento del árbol de cafeto y la vigilancia de la enfermedad.'),
            p('Establezca los valores para cada variable y presione el botón "Estimar incidencia"'),
            
            fluidRow(
              box(title = HTML(paste("Variables climáticas",icon('cloud-sun'))),status = "success",solidHeader = TRUE,collapsible = TRUE,
                  
                numericInput("rDay14-11", label = h5("Número de días lluviosos entre el día 14 y 11 antes de la medición de la incidencia actual (rDay14-11)"), max = 4, value = 2, min = 0),
                numericInput("pre11-8", label = h5("Precipitación acumulada promedio (mm) entre el día 11 y 8 antes de la medición de la incidencia actual (pre11-8)"), value = 7.15, min = 0),
                numericInput("tMax9-6", label = h5("Promedio de temperaturas máximas diarias (°C) entre el día 9 y 6 antes de la medición de la incidencia actual (tMax9-6)"), value = 22, min = 0),
                numericInput("pre6-3", label = h5("Precipitación acumulada promedio (mm) entre el día 6 y 3 antes de la medición de la incidencia actual (pre6-3)"), value = 5.6, min = 0),
                numericInput("tMin4-1", label = h5("Promedio de temperaturas mínimas diarias (°C) entre el día 4 y 1 antes de la medición de la incidencia actual (tMin4-1)"), value = 17.5, min = 0),

              ),
              
              box(title = HTML(paste("Propiedades de cultivo y vigilancia",icon('leaf'))),status = "success",solidHeader = TRUE,collapsible = TRUE,
                selectInput("hGrowth", h5("Etapa de crecimiento de los cultivos 14 días antes de la medición de la enfermedad (hGrowth)"),  choices = list("Crecimiento" = 1, "Decrecimiento" = 0), selected=NULL),
                selectInput("shade", h5("Condición de sombra de los cultivo (shade)"),  choices = list("Bajo sombra" = 1, "Pleno sol" = 0), selected=NULL),
                selectInput("management", h5("Manejo del cultivo (management)"),  choices = list("Alto convencional" = 1, "Medio convencional" = 0), selected=NULL),
                
                numericInput("rP", label = h5("Incidencia actual (rP)"), value = 28.5, min = 0),
                
                #hr(),
                selectInput("feno", h5("Fenología"),  choices = list("De la cosecha hasta la floración" = 1, "De la floración hasta la cosecha" = 2, "Durante de la cosecha" = 3), selected=NULL),
                
                br(),
                actionButton("predict", "Estimar incidencia", icon = icon('code-branch'))
              )
            ),
            
            fluidRow(
              valueBoxOutput("clriBox", width = 12)
            ),
            fluidRow(
              column(12, align="center",
                     plotOutput("prediction"),
              )
            ),
            
            tags$i("El nombre de cada variable se encuentra en el formulario entre paréntesis. El valor base corresponde a el valor promedio de predicciones del modelo al momento de su entrenamiento."),
            
            br(),
            br()
            
    ),
    
    tabItem(tabName = "info",
            h2("Información sobre el modelo"),
            
            p('Para usar este modelo, debe tener el valor de vigilancia de la roya y la información del clima alrededor de la fecha en que fue medida, específicamente de 14 días antes.'),
            p('Los datos de clima deben estar en escala diaria. Las variables están caracterizadas en periodos de días consecutivos. La siguiente figura muestra los periodos para cada variable climática:'),
            
            fluidRow(
              column(12, align="center",
                     img(src = "ventanasTiempo.png",width=600,align = "center")
              )
            ),
            br(),
            p('Por ejemplo, la variable tMax9-6 quiere decir que se toma el promedio de las temperaturas máximas entre los días 9 y 6 antes del día que se hizo la medición de incidencia previa.'),
            
            hr(),
            h3("Investigación"),
            HTML('<p>Este modelo corresponde al resultado de trabajo de investigación conjunto entre la <b>Universidad del Cauca, CIRAD y CATIE.</b></p>'),
            p('El proceso para la construcción del modelo está publicado en el siguiente artículo:'),
              
              
            fluidRow(
                infoBox(
                  tags$b("Computers and Electronics in Agriculture"), 
                  HTML(paste("<a href='https://www.sciencedirect.com/science/article/abs/pii/S0168169920309315', target='_blank'>Discovering weather periods and crop properties favorable for coffee rust incidence from feature selection approaches</a>")),
                  icon = icon("book-open"),width = 12,color='red'),
            ),
            
            
    )
  ),
  
  # bsPopover(
  #   id        = "rDay14-11",
  #   title     = "rDay14-11",
  #   content   = "Número de días lluviosos entre el día 14 y 11 antes de la medición de la incidencia actual",
  #   trigger   = "hover",
  #   placement = "top",
  #   options   = list(container = "body")
  # ),
  # bsPopover(
  #   id        = "pre11-8",
  #   title     = "pre11-8",
  #   content   = "Precipitación acumulada promedio (mm) entre el día 11 y 8 antes de la medición de la incidencia actual",
  #   trigger   = "hover",
  #   placement = "top",
  #   options   = list(container = "body")
  # ),
  # bsPopover(
  #   id        = "tMax9-6",
  #   title     = "tMax9-6",
  #   content   = "Promedio de temperaturas máximas diarias (°C) entre el día 9 y 6 antes de la medición de la incidencia actual",
  #   trigger   = "hover",
  #   placement = "top",
  #   options   = list(container = "body")
  # ),
  # bsPopover(
  #   id        = "pre6-3",
  #   title     = "pre6-3",
  #   content   = "Precipitación acumulada promedio (mm) entre el día 6 y 3 antes de la medición de la incidencia actual",
  #   trigger   = "hover",
  #   placement = "top",
  #   options   = list(container = "body")
  # ),
  # bsPopover(
  #   id        = "tMin4-1",
  #   title     = "tMin4-1",
  #   content   = "Promedio de temperaturas mínimas diarias (°C) entre el día 4 y 1 antes de la medición de la incidencia actual",
  #   trigger   = "hover",
  #   placement = "top",
  #   options   = list(container = "body")
  # )
  
)




############ 
dashboardPage(skin="red",
              header,
              sidebar,
              body
)
