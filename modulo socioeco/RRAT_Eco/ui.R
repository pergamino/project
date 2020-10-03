ui <- dashboardPage(
  
  header <- dashboardHeader(title = "Pronosticos Economicos"),
  
  sidebar <- dashboardSidebar(
    sidebarMenu(
      menuItem("Sistema de producción", tabName = "sistemaProd", icon = icon("th")),
      menuItem("Roya historica", tabName = "royaHistorica", icon = icon("th")),
      menuItem("Mano de obra", tabName = "manoObra", icon = icon("th")),
      menuItem("Pronostico", tabName = "pronostico", icon = icon("th"))
    )
  ),
  
  
  body <- dashboardBody(
    useShinyjs(),
    tags$head(
      tags$link(rel = "stylesheet", type = "text/css", href = "seroya.css")
    ),
    tabItems(
      
      # Sistema de produccion ---------------------------------------------------
      
      tabItem(tabName = "sistemaProd",
              
              fluidRow(
                # ########  1ere colone  ######## 
                
                column(width = 4, style='padding:25px;',
                       
                       # 1.1 : Tipología de productor
                       
                       box(
                         title = "Tipología de productor", status="success", width = NULL, solidHeader = TRUE,
                         color = "green", style='padding:25px;', collapsible = TRUE,
                         
                         # content
                         
                         fluidRow( 
                            column(width=12,
                                   selectInput("selPais","País",paises$pais,selected = NULL,multiple = FALSE,
                                      selectize = TRUE, width = NULL, size = NULL
                                   ),
                                   selectInput("selRegion",label="Región",choices="",selected=NULL,multiple=FALSE,
                                      selectize = TRUE, width = NULL, size = NULL
                                   ),
                                   #textInput("tiRegion",label="Región",value="REGION"),
                                   numericInput("niAlt", label = "Altitud promedio", value = NULL),
                                   textInput("tiTipoProductor",label="Tipo de productor", value = NULL),
                                   numericInput("niNumFam", label = "Num. fam. de este tipo en la zona", value = NULL)
                            )
                        )
                       ),
                       
                       # 1.2 : Familia
                       
                       box(
                         title = "Familia", width = NULL, solidHeader = TRUE,
                         color = "red", status="danger", style='padding:25px;', collapsible = TRUE,
                         
                         # content
                         fluidRow(
                           column(width = 12,
                                  numericInput("niTamFam", label = "Tamaño de la familia (num pers)", value = NULL),
                                  numericInput("niGastAlim", label = "Gasto de alimentacion familia ($/año)", value = NULL),
                                  numericInput("niAhorOtroIngres", label = "Ahorro u otros ingressos ($/año)", value = NULL),
                                  numericInput("niMargSosten", label = "Margen minima para sostenibilidad ($/año)", value = NULL)
                              )
                           )
                         )
                         
                       #)
                ),

                # 2eme colone ######## 

                column(width = 4, style='padding:25px;',
                       
                       # 2.1: Producción de café
                       
                       box(
                         title = "Producción de café", width = NULL, solidHeader = TRUE,
                         color = "olive",status="info", style='padding:25px;', collapsible = TRUE,
                         
                         # content
                         
                         fluidRow(
                           column(width = 12,
                                  numericInput("niAreaProd", label = "Area de producción (ha)", value = NULL),
                                  numericInput("niRedimCafeOro", label = "Rendimiento (q/ha) café oro", value = NULL),
                                  numericInput("niPrecioVentaCafe", label = "Precio de venta del café ($/q)", value = NULL),
                                  textInput("tiNivManejo",label = "Nivel de manejo",value=NULL)
                           )
                         )
                       ),
                       
                       # 2.2: Sistema de producción: costos
                       # !!!!!!!!!!!!!!!!
                       box(
                         title = "Sistema de producción: costos", width = NULL, solidHeader = TRUE,
                         color = "yellow",status="warning", style='padding:25px;', collapsible = TRUE,
                         
                         # content
                         fluidRow(
                           column(width = 12,
                                  numericInput("niCostoTratam", label = "Costo de 1 tratam. roya ($/ha)", value = NULL),
                                  textInput("tiNivCostoInsum",label="Nivel de costos de insumos",value=NULL),
                                  numericInput("niCostoIndirect", label = "% Costos indirectos", value = NULL),
                                  numericInput("niOtroCostoProd", label = "Otros costos de producción ($/año)", value = NULL)
                              )
                         )
                         
                       )
                ),

                #  ######## 3eme colone 
 
                column(width = 4, style='padding:25px;',
                       
                       # 3.1: Sistema de producción: mano de obra
                       
                       box(
                         title = "Sistema de Producción : Mano de obra", width = NULL, solidHeader = TRUE,
                         color = "orange",status="primary", style='padding:25px;', collapsible = TRUE,
                         
                         # content
                         
                         fluidRow(
                           column(width = 12,
                                  numericInput("niMumPeones", label = "Numero de peones permanentes", value = NULL),
                                  numericInput("niSalarDiaJornal", label = "Salario diario jornales ($/día)", value = NULL),
                                  numericInput("niCosecha", label = "Cosecha (días-hombre/q)", value = NULL),
                                  numericInput("niManoObraFam", label = "Mano de obra familiar (ETC)", value = NULL)
                           )
                         )
                       ),
                       
                       # 3.2: Variables externas
                       
                       box(
                         title = "Variables externas", width = NULL, solidHeader = TRUE,
                         color = "aqua",status="success", style='padding:25px;', collapsible = TRUE,
                         
                         # content
                         fluidRow(
                           column(width = 12,
                                  numericInput("niCanastaBasica", label = "Canasta basica ($/mes/persona)", value = NULL),
                                  numericInput("niPrecioTierra", label = "Precio Tierra", value = NULL),
                                  numericInput("niSueldoMinCiudad", label = "Sueldo minimo ciudad ($/mes)", value = NULL),
                                  numericInput("niSueldoMinCampo", label = "Sueldo minimo campo ($/mes)", value = NULL)
                                  )
                           )
                         )
                         
                       #)
                )
                
              ) 
              
      ), 
      
      # Roya historica ----------------------------------------------------------
      
      tabItem(tabName = "royaHistorica",
              
              # Box nombre de region y tipo de prod 
              
              fluidRow(
                
                box(color = "green",background = "green", width=12,
                    fluidRow(
                      column(width = 6,
                             textOutput("nombre_region"),
                             tags$head(tags$style("#nombre_region{color: white;
                                        font-size: 30px;
                                        font-style: bold;
                                        }"
                             )
                             )
                      ),
                      
                      column(width = 6,
                             textOutput("nombre_tipoProductor"),
                             tags$head(tags$style("#nombre_tipoProductor{color: white;
                                        font-size: 30px;
                                          font-style: bold;
                                          }"
                             )
                             )
                      )
                    )
                )
              ),
              
              
              # Box incidencia historica
              
              box(width=6, title = "Incidencia de la roya (promedio historico)",
                  solidHeader = TRUE,
                  status = "warning",
                  helpText("Haga clic en una celda para editarla"),
                  excelOutput("hot",height="100%")
              ),

              box(status="warning",plotOutput("plotRoyaHist"))
              
      ),
      
      
      # Mano de obra ------------------------------------------------------------
      
      
      tabItem(tabName = "manoObra",
              fluidRow(
                box(title = "Mano de obra familiar", 
                    # height = 340, width = NULL, 
                    solidHeader = TRUE,
                    color = "light-blue",
                    status="primary",
                    fluidRow(
                      column(width = 4,
                          numericInput("niDiasMesMOfam", label = "dias/mes MO familia", value = 25)
                      )
                    )
                )
              ),
              fluidRow(
                box(title = NULL, 
                    # height = 340, width = NULL, 
                    solidHeader = TRUE,
                    color = "light-blue",
                    fluidRow(
                      #column(width = 4,
                      #       box(title="Nivel de manejo", color = "light-blue",background = "light-blue", width=50,height = 100),
                      #       HTML("<b>Ninguno</b>"),
                      #       HTML("Minimo"),
                      #       HTML("Bajo"),
                      #       HTML("Medio"),
                      #       HTML("Alto")
                      #),
                      column(width = 6,
                             box(title="Mano de obra manejo (dias-hombres/ha)", color = "light-blue",background = "light-blue", width=50,height = 100),
                             numericInput("ningunMO", label = "Ninguno", value = NULL),
                             numericInput("minimoMO", label = "Minimo", value = NULL),
                             numericInput("bajoMO", label = "Bajo", value = NULL),
                             numericInput("medioMO", label = "Medio", value = NULL),
                             numericInput("altoMO", label = "Alto", value = NULL)
                      ),
                      column(width = 6,
                             box(title="Costos insumos nivel regular ($/ha)", color = "light-blue",background = "light-blue", width=50,height = 100),
                             numericInput("ningunCI", label = "Ninguno", value = NULL),
                             numericInput("minimoCI", label = "Minimo", value = NULL),
                             numericInput("bajoCI", label = "Bajo", value = NULL),
                             numericInput("medioCI", label = "Medio", value = NULL),
                             numericInput("altoCI", label = "Alto", value = NULL)
                      )
                      
                    )
                )
              )
      ),
      
      
      
      # Pronostico --------------------------------------------------------------
      
      
      tabItem(tabName = "pronostico",
              
              fluidRow(
                # column(width = 6,
                box(title="Vigilancia de incidencia de Roya",color = "navy",background ="navy", 
                    width=12,#height = 500,
                    fluidRow(
                      column(width = 4,
                             box(title=tags$p(style = "font-size: 70%;","Mes de la observacion de roya"),color = "teal",background ="teal", 
                                 width=20,height = 100,
                                 selectInput(inputId = "mesObs", label=NULL,
                                             choices=c("enero","febrero","marzo","abril","mayo","junio", "julio","agosto","setiembre","octubre","noviembre","diciembre"),width="200px")
                             )
                             
                      ),
                      column(width = 4,
                             box(title=tags$p(style = "font-size: 70%;","Incidencia Roya en %"),color = "blue",background = "blue",
                                 width=20,height = 100,
                                 numericInput("incObs",label=NULL,value=0,width="200px")
                             )
                             
                      ),
                      column(width = 4,
                             box(title=tags$p(style = "font-size: 70%;","Condiciones para crecimiento de Roya"),color = "olive",background = "olive",
                                 width=20,height = 100,
                                 selectInput(inputId = "condPro", label=NULL,
                                             choices=c("desfavorable","normales", "favorable","muy favorables"),width="200px")
                             )
                      )
                    ),
                    fluidRow(
                      column(
                        width=12,
                        plotOutput("plotVigilancia"),
                        verbatimTextOutput("salida", placeholder = FALSE)
                      ),
                    ),
                    fluidRow(
                      column(
                        width = 6,
                        h3("Máximo de incidencia de roya"),
                        fluidRow(
                          column(width=4,
                                 p("Histórico"),
                                 tags$div(id="maxRoyaBase")
                                 ),
                          column(width=4,
                                 p("Pronóstico"),
                                 tags$div(id="maxRoyaTendencial")
                                 ),
                          column(width=4,
                                 p("Con manejo de roya"),
                                 tags$div(id="maxRoyaManejo")
                                 )
                        ),
                        h3("Margen anual"),
                        fluidRow(
                          column(width=4,
                                 p("Histórico")
                          ),
                          column(width=4,
                                 p("Pronóstico")
                          ),
                          column(width=4,
                                 p("Con manejo de roya")
                          )
                        ),
                        h3("Seguridad Alimentaria y Nutricional"),
                        fluidRow(
                          column(width=4,
                                 p("Histórico")
                          ),
                          column(width=4,
                                 p("Pronóstico")
                          ),
                          column(width=4,
                                 p("Con manejo de roya")
                          )
                        ),
                        h3("Precio mínimo del café para sostenibilidad"),
                        fluidRow(
                          column(width=4,
                                 p("Histórico")
                          ),
                          column(width=4,
                                 p("Pronóstico")
                          ),
                          column(width=4,
                                 p("Con manejo de roya")
                          )
                        ),
                        h3("Ingresos netos del café"),
                        fluidRow(
                          column(width=4,
                                 p("Histórico")
                          ),
                          column(width=4,
                                 p("Pronóstico")
                          ),
                          column(width=4,
                                 p("Con manejo de roya")
                          )
                        ),
                      ),
                      column(
                        width = 6,
                        h3("Valor agregado del producto"),
                        fluidRow(
                          column(width=4,
                                 p("Histórico")
                          ),
                          column(width=4,
                                 p("Pronóstico")
                          ),
                          column(width=4,
                                 p("Con manejo de roya")
                          )
                        ),
                        h3("Valor agregado de los productores de la región"),
                        fluidRow(
                          column(width=4,
                                 p("Histórico")
                          ),
                          column(width=4,
                                 p("Pronóstico")
                          ),
                          column(width=4,
                                 p("Con manejo de roya")
                          )
                        ),
                        h3("Costo de oportunidad Jornaleo"),
                        fluidRow(
                          column(width=4,
                                 p("Histórico")
                          ),
                          column(width=4,
                                 p("Pronóstico")
                          ),
                          column(width=4,
                                 p("Con manejo de roya")
                          )
                        ),
                        h3("Costo de oportunidad Ciudad"),
                        fluidRow(
                          column(width=4,
                                 p("Histórico"),
                          ),
                          column(width=4,
                                 p("Pronóstico")
                          ),
                          column(width=4,
                                 p("Con manejo de roya")
                          )
                        ),
                        h3("Jornales contratados"),
                        fluidRow(
                          column(width=4,
                                 p("Histórico")
                          ),
                          column(width=4,
                                 p("Pronóstico")
                          ),
                          column(width=4,
                                 p("Con manejo de roya")
                          )
                        )
                      )
                    )
                ),
                
              )# fin fluidRow
              
      )# fin de tabItem Pronostico
      
      
    )# fin de tabItems
    
  ) # fin dashboardBody
) # fin dashboardPage

dashboardPage(
  header,
  sidebar,
  body
)
