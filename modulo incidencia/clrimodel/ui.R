# User interface definition file for the Shiny application

library(shiny)
library(ggplot2)
library(shinythemes)


ui <- navbarPage("CLRI Model",
     
     tabPanel("Predict CLRI",
              tags$h4("This app let you predict Coffee Leaf Rust Incidence from weather, disease monitoring, shade, management and host growth information"),
              tags$h4("Please set the values for each variable and press 'Predict CLRI' button"),
              sidebarLayout(
                 sidebarPanel(
                    
                    numericInput("rDay14-11", label = h5("Rainy Days between 14 and 11 days before CLRI measurement"), max = 4, value = 2, min = 0),
                    numericInput("pre11-8", label = h5("Average accumulated precipitation in mm between 11 and 8 days before CLRI measurement"), value = 7.15, min = 0),
                    numericInput("tMax9-6", label = h5("Average maximum air temperature in °C between 9 and 6 days before CLRI measurement"), value = 22, min = 0),
                    numericInput("pre6-3", label = h5("Average accumulated precipitation in mm between 6 and 3 days before CLRI measurement"), value = 5.6, min = 0),
                    numericInput("tMin4-1", label = h5("Average minimum air temperature in °C between 4 and 1 days before CLRI measurement"), value = 17.5, min = 0),
                   
                    selectInput("hGrowth", h5("Host growth during 14 days before CLRI measurement"),  choices = list("Growth" = 1, "Decrease" = 0), selected=NULL),
                    selectInput("shade", h5("Shade condition"),  choices = list("Shade" = 1, "Full Sun" = 0), selected=NULL),
                    selectInput("management", h5("Crop Management"),  choices = list("High Conventional" = 1, "Medium Conventional" = 0), selected=NULL),
                    
                    numericInput("rP", label = h5("Current CLRI"), value = 28.5, min = 0),
                    
                    actionButton("predict", "Predict CLRI")
                 ),
                 mainPanel(
                    verbatimTextOutput("predInstance"),
                    plotOutput("prediction"),
                    tags$br(),
                    tags$br(),
                    h4(textOutput("titleTF")),
                    imageOutput("tframes")
                 )
              )
     )           
)
