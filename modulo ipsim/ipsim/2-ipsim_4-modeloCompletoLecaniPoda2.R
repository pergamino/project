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
  
  df1.1 <- read.table("data_internes/tables_dexi_4-modeloCompletoLecaniPoda2/1.1-riesgo_de_crecimiento_de_la_incidencia.dat",h=T)
  df1.2 <- read.table("data_internes/tables_dexi_4-modeloCompletoLecaniPoda2/1.2-riesgo_de_crecimiento_de_la_incidencia_antes_poda.dat",h=T)
  df2 <- read.table("data_internes/tables_dexi_4-modeloCompletoLecaniPoda2/2-interaccion_patogen_defoliacion.dat",h=T)
  df3 <- read.table("data_internes/tables_dexi_4-modeloCompletoLecaniPoda2/3-evolucion_de_la_poblacion_patogenica.dat",h=T)
  df4 <- read.table("data_internes/tables_dexi_4-modeloCompletoLecaniPoda2/4-interaccion_clima_hospedero_patogeno.dat",h=T)
  df5 <- read.table("data_internes/tables_dexi_4-modeloCompletoLecaniPoda2/5-eficacia_de_la_aplicacion_de_fungicidas.dat",h=T)
  df6 <- read.table("data_internes/tables_dexi_4-modeloCompletoLecaniPoda2/6-crecimiento_de_la_roya_ligado_al_clima_sombra.dat",h=T)
  df7 <- read.table("data_internes/tables_dexi_4-modeloCompletoLecaniPoda2/7-cantidad_esporas_disponibles.dat",h=T)
  df8.1 <- read.table("data_internes/tables_dexi_4-modeloCompletoLecaniPoda2/8.1-perdidas_esporas.dat",h=T)
  df8.2 <- read.table("data_internes/tables_dexi_4-modeloCompletoLecaniPoda2/8.2-inoculum_disponible_antes_de_lavado.dat",h=T)
  df9 <- read.table("data_internes/tables_dexi_4-modeloCompletoLecaniPoda2/9-infeccion.dat",h=T)
  df10 <- read.table("data_internes/tables_dexi_4-modeloCompletoLecaniPoda2/10-latencia.dat",h=T)
  df11 <- read.table("data_internes/tables_dexi_4-modeloCompletoLecaniPoda2/11-susceptibilidad_del_hospedero.dat",h=T)
  df12 <- read.table("data_internes/tables_dexi_4-modeloCompletoLecaniPoda2/12-susceptibilidad_del_hospedero_ligada_sombra.dat",h=T)
  df13 <- read.table("data_internes/tables_dexi_4-modeloCompletoLecaniPoda2/13-susceptibilidad_de_la_hoja_ligada_a_la_carga_fructifera.dat",h=T)
  df14 <- read.table("data_internes/tables_dexi_4-modeloCompletoLecaniPoda2/14-defoliacion.dat",h=T)
  df15 <- read.table("data_internes/tables_dexi_4-modeloCompletoLecaniPoda2/15-effecto_fruto_sobre_defoliacion.dat",h=T)
  df16 <- read.table("data_internes/tables_dexi_4-modeloCompletoLecaniPoda2/16-aparicion_de_hojas.dat",h=T)
  df17 <- read.table("data_internes/tables_dexi_4-modeloCompletoLecaniPoda2/17-interaccion_fruto_clima_nutricion_sobre_aparicion_hojas.dat",h=T)
  df18 <- read.table("data_internes/tables_dexi_4-modeloCompletoLecaniPoda2/18-interaccion_fruto_clima_sobre_aparicion_hojas.dat",h=T)
  df19 <- read.table("data_internes/tables_dexi_4-modeloCompletoLecaniPoda2/19-effecto_fruto_sobre_crecimiento_vegetativo.dat",h=T)
  
  
  # Les var qui varient avec le temps ----------------------
  
  
  # Fenologia del cafeto :
  # 1: desde la floracion hasta el inicio de la cosecha, 
  # 2: durante la cosecha, 
  # 3: fin de la cosecha hasta la floracion
  # floracion : Mars, avril
  # ini cosecha : octobre 
  # fin cosecha : janvier
  
  sub_df <- subset(output_moulinette,var=="Lavado")
  
  feno_cafe <- NULL
  for(f in 1:nrow(sub_df)){
    feno_cafe[f] = ifelse(sub_df$fecha_med_monitoreo[f]>=date_ini_cosecha & sub_df$fecha_med_monitoreo[f]<=date_fin_cosecha,2,
                          ifelse(sub_df$fecha_med_monitoreo[f]>date_floracion & sub_df$fecha_med_monitoreo[f]<=date_ini_cosecha,1,3))
  }
  
  int_pato_defo         <- NULL
  ef_fruto_creci        <- NULL
  int_ef_fruto_clim     <- NULL
  aparicion_hojas       <- NULL
  ef_fruto_def          <- NULL
  defoliacion           <- NULL
  evo_pobla_foliar      <- NULL
  suscept_lig_carga     <- NULL
  suscept_hosp_sombr    <- NULL
  suscept_hosp          <- NULL
  creci                 <- NULL
  int_clim_hosp_patog   <- NULL
  evo_pobla_patogenica  <- NULL
  riesgo                <- NULL
  sortie_ipsim          <- NULL
  int_fruto_clim        <- NULL
  ap_hoj_nutri_clim     <- NULL
  ef_fru_nutri_somb_def <- NULL
  infecc                <- NULL
  perd_esp              <- NULL
  inoc_antes_lavado     <- NULL
  latenc                <- NULL
  cant_esp              <- NULL
  ef_ap_fungicidas      <- NULL
  riesgo_antes_poda     <- NULL
  
  
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
    
    # Inoculum : 1: bajo (inc<5%), 2: medio (inc [5-10%]), 3 : alto (inc>10%) 
    inoc = subset(output_incidencia,var=="Inoculum")$cat[j]
    
    # Inoculum antes parasitismo : 1: bajo (inc<10%), 2: medio (inc [10-30%]), 3 : alto (inc>30%) 
    inoc_antes_parasitismo = subset(output_incidencia,var=="Inoculo disponible antes del parasitismo")$cat[j]
    
    # Efecto de la incidencia sobre la eficacia de las fungicidas 
    # 1: Incidencia baja, 2: Incidencia media, 3: Incidencia alta
    inc_ef_fung = subset(output_incidencia,var=="Efecto de la incidencia sobre la eficacia de las fungicidas")$cat[j]
    
    
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
    
    for (efah in 1:nrow(df19)){
      ef_fruto_creci[j] <- if (df19$Fenologia_del_fruto[efah]==feno_cafe[j] & 
                               df19$Carga_fructifera[efah]==carga_fruct){
        df19$Efecto_del_fruto_clima_sobre_el_crecimiento_vegetativo[efah]
      } else {
        next
      }
    }
    
    # 18-interaccion_fruto_clima_sobre_aparicion_hojas --------------------
    for (iefc in 1:nrow(df18)){
      int_fruto_clim[j] <- if (df18$Efecto_del_fruto_sobre_el_crecimiento_vegetativo[iefc]==ef_fruto_creci[j] &
                               df18$Clima[iefc]==ap_hojas_clim){
        df18$Interaccion_fruto_clima_sobre_aparicion_hojas[iefc]
      } else {
        next
      }
    }
    
    
    # 17-interaccion_fruto_clima_nutricion_sobre_aparicion_hojas --------------------
    for (ahnc in 1:nrow(df17)){
      ap_hoj_nutri_clim[j] <- if (df17$Interaccion_fruto_clima_sobre_aparicion_hojas[ahnc]==int_fruto_clim[j] &
                                  df17$Nutricion_adecuada[ahnc]==nutri_adecuada){
        df17$Interaccion_fruto_clima_nutricion_sobre_aparicion_hojas[ahnc]
      } else {
        next
      }
    }

    
    # 16-aparicion_de_hojas --------------------
    for (ah in 1:nrow(df16)){
      aparicion_hojas[j] <- if (df16$Interaccion_fruto_clima_nutricion_sobre_aparicion_hojas[ah]==ap_hoj_nutri_clim[j] &
                                df16$Sombra[ah]==sombra) {
        df16$Aparicion_de_hojas[ah]
      } else {
        next
      }
    }
    
    
    # 15-effecto_fruto_sobre_defoliacion --------------------
    
    for (efd in 1:nrow(df15)){
      ef_fruto_def[j] <- if (df15$Fenologia_del_fruto[efd]==feno_cafe[j] & 
                             df15$Carga_fructifera[efd]==carga_fruct){
        df15$Efecto_del_fruto_sobre_la_defoliacion[efd]
      } else {
        next
      }
    }
    

    # 14-defoliacion --------------------
    
    for (d in 1:nrow(df14)){
      defoliacion[j] <- if (df14$Incidencia[d]==ef_inc_defol &
                            df14$Efecto_del_fruto_sobre_la_defoliacion[d]==ef_fruto_def[j]){
        df14$Defoliacion[d]
      } else {
        next
      }
    }
    
    
    
    # 13-susceptibilidad_de_la_hoja_ligada_a_la_carga_fructifera --------------------
    
    for (sc in 1:nrow(df13)){
      suscept_lig_carga[j] <-  if (df13$Fenologia_del_fruto[sc]==feno_cafe[j] & 
                                   df13$Carga_fructifera[sc]==carga_fruct) {
        df13$Susceptiblidad_de_la_hoja_ligada_a_la_carga_fructifera[sc]
      } else {
        next
      }
    }
    
    # 12-susceptibilidad_del_hospedero_sombra  --------------------
    
    for (shs in 1:nrow(df12)){
      suscept_hosp_sombr[j] <-  if (df12$Susceptiblidad_de_la_hoja_ligada_a_la_carga_fructifera[shs]==suscept_lig_carga[j] & 
                                    df12$Sombra[shs]==sombra) {
        df12$Susceptibilidad_del_hospedero_ligada_sombra[shs]
      } else {
        next
      }
    }
    
    # 11-susceptibilidad_del_hospedero  --------------------
    
    for (sh in 1:nrow(df11)){
      suscept_hosp[j] <-  if (df11$Susceptibilidad_del_hospedero_ligada_sombra[sh]==suscept_hosp_sombr[j] & 
                              df11$Variedad[sh]==variedad) {
        df11$Susceptibilidad_del_hospedero[sh]
      } else {
        next
      }
    }
    
    
    # 10-latencia ------------------
    for (late in 1:nrow(df10)){
      latenc[j] <- if(df10$Periodo_de_latencia_por_temperatura[late]==lat &
                      df10$Sombra[late]==sombra) {
        df10$Latencia[late]
      }else {
        next
      }
    }
    
    
    # 9-infeccion ------------------
    for (ifcc in 1:nrow(df9)){
      infecc[j] <- if(df9$Infeccion_de_hojas_por_mojadura[ifcc]==inf &
                      df9$Sombra[ifcc]==sombra) {
        df9$Infeccion[ifcc]
      }else {
        next
      }
    }
    
    # 8.1-perdidas_esporas ------------------
    for (pe in 1:nrow(df8.1)){
      perd_esp[j] <- if(df8.1$Perdidas_de_esporas_por_lluvia[pe]==perd &
                        df8.1$Sombra[pe]==sombra) {
        df8.1$Perdidas_esporas[pe]
      }else {
        next
      }
    }
    
    # 8.2-Inoculo_disponible_antes_de_lavado ------------------
    for (idl in 1:nrow(df8.2)){
      inoc_antes_lavado[j] <- if(df8.2$Sombra[idl]==sombra &
                                 df8.2$Inoculo_antes_del_parasitismo[idl]==inoc_antes_parasitismo &
                                 df8.2$Aplicacion_fungicidas[idl]==tratamiento[j]) {
        df8.2$Inoculo_disponible_antes_de_lavado[idl]
      }else {
        next
      }
    }
    
    # 7-cantidad_esporas ------------------
    for (ced in 1:nrow(df7)){
      cant_esp[j] <- if(df7$Perdidas_esporas[ced]==perd_esp[j] & 
                        df7$Inoculo_disponible_antes_de_lavado[ced]==inoc_antes_lavado[j]) {
        df7$Cantidad_de_esporas_disponibles[ced]
      }else {
        next
      }
      }
    
    
    # 6-crecimiento_de_la_roya_ligado_al_clima_sombra --------------------
    
    for (cr in 1:nrow(df6)){
      creci[j] <-  if (df6$Cantidad_de_esporas_disponibles[cr]==cant_esp[j] &
                       df6$Infeccion[cr]==infecc[j] &
                       df6$Latencia[cr]==latenc[j]) {
        df6$Crecimiento_de_la_roya_ligado_al_clima_y_sombra[cr]
      } else {
        next
      }
    }
    
    
    # 5-eficacia_de_la_aplicacion_de_fungicidas ------------------
    
    for (eaf in 1:nrow(df5)){
      ef_ap_fungicidas[j] <-  if (df5$Incidencia[eaf]==inc_ef_fung &
                                  df5$Aplicacion_fungicidas[eaf]==tratamiento[j]
      ) {
        df5$Eficacia_de_la_aplicacion[eaf]
      } else {
        next
      }
    }
    
    
    
    # 4-interaccion_clima_hospedero_patogeno --------------------
    
    for (ichp in 1:nrow(df4)){
      int_clim_hosp_patog[j] <-  if (df4$Crecimiento_de_la_roya_ligado_al_clima_y_sombra[ichp]==creci[j] &
                                     df4$Susceptibilidad_del_hospedero[ichp]==suscept_hosp[j]
      ) {
        df4$Interaccion_clima_hospedero_patogeno[ichp]
      } else {
        next
      }
    }
    
    
    # 3-evolucion_de_la_poblacion_patogenica --------------------
    
    for(epp in 1:nrow(df3)){
      evo_pobla_patogenica[j] <- if (df3$Interaccion_clima_hospedero_patogeno[epp]==int_clim_hosp_patog[j] & 
                                     df3$Eficacia_de_la_aplicacion[epp]==ef_ap_fungicidas[j]){
        df3$Evolucion_de_la_poblacion_patogenica[epp]
      } else{
        next
      }
    }
    
    # 2-interaccion_patogen_defoliacion --------------------
    
    for (ipd in 1:nrow(df2)){
      int_pato_defo[j] <- if(df2$Evolucion_de_la_poblacion_patogenica[ipd]==evo_pobla_patogenica[j] & 
                             df2$Defoliacion[ipd]==defoliacion[j]){
        df2$Interaccion_patogen_defoliacion[ipd]
      }else{
        next
      }
    }
    
    
    # 1.2-Riesgo_de_crecimiento_de_la_incidencia --------------------
    
    for (rsgap in 1:nrow(df1.2)){
      riesgo_antes_poda[j] <-  if (df1.2$Interaccion_patogen_defoliacion[rsgap]==int_pato_defo[j] &
                                   df1.2$Aparicion_de_hojas[rsgap]==aparicion_hojas[j]) {
        df1.2$Riesgo_de_crecimiento_de_la_incidencia_antes_poda[rsgap]
      } else {
        next
      }
    }
    
    # 1.1-Riesgo_de_crecimiento_de_la_incidencia --------------------
    
    for (rsg in 1:nrow(df1.1)){
      riesgo[j] <-  if (df1.1$Poda[rsg]==poda_del_mes &
                        df1.1$Riesgo_de_crecimiento_antes_poda[rsg]==riesgo_antes_poda[j]) {
        df1.1$Riesgo_de_crecimiento_de_la_incidencia_de_la_roya[rsg]
      } else {
        next
      }
    }
    
    sortie_ipsim_t <- data.frame(
      Fecha_median=sub_df$fecha_med_monitoreo[j],
      riesgo=riesgo[j],
      categoria=categorie[riesgo[j]],
      inicial_categoria = initiale_categorie[riesgo[j]],
      Perdidas_esporas=perd_esp[j],
      Inoc_antes_lavado=inoc_antes_lavado[j],
      Infeccion = infecc[j],
      Latencia = latenc[j],
      Aparicion_hojas = aparicion_hojas[j],
      Defoliacion=defoliacion[j],
      Cantidad_esporas=cant_esp[j],
      Suscept_hospedero=suscept_hosp[j],
      Sombra=sombra
      )
    
    sortie_ipsim <- rbind(sortie_ipsim,sortie_ipsim_t)
    
  }
  
  return(sortie_ipsim)
}