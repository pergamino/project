
# Dependencias ------------------------------------------------------------

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

#global lat and lng
latG <<- -87.565
lngG <<- 14.1378


# Carga de datos y scripts --------------------------------------------------

source("03_llamados.R")
#llamadas a cada una de las partes

## Ultimos datos de pronostico generados y variables
#datos_pron_finales <- readRDS("datos/03_datos_pron_finales.RDS")

## Set de datos completo (para el historico)
#datos_pronosticos <- readRDS("datos/02_datos_pronosticos.RDS")


# Definicion del Server -----------------------------------------------------------

shinyServer(function(input, output, session) {

  dataModal <- function(failed = FALSE) {
    modalDialog(
      title = "Guía de uso",
      size = "l",
      fluidRow(
        column(width=12,
               HTML("<embed src='aspectos_tecnicos.pdf' type='application/pdf' internalinstanceid='44' title='' width='100%' height='890'>")      
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

  observeEvent(input$ejecutar, {
    
    #llamadas a cada una de las partes con archivo csv
    if(generar_datos(input) == 1){
      procesar_variables()
      generar_pronosticos()
    }

    
    ## Ultimos datos de pronostico generados y variables
    datos_pron_finales <- readRDS("datos/03_datos_pron_finales.RDS")
    
    ## Set de datos completo (para el historico)
    datos_pronosticos <- readRDS("datos/02_datos_pronosticos.RDS")

  
  # Datos reactivos ----------------------------------------------------------------
  
  ## Ultimos pronosticos: Seleccionar data segun la variante escogida 
  ## por el usuario 
  
  data <- reactive({
    
    req(input$sombra, input$arboles)
    
    if (input$sombra == "Sí hay sombra" & input$arboles == "Menor a 7 metros") {
      
      data <- datos_pron_finales %>%
        filter(modelo %in% c("mod_aparicion_s_baja",
                             "mod_esporulacion_s_baja",
                             "mod_intensificacion_s_baja"
                             )
               )
      
    } else if (input$sombra == "Sí hay sombra" & input$arboles == "Mayor o igual a 7 metros con sombra irregular") {
      
      data <- datos_pron_finales %>%
        filter(modelo %in% c("mod_aparicion_s_alta_irreg",
                             "mod_esporulacion_s_alta_irreg",
                             "mod_intensificacion_s_alta_irreg"
                             )
               )
      
    } else if(input$sombra == "Sí hay sombra" & input$arboles == "Mayor o igual a 7 metros con sombra regular") {
      
      data <- datos_pron_finales %>%
        filter(modelo %in% c("mod_aparicion_s_alta_reg",
                             "mod_esporulacion_s_alta_reg",
                             "mod_intensificacion_s_alta_reg"
                             )
               )
      
    } else {
      
      data <- datos_pron_finales %>%
        filter(modelo %in% c("mod_aparicion",
                             "mod_esporulacion",
                             "mod_intensificacion"
                             )
               )
    }
    
    return(data)
    
  })
  
  
  ## Datos históricos: Seleccionar data segun la variante escogida 
  ## por el usuario 
  
  data_historica <- reactive({
    
    req(input$sombra, input$arboles)
    
    if (input$sombra == "Sí hay sombra" & input$arboles == "Menor a 7 metros") {
      
      data_historica <- datos_pronosticos %>%
        select(fecha, 
               lluvia_diaria, 
               temp_min_sombra, 
               temp_max_s_baja,
               amplitud_term_s_baja, 
               mod_aparicion_s_baja,
               mod_esporulacion_s_baja, 
               mod_intensificacion_s_baja
               )
      
    } else if (input$sombra == "Sí hay sombra" & input$arboles == "Mayor o igual a 7 metros con sombra irregular") {
      
      data_historica <- datos_pronosticos %>%
        select(fecha,
               lluvia_diaria,
               temp_min_sombra,
               temp_max_s_alta_irreg,
               amplitud_term_s_alta_irreg, 
               mod_aparicion_s_alta_irreg,
               mod_esporulacion_s_alta_irreg,
               mod_intensificacion_s_alta_irreg
               )
      
    } else if(input$sombra == "Sí hay sombra" & input$arboles == "Mayor o igual a 7 metros con sombra regular") {
      
      data_historica <- datos_pronosticos %>%
        select(fecha, 
               lluvia_diaria, 
               temp_min_sombra, 
               temp_max_s_alta_reg,
               amplitud_term_s_alta_reg,
               mod_aparicion_s_alta_reg,
               mod_esporulacion_s_alta_reg,
               mod_intensificacion_s_alta_reg
               )
      
    } else {
      
      data_historica <- datos_pronosticos %>%
        select(fecha, 
               lluvia_diaria, 
               temp_min, temp_max,
               amplitud_termica, 
               mod_aparicion,
               mod_esporulacion, 
               mod_intensificacion)
    }
    
    
    return(data_historica)
    
  })
  
  
  # Eventos condicionales ---------------------------------------------------
  
  # Evento condicional: mostrar/ocultar variantes de altura del arbol en caja de
  # seleccion de la variante, en subseccion "Inicio"
  
  observeEvent(input$sombra, {
    
    if (input$sombra == "Sí hay sombra"){
      
      shinyjs::show("arboles")
      
    } else {
      
      shinyjs::hide("arboles")
      
    }
    
  })
  
  # Evento condicional: mostrar/ocultar los valueboxes con las variables y 
  # pronostico segun modelo seleccionado por el usuario, en subseccion 
  # "Informacion del modelo"
  
  observeEvent(input$modelo, {
    
    if (input$modelo == "Modelo de infección"){
      
      shinyjs::show("prom_lluvia"); 
      shinyjs::show("prom_temp_min"); 
      shinyjs::show("prom_amp_term"); 
      shinyjs::hide("prom_temp_max"); 
      shinyjs::hide("amp_term"); 
      shinyjs::hide("temp_max"); 
      shinyjs::hide("prom_lluvia_2"); 
      shinyjs::hide("prom_lluvia_3"); 
      shinyjs::show("p_modelo1"); 
      shinyjs::hide("p_modelo2"); 
      shinyjs::hide("p_modelo3");
      shinyjs::show("sombra") 
      
    } else if (input$modelo == "Modelo de inicio de la esporulación"){
      
      shinyjs::hide("prom_lluvia"); 
      shinyjs::hide("prom_temp_min"); 
      shinyjs::hide("prom_amp_term"); 
      shinyjs::show("prom_temp_max"); 
      shinyjs::show("amp_term"); 
      shinyjs::hide("temp_max"); 
      shinyjs::show("prom_lluvia_2"); 
      shinyjs::show("prom_lluvia_3");
      shinyjs::hide("p_modelo1"); 
      shinyjs::show("p_modelo2");
      shinyjs::hide("p_modelo3");
      shinyjs::show("sombra")
      
    } else if (input$modelo == "Modelo de intensificación de la esporulación"){
      
      shinyjs::hide("prom_lluvia");
      shinyjs::hide("prom_temp_min"); 
      shinyjs::hide("prom_amp_term"); 
      shinyjs::hide("prom_temp_max"); 
      shinyjs::hide("amp_term");
      shinyjs::show("temp_max");
      shinyjs::hide("prom_lluvia_2"); 
      shinyjs::hide("prom_lluvia_3"); 
      shinyjs::hide("p_modelo1"); 
      shinyjs::hide("p_modelo2"); 
      shinyjs::show("p_modelo3");
      shinyjs::show("sombra")
      
    }
    
  })
  
  
  # Output semaforo (en subseccion "Inicio") ---------------------------------------
  
  output$semaforo <- function() {
    
    pn <- c(round(data()[1, 2], 3), 
            round(data()[2, 2], 3), 
            round(data()[3, 2], 4))
    
    nombres <- c("p1", "p2", "p3")
    
    fecha <- c(data()[1, 1], data()[2, 1], data()[3, 1])
    
    df <- data.frame(nombres, fecha, pn)
    
    df <- df %>%
      mutate(colores = ifelse(nombres == "p1",
                              ifelse(pn >= 0.04, addLink("red"),
                                     ifelse(pn >= 0.02, addLink("orange"),
                                            ifelse(pn >= 0.01, addLink("yellow"),
                                                   addLink("limegreen")
                                                   )
                                            )
                                     ),
                              ifelse(nombres == "p2",
                                     ifelse(pn >= 0.31, addLink("red"),
                                            ifelse(pn >= 0.29, addLink("orange"),
                                                   ifelse(pn >= 0.24, addLink("yellow"),
                                                          addLink("limegreen")
                                                          )
                                                   )
                                            ),
                                     ifelse(nombres == "p3",
                                            ifelse(pn >= 0.0347, addLink("red"),
                                                   ifelse(pn >= 0.0342, addLink("orange"),
                                                          ifelse(pn >= 0.0333, addLink("yellow"),
                                                                 addLink("limegreen")
                                                                 )
                                                          )
                                                   ),
                                            "Error en ifelse del mutate del Semaforo"
                                            )
                                     )
                              )
             )
    
    df$nombres <- c("Probabilidad de aparición de la lesión a los 10 días",
                    "Probabilidad de aparición de las primeras esporas a los 3 días",
                    "Pronóstico del incremento del área esporulada a los 5 días")
    
    df <- df %>% 
      select(nombres, fecha, colores)
    
    colnames(df) <- c("Pronóstico", 
                      "Fecha para la cual se pronostica", 
                      "Indicador")
    
    # Generacion de la tabla con kable()
    
    df %>%
      knitr::kable(escape = F, align = "c") %>%
      kable_styling(font_size = 22)
    
  }
  
  
  # Outputs de los valueBoxes (subseccion "Informacion del modelo") ----------------------------------------------------
  
  # Modelo de la apricion de la lesion (infeccion)
  
  output$prom_lluvia <- renderValueBox({
    
    valueBox(round(data()[1, 4], 3), 
             tags$p("Promedio de la lluvia diaria (mm)", 
                    style = "font-size: 120%"
                    ), 
             icon = icon("cloud"), 
             color = "aqua"
             )
  })
  
  output$prom_temp_min <- renderValueBox({
    
    valueBox(round(data()[1, 6], 3), 
             tags$p("Promedio de la temperatura mínima del aire (°C)",
                    style = "font-size: 120%"
                    ), 
             icon = icon("thermometer-empty"), 
             color = "blue"
             
             )
  })
  
  output$prom_amp_term <- renderValueBox({
    
    valueBox(round(data()[1, 8], 3), 
             tags$p("Promedio de la amplitud térmica (°C)",
                    style = "font-size: 120%"
                    ), 
             icon = icon("thermometer-half"), 
             color = "purple"
             )
  })
  
  output$p_modelo1 <- renderValueBox({
    
    p1 <- round(data()[1, 2], 3)
    
    valueBox(p1, 
             tags$p("Probabilidad de aparición de la lesión", 
                        style = "font-size: 120%"
                        ), 
             icon = icon("cloud"),
             color = ifelse(p1 >= 0.04, "red",
                            ifelse(p1 >= 0.02, "orange",
                                   ifelse(p1 >= 0.01, "yellow", "green")
                                   )
                            ),
             )
  })
  
  
  # Modelo de esporulacion
  
  output$prom_temp_max <- renderValueBox({
    
    valueBox(round(data()[2, 7], 3), 
             tags$p("Promedio de la temperatura máxima del aire (°C)",
                    style = "font-size: 120%"
                    ), 
             icon = icon("thermometer-full"),
             color = "lime"
             )
  })
  
  output$amp_term <- renderValueBox({
    
    valueBox(round(data()[2,8],3),
             tags$p("Amplitud térmica (°C)",
                    style = "font-size: 120%"), 
             icon = icon("thermometer-half"),
             color = "purple"
             )
    
  })
  
  output$prom_lluvia_2 <- renderValueBox({
    
    valueBox(round(data()[2, 4], 3), 
             tags$p("Promedio de la lluvia diaria A (mm)",
                    style = "font-size: 120%"
                    ), 
             icon = icon("cloud"),
             color = "aqua"
             )
    
  })
  
  output$prom_lluvia_3 <- renderValueBox({
    
    valueBox(round(data()[2, 5], 3),
             tags$p("Promedio de la lluvia diaria B (mm)",
                    style = "font-size: 120%"
                    ), 
             icon = icon("cloud"),
             color = "aqua"
             )
    
  })
  
  output$p_modelo2 <- renderValueBox({
    
    p2 <- round(data()[2, 2], 3)
    
    valueBox(p2, 
             tags$p("Probabilidad de aparición de las primeras esporas", 
                        style = "font-size: 120%"
                        ), 
             icon = icon("cloud"),
             color = ifelse(p2 >= 0.31, "red",
                            ifelse(p2 >= 0.29, "orange",
                                   ifelse(p2 >= 0.24, "yellow", "green")
                                   )
                            ),
             )
  })
  
  
  # Modelo de intensificacion
  
  output$temp_max <- renderValueBox({
    
    valueBox(round(data()[3, 7], 3), 
             tags$p("Temperatura máxima (°C)", 
                    style = "font-size: 120%"
                    ), 
             icon = icon("thermometer-full"),
             color = "lime"
             )
    
  })
  
  output$p_modelo3 <- renderValueBox({
    
    p3 <- round(data()[3, 2], 4)
    
    valueBox(p3, 
             tags$p("Pronóstico del incremento del área esporulada (cm)",
                    tags$sup("2"),")", 
                    style = "font-size: 115%"
                    ), 
             icon = icon("cloud"),
             color = ifelse(p3 >= 0.0347, "red",
                            ifelse(p3 >= 0.0342, "orange",
                                   ifelse(p3 >= 0.0333, "yellow", "green")
                                   )
                            )
             )
  })
  

  # Output de botones de descarga (subseccion "Informacion del modelo") ---------------------------------------
  
  # Boton descarga de csv
  
  output$csv <- downloadHandler(
    
    filename = function() {
      
      paste0("reporte-", Sys.Date(),".csv")
      
    }, 
    content = function(fname) {
      
      df1 <- data.frame(data_historica())
      
      df1 <- tail(df1, 374)
      
      colnames(df1) <- c("Fecha", 
                         "Modelo aparición", 
                         "Modelo esporulación", 
                         "Modelo intensificación",
                         "Lluvia diaria", 
                         "Temperatura mínima",
                         "Temperatura máxima", 
                         "Amplitud térmica"
                         )
      
      write.csv(df1, fname, row.names = F)
      
    }
  )
  
  # Boton descarga de excel
  
  output$excel <- downloadHandler(
    
    filename = function(){
      
      paste0("reporte-", Sys.Date(),".xlsx")
      
    }, 
    content = function(file){
      
      df1 <- data.frame(data_historica())
      
      df1 <- tail(df1, 374)
      
      colnames(df1) <- c("Fecha", 
                         "Modelo aparición",
                         "Modelo esporulación", 
                         "Modelo intensificación",
                         "Lluvia diaria", 
                         "Temperatura mínima",
                         "Temperatura máxima",
                         "Amplitud térmica"
                         )
      
      write_xlsx(df1, path = file)
      
    }
  )
  
  
  # Output historico (subseccion "Informacion del modelo") ---------------------------------------
  
  output$historico <- function() {
    
    df1 <- data.frame(data_historica())
    
    df1 <- tail(df1, 374)
    
    colnames(df1) <- c("fecha", 
                       "lluvia_diaria",
                       "temp_min", "temp_max", 
                       "amp_term", 
                       "modelo_aparicion", 
                       "modelo_esporulacion", 
                       "modelo_intensificacion"
                       )
    df1 <- df1 %>% 
      arrange(desc(fecha)) %>%
      mutate(modelo_aparicion = round(modelo_aparicion, 4),
             modelo_aparicion = cell_spec(modelo_aparicion,
                                          "html",
                                          color      = ifelse(is.na(modelo_aparicion), "white",
                                                              ifelse(modelo_aparicion >= 0.04, "white",
                                                                     "black"
                                                                     )
                                                              ),
                                          background = ifelse(is.na(modelo_aparicion), "white",
                                                              ifelse(modelo_aparicion >= 0.04, "red",
                                                                     ifelse(modelo_aparicion >= 0.02, "orange",
                                                                            ifelse(modelo_aparicion >= 0.01, "yellow",
                                                                                   "limegreen"
                                                                                   )
                                                                            )
                                                                     )
                                                              ),
                                          extra_css  = paste(paste('background-color', sep = ': '),
                                                             'display: inline-block', 
                                                             'text-align: center', 
                                                             'padding: 0px', 
                                                             'margin: 0px', 
                                                             'width: 150px', 
                                                             sep = "; "
                                                             )
                                          ),
             modelo_esporulacion = round(modelo_esporulacion, 4),
             modelo_esporulacion = cell_spec(modelo_esporulacion,
                                             "html",
                                             color      = ifelse(is.na(modelo_esporulacion), "white",
                                                                 ifelse(modelo_esporulacion >= 0.31, "white",
                                                                        "black"
                                                                        )
                                                                 ),
                                             background = ifelse(is.na(modelo_esporulacion), "white",
                                                                 ifelse(modelo_esporulacion >= 0.31, "red",
                                                                        ifelse(modelo_esporulacion >= 0.29, "orange",
                                                                               ifelse(modelo_esporulacion >= 0.24, "yellow",
                                                                                      "limegreen"
                                                                                      )
                                                                               )
                                                                        )
                                                                 ),
                                             extra_css   = paste(paste('background-color', sep = ': '),
                                                                 'display: inline-block', 
                                                                 'text-align: center', 
                                                                 'padding: 0px', 
                                                                 'margin: 0px', 
                                                                 'width: 150px', 
                                                                 sep = "; "
                                                                 )
                                             ),
             modelo_intensificacion = round(modelo_intensificacion, 4),
             modelo_intensificacion = cell_spec(modelo_intensificacion,
                                                "html",
                                                color      = ifelse(is.na(modelo_intensificacion), "white",
                                                                    ifelse(modelo_intensificacion >= 0.0347, "white",
                                                                           "black"
                                                                           )
                                                                    ),
                                                background = ifelse(is.na(modelo_intensificacion), "white",
                                                                    ifelse(modelo_intensificacion >= 0.0347, "red",
                                                                           ifelse(modelo_intensificacion >= 0.0342, "orange",
                                                                                  ifelse(modelo_intensificacion >= 0.0333, "yellow",
                                                                                         "limegreen"
                                                                                         )
                                                                                  )
                                                                           )
                                                                    ),
                                                extra_css  = paste(paste('background-color', sep = ': '),
                                                                  'display: inline-block', 
                                                                  'text-align: center', 
                                                                  'padding: 0px', 
                                                                  'margin: 0px', 
                                                                  'width: 150px', 
                                                                  sep = "; "
                                                                  )
                                                ),
             lluvia_diaria = round(lluvia_diaria, 4),
             lluvia_diaria = cell_spec(lluvia_diaria,
                                       "html",
                                       color = ifelse(is.na(lluvia_diaria), 
                                                      "white",
                                                      "black"
                                                      )
                                       ),
             temp_min = round(temp_min, 4),
             temp_min = cell_spec(temp_min,
                                  "html",
                                  color = ifelse(is.na(temp_min), 
                                                 "white",
                                                 "black"
                                                 )
                                  ),
             temp_max = round(temp_max, 4),
             temp_max = cell_spec(temp_max,
                                  "html",
                                  color = ifelse(is.na(temp_max), 
                                                 "white",
                                                 "black"
                                                 )
                                  ),
             amp_term = round(amp_term, 4),
             amp_term = cell_spec(amp_term,
                                  "html",
                                  color = ifelse(is.na(amp_term), 
                                                 "white",
                                                 "black")
                                  ),
             )
    
    colnames(df1) <- c("Fecha",
                       "Lluvia diaria", 
                       "Temperatura mínima",
                       "Temperatura máxima", 
                       "Amplitud térmica",
                       "Modelo aparición", 
                       "Modelo esporulación", 
                       "Modelo intensificación"
                       )
    
    df1 <- df1[, c(1, 6:8, 2:5)]
    
    df1 %>%
      knitr::kable(format = "html", 
                   escape = F, 
                   align  = "c"
                   ) %>%
      kable_styling(position   = "center", 
                    full_width = T, 
                    font_size  = 15
                    ) %>%
      column_spec(1, 
                  width = "10em"
                  ) %>%
      scroll_box(width  = "100%", 
                 height = "400px"
                 ) 
    
  }
  
  
  # Output graficos historicos (subseccion "Graficos") ---------------------------------------
  
  # Grafico modelo de aparicion de la lesion (infeccion)
  
  output$grafico_modelo_aparicion <- renderDygraph ({
    
    datos_prob <- data.frame(data_historica())
    
    datos_prob <- tail(datos_prob, 374) 
    
    colnames(datos_prob) <- c("fecha", 
                              "lluvia_diaria",
                              "temp_min", 
                              "temp_max",
                              "amp_term",
                              "modelo_infeccion", 
                              "modelo_esporulacion", 
                              "modelo_intensificacion"
                              )
    
    xts(datos_prob$modelo_infeccion, 
        order.by = datos_prob$fecha
        ) %>%
      dygraph(main    = "Probabilidades para el Modelo de Infección") %>% 
      dyShading(from  = "0", 
                to    = "0.01", 
                axis  = "y",
                color ="#45CC46"
                ) %>% 
      dyShading(from  = "0.01",
                to    = "0.02", 
                axis  = "y",
                color ="#F6F500"
                ) %>% 
      dyShading(from  = "0.02", 
                to    = "0.04",
                axis  = "y",
                color ="#FF8F19"
                ) %>%
      dyShading(from  = "0.04", 
                to    = "1",
                axis  = "y",
                color ="#E71E1E"
                ) %>% 
      dySeries("V1", 
               label  = "Probabilidad"
               ) %>% 
      dyRangeSelector() %>% 
      dyLegend(show   = "always")
    
  })
  
  # Grafico modelo de esporulacion
  
  output$grafico_modelo_esporulacion <-renderDygraph ({
    
    datos_prob2 <- data.frame(data_historica())
    
    datos_prob2 <- tail(datos_prob2,367)
    
    colnames(datos_prob2) <- c("fecha", 
                               "lluvia_diaria",
                               "temp_min", 
                               "temp_max", 
                               "amp_term", 
                               "modelo_infeccion", 
                               "modelo_esporulacion", 
                               "modelo_intensificacion"
                               )
    
    xts(datos_prob2$modelo_esporulacion,
        order.by = datos_prob2$fecha
        ) %>%
      dygraph(main    = "Probabilidades para el Modelo de Esporulación") %>% 
      dyShading(from  = "0",
                to    = "0.24",
                axis  = "y",
                color ="#45CC46"
                ) %>% 
      dyShading(from  = "0.24",
                to    = "0.29", 
                axis  = "y",
                color ="#F6F500"
                ) %>% 
      dyShading(from  = "0.29", 
                to    = "0.31", 
                axis  = "y",
                color ="#FF8F19"
                ) %>%
      dyShading(from  = "0.31",
                to    = "1", 
                axis  = "y",
                color ="#E71E1E"
                ) %>% 
      dySeries("V1", 
               label  = "Probabilidad"
               ) %>% 
      #dyOptions(connectSeparatedPoints = TRUE) %>% 
      dyRangeSelector() %>% 
      dyLegend(show   = "always")
    
  })
  
  # Grafico de modelo de intensificacion
  
  output$grafico_modelo_intensificacion <- renderDygraph ({
    
    datos_prob3 <- data.frame(data_historica())
    
    datos_prob3 <- tail(datos_prob3, 367)
    
    colnames(datos_prob3) <- c("fecha", 
                               "lluvia_diaria",
                               "temp_min", 
                               "temp_max", 
                               "amp_term",
                               "modelo_infeccion", 
                               "modelo_esporulacion",
                               "modelo_intensificacion"
                               )
    
    xts(datos_prob3$modelo_intensificacion,
        order.by = datos_prob3$fecha
        ) %>%
      dygraph(main   = "Incremento para el Modelo de Intensificación") %>% 
      dyShading(from  = "0",
                to    = "0.0333", 
                axis  = "y",
                color ="#45CC46"
                ) %>% 
      dyShading(from  = "0.0333",
                to    = "0.0342", 
                axis  = "y",
                color ="#F6F500"
                ) %>% 
      dyShading(from  = "0.0342",
                to    = "0.0347",
                axis  = "y",
                color ="#FF8F19"
                ) %>%
      dyShading(from  = "0.0347", 
                to    = "1", 
                axis  = "y",
                color ="#E71E1E"
                ) %>% 
      dySeries("V1", 
               label  = "Probabilidad"
               ) %>% 
      dyRangeSelector() %>% 
      dyLegend(show   = "always")
    
  })
  
  # Descargar documento pdf
  
  output$downloadData <- downloadHandler(
    filename = "manual-de-usuario.pdf",
    content = function(file) {
      file.copy("datos/guia.pdf", file)
    }
  )

  })

  
})
