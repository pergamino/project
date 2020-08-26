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
      
      output$predInstance <- renderText({
        paste("The predicted CLRI is:", round(predInstance, 2), '%')
      })
      
      output$prediction <- renderPlot({
        shapV$impact <- ifelse(shapV$value < 0, "negative","positive")
        ggplot(shapV, aes(x=shapV$name, y=shapV$value)) + 
          geom_bar(stat = "identity", width=0.5, aes(fill = impact)) + 
          scale_fill_manual(values=c(positive="firebrick1",negative="steelblue")) + 
          labs(y = paste("Impact on model output value according to base value = ", round(shap_valuesI$BIAS0,2), "%"), x = "Feature") +
          coord_flip()
      }, width = 600)
      
      output$titleTF <- renderText({ "Windows for each weather variable according date of prediction" })
      
      output$tframes <- renderImage({
        list(src = here('shap','www','timeframesModCorr.png'),
             contentType = 'image/png',
             width = '600 px')
      }, deleteFile = FALSE)
      
    }
    
  })
  
  
}