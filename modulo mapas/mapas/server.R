# !!!!!!!!!!!!!! Ajouter une barre de chargement
# !!!!! Charger les donnees
# pour recuperer le nom du fichier = fonction baseName 


server <- function(input, output) {
  waiting_screen <- tagList(
    spin_flower(),
    h4("Cargando datos desde Base de Datos Pergamino ...")
  )
  waiter_show(html = waiting_screen, color = "black")
  
  con <- dbConnect(PostgreSQL(), dbname = "pergamino", user = "admin",
                   host = "localhost",
                   password = "%Rsecret#")
  
  zonas <- st_read("CafeCardSHP/CafeRRAT5b.shp")
  zonas <- st_simplify(zonas, preserveTopology = T, dTolerance = 1)
  
  sql <- "select
a.nombre as RRAT5,
b.periodo as Periodo,
c.catvariedad as CATvariedad,
UPPER(d.pais) as pais,
z.incidencia_media as media,
e.color as alertares,
f.color as alertamed,
g.color as alertasus,
z.nregistros as n,
z.mes,
z.anio
from region_alerta a
inner join evaluacion_regional_roya_detalle z on a.cod_region = z.cod_region 
inner join periodo_fenologia b on b.cod_periodo = z.cod_periodo
inner join categoria_variedad c on c.cod_catvariedad = z.cod_catvariedad
inner join pais d on d.cod_pais = z.cod_pais
inner join (select cod_alerta, color from alertas) as e on e.cod_alerta = z.cod_alerta_res
inner join (select cod_alerta, color from alertas) as f on f.cod_alerta = z.cod_alerta_med 
inner join (select cod_alerta, color from alertas) as g on g.cod_alerta = z.cod_alerta_sus
order by z.anio, z.mes asc"
  
  epid <- dbGetQuery(con,sql)
  
  sqlareas <- "select 
case when periodo = 'Antes de cosecha' then 1 
when periodo = 'Durante cosecha' then 2
when periodo = 'Después de cosecha' then 3
end as periodo,
case when catvariedad = 'Susceptibles' then 1
when catvariedad = 'Medianamente resistentes' then 2
when catvariedad = 'Resistentes' then 3
end as catvariedad,
mes,
anio,
case when color = 'azul' then '#00b2f3'
when color = 'verde' then '#63fd2c'
when color = 'amarilla' then '#fffc00'
when color = 'naranja' then '#fabf00'
when color = 'rojo' then '#fd0100' end as color,
case when color = 'azul' then 1
when color = 'verde' then 2
when color = 'amarilla' then 3
when color = 'naranja' then 4
when color = 'rojo' then 5 end as orden,
areaalerta,
porcentaje
from alertas_porcentaje_areas order by periodo,catvariedad,mes,anio,orden"
  
  areas <- dbGetQuery(con,sqlareas)
  
  sql2 <- "select * from evaluacion_regional_roya order by anio, mes"
  cabeceras <- dbGetQuery(con,sql2)
  
  dbDisconnect(con)
  
  epid$periodo2 <- ifelse(epid$periodo== "Antes de cosecha",
                          "De la floración hasta la cosecha",
                          ifelse(epid$periodo == "Durante cosecha",
                                 "Durante de la cosecha",
                                 "De la cosecha hasta la floración"))
  
  periodo_feno <- unique(factor(epid$periodo2))
  defAnio <- max(epid$anio)
  defMes <- max(filter(epid,anio==defAnio)$mes)
  defVariedad <- ""
  defFenologia <- ""
  if(nrow(filter(epid,anio==defAnio & mes==defMes & catvariedad=="Susceptibles"))>0) {
    defVariedad <- "Susceptibles"
    if(nrow(filter(epid,anio==defAnio & mes==defMes & catvariedad=="Susceptibles" & periodo2 == "De la floración hasta la cosecha"))>0){
      defFenologia <- "De la floración hasta la cosecha"
    } else if(nrow(filter(epid,anio==defAnio & mes==defMes & catvariedad=="Susceptibles" & periodo2 == "Durante de la cosecha"))>0) {
      defFenologia <- "Durante de la cosecha"
    } else {
      defFenologia <- "De la cosecha hasta la floración"
    }
  } else if(nrow(filter(epid,anio==defAnio & mes==defMes & catvariedad=="Medianamente resistentes"))>0) {
    defVariedad <- "Medianamente resistentes"
    if(nrow(filter(epid,anio==defAnio & mes==defMes & catvariedad=="Medianamente resistentes" & periodo2 == "De la floración hasta la cosecha"))>0){
      defFenologia <- "De la floración hasta la cosecha"
    } else if(nrow(filter(epid,anio==defAnio & mes==defMes & catvariedad=="Medianamente resistentes" & periodo2 == "Durante de la cosecha"))>0) {
      defFenologia <- "Durante de la cosecha"
    } else {
      defFenologia <- "De la cosecha hasta la floración"
    }
  } else {
    defVariedad <- "Resistentes"
    if(nrow(filter(epid,anio==defAnio & mes==defMes & catvariedad=="Resistentes" & periodo2 == "De la floración hasta la cosecha"))>0){
      defFenologia <- "De la floración hasta la cosecha"
    } else if(nrow(filter(epid,anio==defAnio & mes==defMes & catvariedad=="Resistentes" & periodo2 == "Durante de la cosecha"))>0) {
      defFenologia <- "Durante de la cosecha"
    } else {
      defFenologia <- "De la cosecha hasta la floración"
    }
  }
  
  #print(defVariedad)
  #print(defFenologia)
  
  #epid <- read.xlsx("dataEpid/allData.xlsx")
  
  epid$alerta[epid$alertares!=""] <- epid$alertares[epid$alertares!=""]
  epid$alerta[epid$alertamed!=""] <- epid$alertamed[epid$alertamed!=""]
  epid$alerta[epid$alertasus!=""] <- epid$alertasus[epid$alertasus!=""]
  
  epid$id <- paste0(epid$rrat5,epid$pais)
  zonas$id <- paste0(zonas$RRAT5,zonas$PAIS)
  
  tabColors <- c("roja"="red","rojo"="red","naranja"="orange","amarillo"="yellow",
                 "amarilla"="yellow","verde"="green","azul"="blue") 
  
  epid$alerta <- tabColors[trim(epid$alerta)]
  
  
  variedad <- unique(factor(epid$catvariedad))
  
  
  
  
  anios <- unique(factor(epid$anio))
  
  zonas <- st_transform(zonas,4326) # à la place de 4326 "+proj=longlat +datum=WGS84"
  
  bnd_zonas <- st_bbox(zonas)
  
  minMes <- 1
  maxMes <- 12
  
  getMes <- function(mes)
  {
    switch(mes,"1" = "Enero", "2" = "Febrero","3" = "Marzo","4" = "Abril","5" = "Mayo","6" = "Junio","7" = "Julio","8" = "Agosto","9" = "Septiembre","10" = "Octubre","11" = "Noviembre","12" = "Diciembre")
  }
  waiter_hide()
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
    comentario <- filter(cabeceras,anio==input$selAnio & mes==input$selMes)$comentario
    urlinforme <- filter(cabeceras,anio==input$selAnio & mes==input$selMes)$archivo
    comentario
  })
  
  urlInforme <- reactive({
    urlinforme <- filter(cabeceras,anio==input$selAnio & mes==input$selMes)$archivo
    if(is.null(urlinforme))
      hide(id = "informe", anim = TRUE)
    else 
      show(id = "informe", anim = TRUE)
    urlinforme
  })
  
  observe({
    runjs(paste("$('#informe').attr('href','https://admin.redpergamino.net/files/",urlInforme(),"')",sep=""))
  })
  
  dataModal <- function(failed = FALSE) {
    modalDialog(
      title = "Guía de uso",
      size = "l",
      fluidRow(
        column(width=12,
               HTML("<embed src='guia_para_el_uso_de_mapalerta.pdf' type='application/pdf' internalinstanceid='44' title='' width='100%' height='890'>")      
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