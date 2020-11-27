# File to manage the interactions of the Shiny application

# Parameters:
# input: list of buttons, select box, sliders... defined in UI
# output: list of displays (tables, plots, maps...) defined in UI

suppressPackageStartupMessages({
  library("SHAPforxgboost"); library("ggplot2"); library("xgboost")
  library("data.table"); library("here"); library('plotly')
  library(lubridate)
})
library(DT)


server <- function(input, output, session) {
  
  observeEvent(input$predict, {
    
    
    if(anyNA(list(input$hGrowth,input$rP, input$shade, input$management), recursive = TRUE) || is.null(input$file)){
      
      showNotification('Por favor, introduzca todos los campos requeridos', type = 'error')
    }
    
    else{
      req(input$file) ## ?req #  require that the input is available
      inFile <- input$file 
      df <- read.csv(inFile$datapath, sep = ',', header = TRUE, check.names = FALSE)
      
      if("precipitacion" %in% colnames(df) && "tempmin" %in% colnames(df) && "tempmax" %in% colnames(df) && "fecha" %in% colnames(df))
      {
        names(df)[names(df) == "precipitacion"] <- "precipitacion"
        names(df)[names(df) == "tempmin"] <- "tmin"
        names(df)[names(df) == "tempmax"] <- "tmax"
        names(df)[names(df) == "fecha"] <- "fecha"
        df$fecha <- as_date(format(strptime(as.character(df$fecha), "%m/%d/%y" ),"%Y-%m-%d"))
      }
      else
      {
        df$fecha <- as.Date(df$fecha,format="%Y-%m-%d")
      }

      fechaI <- as.Date(as.character(input$date),format="%Y-%m-%d")
      
      df14_11 <- df[df$fecha >= fechaI - 14 & df$fecha <= fechaI - 11,'precipitacion']
      rDay14_11 <- sum(df14_11 >= 1)
      
      pre11_8 <- mean(df[df$fecha >= fechaI - 11 & df$fecha <= fechaI - 8,'precipitacion'])
      
      pre6_3 <- mean(df[df$fecha >= fechaI - 6 & df$fecha <= fechaI - 3,'precipitacion'])
      
      tmax9_6 <- mean(df[df$fecha >= fechaI - 9 & df$fecha <= fechaI - 6,'tmax'])
      
      tmin4_1 <- mean(df[df$fecha >= fechaI - 4 & df$fecha <= fechaI - 1,'tmin'])
      
      #comprobar que datos de clima disponibles para fecha de pronóstico
      if(anyNA(list(rDay14_11,pre11_8,tmax9_6,pre6_3,tmin4_1), recursive = TRUE)){
        
        showNotification('Los datos de clima del archivo subido no corresponden a 15 días antes de la fecha de medición de la enfermedad especificada', type = 'error')
        
      }
      
      else{
        
        #informar variables extraídas de clima
        
        output$textVar <- renderText({ 
          "Valores de variables predictivas a partir del archivo de clima:"
        })
        
        Variable <- c("Número de días lluviosos entre el día 14 y 11 antes de la medición de la incidencia actual (rDay14-11)",
                      "Precipitación acumulada promedio (mm) entre el día 11 y 8 antes de la medición de la incidencia actual (pre11-8)",
                      "Promedio de temperaturas máximas diarias (°C) entre el día 9 y 6 antes de la medición de la incidencia actual (tMax9-6)",
                      "Precipitación acumulada promedio (mm) entre el día 6 y 3 antes de la medición de la incidencia actual (pre6-3)",
                      "Promedio de temperaturas mínimas diarias (°C) entre el día 4 y 1 antes de la medición de la incidencia actual (tMin4-1)"
                      )
        
        Valor <- c(rDay14_11,pre11_8,tmax9_6,pre6_3,tmin4_1)
        
        dfVar <- data.frame(Variable,Valor)
        
        output$tblVar <- renderTable(dfVar, striped = TRUE,spacing = 'm',digits = 2)  
        
        #empezar proceso de predicción
        dI <- c(rDay14_11,pre11_8,tmax9_6,pre6_3,tmin4_1,input$hGrowth,input$rP,input$shade,input$management)
        
        instance <- data.frame(matrix(ncol=ncol(dataX)))
        
        names(instance) <- colnames(dataX)
        
        instance[nrow(instance)+1,] <- as.list(as.numeric(dI))
        
        instance <- na.omit(instance)
        
        predInstance <- predict(mod, as.matrix(instance))
        
        shap_valuesI <- shap.values(xgb_model = mod, X_train = as.matrix(instance))
        
        shapScores <- shap_valuesI$shap_score
        
        shapV <- data <- data.frame(
          name=colnames(dataX) ,  
          value=t(shapScores)
        )
        
        if (input$feno == 1 | input$feno == 3) {
          
          if(predInstance < 5){
            colorBox = 'aqua'
          }
          else if(predInstance >= 5 & predInstance < 15){
            colorBox = 'green'
          }
          else if(predInstance >= 15 & predInstance < 20){
            colorBox = 'yellow'
          }
          else if(predInstance >= 20 & predInstance < 30){
            colorBox = 'orange'
          }
          else {
            colorBox = 'red'
          }
          
          
        } else {
          if(predInstance < 3){
            colorBox = 'aqua'
          }
          else if(predInstance >= 3 & predInstance < 5){
            colorBox = 'green'
          }
          else if(predInstance >= 5 & predInstance < 10){
            colorBox = 'yellow'
          }
          else if(predInstance >= 10 & predInstance < 20){
            colorBox = 'orange'
          }
          else {
            colorBox = 'red'
          }
        }
        
        output$clriBox <- renderValueBox({
          valueBox(
            paste(round(predInstance, 2),'%', sep=''), paste("Incidencia prevista para el",fechaI + 28), icon = icon("viruses", lib = "font-awesome"),
            color = colorBox
          )
        })
        
        output$prediction <- renderPlot({
          shapV$impacto <- ifelse(shapV$value < 0, "negativo","positivo")
          ggplot(shapV, aes(x=name, y=value)) + 
            geom_bar(stat = "identity", width=0.5, aes(fill = impacto)) + 
            scale_fill_manual(values=c(positivo="firebrick1",negativo="steelblue")) + 
            labs(title = paste("Impacto en la predicción del modelo de acuerdo al valor base = ", round(shap_valuesI$BIAS0,2), "%"), x = "Variable", y = 'Impacto') +
            coord_flip() +
            theme(
              plot.title = element_text(size=14,face="bold"),
              axis.title=element_text(size=12,face="bold"),
              axis.text=element_text(size=12),
            )
        })
        
        
      } #end else
      
      
    } #end else
    
  })
  
    output$downloadData <- downloadHandler(
    filename <- function() {
      paste("muestraClima", "csv", sep=".")
    },
    
    content <- function(file) {
      file.copy("data/muestraClima.csv", file)
    },
    contentType = "text/csv"
  )
}