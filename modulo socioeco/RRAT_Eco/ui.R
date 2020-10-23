ui <- dashboardPage(
  
  header <- dashboardHeader(title = "SEROYA"),
  
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
                
                box(color = "green",background = "green", width=12,
                    fluidRow(
                      column(width = 3,
                             textOutput("nombre_region_sp"),
                             tags$head(tags$style("#nombre_region_sp{color: white;
                                        font-size: 30px;
                                        font-style: bold;
                                        }"
                             )
                             )
                      ),
                      
                      column(width = 5,
                             textOutput("nombre_tipoProductor_sp"),
                             tags$head(tags$style("#nombre_tipoProductor_sp{color: white;
                                        font-size: 30px;
                                          font-style: bold;
                                          }"
                             )
                             )
                      ),
                      column(width = 4,
                             fluidRow(
                               column(width = 6,
                                      downloadButton("sistemaDescargar","Descargar Sistema Productivo",icon=icon("arrow-alt-circle-down"),style="margin-top:23px;")         
                                      ),
                               column(width = 6,
                                      fileInput("sistemaUpload", label = "Subir Sistema Productivo", width = "200px")         
                                      )
                             )
                      )
                    )
                )
              ),
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
                      column(width = 3,
                             textOutput("nombre_region"),
                             tags$head(tags$style("#nombre_region{color: white;
                                        font-size: 30px;
                                        font-style: bold;
                                        }"
                             )
                             )
                      ),
                      
                      column(width = 5,
                             textOutput("nombre_tipoProductor"),
                             tags$head(tags$style("#nombre_tipoProductor{color: white;
                                        font-size: 30px;
                                          font-style: bold;
                                          }"
                             )
                             )
                      ),
                      column(width = 4,
                             fluidRow(
                              column(width=6,downloadButton("royaDescargar","Descargar datos de roya",icon=icon("arrow-alt-circle-down"),style="margin-top:23px;")),
                              column(width=6,fileInput("royaUpload",label="Subir datos de roya",width="200px")),
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
                
                box(color = "green",background = "green", width=12,
                    fluidRow(
                      column(width = 4,
                             textOutput("nombre_region_mo"),
                             tags$head(tags$style("#nombre_region_mo{color: white;
                                        font-size: 30px;
                                        font-style: bold;
                                        }"
                             )
                             )
                      ),
                      
                      column(width = 4,
                             textOutput("nombre_tipoProductor_mo"),
                             tags$head(tags$style("#nombre_tipoProductor_mo{color: white;
                                        font-size: 30px;
                                          font-style: bold;
                                          }"
                             )
                             )
                      ),
                      column(width = 4,
                             fluidRow(
                                column(width=6,downloadButton("moDescargar","Descargar datos Mano de Obra",icon=icon("arrow-alt-circle-down"),style="margin-top:23px;")),
                                column(width=6,fileInput("moUpload",label="Subir datos de Mano de Obra",width="200px")),
                             )
                      )
                    )
                )
              ),
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
                             uiOutput("box1"),
                             numericInput("ningunMO", label = "Ninguno", value = NULL),
                             numericInput("minimoMO", label = "Minimo", value = NULL),
                             numericInput("bajoMO", label = "Bajo", value = NULL),
                             numericInput("medioMO", label = "Medio", value = NULL),
                             numericInput("altoMO", label = "Alto", value = NULL)
                      ),
                      column(width = 6,
                             uiOutput("box2"),
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
                box(color = "green",background = "green", width=12,
                    fluidRow(
                      column(width = 4,
                             textOutput("nombre_region_pro"),
                             tags$head(tags$style("#nombre_region_pro{color: white;
                                        font-size: 30px;
                                        font-style: bold;
                                        }"
                             )
                             )
                      ),
                      column(width = 4,
                             textOutput("nombre_tipoProductor_pro"),
                             tags$head(tags$style("#nombre_tipoProductor_pro{color: white;
                                        font-size: 30px;
                                          font-style: bold;
                                          }"
                             )
                             )
                      )
                    )
                )
              ),
              fluidRow(
                # column(width = 6,
                box(title="Vigilancia de incidencia de Roya",color = "navy",background ="navy", 
                    width=12,#height = 500,
                    fluidRow(
                      column(width = 3,
                             box(title=tags$p(style = "font-size: 70%;","Mes de la observacion de roya"),color = "teal",background ="teal", 
                                 width=20,height = 100,
                                 selectInput(inputId = "mesObs", label=NULL,
                                             choices=c("enero","febrero","marzo","abril","mayo","junio", "julio","agosto","setiembre","octubre","noviembre","diciembre"),width="200px")
                             ),
                             box(title=tags$p(style = "font-size: 70%;","Incidencia Roya en %"),color = "blue",background = "blue",
                                 width=20,height = 100,
                                 numericInput("incObs",label=NULL,value=0,width="200px")
                             ),
                             box(title=tags$p(style = "font-size: 70%;","Condiciones para crecimiento de Roya"),color = "olive",background = "olive",
                                 width=20,height = 100,
                                 selectInput(inputId = "condPro", label=NULL,
                                             choices=c("desfavorable","normales", "favorable","muy favorables"),width="200px")
                             ),
                             box(title=tags$p(style = "font-size: 70%;","Pronóstico"),color = "orange",background = "orange",
                                 width=20,height = 100,
                                 selectInput(inputId = "pronostico", label=NULL,
                                             choices=c("Año en curso","Año siguiente"),width="200px")
                             )
                      ),
                      column(width=9,
                             plotOutput("plotVigilancia"),
                             )
                    ),
                ),
                    fluidRow(
                      column(
                        width = 6,
                        style="padding:8px;",
                        box(width=12,
                        h3("Máximo de incidencia de roya"),
                        fluidRow(
                          column(width=4,
                                 p("Histórico"),
                                 div(id="maxRoyaBase", class="azul")
                                 ),
                          column(width=4,
                                 p("Pronóstico"),
                                 tags$div(id="maxRoyaTendencial", class="azul")
                                 ),
                          column(width=4,
                                 p("Con manejo de roya"),
                                 tags$div(id="maxRoyaManejo", class="azul")
                                 )
                        ),
                        h3("Margen anual"),
                        fluidRow(
                          column(width=4,
                                 p("Histórico"),
                                 tags$div(id="margenBase", class="verde2")
                          ),
                          column(width=4,
                                 p("Pronóstico"),
                                 tags$div(id="margenTendencial", class="verde2")
                          ),
                          column(width=4,
                                 p("Con manejo de roya"),
                                 tags$div(id="margenManejo", class="verde2")
                          )
                        ),
                        h3("Seguridad Alimentaria y Nutricional"),
                        fluidRow(
                          column(width=4,
                                 p("Histórico"),
                                 tags$div(id="sanBase", class="azul")
                          ),
                          column(width=4,
                                 p("Pronóstico"),
                                 tags$div(id="sanTendencial", class="azul")
                          ),
                          column(width=4,
                                 p("Con manejo de roya"),
                                 tags$div(id="sanManejo", class="azul")
                          )
                        ),
                        h3("Precio mínimo del café para sostenibilidad"),
                        fluidRow(
                          column(width=4,
                                 p("Histórico"),
                                 tags$div(id="preciosostcafeBase", class="azul")
                          ),
                          column(width=4,
                                 p("Pronóstico"),
                                 tags$div(id="preciosostcafeTendencial", class="azul")
                          ),
                          column(width=4,
                                 p("Con manejo de roya"),
                                 tags$div(id="preciosostcafeManejo", class="azul")
                          )
                        ),
                        h3("Ingresos netos del café"),
                        fluidRow(
                          column(width=4,
                                 p("Histórico"),
                                 tags$div(id="ingresosBase", class="azul")
                          ),
                          column(width=4,
                                 p("Pronóstico"),
                                 tags$div(id="ingresosTendencial", class="azul")
                          ),
                          column(width=4,
                                 p("Con manejo de roya"),
                                 tags$div(id="ingresosManejo", class="azul")
                          )
                        ),
                      )),
                      column(
                        width = 6,
                        style="padding:8px;",
                        box(width=12,
                        h3("Valor agregado del productor"),
                        fluidRow(
                          column(width=4,
                                 p("Histórico"),
                                 tags$div(id="valoragregadoBase", class="azul")
                          ),
                          column(width=4,
                                 p("Pronóstico"),
                                 tags$div(id="valoragregadoTendencial", class="azul")
                          ),
                          column(width=4,
                                 p("Con manejo de roya"),
                                 tags$div(id="valoragregadoManejo", class="azul")
                          )
                        ),
                        h3("Valor agregado de los productores de la región"),
                        fluidRow(
                          column(width=4,
                                 p("Histórico"),
                                 tags$div(id="valoragregadoRBase", class="azul2")
                          ),
                          column(width=4,
                                 p("Pronóstico"),
                                 tags$div(id="valoragregadoRTendencial", class="azul2")
                          ),
                          column(width=4,
                                 p("Con manejo de roya"),
                                 tags$div(id="valoragregadoRManejo", class="azul2")
                          )
                        ),
                        h3("Costo de oportunidad Jornaleo"),
                        fluidRow(
                          column(width=4,
                                 p("Histórico"),
                                 tags$div(id="costoopjornalBase", class="azul")
                          ),
                          column(width=4,
                                 p("Pronóstico"),
                                 tags$div(id="costoopjornalTendencial", class="azul")
                          ),
                          column(width=4,
                                 p("Con manejo de roya"),
                                 tags$div(id="costoopjornalManejo", class="azul")
                          )
                        ),
                        h3("Costo de oportunidad Ciudad"),
                        fluidRow(
                          column(width=4,
                                 p("Histórico"),
                                 tags$div(id="costoopciudadBase", class="verde2")
                          ),
                          column(width=4,
                                 p("Pronóstico"),
                                 tags$div(id="costoopciudadTendencial", class="verde2")
                          ),
                          column(width=4,
                                 p("Con manejo de roya"),
                                 tags$div(id="costoopciudadManejo", class="verde2")
                          )
                        ),
                        h3("Jornales contratados"),
                        fluidRow(
                          column(width=4,
                                 p("Histórico"),
                                 tags$div(id="jornalesBase", class="azul")
                          ),
                          column(width=4,
                                 p("Pronóstico"),
                                 tags$div(id="jornalesTendencial", class="azul")
                          ),
                          column(width=4,
                                 p("Con manejo de roya"),
                                 tags$div(id="jornalesManejo", class="azul")
                          )
                        )
                      )
                      )
                    )
                ),
                
              )# fin fluidRow
              
      )# fin de tabItem Pronostico
      
      
    )# fin de tabItems
    
  ) # fin dashboardBody


dashboardPage(
  header,
  sidebar,
  body
)
