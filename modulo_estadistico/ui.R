# Asegurarse de tener todos los paquetes instalados

library(shiny)
library(shinydashboard)
library(shinyjs)
library(tableHTML)
library(DT)
library(shinyBS)

shinyUI(
    dashboardPage(
        dashboardHeader(title = "Pergamino"),
        dashboardSidebar(
            sidebarMenu(
                menuItem("Módulo Estadístico", tabName = "estadistico", icon = icon("chart-bar"))
            )
        ),
        dashboardBody(
            useShinyjs(),
            bsPopover(
                id = "semaforo",
                title = "Referencia para la probabilidad",
                content = "Rojo = Alta, Naranja = Regular, Amarillo =  Baja, Verde = Muy baja",
                trigger = "click",
                placement = "top",
                options = list(container = "body")),
            tabItem(
                tabName = "estadistico",
                h2(tags$b("Contenido del módulo estadístico")),
                h2(paste("Día de consulta:",Sys.Date())),
            ),
            tags$style(make_css(list('.box', 
                                     c('font-size', 'font-family', 'color'), 
                                     c('16px', 'arial', 'black')))),
            tabBox(
                id = "tabbox1", width = "1000px",
                tabPanel("Inicio",
                         fluidRow(
                             box(
                                 title = tags$p("Ajuste de temperatura", style = "font-size: 125%"),
                                 status = "success",
                                 solidHeader = TRUE,
                                 radioButtons(
                                     inputId = "sombra",
                                     label = "Seleccione si la parcela de café cuenta con sombra:",
                                     choices = c("Sí hay sombra", "No hay sombra")),
                                 radioButtons(
                                     inputId = "arboles",
                                     label = "Seleccione la altura de los árboles que producen sombra:",
                                     choices = c("Mayor o igual a 7 metros con sombra irregular",
                                                 "Mayor o igual a 7 metros con sombra regular",
                                                 "Menor a 7 metros"))
                             )
                            ),
                         fluidRow(
                             dataTableOutput("semaforo")
                        )
                ),
                tabPanel(
                    "Información del modelo",
                    fluidRow(
                        box(
                            title = tags$p("Modelo", style = "font-size: 125%"),
                            status = "primary",
                            solidHeader = TRUE,
                            selectInput(
                                inputId = "modelo",
                                label = "Seleccione el modelo",
                                choices = c("Modelo de infección", "Modelo de inicio de la esporulación", "Modelo de intensificación de la esporulación"),
                                selected = "Modelo de infección")
                        )
                    ),
                    fluidRow(
                        valueBoxOutput("prom_lluvia"),
                        valueBoxOutput("prom_temp_min"),
                        valueBoxOutput("prom_amp_term"),
                        valueBoxOutput("prom_temp_max"),
                        valueBoxOutput("amp_term"),
                        valueBoxOutput("temp_max"),
                        valueBoxOutput("prom_lluvia_2"),
                        valueBoxOutput("prom_lluvia_3")
                    ),
                    fluidRow(
                        title = tags$p("Probabilidad del modelo seleccionado", "font-size: 125%"),
                        valueBoxOutput("p_modelo1"),
                        valueBoxOutput("p_modelo2"),
                        valueBoxOutput("p_modelo3")
                    )
                )
            )
        )
    )
)