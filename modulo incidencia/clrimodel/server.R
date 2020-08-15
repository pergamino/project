# File to manage the interactions of the Shiny application

# Parameters:
# input: list of buttons, select box, sliders... defined in UI
# output: list of displays (tables, plots, maps...) defined in UI

suppressPackageStartupMessages({
  library("SHAPforxgboost"); library("ggplot2"); library("xgboost")
  library("data.table"); library("here"); library('plotly')
})
library(DT)


server <- function(input, output, session) {
  
  observeEvent(input$predict, {
    
    
    if(anyNA(list(input$`rDay14-11`,input$`pre11-8`,input$`tMax9-6`,input$`pre6-3`,input$`tMin4-1`,input$hGrowth,
                  input$rP, input$shade, input$management), recursive = TRUE)){
      
      showNotification('Please introduce values for all the features', type = 'error')
    }
    
    else{
      dI <- c(input$`rDay14-11`,input$`pre11-8`,input$`tMax9-6`,input$`pre6-3`,input$`tMin4-1`,input$hGrowth,
              input$rP, input$shade, input$management)
      
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
          paste(round(predInstance, 2),'%', sep=''), "Incidencia prevista para 28 días después de la fecha de vigilancia", icon = icon("viruses", lib = "font-awesome"),
          color = colorBox
        )
      })
      
      output$prediction <- renderPlot({
        shapV$impacto <- ifelse(shapV$value < 0, "negativo","positivo")
        ggplot(shapV, aes(x=shapV$name, y=shapV$value)) + 
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
      
      
    }
    
  })
  
  
}