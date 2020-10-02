# !!!!!!!!!!!!!! Ajouter une barre de chargement
# !!!!! Charger les donnees
# pour recuperer le nom du fichier = fonction baseName 


server <- function(input, output) {
  
  chooseSuscept <- reactive({
    subset(epid,catvariedad==input$nivSuscept & periodo2==input$feno & mes==input$selMes & anio==input$selAnio)
  })
  
  chooseAreas <- reactive({
    sa <- subset(areas,mes==input$selMes & anio==input$selAnio)
    sa
  })
  
  # chooseFeno <- reactive({
  #   subset(chooseSuscept(),Periodo==input$feno)
  # })
  
  output$outbreakMap <- renderLeaflet({
    
    # The render is not reactive here because it does not observe anything
    # It will only be used to initialize the leaflet map
    # The map update will be done with the proxy (see below)
    
    leaflet() %>% # the full data frame will be used
      addProviderTiles("Esri.WorldStreetMap") %>%
      setView(zonas,lng=-79,lat=10,zoom=5)
      # fitBounds(bnd_zonas$xmin, bnd_zonas$ymin, bnd_zonas$xmax, bnd_zonas$ymax) 
    # addPolygons(data=zonas, weight = 1, fillColor = ~alerta,
    # opacity = 1, color = ~alerta, fillOpacity = 0.7)
    
  })
  
  
  #### Update the leaflet map with the proxy ####
  
  observe({
    
    # The observer observes the data frame returned by the reactive expression tempDF
    
    # leafletProxy will update the existing leaflet object,
    # WITHOUT re-initializing it (unlike the render)
    # This way the map background is not reloaded again and the zoom is not reset.
    
    # For clusters, move the mouse over the circle to display the area concerned
    
    toto <- setNames(chooseSuscept()$alerta,chooseSuscept()$id)
    countN <- setNames(chooseSuscept()$n,chooseSuscept()$id)
    print(toto)
    # toto <- setNames(chooseFeno()$alerta,chooseFeno()$id)
    zonas$alerta <- toto[zonas$id]
    zonas$count <- countN[zonas$id]
    #print(zonas)
    leafletProxy(mapId = "outbreakMap") %>%
      clearShapes() %>% # deletes polygons
      addPolygons(data=zonas, weight = 1, fillColor = ~alerta,
                  opacity = 1, color = ~alerta, fillOpacity = 0.7, popup = ~paste("<b>Número de Registros: </b> ",count,sep=""))
    
  })
  
  output$approvalBox <- renderValueBox({
    valueBox(
      paste0(getMes(input$selMes)," ",input$selAnio), paste0(input$nivSuscept," - ",input$feno), icon = icon("map", lib = "font-awesome"), color = "blue", width=12
    )
  })
  
  output$comentario <- renderText({
    filter(cabeceras,anio==input$selAnio & mes==input$selMes)$comentario
  })
  
  output$areasplot2 <- renderPlot({
    areaespecifica1 <- subset(areas,mes==input$selMes & anio==input$selAnio & periodo==1 & catvariedad==1)
    areaespecifica1$color <- factor(areaespecifica1$color,levels=c("#00b2f3", "#63fd2c", "#fffc00","#fabf00","#fd0100"))
    
    areaespecifica2 <- subset(areas,mes==input$selMes & anio==input$selAnio & periodo==1 & catvariedad==2)
    areaespecifica2$color <- factor(areaespecifica2$color,levels=c("#00b2f3", "#63fd2c", "#fffc00","#fabf00","#fd0100"))
    
    areaespecifica3 <- subset(areas,mes==input$selMes & anio==input$selAnio & periodo==1 & catvariedad==3)
    areaespecifica3$color <- factor(areaespecifica3$color,levels=c("#00b2f3", "#63fd2c", "#fffc00","#fabf00","#fd0100"))
    
    areaespecifica4 <- subset(areas,mes==input$selMes & anio==input$selAnio & periodo==2 & catvariedad==1)
    areaespecifica4$color <- factor(areaespecifica4$color,levels=c("#00b2f3", "#63fd2c", "#fffc00","#fabf00","#fd0100"))
    
    areaespecifica5 <- subset(areas,mes==input$selMes & anio==input$selAnio & periodo==2 & catvariedad==2)
    areaespecifica5$color <- factor(areaespecifica5$color,levels=c("#00b2f3", "#63fd2c", "#fffc00","#fabf00","#fd0100"))
    
    areaespecifica6 <- subset(areas,mes==input$selMes & anio==input$selAnio & periodo==2 & catvariedad==3)
    areaespecifica6$color <- factor(areaespecifica6$color,levels=c("#00b2f3", "#63fd2c", "#fffc00","#fabf00","#fd0100"))
    
    areaespecifica7 <- subset(areas,mes==input$selMes & anio==input$selAnio & periodo==3 & catvariedad==1)
    areaespecifica7$color <- factor(areaespecifica7$color,levels=c("#00b2f3", "#63fd2c", "#fffc00","#fabf00","#fd0100"))
    
    areaespecifica8 <- subset(areas,mes==input$selMes & anio==input$selAnio & periodo==3 & catvariedad==2)
    areaespecifica8$color <- factor(areaespecifica8$color,levels=c("#00b2f3", "#63fd2c", "#fffc00","#fabf00","#fd0100"))
    
    areaespecifica9 <- subset(areas,mes==input$selMes & anio==input$selAnio & periodo==3 & catvariedad==3)
    areaespecifica9$color <- factor(areaespecifica9$color,levels=c("#00b2f3", "#63fd2c", "#fffc00","#fabf00","#fd0100"))
    
    if(nrow(areaespecifica1)>0)
    {
      plot1 <- ggplot(data=areaespecifica1) + geom_col(aes(x=factor(1), y=porcentaje, fill=color), width=1)
      plot1 <- plot1 + coord_polar(theta = "x") + theme(legend.position = "none", axis.title.x = element_blank(), axis.ticks = element_blank(), axis.text.y = element_blank()) + labs(title=element_blank(), x=element_blank(),y=element_blank()) + scale_fill_manual(breaks = c("#00b2f3", "#63fd2c", "#fffc00","#fabf00","#fd0100"), values=c("#00b2f3", "#63fd2c", "#fffc00", "#fabf00","#fd0100"))
    } else {
      plot1 <- ggplot() + theme_void()
    }
    
    if(nrow(areaespecifica2)>0)
    {
      plot2 <- ggplot(data=areaespecifica2) + geom_col(aes(x=factor(1), y=porcentaje, fill=color), width=1)
      plot2 <- plot2 + coord_polar(theta = "x") + theme(legend.position = "none", axis.title.x = element_blank(), axis.ticks = element_blank(), axis.text.y = element_blank()) + labs(title=element_blank(), x=element_blank(),y=element_blank()) + scale_fill_manual(breaks = c("#00b2f3", "#63fd2c", "#fffc00","#fabf00","#fd0100"), values=c("#00b2f3", "#63fd2c", "#fffc00", "#fabf00","#fd0100"))
    } else {
      plot2 <- ggplot() + theme_void()
    }
    
    if(nrow(areaespecifica3)>0)
    {
      plot3 <- ggplot(data=areaespecifica3) + geom_col(aes(x=factor(1), y=porcentaje, fill=color), width=1)
      plot3 <- plot3 + coord_polar(theta = "x") + theme(legend.position = "none", axis.title.x = element_blank(), axis.ticks = element_blank(), axis.text.y = element_blank()) + labs(title=element_blank(), x=element_blank(),y=element_blank()) + scale_fill_manual(breaks = c("#00b2f3", "#63fd2c", "#fffc00","#fabf00","#fd0100"), values=c("#00b2f3", "#63fd2c", "#fffc00", "#fabf00","#fd0100"))
      
    } else {
      plot3 <- ggplot() + theme_void()
    }
    
    if(nrow(areaespecifica4)>0)
    {
      plot4 <- ggplot(data=areaespecifica4) + geom_col(aes(x=factor(1), y=porcentaje, fill=color), width=1)
      plot4 <- plot4 + coord_polar(theta = "x") + theme(legend.position = "none", axis.title.x = element_blank(), axis.ticks = element_blank(), axis.text.y = element_blank()) + labs(title=element_blank(), x=element_blank(),y=element_blank()) + scale_fill_manual(breaks = c("#00b2f3", "#63fd2c", "#fffc00","#fabf00","#fd0100"), values=c("#00b2f3", "#63fd2c", "#fffc00", "#fabf00","#fd0100"))
    } else {
      plot4 <- ggplot() + theme_void()
    }
    
    if(nrow(areaespecifica5)>0)
    {
      plot5 <- ggplot(data=areaespecifica5) + geom_col(aes(x=factor(1), y=porcentaje, fill=color), width=1)
      plot5 <- plot5 + coord_polar(theta = "x") + theme(legend.position = "none", axis.title.x = element_blank(), axis.ticks = element_blank(), axis.text.y = element_blank()) + labs(title=element_blank(), x=element_blank(),y=element_blank()) + scale_fill_manual(breaks = c("#00b2f3", "#63fd2c", "#fffc00","#fabf00","#fd0100"), values=c("#00b2f3", "#63fd2c", "#fffc00", "#fabf00","#fd0100"))
      
    } else {
      plot5 <- ggplot() + theme_void()
    }
    
    if(nrow(areaespecifica6)>0)
    {
      plot6 <- ggplot(data=areaespecifica6) + geom_col(aes(x=factor(1), y=porcentaje, fill=color), width=1)
      plot6 <- plot6 + coord_polar(theta = "x") + theme(legend.position = "none", axis.title.x = element_blank(), axis.ticks = element_blank(), axis.text.y = element_blank()) + labs(title=element_blank(), x=element_blank(),y=element_blank()) + scale_fill_manual(breaks = c("#00b2f3", "#63fd2c", "#fffc00","#fabf00","#fd0100"), values=c("#00b2f3", "#63fd2c", "#fffc00", "#fabf00","#fd0100"))
    } else {
      plot6 <- ggplot() + theme_void()
    }
    
    if(nrow(areaespecifica7)>0)
    {
      plot7 <- ggplot(data=areaespecifica7) + geom_col(aes(x=factor(1), y=porcentaje, fill=color), width=1)
      plot7 <- plot7 + coord_polar(theta = "x") + theme(legend.position = "none", axis.title.x = element_blank(), axis.ticks = element_blank(), axis.text.y = element_blank()) + labs(title=element_blank(), x=element_blank(),y=element_blank()) + scale_fill_manual(breaks = c("#00b2f3", "#63fd2c", "#fffc00","#fabf00","#fd0100"), values=c("#00b2f3", "#63fd2c", "#fffc00", "#fabf00","#fd0100"))
    } else {
      plot7 <- ggplot() + theme_void()
    }
    
    if(nrow(areaespecifica8)>0)
    {
      plot8 <- ggplot(data=areaespecifica8) + geom_col(aes(x=factor(1), y=porcentaje, fill=color), width=1)
      plot8 <- plot8 + coord_polar(theta = "x") + theme(legend.position = "none", axis.title.x = element_blank(), axis.ticks = element_blank(), axis.text.y = element_blank()) + labs(title=element_blank(), x=element_blank(),y=element_blank()) + scale_fill_manual(breaks = c("#00b2f3", "#63fd2c", "#fffc00","#fabf00","#fd0100"), values=c("#00b2f3", "#63fd2c", "#fffc00", "#fabf00","#fd0100"))
    } else {
      plot8 <- ggplot() + theme_void()
    }
    
    if(nrow(areaespecifica9)>0)
    {
      plot9 <- ggplot(data=areaespecifica9) + geom_col(aes(x=factor(1), y=porcentaje, fill=color), width=1)
      plot9 <- plot9 + coord_polar(theta = "x") + theme(legend.position = "none", axis.title.x = element_blank(), axis.ticks = element_blank(), axis.text.y = element_blank()) + labs(title=element_blank(), x=element_blank(),y=element_blank()) + scale_fill_manual(breaks = c("#00b2f3", "#63fd2c", "#fffc00","#fabf00","#fd0100"), values=c("#00b2f3", "#63fd2c", "#fffc00", "#fabf00","#fd0100"))
    } else {
      plot9 <- ggplot() + theme_void()
    }
    
    pl <- list(plot4, plot6, plot5, plot7, plot9, plot8, plot1, plot3, plot2)
    col.titles = c("Materiales\n susceptibles\n            ","Materiales\n resistentes\n             ","Materiales\n medianamente resistentes")
    row.titles = c("Durante la cosecha\n                          ","Después de la cosecha,\n antes de la floración","Después de la floración,\n antes de la cosecha")
    pl[1:3] = lapply(1:3, function(i) arrangeGrob(pl[[i]], top=col.titles[i], widths = unit(5,"cm"), heights=unit(5,"cm")))
    grid.arrange(grobs=lapply(c(1,4,7), function(i) {
      arrangeGrob(grobs=pl[i:(i+2)], left=row.titles[i/3 + 1], nrow=1, heights=unit(5,"cm"))
    }), nrow=3)
  })
}