# Asegurarse de tener todos los paquetes instalados

library(shiny)
library(shinydashboard)
library(shinyjs)
library(dplyr)
library(tableHTML)
library(DT)
library(shinyBS)

datos_crudos <- readRDS("datos/datos_crudos.RDS")
source("modelos.R")

shinyServer(function(input, output, session) {
    
    data <- reactive({
        
        req(input$sombra,input$arboles)
        
        if (input$sombra == "Sí hay sombra" & input$arboles == "Menor a 7 metros"){
            
            datos_crudos$temp_min <- 1.23 + 0.94 * datos_crudos$temp_min
            datos_crudos$temp_max <- 6.56 + 0.77 * datos_crudos$temp_max
            datos_crudos$amplitud_termica <- datos_crudos$temp_max - datos_crudos$temp_min
            datos_crudos$probabilidad_lesion_en_10_dias <- sapply(datos_crudos$fecha,aparicion, data = datos_crudos)
            datos_crudos$probabilidad_inicio_esporulacion <- sapply(datos_crudos$fecha,esporulacion, data = datos_crudos)
            datos_crudos$pronostico_incremento_area_esporulada <- sapply(datos_crudos$fecha,intensificacion, data = datos_crudos)
            
        } else if (input$sombra == "Sí hay sombra" & input$arboles == "Mayor o igual a 7 metros con sombra irregular"){
            
            datos_crudos$temp_min <- 1.23 + 0.94 * datos_crudos$temp_min
            datos_crudos$temp_max <- 5.18 + 0.77 * datos_crudos$temp_max
            datos_crudos$amplitud_termica <- datos_crudos$temp_max - datos_crudos$temp_min
            datos_crudos$probabilidad_lesion_en_10_dias <- sapply(datos_crudos$fecha,aparicion, data = datos_crudos)
            datos_crudos$probabilidad_inicio_esporulacion <- sapply(datos_crudos$fecha,esporulacion, data = datos_crudos)
            datos_crudos$pronostico_incremento_area_esporulada <- sapply(datos_crudos$fecha,intensificacion, data = datos_crudos)
            
        } else if(input$sombra == "Sí hay sombra" & input$arboles == "Mayor o igual a 7 metros con sombra regular"){
            
            datos_crudos$temp_min <- 1.23 + 0.94 * datos_crudos$temp_min
            datos_crudos$temp_max <- 4.23 + 0.77 * datos_crudos$temp_max
            datos_crudos$amplitud_termica <- datos_crudos$temp_max - datos_crudos$temp_min
            datos_crudos$probabilidad_lesion_en_10_dias <- sapply(datos_crudos$fecha,aparicion, data = datos_crudos)
            datos_crudos$probabilidad_inicio_esporulacion <- sapply(datos_crudos$fecha,esporulacion, data = datos_crudos)
            datos_crudos$pronostico_incremento_area_esporulada <- sapply(datos_crudos$fecha,intensificacion, data = datos_crudos)
            
        }else {
            
            datos_crudos$temp_min <- datos_crudos$temp_min
            datos_crudos$temp_max <- datos_crudos$temp_max
            datos_crudos$amplitud_termica <- datos_crudos$temp_max - datos_crudos$temp_min
            datos_crudos$probabilidad_lesion_en_10_dias <- sapply(datos_crudos$fecha,aparicion, data = datos_crudos)
            datos_crudos$probabilidad_inicio_esporulacion <- sapply(datos_crudos$fecha,esporulacion, data = datos_crudos)
            datos_crudos$pronostico_incremento_area_esporulada <- sapply(datos_crudos$fecha,intensificacion, data = datos_crudos)
        }
        
        
        return(datos_crudos)
        
    })
    
    #Outputs de los valueBox
    
    output$prom_lluvia <- renderValueBox({
        valueBox(round(mean(data()$lluvia_diaria[(nrow(data())-24):(nrow(data())-15)]),3), tags$p("Promedio de la lluvia diaria (mm)", style = "font-size: 120%"), 
                 icon = icon("cloud"), color = "aqua")
    })
    
    output$prom_temp_min <- renderValueBox({
        valueBox(round(mean(data()$temp_min[(nrow(data())-11):(nrow(data())-9)]),3), tags$p("Promedio de la temperatura mínima del aire (°C)", style = "font-size: 120%"), 
                 icon = icon("thermometer-empty"), color = "blue")
    })
    
    output$prom_amp_term <- renderValueBox({
        valueBox(round(mean(data()$amplitud_termica[(nrow(data())-11):(nrow(data())-1)]),3), tags$p("Promedio de la amplitud térmica (°C)", style = "font-size: 120%"), 
                 icon = icon("thermometer-half"), color = "lime")
    })
    
    output$prom_temp_max <- renderValueBox({
        valueBox(round(mean(data()$temp_max[(nrow(data())-13):(nrow(data())-10)]),3), tags$p("Promedio de la temperatura máxima del aire (°C)", style = "font-size: 120%"), 
                 icon = icon("thermometer-full"), color = "maroon")
    })
    
    output$amp_term <- renderValueBox({
        valueBox(round(mean(data()$amplitud_termica[(nrow(data())-2)]),3), tags$p("Amplitud térmica (°C)", style = "font-size: 120%"), 
                 icon = icon("thermometer-half"), color = "light-blue")
    })
    
    output$temp_max <- renderValueBox({
        valueBox(round(data()$temp_max[(nrow(data()) - 1)],3), tags$p("Temperatura máxima (°C)", style = "font-size: 120%"), 
                 icon = icon("thermometer-full"), color = "purple")
    })
    
    output$prom_lluvia_2 <- renderValueBox({
        valueBox(round(mean(data()$lluvia_diaria[(nrow(data())-10):(nrow(data())-9)]),3), tags$p("Promedio de la lluvia diaria A (mm)", style = "font-size: 120%"), 
                 icon = icon("cloud"), color = "fuchsia")
    })
    
    output$prom_lluvia_3 <- renderValueBox({
        valueBox(round(mean(data()$lluvia_diaria[(nrow(data())-3):(nrow(data())-1)]),3), tags$p("Promedio de la lluvia diaria B (mm)", style = "font-size: 120%"), 
                 icon = icon("cloud"), color = "teal")
    })
    
    output$p_modelo1 <- renderValueBox({
        p1 <- round(data()$probabilidad_lesion_en_10_dias[nrow(data())],3)
        valueBox(p1, tags$p("Probabilidad de aparición de la lesión", style = "font-size: 120%"), 
                 icon = icon("cloud"),
                 color = ifelse(p1 >= 0.04, "red",
                                ifelse(p1 >= 0.02, "orange",
                                       ifelse(p1 >= 0.01, "yellow", "green"))))
    })
    
    output$p_modelo2 <- renderValueBox({
        p2 <- round(data()$probabilidad_inicio_esporulacion[nrow(data())],3)
        valueBox(p2, tags$p("Probabilidad de aparición de las primeras esporas", style = "font-size: 120%"), 
                 icon = icon("cloud"),
                 color = ifelse(p2 >= 0.31, "red",
                                ifelse(p2 >= 0.29, "orange",
                                       ifelse(p2 >= 0.24, "yellow", "green"))))
    })
    
    output$p_modelo3 <- renderValueBox({
        p3 <- round(data()$pronostico_incremento_area_esporulada[nrow(data())],4)
        valueBox(p3, tags$p("Pronóstico del incremento del área esporulada (cm",tags$sup("2"),")", style = "font-size: 115%"), 
                 icon = icon("cloud"),
                 color = ifelse(p3 >= 0.0347, "red",
                                ifelse(p3 >= 0.0342, "orange",
                                       ifelse(p3 >= 0.0333, "yellow", "green"))))
    })
    
    #Parte de selección del modelo
    
    observeEvent(input$modelo, {
        if (input$modelo == "Modelo de infección"){
            show("prom_lluvia"); show("prom_temp_min"); show("prom_amp_term"); 
            hide("prom_temp_max"); hide("amp_term"); hide("temp_max"); hide("prom_lluvia_2"); 
            hide("prom_lluvia_3"); show("p_modelo1"); hide("p_modelo2"); hide("p_modelo3");
            show("sombra") 
        } else if (input$modelo == "Modelo de inicio de la esporulación"){
            hide("prom_lluvia"); hide("prom_temp_min"); hide("prom_amp_term"); 
            show("prom_temp_max"); show("amp_term"); hide("temp_max"); show("prom_lluvia_2"); 
            show("prom_lluvia_3"); hide("p_modelo1"); show("p_modelo2"); hide("p_modelo3");
            show("sombra")
        } else if (input$modelo == "Modelo de intensificación de la esporulación"){
            hide("prom_lluvia"); hide("prom_temp_min"); hide("prom_amp_term"); 
            hide("prom_temp_max"); hide("amp_term"); show("temp_max"); hide("prom_lluvia_2"); 
            hide("prom_lluvia_3"); hide("p_modelo1"); hide("p_modelo2"); show("p_modelo3");
            show("sombra")
        }
    })
    
    # Aparación o no de la opción de altura de árboles
    
    observeEvent(input$sombra, {
        if (input$sombra == "Sí hay sombra"){
            show("arboles")
        } else {hide("arboles")}
    })
   
    output$semaforo <- renderDataTable({
        p1 <- round(data()$probabilidad_lesion_en_10_dias[nrow(data())],3)
        p2 <- round(data()$probabilidad_inicio_esporulacion[nrow(data())],3)
        p3 <- round(data()$pronostico_incremento_area_esporulada[nrow(data())],4)
        pn <- c(p1,p2,p3)
        nombres <- c("p1","p2","p3")
        fecha <- c(Sys.Date()+9, Sys.Date()+2, Sys.Date()+4)
        df <- data.frame(nombres,fecha,pn)
        df <- df %>%
            mutate(colores = ifelse(nombres == "p1",
                                    ifelse(pn >= 0.04, "r",
                                           ifelse(pn >= 0.02, "n",
                                                  ifelse(pn >= 0.01, "a",
                                                         "v"))),
                                    ifelse(nombres == "p2",
                                           ifelse(pn >= 0.31, "r",
                                                  ifelse(pn >= 0.29, "n",
                                                         ifelse(pn >= 0.24, "a",
                                                                "v"))),
                                           ifelse(nombres == "p3",
                                                  ifelse(pn >= 0.0347, "r",
                                                         ifelse(pn >= 0.0342, "n",
                                                                ifelse(pn >= 0.0333, "a",
                                                                       "v"))),
                                                  "no sirve"
                                           )
                                    )
            )
            )
        df$nombres <- c("Probabilidad de aparición de la lesión",
                        "Probabilidad de aparición de las primeras esporas",
                        "Pronóstico del incremento del área esporulada")
        df <- df %>% 
            select(nombres,fecha,colores)
        colnames(df) <- c("Pronóstico", "Fecha del pronóstico", "Indicador")
        
        datatable(df, selection = "none" ,rownames = FALSE, options = list(
            columnDefs = list(list(className = 'dt-center', targets = "_all")),
            dom = 't',
            order = FALSE, 
            headerCallback = DT::JS(
                "function(thead) {",
                "  $(thead).css('font-size', '1.3em');",
                "}"
            )
        ),caption = tags$a(icon("question-circle"), id = "1q")) %>% 
            formatStyle(
                'Indicador',
                color = styleEqual(
                    c("r","n","a","v"),
                    c("red","orange","yellow","limegreen")
                ),
                backgroundColor = styleEqual(
                    c("r","n","a","v"),
                    c("red","orange","yellow","limegreen")
                )
            ) %>%
            formatStyle(
                'Pronóstico',
                fontSize = '150%'
            ) %>%
            formatStyle(
                'Fecha del pronóstico',
                fontSize = '150%'
            )
        
    })
    
})
