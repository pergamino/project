library(shiny)
library(shinydashboard)
library(leaflet)




header <- dashboardHeader(titleWidth = 275,title = "Mapa de Alerta Regional")


############    Siderbar  #####################
sidebar <- dashboardSidebar(
  width = 275,
  radioButtons(inputId = "nivSuscept",
               label = "Nivel de susceptibilidad de la variedad",
               choices = levels(variedad),
               selected=levels(variedad)[1]),
  
  radioButtons(inputId = "feno",
               label = "Fenología",
               choices = levels(periodo_feno),
               selected = levels(periodo_feno)[1]),
  selectInput("selAnio", label = "Año", 
              choices = anios, 
              selected = 1),
  selectInput("selMes", label = "Mes", 
              choices = list("Enero" = 1, "Febrero" = 2, "Marzo" = 3, "Abril" = 4, "Mayo" = 5, "Junio" = 6, "Julio" = 7, "Agosto" = 8, "Septiembre" = 9, "Octubre" = 10, "Noviembre" = 11, "Diciembre" = 12), 
              selected = 1),
  box(title = "Colores de alerta",status="warning",height=350,width=250,
  img(src = "colorAlertas.png",height=250,width=240)
  )
)

############    Body    ######################

body <- dashboardBody(
  
  valueBoxOutput("approvalBox", width=12),
  fluidRow(
    box(width=7,leafletOutput(outputId = "outbreakMap", height = 660)),
    box(width=5, title="Síntesis de Alertas", status = "primary", solidHeader = TRUE,
      plotOutput('areasplot2')
    )
  )
  
)


############ 
dashboardPage(skin="green",
              header,
              sidebar,
              body
)