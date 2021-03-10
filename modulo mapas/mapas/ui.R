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
               selected=defVariedad),
  
  radioButtons(inputId = "feno",
               label = "Fenología",
               choices = levels(periodo_feno),
               selected = defFenologia),
  selectInput("selAnio", label = "Año", 
              choices = anios, 
              selected = defAnio),
  selectInput("selMes", label = "Mes", 
              choices = list("Enero" = 1, "Febrero" = 2, "Marzo" = 3, "Abril" = 4, "Mayo" = 5, "Junio" = 6, "Julio" = 7, "Agosto" = 8, "Septiembre" = 9, "Octubre" = 10, "Noviembre" = 11, "Diciembre" = 12), 
              selected = defMes),
  tags$div(style="padding:15px;text-align:center;",actionLink("show", "Ver guía de uso", style="margin:20px;")
      
      
  ),
  box(title = "Colores de alerta",status="warning",height=350,width=250,
  img(src = "colorAlertas.png",height=250,width=240)
  ),
  tags$div(style="width: 240px;color: white;text-align: center;padding: 15px;",
           HTML("<br><br><b>Créditos:</b><br>Jacques Avelino,  jacques.avelino@cirad.fr <br>
              <br>
              Eliseo Martinez, eliseo.martinez@gmail.com <br>
              Grégoire Leclerc, gregoire.leclerc@cirad.fr <br>
              Natacha Motisi, natacha.motisi@cirad.fr <br>
              Pierre Bommel, pierre.bommel@cirad.fr <br>
              Guillaume Cornu guillaume.cornu@cirad.fr <br>
              Sylvain Falala sylvain.falala@cirad.fr "))
)

############    Body    ######################

body <- dashboardBody(
  useShinyjs(),
  valueBoxOutput("approvalBox", width=12),
  fluidRow(
    column(width=7,box(width=12,leafletOutput(outputId = "outbreakMap", height = 460)),
           box(width=12,style="min-height:160px;padding:20px;text-align: justify; font-size:14pt;",
               textOutput("comentario"),
               tags$hr(),
               a(id="informe","Ver informe completo",target="blank_")
          )
    ),
    box(width=5, title="Síntesis de Alertas", status = "primary", solidHeader = TRUE, height = 660,
      plotOutput('areasplot2', height = "570px")
    )
  )
  
)


############ 
dashboardPage(skin="green",
              header,
              sidebar,
              body
)