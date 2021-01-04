# Modif le 07/12/2020 : defoliacion eliminado del efecto sobre la cantidad de inoculo
# Modif le 19/10/2020: ajout de la defoliacion x aparicion de hoja x evolucion patogenica 
# Modif : 09/06/2020 : ajout effet de l'incidence sur l'efficacite du fongicide
# Modif : 20/04/2020: on enleve la table effet nutri sur defoliation
# Modif: 03/04/2020 :
# - changement de la table sensibilité liée à la charge fructifère
# - pas d'effet de la nutrition sur la defoliation table 12_2
# Modif 02/04/2020 : qte de spores = inoc precedent (niv incidence) x lessivage
# se combine ensuite avec l'infection et la latence 



func_ipsim <- function(output_moulinette,
                       output_incidencia,
                       carga_fruct,
                       variedad,
                       quimicos,
                       nutri_adecuada,
                       calidad_del_manejo,
                       date_floracion,
                       date_ini_cosecha,
                       date_fin_cosecha,
                       sombra,
                       poda) {
  
  library("magrittr")
  library("lubridate")
  
  
  # categories de risque ---------------
  
  
  # cat1: va aumentar fuertamente
  # cat2: va aumentar
  # cat3: es estable o va aumentar levemente
  # cat4: va bajar
  
  categorie <- c("La incidencia va aumentar fuertemente",
                 "La incidencia va aumentar",
                 "La incidencia es estable o va aumentar levemente",
                 "La incidencia va bajar")  
  
  initiale_categorie <- c("AF","A","E","B") 
  
  # Importation des tables de dexi -----------
  
  df1 <- read.table("data_internes/tablas_dexi/1-riesgo_de_crecimiento_de_la_roya.dat",h=T)
  df2 <- read.table("data_internes/tablas_dexi/2-riesgo_de_crecimiento_de_la_incidencia_antes_de_la_poda.dat",h=T)
  df3 <- read.table("data_internes/tablas_dexi/3-evolucion_de_la_poblacion_patogenica.dat",h=T)
  df4 <- read.table("data_internes/tablas_dexi/4-interaccion_clima_hospedero_patogeno.dat",h=T)
  df5 <- read.table("data_internes/tablas_dexi/5-efficacia_de_la_aplicacion_de_las_fungicidas.dat",h=T)
  df6 <- read.table("data_internes/tablas_dexi/6-crecimiento_potencial_de_la_poblacion_patogenica.dat",h=T)
  df7 <- read.table("data_internes/tablas_dexi/7-cantidad_de_esporas_disponible_para_la_infeccion.dat",h=T)
  df8.1 <- read.table("data_internes/tablas_dexi/8.1-inoculo_disponible_despues_del_parasitismo.dat",h=T)
  df8.2 <- read.table("data_internes/tablas_dexi/8.2-perdidas_de_esporas.dat",h=T)
  df9 <- read.table("data_internes/tablas_dexi/9-infeccion.dat",h=T)
  df10 <- read.table("data_internes/tablas_dexi/10-latencia.dat",h=T)
  df11 <- read.table("data_internes/tablas_dexi/11-susceptibilidad_del_hospedero.dat",h=T)
  df12 <- read.table("data_internes/tablas_dexi/12-susceptibilidad_fisiologica_del_hospedero.dat",h=T)
  df13 <- read.table("data_internes/tablas_dexi/13-efecto_del_fruto_sobre_la_susceptibilidad_de_la_hoja_a_la_roya.dat",h=T)
  df14 <- read.table("data_internes/tablas_dexi/14-defoliacion.dat",h=T)
  df15 <- read.table("data_internes/tablas_dexi/15-efecto_del_fruto_sobre_la_defoliacion.dat",h=T)
  df16 <- read.table("data_internes/tablas_dexi/16-aparicion_de_las_hojas.dat",h=T)
  df17 <- read.table("data_internes/tablas_dexi/17-interaccion_fruto_clima_nutricion_sobre_el_crecimiento_vegetativo.dat",h=T)
  df18 <- read.table("data_internes/tablas_dexi/18-interaccion_fruto_clima_sobre_el_crecimiento_vegetativo.dat",h=T)
  df19 <- read.table("data_internes/tablas_dexi/19-efecto_del_fruto_sobre_el_crecimiento_vegetativo.dat",h=T)
  
  
  # Les var qui varient avec le temps ----------------------
  
  
  # Fenologia del cafeto :
  # 1: desde la floracion hasta el inicio de la cosecha, 
  # 2: durante la cosecha, 
  # 3: fin de la cosecha hasta la floracion
  # floracion : Mars, avril
  # ini cosecha : octobre 
  # fin cosecha : janvier
  
  sub_df <- subset(output_moulinette,var=="Lavado")
  
  # ordonner les dates 
  sub_df <- sub_df[order(sub_df[,"fecha_med_monitoreo"]),]
  
  feno_cafe <- NULL
  for(f in 1:nrow(sub_df)){
    feno_cafe[f] = ifelse(sub_df$fecha_med_monitoreo[f]>=date_ini_cosecha & sub_df$fecha_med_monitoreo[f]<=date_fin_cosecha,2,
                          ifelse(sub_df$fecha_med_monitoreo[f]>date_floracion & sub_df$fecha_med_monitoreo[f]<=date_ini_cosecha,1,3))
  }

  ef_fruto_creci        <- NULL
  aparicion_hojas       <- NULL
  ef_fruto_def          <- NULL
  defoliacion           <- NULL
  suscept_lig_carga     <- NULL
  suscept_hosp_sombr    <- NULL
  suscept_hosp          <- NULL
  creci                 <- NULL
  int_clim_hosp_patog   <- NULL
  evo_pobla_patogenica  <- NULL
  riesgo                <- NULL
  int_fruto_clim        <- NULL
  ap_hoj_nutri_clim     <- NULL
  infecc                <- NULL
  perd_esp              <- NULL
  inoc_disp_desp_parasit<- NULL
  latenc                <- NULL
  ef_ap_fungicidas      <- NULL
  riesgo_antes_poda     <- NULL
  sortie_ipsimt2        <- NULL
  sortie_ipsim_ori      <- NULL
  cant_esp_disp         <- NULL
  
  
  # calendrier de traitements
  tratamiento <- rep(2,nrow(sub_df))
  mes_monit <- unique(month(sub_df$fecha_med_monitoreo))
  if(is.na(quimicos)) {
    tratamiento <- tratamiento
  } else {
    tratamiento[mes_monit %in% quimicos] <- 1
  }
  
  
  # calendrier poda
  df_poda <- data.frame(mes=1:12,
                        poda=poda)
  
  
  ##### Calcul des sorties ipsim ------------------------
  
  for(j in 1:nrow(sub_df)){
    # poda
    poda_del_mes <- df_poda$poda[df_poda$mes == mes_monit[j]]
    
    # Variables environnementales 

    # Inoculum de inoculo (para el parasitismo y eficacia fungicidas) : 
    # 1: bajo (inc<10%), 2: medio (inc [10-30%]), 3 : alto (inc>30%) 
    cant_inoc = subset(output_incidencia,var=="Inoculo")$cat[j]

    
    # Efecto de la incidencia sobre la defoliacion: 
    # 1: Efecto bajo de la incidencia sobre la defoliacion
    # 2: Efecto medio 
    # 3: Efecto alto 
    ef_inc_defol = subset(output_incidencia,var=="Efecto de la incidencia sobre la defoliacion")$cat[j]
    
    # Perdidas_de_esporas_por_lluvia 1: Lavado insuficiente, 2: lavado regular, 3: Lavado eficiente
    perd = subset(output_moulinette,var=="Lavado")$cat[j]
    
    # Infeccion_de_hojas_por_mojadura 1: Alta, 2: Media, 3: Baja
    inf = subset(output_moulinette,var=="Infeccion")$cat[j]
    
    # Periodo_de_latencia_por_temperatura 1: Latencia breve, 2: Latencia media, 3:Latencia larga
    lat = subset(output_moulinette,var=="Latencia")$cat[j]
    
    # Efecto del clima sobre la aparicion de la hojas 1: Favorable a el crecimiento, 2: Moderadamente favorable a el crecimiento 3: Desfavorable a el crecimiento
    ap_hojas_clim = subset(output_moulinette,var=="Aparicion_hojas")$cat[j]
    
    
    
    # Tables d'aggregation - Decision rules ------------
    
    
    # 19-effecto_fruto_sobre_crecimiento_vegetativo --------------------
    
    nom_Fenologia_del_fruto <- c("Desde la floracion hasta el inicio de la cosecha", 
                                 "Durante la cosecha",
                                 "Desde la fin de cosecha hasta la floracion")
    col_Fenologia_del_fruto <- rep("gray",3)
    
    nom_Carga_fructifera <- c("Carga fructifera alta", "Carga fructifera media","Carga fructifera baja")
    col_Carga_fructifera <- c("green","orange","red")
    
    nom_Efecto_del_fruto_sobre_el_crecimiento_vegetativo <- 
      c("Ef.fruto desfavorable",
        "Ef.fruto moderadamente favorable",
        "Ef.fruto favorable")
    col_Efecto_del_fruto_sobre_el_crecimiento_vegetativo <- c("red","orange","green")
    
    for (efah in 1:nrow(df19)){
      ef_fruto_creci[j] <- if (df19$Fenologia_del_fruto[efah]==feno_cafe[j] & 
                               df19$Carga_fructifera[efah]==carga_fruct){
        df19$Efecto_del_fruto_sobre_el_crecimiento_vegetativo[efah]

      } else {
        next
      }
    }
    
    
    t19 <- data.frame(
      Color=c(col_Fenologia_del_fruto[feno_cafe[j]],col_Carga_fructifera[carga_fruct]),
      AggregateAttributes=c(nom_Fenologia_del_fruto[feno_cafe[j]],
                            nom_Carga_fructifera[carga_fruct]),
      ResultAttribut=nom_Efecto_del_fruto_sobre_el_crecimiento_vegetativo[ef_fruto_creci[j]],
      AggregateTable="A6"
    )
    

    
    # 18-interaccion_fruto_clima_sobre_aparicion_hojas --------------------
    
    nom_ap_hojas_clim <- c("Lluvia favorable para creci. vegetativo",
                           "Lluvia moderadamente favorable para creci. vegetativo",
                           "Lluvia desfavorable para creci. vegetativo")
    col_ap_hojas_clim <- c("green","orange","red")
    
    nom_Interaccion_fruto_clima_sobre_el_crecimiento_vegetativo <- c("Ef.frutoxclima favorable",
                                                           "Ef.frutoxclima moderadamente favorable",
                                                           "Ef.frutoxclima desfavorable")
    col_Interaccion_fruto_clima_sobre_el_crecimiento_vegetativo <- c("green","orange","red")
    
    for (iefc in 1:nrow(df18)){
      int_fruto_clim[j] <- if (df18$Efecto_del_fruto_sobre_el_crecimiento_vegetativo[iefc]==ef_fruto_creci[j] &
                               df18$Lluvia[iefc]==ap_hojas_clim){
        df18$Interaccion_fruto_clima_sobre_el_crecimiento_vegetativo[iefc]
      } else {
        next
      }

    }

    
    t18 <- data.frame(
      Color=c(col_Efecto_del_fruto_sobre_el_crecimiento_vegetativo[ef_fruto_creci[j]],
              col_ap_hojas_clim[ap_hojas_clim]),
      AggregateAttributes=c(nom_Efecto_del_fruto_sobre_el_crecimiento_vegetativo[ef_fruto_creci[j]],
                            nom_ap_hojas_clim[ap_hojas_clim]),
      ResultAttribut=nom_Interaccion_fruto_clima_sobre_el_crecimiento_vegetativo[int_fruto_clim[j]],
      AggregateTable="A5"
    )
    
    
    # 17-Interaccion_fruto_clima_nutricion_sobre_el_crecimiento_vegetativo --------------------
    
    nom_Nutricion_del_cafeto <- c("Nutricion suficiente","Nutricion no suficiente")
    col_Nutricion_del_cafeto <- c("green","red")
    
    nom_Interaccion_fruto_clima_nutricion_sobre_el_crecimiento_vegetativo <- 
      c("Nutri. favorable",
        "Nutri. moderadamente favorable",
        "Nutri. desfavorable")
    col_Interaccion_fruto_clima_nutricion_sobre_el_crecimiento_vegetativo <- c("green","orange","red")
    
    
    for (ahnc in 1:nrow(df17)){
      ap_hoj_nutri_clim[j] <- if (df17$Interaccion_fruto_clima_sobre_el_crecimiento_vegetativo[ahnc]==int_fruto_clim[j] &
                                  df17$Nutricion_del_cafeto[ahnc]==nutri_adecuada){
        df17$Interaccion_fruto_clima_nutricion_sobre_el_crecimiento_vegetativo[ahnc]
      } else {
        next
      }
    }

    
    t17 <- data.frame(
      Color=c(col_Interaccion_fruto_clima_sobre_el_crecimiento_vegetativo[int_fruto_clim[j]],
              col_Nutricion_del_cafeto[nutri_adecuada]),
      AggregateAttributes=c(nom_Interaccion_fruto_clima_sobre_el_crecimiento_vegetativo[int_fruto_clim[j]],
                            nom_Nutricion_del_cafeto[nutri_adecuada]),
      ResultAttribut=nom_Interaccion_fruto_clima_nutricion_sobre_el_crecimiento_vegetativo[ap_hoj_nutri_clim[j]],
      AggregateTable="A4"
    )
    
    
    # 16-aparicion_de_hojas --------------------
    
    nom_sombra <- c("Alta sombra","Media sombra","Pleno sol")
    col_sombra <- c("green","orange","red")
    
    
    nom_Aparicion_de_las_hojas <- c("Apparicion hojas alta","Apparicion hojas media",
                                    "Apparicion hojas baja o nula")
    col_Aparicion_de_las_hojas <- c("green","orange","red")
    
    
    for (ah in 1:nrow(df16)){
      aparicion_hojas[j] <- if (df16$Interaccion_fruto_clima_nutricion_sobre_el_crecimiento_vegetativo[ah]==ap_hoj_nutri_clim[j] &
                                df16$Sombra[ah]==sombra) {
        df16$Aparicion_de_las_hojas[ah]
      } else {
        next
      }
    }
    
    t16 <- data.frame(
      Color=c(col_sombra[sombra],
              col_Interaccion_fruto_clima_nutricion_sobre_el_crecimiento_vegetativo[ap_hoj_nutri_clim[j]]),
      AggregateAttributes=c(nom_sombra[sombra],
                            nom_Interaccion_fruto_clima_nutricion_sobre_el_crecimiento_vegetativo[ap_hoj_nutri_clim[j]]),
      ResultAttribut=nom_Aparicion_de_las_hojas[aparicion_hojas[j]],
      AggregateTable="A3"
    )

    
    
    # 15-effecto_fruto_sobre_defoliacion --------------------
    
    nom_Efecto_del_fruto_sobre_la_defoliacion <- c("Ef. fruto favorable a la defol.",
                                                   "Ef. fruto moderadamente favorable a la defol.",
                                                   "Ef. fruto unfavorable a la defol.")
    col_Efecto_del_fruto_sobre_la_defoliacion <- c("red","orange","green")
    
    
    for (efd in 1:nrow(df15)){
      ef_fruto_def[j] <- if (df15$Fenologia_del_fruto[efd]==feno_cafe[j] & 
                             df15$Carga_fructifera[efd]==carga_fruct){
        df15$Efecto_del_fruto_sobre_la_defoliacion[efd]
      } else {
        next
      }
    }
    
    
    t15 <- data.frame(
      Color=c(col_Fenologia_del_fruto[feno_cafe[j]],
              col_Carga_fructifera[carga_fruct]),
      AggregateAttributes=c(nom_Fenologia_del_fruto[feno_cafe[j]],
                            nom_Carga_fructifera[carga_fruct]),
      ResultAttribut=nom_Efecto_del_fruto_sobre_la_defoliacion[ef_fruto_def[j]],
      AggregateTable="A9"
    )


    # 14-defoliacion --------------------
    
    nom_Incidencia_sobre_la_defoliacion <- c("Regular efecto de incidencia sobre defol.",
                          "Medio efecto de incidencia sobre defol.",
                          "Alto efecto de incidencia sobre defol.")
    col_Incidencia_sobre_la_defoliacion <- c("green","orange","red")
    
    nom_Defoliacion <- c("Defoliacion alta",
                   "Defoliacion media",
                   "Defoliacion baja o nula")
    col_Defoliacion <- c("red","orange","green")
    
    
    for (d in 1:nrow(df14)){
      defoliacion[j] <- if (df14$Incidencia_sobre_la_defoliacion[d]==ef_inc_defol &
                            df14$Efecto_del_fruto_sobre_la_defoliacion[d]==ef_fruto_def[j]){
        df14$Defoliacion[d]
      } else {
        next
      }
    }
    
    
    t14 <- data.frame(
      Color=c(col_Incidencia_sobre_la_defoliacion[ef_inc_defol],
              col_Efecto_del_fruto_sobre_la_defoliacion[ef_fruto_def[j]]),
      AggregateAttributes=c(nom_Incidencia_sobre_la_defoliacion[ef_inc_defol],
                            nom_Efecto_del_fruto_sobre_la_defoliacion[ef_fruto_def[j]]),
      ResultAttribut=nom_Defoliacion[defoliacion[j]],
      AggregateTable="A8"
    )
    

    # 13-efecto_del_fruto_sobre_la_susceptibilidad_de_la_hoja_a_la_roya --------------------
    
    nom_Efecto_del_fruto_sobre_la_susceptibilidad_de_la_hoja_a_la_roya <- c("Alta susceptibilidad fisiologica",
                                                                    "Media susceptibilidad fisiologica",
                                                                    "Baja susceptibilidad fisiologica")
    col_Efecto_del_fruto_sobre_la_susceptibilidad_de_la_hoja_a_la_roya <- c("red","orange","green")
    
    for (sc in 1:nrow(df13)){
      suscept_lig_carga[j] <-  if (df13$Fenologia_del_fruto[sc]==feno_cafe[j] & 
                                   df13$Carga_fructifera[sc]==carga_fruct) {
        df13$Efecto_del_fruto_sobre_la_susceptibilidad_de_la_hoja_a_la_roya[sc]
      } else {
        next
      }
    }
    
    t13 <- data.frame(
      Color=c(col_Fenologia_del_fruto[feno_cafe[j]],
              col_Carga_fructifera[carga_fruct]),
      AggregateAttributes=c(nom_Fenologia_del_fruto[feno_cafe[j]],
                            nom_Carga_fructifera[carga_fruct]),
      ResultAttribut=nom_Efecto_del_fruto_sobre_la_susceptibilidad_de_la_hoja_a_la_roya[suscept_lig_carga[j]],
      AggregateTable="A15"
    )
    

    
    # 12-susceptibilidad_del_hospedero_sombra  --------------------
    
    nom_Susceptibilidad_fisiologica_del_hospedero <- c("Alta susceptibilidad",
                                      "Media susceptibilidad",
                                      "Baja susceptibilidad")
    col_Susceptibilidad_fisiologica_del_hospedero <- c("red","orange","green")
    
    
    for (shs in 1:nrow(df12)){
      suscept_hosp_sombr[j] <-  if (df12$Efecto_del_fruto_sobre_la_susceptibilidad_de_la_hoja_a_la_roya[shs]==suscept_lig_carga[j] & 
                                    df12$Sombra[shs]==sombra) {
        df12$Susceptibilidad_fisiologica_del_hospedero[shs]
      } else {
        next
      }
    }
    
    
    t12 <- data.frame(
      Color=c(col_Efecto_del_fruto_sobre_la_susceptibilidad_de_la_hoja_a_la_roya[suscept_lig_carga[j]],
              col_sombra[sombra]),
      AggregateAttributes=c(nom_Efecto_del_fruto_sobre_la_susceptibilidad_de_la_hoja_a_la_roya[suscept_lig_carga[j]],
                            nom_sombra[sombra]),
      ResultAttribut=nom_Susceptibilidad_fisiologica_del_hospedero[suscept_hosp_sombr[j]],
      AggregateTable="A14"
    )
    

    
    # 11-susceptibilidad_del_hospedero  --------------------
    
    nom_Nivel_de_resistencia_genetica <- c("Variedad susceptible","Variedad medianamente susceptible","Variedad resistente")
    col_Nivel_de_resistencia_genetica <-  c("red","orange","green")
    
    nom_Susceptibilidad_del_hospedero <- c("Alta susceptibilidad del hospedero ","Media susceptibilidad del hospedero","Baja susceptibilidad del hospedero")
    col_Susceptibilidad_del_hospedero <- c("red","orange","green")
    
    
    for (sh in 1:nrow(df11)){
      suscept_hosp[j] <-  if (df11$Susceptibilidad_fisiologica_del_hospedero[sh]==suscept_hosp_sombr[j] & 
                              df11$Nivel_de_resistencia_genetica[sh]==variedad) {
        df11$Susceptibilidad_del_hospedero[sh]
      } else {
        next
      }
    }
    
    t11 <- data.frame(
      Color=c(col_Susceptibilidad_fisiologica_del_hospedero[suscept_hosp_sombr[j]],
              col_Nivel_de_resistencia_genetica[variedad]),
      AggregateAttributes=c(nom_Susceptibilidad_fisiologica_del_hospedero[suscept_hosp_sombr[j]],
                            nom_Nivel_de_resistencia_genetica[variedad]),
      ResultAttribut=nom_Susceptibilidad_del_hospedero[suscept_hosp[j]],
      AggregateTable="A13"
    )
    

    
    # 10-Latencia ------------------
    
    nom_Latencia_por_temperatura <- c("Corto periodo de latencia por temperatura",
                                     "Regular periodo de latencia por temperatura",
                                     "Largo periodo de latencia  por temperatura")
    col_Latencia_por_temperatura <- c("red","orange","green")
    
    nom_Latencia <- c("Latencia corta",
                      "Latencia regular",
                      "Latencia larga")
    
    col_Latencia <- c("red","orange","green")
      
    
    for (late in 1:nrow(df10)){
      latenc[j] <- if(df10$Latencia_por_temperatura[late]==lat &
                      df10$Sombra[late]==sombra) {
        df10$Latencia[late]
      }else {
        next
      }
    }
    
    
    t10 <- data.frame(
      Color=c(col_Latencia_por_temperatura[lat],
              col_sombra[sombra]),
      AggregateAttributes=c(nom_Latencia_por_temperatura[lat],
                            nom_sombra[sombra]),
      ResultAttribut=nom_Latencia[latenc[j]],
      AggregateTable="A17"
    )

    
    
    # 9-infeccion ------------------
    
    nom_Infeccion_de_las_hojas_por_mojadura <- c("Alta infeccion por mojadura", 
                                                 "Regular Infeccion por mojadura",
                                                 "Baja infeccion por mojadura")
    col_Infeccion_de_las_hojas_por_mojadura <- c("red","orange","green")
    
    nom_Infeccion <- c("Alta infeccion",
                       "Regular infeccion",
                       "Baja infeccion")
    col_Infeccion <- c("red","orange","green")
    
    
    for (ifcc in 1:nrow(df9)){
      infecc[j] <- if(df9$Infeccion_de_las_hojas_por_mojadura[ifcc]==inf &
                      df9$Sombra[ifcc]==sombra) {
        df9$Infeccion[ifcc]
      }else {
        next
      }
    }
    
    t9 <- data.frame(
      Color=c(col_Infeccion_de_las_hojas_por_mojadura[inf],
              col_sombra[sombra]),
      AggregateAttributes=c(nom_Infeccion_de_las_hojas_por_mojadura[inf],
                            nom_sombra[sombra]),
      ResultAttribut=nom_Infeccion[infecc[j]],
      AggregateTable="A18"
    )
    
    
    # 8.1-Inoculo_disponible_despues_del_parasitismo ------------------
    
    nom_Cantidad_de_inoculo <- c("Baja cantidad de inoculo",
                                 "Media cantidad de inoculo",
                                 "Alta cantidad de inoculo")
    col_Cantidad_de_inoculo <- c("green","orange","red")
    
    nom_Fungicidas <- c("Aplicacion fungicidas","No aplicacion fungicidas")
    col_Fungicidas <- c("red","green")
    
    nom_Inoculo_disponible_despues_del_parasitismo <- c("Bajo inoculo disp. despues parasitismo",
                                                        "Medio inoculo disp. despues parasitismo",
                                                        "Alto inoculo disp. despues parasitismo")
    col_Inoculo_disponible_despues_del_parasitismo <- c("green","orange","red")
    
    for (iddp in 1:nrow(df8.1)){
      inoc_disp_desp_parasit[j] <- if(df8.1$Sombra[iddp]==sombra &
                                 df8.1$Cantidad_de_inoculo[iddp]==cant_inoc &
                                 df8.1$Fungicidas[iddp]==tratamiento[j]) {
        df8.1$Inoculo_disponible_despues_del_parasitismo[iddp]
      }else {
        next
      }
    }
    
    
    t8.1 <- data.frame(
      Color=c(col_sombra[sombra],
              col_Cantidad_de_inoculo[cant_inoc],
              col_Fungicidas[tratamiento[j]]),
      AggregateAttributes=c(nom_sombra[sombra],
                            nom_Cantidad_de_inoculo[cant_inoc],
                            nom_Fungicidas[tratamiento[j]]),
      ResultAttribut=nom_Inoculo_disponible_despues_del_parasitismo[inoc_disp_desp_parasit[j]],
      AggregateTable="A20"
    )
    
    
    
    # 8.2-perdidas_de_esporas ------------------
    
    nom_Perdidas_de_esporas_por_lavado <- c("Insuficiente lavado de esporas por lluvia",
                                   "Regular lavado de esporas por lluvia",
                                   "Eficiente lavado de esporas por lluvia")
    col_Perdidas_de_esporas_por_lavado <- c("red","orange","green")
    
    nom_Perdidas_de_esporas <- c("Baja perdida de esporas",
                                 "Regular perdida de esporas",
                                 "Alta perdida de esporas")
    col_Perdidas_de_esporas <- c("red","orange","green")
    
    for (pe in 1:nrow(df8.2)){
      perd_esp[j] <- if(df8.2$Perdidas_de_esporas_por_lavado[pe]==perd &
                        df8.2$Sombra[pe]==sombra) {
        df8.2$Perdidas_de_esporas[pe]
      }else {
        next
      }
    }
    
    t8.2 <- data.frame(
      Color=c(col_Perdidas_de_esporas_por_lavado[perd],
              col_sombra[sombra]),
      AggregateAttributes=c(nom_Perdidas_de_esporas_por_lavado[perd],
                            nom_sombra[sombra]),
      ResultAttribut=nom_Perdidas_de_esporas[perd_esp[j]],
      AggregateTable="A21"
    )


    # 7-Cantidad_de_esporas_disponible_para_la_infeccion --------------
    
    nom_Cantidad_de_esporas_disponible_para_la_infeccion <- c("Baja cantidad de esporas disponible para la infeccion",
                                             "Media cantidad de esporas disponible para la infeccion",
                                             "Alta cantidad de esporas disponible para la infeccion")
    col_Cantidad_de_esporas_disponible_para_la_infeccion <- c("green","orange","red")
    
    
    for (cspor in 1:nrow(df7)){
      cant_esp_disp[j] <- if(df7$Inoculo_disponible_despues_del_parasitismo[cspor]==inoc_disp_desp_parasit[j] & 
                             df7$Perdidas_de_esporas[cspor]==perd_esp[j]) {
        df7$Cantidad_de_esporas_disponible_para_la_infeccion[cspor]
      }else {
        next
      }
    }
    
    t7 <- data.frame(
      Color=c(col_Inoculo_disponible_despues_del_parasitismo[inoc_disp_desp_parasit[j]],
              col_Perdidas_de_esporas[perd_esp[j]]),
      AggregateAttributes=c(nom_Inoculo_disponible_despues_del_parasitismo[inoc_disp_desp_parasit[j]],
                            nom_Perdidas_de_esporas[perd_esp[j]]),
      ResultAttribut=nom_Cantidad_de_esporas_disponible_para_la_infeccion[cant_esp_disp[j]],
      AggregateTable="A22"
    )
    
    
    # 6-Crecimiento_potencial_de_la_poblacion_patogenica --------------------
    
    nom_Crecimiento_potencial_de_la_poblacion_patogenica <- c("Crecimiento potencial de la poblacion patogenica",
                                                             "Stabilidad potencial de la poblacion patogenica",
                                                             "Decrecimiento potencial de la poblacion patogenica")
    col_Crecimiento_potencial_de_la_poblacion_patogenica <- c("red","orange","green")
    
    for (cr in 1:nrow(df6)){
      creci[j] <-  if (df6$Cantidad_de_esporas_disponible_para_la_infeccion[cr]==cant_esp_disp[j] &
                       df6$Infeccion[cr]==infecc[j] &
                       df6$Latencia[cr]==latenc[j]) {
        df6$Crecimiento_potencial_de_la_poblacion_patogenica[cr]
      } else {
        next
      }
    }
    
    
    t6 <- data.frame(
      Color=c(col_Cantidad_de_esporas_disponible_para_la_infeccion[cant_esp_disp[j]],
              col_Infeccion[infecc[j]],
              col_Latencia[latenc[j]]),
      AggregateAttributes=c(nom_Cantidad_de_esporas_disponible_para_la_infeccion[cant_esp_disp[j]],
                            nom_Infeccion[infecc[j]],
                            nom_Latencia[latenc[j]]),
      ResultAttribut=nom_Crecimiento_potencial_de_la_poblacion_patogenica[creci[j]],
      AggregateTable="A16"
    )
    

    
    # 5-eficacia_de_la_aplicacion_de_fungicidas ------------------
    nom_Inoculo_fung <- c("Baja cantidad de inoculo",
                          "Media cantidad de inoculo",
                          "Alta cantidad de inoculo")
    col_Inoculo_fung <- c("green","orange","red")
    
    nom_Efficacia_de_la_aplicacion_de_las_fungicidas <- c("Alta eficacia de las fungicidas",
                                       "Media eficacia de las fungicidas",
                                       "Baja eficacia de las fungicidas")
    col_Efficacia_de_la_aplicacion_de_las_fungicidas <- c("green","orange","red")
    
    for (eaf in 1:nrow(df5)){
      ef_ap_fungicidas[j] <-  if (df5$Cantidad_de_inoculo[eaf]==cant_inoc &
                                  df5$Fungicidas[eaf]==tratamiento[j]
      ) {
        df5$Efficacia_de_la_aplicacion_de_las_fungicidas[eaf]
      } else {
        next
      }
    }
    
    t5 <- data.frame(
      Color=c(col_Inoculo_fung[cant_inoc],
              col_Fungicidas[tratamiento[j]]),
      AggregateAttributes=c(nom_Inoculo_fung[cant_inoc],
                            nom_Fungicidas[tratamiento[j]]),
      ResultAttribut=nom_Efficacia_de_la_aplicacion_de_las_fungicidas[ef_ap_fungicidas[j]],
      AggregateTable="A11"
    )

    
    
    # 4-interaccion_clima_hospedero_patogeno --------------------
    
    nom_Interaccion_clima_hospedero_patogeno <- c("Favorable al crecimiento de la poblacion patogenica",
                                                  "Moderadamente favorable al crecimiento de la poblacion patogenica",
                                                  "Desfavorable al crecimiento de la poblacion patogenica")
    
    col_Interaccion_clima_hospedero_patogeno <- c("red","orange","green")
    
    for (ichp in 1:nrow(df4)){
      int_clim_hosp_patog[j] <-  if (df4$Crecimiento_potencial_de_la_poblacion_patogenica[ichp]==creci[j] &
                                     df4$Susceptibilidad_del_hospedero[ichp]==suscept_hosp[j]
      ) {
        df4$Interaccion_clima_hospedero_patogeno[ichp]
      } else {
        next
      }
    }
    
    
    t4 <- data.frame(
      Color=c(col_Crecimiento_potencial_de_la_poblacion_patogenica[creci[j]],
              col_Susceptibilidad_del_hospedero[suscept_hosp[j]]),
      AggregateAttributes=c(nom_Crecimiento_potencial_de_la_poblacion_patogenica[creci[j]],
                            nom_Susceptibilidad_del_hospedero[suscept_hosp[j]]),
      ResultAttribut=nom_Interaccion_clima_hospedero_patogeno[int_clim_hosp_patog[j]],
      AggregateTable="A12"
    )

    
    # 3-evolucion_de_la_poblacion_patogenica --------------------
    
    nom_Evolucion_de_la_poblacion_patogenica <- c("Crecimiento de la poblacion patogenica",
                                                  "Stabilidad de la poblacion patogenica",
                                                  "Decrecimiento de la poblacion patogenica")
    col_Evolucion_de_la_poblacion_patogenica <- c("red","orange","green")
    
    for(epp in 1:nrow(df3)){
      evo_pobla_patogenica[j] <- if (df3$Interaccion_clima_hospedero_patogeno[epp]==int_clim_hosp_patog[j] & 
                                     df3$Efficacia_de_la_aplicacion_de_las_fungicidas[epp]==ef_ap_fungicidas[j]){
        df3$Evolucion_de_la_poblacion_patogenica[epp]
      } else{
        next
      }
    }
    
    
    t3 <- data.frame(
      Color=c(col_Interaccion_clima_hospedero_patogeno[int_clim_hosp_patog[j]],
              col_Efficacia_de_la_aplicacion_de_las_fungicidas[ef_ap_fungicidas[j]]),
      AggregateAttributes=c(nom_Interaccion_clima_hospedero_patogeno[int_clim_hosp_patog[j]],
                            nom_Efficacia_de_la_aplicacion_de_las_fungicidas[ef_ap_fungicidas[j]]),
      ResultAttribut=nom_Evolucion_de_la_poblacion_patogenica[evo_pobla_patogenica[j]],
      AggregateTable="A10"
    )

    
    # 2-riesgo_de_crecimiento_de_la_incidencia_antes_de_la_poda --------------------
    
    nom_Riesgo_de_crecimiento_de_la_incidencia_antes_de_la_poda <- c("Antes poda : inc. va aumentar fuertemente",
                                                                     "Antes poda : inc. va aumentar",
                                                                     "Antes poda : inc. estable o va aumentar levemente",
                                                                     "Antes poda : inc. va bajar")
    col_Riesgo_de_crecimiento_de_la_incidencia_antes_de_la_poda <- c("#8b0000","red","orange","green")
    
    for (rsgap in 1:nrow(df2)){
      riesgo_antes_poda[j] <-  if (df2$Evolucion_de_la_poblacion_patogenica[rsgap]==evo_pobla_patogenica[j] &
                                   df2$Aparicion_de_las_hojas[rsgap]==aparicion_hojas[j] & 
                                   df2$Defoliacion[rsgap]==defoliacion[j]) {
        df2$Riesgo_de_crecimiento_de_la_incidencia_antes_de_la_poda[rsgap]
      } else {
        next
      }
    }

    t2 <- data.frame(
      Color=c(col_Evolucion_de_la_poblacion_patogenica[evo_pobla_patogenica[j]],
              col_Aparicion_de_las_hojas[aparicion_hojas[j]],
              col_Defoliacion[defoliacion[j]]),
      AggregateAttributes=c(nom_Evolucion_de_la_poblacion_patogenica[evo_pobla_patogenica[j]],
                            nom_Aparicion_de_las_hojas[aparicion_hojas[j]],
                            nom_Defoliacion[defoliacion[j]]),
      ResultAttribut=nom_Riesgo_de_crecimiento_de_la_incidencia_antes_de_la_poda[riesgo_antes_poda[j]],
      AggregateTable="A2"
      )

    
    
    # 1-Riesgo_de_crecimiento_de_la_roya --------------------
    
    nom_Poda <- c("Poda total", "Poda 50%", "Poda 25%", "No poda")
    col_Poda <- c("#8b0000","red","orange","green")
    
    nom_Riesgo_de_crecimiento_de_la_roya <- c("La incidencia va aumentar fuertemente",
                                              "La incidencia va aumentar",
                                              "La incidencia es estable o va aumentar levemente",
                                              "La incidencia va bajar")
    col_Riesgo_de_crecimiento_de_la_roya <- c("#8b0000","red","orange","green")
    
    
    for (rsg in 1:nrow(df1)){
      riesgo[j] <-  if (df1$Poda[rsg]==poda_del_mes &
                        df1$Riesgo_de_crecimiento_de_la_incidencia_antes_de_la_poda[rsg]==riesgo_antes_poda[j]) {
        df1$Riesgo_de_crecimiento_de_la_roya[rsg]
      } else {
        next
      }
    }
    
    t1 <- data.frame(
      Color=c(col_Poda[poda_del_mes],
              col_Riesgo_de_crecimiento_de_la_incidencia_antes_de_la_poda[riesgo_antes_poda[j]]),
      AggregateAttributes=c(nom_Poda[poda_del_mes],
                            nom_Riesgo_de_crecimiento_de_la_incidencia_antes_de_la_poda[riesgo_antes_poda[j]]),
      ResultAttribut=nom_Riesgo_de_crecimiento_de_la_roya[riesgo[j]],
      AggregateTable="A1"
      )
    

    
    sortie_ipsim_t <- data.frame(
      Fecha_median=sub_df$fecha_med_monitoreo[j],
      riesgo=riesgo[j],
      categoria=categorie[riesgo[j]],
      inicial_categoria = initiale_categorie[riesgo[j]],
      Perdidas_de_esporas=perd_esp[j],
      Infeccion = infecc[j],
      Latencia = latenc[j],
      Aparicion_hojas = aparicion_hojas[j],
      Defoliacion=defoliacion[j],
      Cantidad_esporas=cant_esp_disp[j],
      Suscept_hospedero=suscept_hosp[j],
      Sombra=sombra
      )
    
    sortie_ipsimt2 <- rbind(sortie_ipsimt2,sortie_ipsim_t)
 

    t1.0 <- t1[1,]
    t1.0$Color <- col_Riesgo_de_crecimiento_de_la_roya[riesgo[j]]
    t1.0$AggregateAttributes <- NA
    t1.0$AggregateTable <- "A0"
    
   tabla_arbol <- rbind(t1.0,t1,t2,t10,t11,t12,t13,t14,
                        t15,t16,t17,t18,t19,t3,t4,t5,t6,t7,t8.1,t8.2,t9)
   tabla_arbol <- subset(tabla_arbol,select = c(AggregateAttributes,ResultAttribut,AggregateTable,Color))
   
   
   sortie_ipsim_ori <- list(sortie_ipsimt2,tabla_arbol)
    
  }
  
  return(sortie_ipsim_ori)
}
