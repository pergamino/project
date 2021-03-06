args = commandArgs(trailingOnly=TRUE)

#library(bsplus)
#library(leaflet)
library(RPostgreSQL)
library(writexl)

setwd("/srv/project/modulo_estadistico")
#setwd("C:\\Users\\Jaime\\Documents\\Consultorias\\Pergamino\\ComponentesSW\\ipsim_new\\project\\modulo_estadistico")

source("01_procesador_de_variables.R")
source("02_generador_de_pronosticos.R")
lat <<- -87.565
lng <<- 14.1378

func_stadaman_app <- function() {
  
    #create connection object
    con <- dbConnect(drv =PostgreSQL(), 
                     user="admin", 
                     password="%Rsecret#",
                     host="localhost", 
                     port=5432, 
                     dbname="pergamino")
    
    #cadena para hacer la consulta del clima segun la coordenada proporcinada
    consulta <- paste("select fecha, precipitacion, tempmin, tempmax from datosmodeloclima where gid in (select gid from climasamplingpoints order by st_distance(st_geogfromtext('POINT(",args[2]," ",args[1],")'),geom) limit 1)",sep="")
    
    #consulta <- paste("select fecha, precipitacion, tempmin, tempmax from datosmodeloclima where gid in (select gid from climasamplingpoints order by st_distance(st_geogfromtext('POINT(",lng," ",lat,")'),geom) limit 1)",sep="")
    
    #realizar la consulta en la tabla datosmodeloclima
    datos_crudos <- dbGetQuery(con,consulta)
    
    
    tryCatch(
      {
        if("precipitacion" %in% colnames(datos_crudos) && "tempmin" %in% colnames(datos_crudos) && "tempmax" %in% colnames(datos_crudos) && "fecha" %in% colnames(datos_crudos)  )
        {
          
          names(datos_crudos)[names(datos_crudos) == "precipitacion"] <- "lluvia_diaria"
          names(datos_crudos)[names(datos_crudos) == "tempmin"] <- "temp_min"
          names(datos_crudos)[names(datos_crudos) == "tempmax"] <- "temp_max"
          names(datos_crudos)[names(datos_crudos) == "fecha"] <- "fecha"
          
          #datos_crudos$fecha <- as_date(format(strptime(as.character(datos_crudos$fecha), "%m/%d/%y" ),"%Y-%m-%d")) #cambiar formato de fechas 
          saveRDS(datos_crudos, file = "datos/00_datos_crudos.RDS")
          
          procesar_variables()
          generar_pronosticos()
          
          ## Ultimos datos de pronostico generados y variables
          datos_pron_finales <- readRDS("datos/03_datos_pron_finales.RDS")
          
          data <- datos_pron_finales %>% filter(modelo %in% c("mod_aparicion","mod_esporulacion","mod_intensificacion"))
          
          data2 <- datos_pron_finales %>% filter(modelo %in% c("mod_aparicion_s_baja", "mod_esporulacion_s_baja", "mod_intensificacion_s_baja"))
          
          data3 <- datos_pron_finales %>% filter(modelo %in% c("mod_aparicion_s_alta_irreg", "mod_esporulacion_s_alta_irreg", "mod_intensificacion_s_alta_irreg"))
          
          data4 <- datos_pron_finales %>% filter(modelo %in% c("mod_aparicion_s_alta_reg", "mod_esporulacion_s_alta_reg", "mod_intensificacion_s_alta_reg"))
          
          #CABECERA 
          sql <- paste("insert into datalink_stadman_app(cod_lote) values(",args[3],") RETURNING correl;");
          #sql <- paste("insert into datalink_stadman_app(cod_lote) values(2) RETURNING correl;");
          rs_insert_cabecera <- dbGetQuery(con,sql)
          
          ######-------SIN sombra-----------------------------------------------------------------------------------------------------------------
          #SIN SOMBRA
          sql2 <- paste("insert into dlink_stman_app_sinsombra(id_cabecera) values(",rs_insert_cabecera$correl,") RETURNING correl;");
          rs_insert_sin <- dbGetQuery(con,sql2)
          
          #SIN SOMBRA_mod_aparicion
          sql3 <- paste("insert into dlink_stman_app_modelo(id_cabecera_sin,modelo,prom_lluvia_a,prom_temp_min,amplitud_termica,prob_aparicion_lesion) 
                        values(",rs_insert_sin$correl,",'mod_aparicion',",data[1,4],",",data[1,6],",",data[1,8],",",data[1,2],");");
          dbGetQuery(con,sql3)
          
          #SIN SOMBRA_mod_esporulacion
          sql4 <- paste("insert into dlink_stman_app_modelo(id_cabecera_sin,modelo,prom_lluvia_a,prom_lluvia_b,prom_temp_max,amplitud_termica,prob_aparicion_esporas) 
                        values(",rs_insert_sin$correl,",'mod_esporulacion',",data[2,4],",",data[2,5],",",data[2,7],",",data[2,8],",",data[2,2],");");
          dbGetQuery(con,sql4)
          
          #SIN SOMBRA_mod_intensificacion
          sql5 <- paste("insert into dlink_stman_app_modelo(id_cabecera_sin,modelo,prom_temp_max,pronos_incremento_area) 
                        values(",rs_insert_sin$correl,",'mod_intensificacion',",data[3,7],",",data[3,2],");");
          dbGetQuery(con,sql5)
          
          #SIN SOMBRA_probabilidad 10 dias
          alerta <- ifelse(data[1,2] >= 0.04, "Alta",ifelse(data[1,2] >= 0.02, "Regular",ifelse(data[1,2] >= 0.01, "Baja", "Muy baja")))
          sql_sin_10dias <- paste("insert into dlink_stman_app_probas(id_cabecera_sin,dias,fecha,probabilidad) values(",rs_insert_sin$correl,",10,'",data[1,1],"','",alerta,"');");
          dbGetQuery(con,sql_sin_10dias)
          
          #SIN SOMBRA_probabilidad 3 dias (primeras esporas)
          alerta2 <- ifelse(data[2,2] >= 0.31, "Alta", ifelse(data[2,2] >= 0.29, "Regular", ifelse(data[2,2] >= 0.24, "Baja", "Muy baja")))
          sql_sin_3dias <- paste("insert into dlink_stman_app_probas(id_cabecera_sin,dias,fecha,probabilidad) values(",rs_insert_sin$correl,",3,'",data[2,1],"','",alerta2,"');");
          dbGetQuery(con,sql_sin_3dias)
          
          #SIN SOMBRA_probabilidad 5 dias (incremento del area esporulada)
          alerta3 <- ifelse(data[3,2] >= 0.0347, "Alta",ifelse(data[3,2] >= 0.0342, "Regular", ifelse(data[3,2] >= 0.0333, "Baja", "Muy baja")))
          sql_sin_5dias <- paste("insert into dlink_stman_app_probas(id_cabecera_sin,dias,fecha,probabilidad) values(",rs_insert_sin$correl,",5,'",data[3,1],"','",alerta3,"');");
          dbGetQuery(con,sql_sin_5dias)
          
          
          ######-------con sombra-----------------------------------------------------------------------------------------------------------------
          #CON SOMBRA
          sql2_con <- paste("insert into dlink_stman_app_consombra(id_cabecera) values(",rs_insert_cabecera$correl,") RETURNING correl;");
          rs_insert_con <- dbGetQuery(con,sql2_con)
          ##----------------------------------------
          #CON SOMBRA tipo BAJA (menor a 7 metros) 
          sql3_con <- paste("insert into dlink_stman_app_tiposombra(id_cabecera_consombra,tipo_sombra) values(",rs_insert_con$correl,",'Baja') RETURNING correl;");
          rs_insert_con_baja <- dbGetQuery(con,sql3_con)
          
          #CON SOMBRA Baja   _mod_aparicion
          sql4_con <- paste("insert into dlink_stman_app_modelo(id_cabecera_con,modelo,prom_lluvia_a,prom_temp_min,amplitud_termica,prob_aparicion_lesion) 
                        values(",rs_insert_con_baja$correl,",'mod_aparicion',",data2[1,4],",",data2[1,6],",",data2[1,8],",",data2[1,2],");");
          dbGetQuery(con,sql4_con)
          
          #CON SOMBRA Baja    _mod_esporulacion
          sql5_con <- paste("insert into dlink_stman_app_modelo(id_cabecera_con,modelo,prom_lluvia_a,prom_lluvia_b,prom_temp_max,amplitud_termica,prob_aparicion_esporas) 
                        values(",rs_insert_con_baja$correl,",'mod_esporulacion',",data2[2,4],",",data2[2,5],",",data2[2,7],",",data2[2,8],",",data2[2,2],");");
          dbGetQuery(con,sql5_con)
          
          #CON SOMBRA Baja   _mod_intensificacion
          sql6_con <- paste("insert into dlink_stman_app_modelo(id_cabecera_con,modelo,prom_temp_max,pronos_incremento_area) 
                        values(",rs_insert_con_baja$correl,",'mod_intensificacion',",data2[3,7],",",data2[3,2],");");
          dbGetQuery(con,sql6_con)
          
          #CON SOMBRA BAJA_probabilidad 10 dias
          alerta <- ifelse(data2[1,2] >= 0.04, "Alta",ifelse(data2[1,2] >= 0.02, "Regular",ifelse(data2[1,2] >= 0.01, "Baja", "Muy baja")))
          sql_con_10dias_baja <- paste("insert into dlink_stman_app_probas(id_cabecera_con,dias,fecha,probabilidad) values(",rs_insert_con_baja$correl,",10,'",data2[1,1],"','",alerta,"');");
          dbGetQuery(con,sql_con_10dias_baja)
          
          #CON SOMBRA BAJA_probabilidad 3 dias (primeras esporas)
          alerta2 <- ifelse(data2[2,2] >= 0.31, "Alta", ifelse(data2[2,2] >= 0.29, "Regular", ifelse(data2[2,2] >= 0.24, "Baja", "Muy baja")))
          sql_con_3dias_baja <- paste("insert into dlink_stman_app_probas(id_cabecera_con,dias,fecha,probabilidad) values(",rs_insert_con_baja$correl,",3,'",data2[2,1],"','",alerta2,"');");
          dbGetQuery(con,sql_con_3dias_baja)
          
          #CON SOMBRA BAJA_probabilidad 5 dias (incremento del area esporulada)
          alerta3 <- ifelse(data2[3,2] >= 0.0347, "Alta",ifelse(data2[3,2] >= 0.0342, "Regular", ifelse(data2[3,2] >= 0.0333, "Baja", "Muy baja")))
          sql_con_5dias_baja <- paste("insert into dlink_stman_app_probas(id_cabecera_con,dias,fecha,probabilidad) values(",rs_insert_con_baja$correl,",5,'",data2[3,1],"','",alerta3,"');");
          dbGetQuery(con,sql_con_5dias_baja)
          
          ##----------------------------------------
          #CON SOMBRA tipo IRREGULAR
          sql7_con <- paste("insert into dlink_stman_app_tiposombra(id_cabecera_consombra,tipo_sombra) values(",rs_insert_con$correl,",'Irregular') RETURNING correl;");
          rs_insert_con_irre <- dbGetQuery(con,sql7_con)
          
          #CON SOMBRA IRREGULAR   _mod_aparicion
          sql8_con <- paste("insert into dlink_stman_app_modelo(id_cabecera_con,modelo,prom_lluvia_a,prom_temp_min,amplitud_termica,prob_aparicion_lesion) 
                        values(",rs_insert_con_irre$correl,",'mod_aparicion',",data3[1,4],",",data3[1,6],",",data3[1,8],",",data3[1,2],");");
          dbGetQuery(con,sql8_con)
          
          #CON SOMBRA IRREGULAR    _mod_esporulacion
          sql9_con <- paste("insert into dlink_stman_app_modelo(id_cabecera_con,modelo,prom_lluvia_a,prom_lluvia_b,prom_temp_max,amplitud_termica,prob_aparicion_esporas) 
                        values(",rs_insert_con_irre$correl,",'mod_esporulacion',",data3[2,4],",",data3[2,5],",",data3[2,7],",",data3[2,8],",",data3[2,2],");");
          dbGetQuery(con,sql9_con)
          
          #CON SOMBRA IRREGULAR   _mod_intensificacion
          sql10_con <- paste("insert into dlink_stman_app_modelo(id_cabecera_con,modelo,prom_temp_max,pronos_incremento_area) 
                        values(",rs_insert_con_irre$correl,",'mod_intensificacion',",data3[3,7],",",data3[3,2],");");
          dbGetQuery(con,sql10_con)
          
          #CON SOMBRA IRREGULAR_probabilidad 10 dias
          alerta <- ifelse(data3[1,2] >= 0.04, "Alta",ifelse(data3[1,2] >= 0.02, "Regular",ifelse(data3[1,2] >= 0.01, "Baja", "Muy baja")))
          sql_con_10dias_irre <- paste("insert into dlink_stman_app_probas(id_cabecera_con,dias,fecha,probabilidad) values(",rs_insert_con_irre$correl,",10,'",data3[1,1],"','",alerta,"');");
          dbGetQuery(con,sql_con_10dias_irre)
          
          #CON SOMBRA BAJA_probabilidad 3 dias (primeras esporas)
          alerta2 <- ifelse(data3[2,2] >= 0.31, "Alta", ifelse(data3[2,2] >= 0.29, "Regular", ifelse(data3[2,2] >= 0.24, "Baja", "Muy baja")))
          sql_con_3dias_irre <- paste("insert into dlink_stman_app_probas(id_cabecera_con,dias,fecha,probabilidad) values(",rs_insert_con_irre$correl,",3,'",data3[2,1],"','",alerta2,"');");
          dbGetQuery(con,sql_con_3dias_irre)
          
          #CON SOMBRA BAJA_probabilidad 5 dias (incremento del area esporulada)
          alerta3 <- ifelse(data3[3,2] >= 0.0347, "Alta",ifelse(data3[3,2] >= 0.0342, "Regular", ifelse(data3[3,2] >= 0.0333, "Baja", "Muy baja")))
          sql_con_5dias_irre <- paste("insert into dlink_stman_app_probas(id_cabecera_con,dias,fecha,probabilidad) values(",rs_insert_con_irre$correl,",5,'",data3[3,1],"','",alerta3,"');");
          dbGetQuery(con,sql_con_5dias_irre)
          
          ##----------------------------------------
          #CON SOMBRA tipo REGULAR
          sql11_con <- paste("insert into dlink_stman_app_tiposombra(id_cabecera_consombra,tipo_sombra) values(",rs_insert_con$correl,",'Regular') RETURNING correl;");
          rs_insert_con_regu <- dbGetQuery(con,sql11_con)
          
          #CON SOMBRA REGULAR   _mod_aparicion
          sql12_con <- paste("insert into dlink_stman_app_modelo(id_cabecera_con,modelo,prom_lluvia_a,prom_temp_min,amplitud_termica,prob_aparicion_lesion) 
                        values(",rs_insert_con_regu$correl,",'mod_aparicion',",data4[1,4],",",data4[1,6],",",data4[1,8],",",data4[1,2],");");
          dbGetQuery(con,sql12_con)
          
          #CON SOMBRA REGULAR    _mod_esporulacion
          sql13_con <- paste("insert into dlink_stman_app_modelo(id_cabecera_con,modelo,prom_lluvia_a,prom_lluvia_b,prom_temp_max,amplitud_termica,prob_aparicion_esporas) 
                        values(",rs_insert_con_regu$correl,",'mod_esporulacion',",data4[2,4],",",data4[2,5],",",data4[2,7],",",data4[2,8],",",data4[2,2],");");
          dbGetQuery(con,sql13_con)
          
          #CON SOMBRA REGULAR   _mod_intensificacion
          sql14_con <- paste("insert into dlink_stman_app_modelo(id_cabecera_con,modelo,prom_temp_max,pronos_incremento_area) 
                        values(",rs_insert_con_regu$correl,",'mod_intensificacion',",data4[3,7],",",data4[3,2],");");
          dbGetQuery(con,sql14_con)
          
          #CON SOMBRA REGULAR_probabilidad 10 dias
          alerta <- ifelse(data4[1,2] >= 0.04, "Alta",ifelse(data4[1,2] >= 0.02, "Regular",ifelse(data4[1,2] >= 0.01, "Baja", "Muy baja")))
          sql_con_10dias_regu <- paste("insert into dlink_stman_app_probas(id_cabecera_con,dias,fecha,probabilidad) values(",rs_insert_con_regu$correl,",10,'",data4[1,1],"','",alerta,"');");
          dbGetQuery(con,sql_con_10dias_regu)
          
          #CON SOMBRA REGULAR_probabilidad 3 dias (primeras esporas)
          alerta2 <- ifelse(data4[2,2] >= 0.31, "Alta", ifelse(data4[2,2] >= 0.29, "Regular", ifelse(data4[2,2] >= 0.24, "Baja", "Muy baja")))
          sql_con_3dias_regu <- paste("insert into dlink_stman_app_probas(id_cabecera_con,dias,fecha,probabilidad) values(",rs_insert_con_regu$correl,",3,'",data4[2,1],"','",alerta2,"');");
          dbGetQuery(con,sql_con_3dias_regu)
          
          #CON SOMBRA REGULAR_probabilidad 5 dias (incremento del area esporulada)
          alerta3 <- ifelse(data4[3,2] >= 0.0347, "Alta",ifelse(data4[3,2] >= 0.0342, "Regular", ifelse(data4[3,2] >= 0.0333, "Baja", "Muy baja")))
          sql_con_5dias_regu <- paste("insert into dlink_stman_app_probas(id_cabecera_con,dias,fecha,probabilidad) values(",rs_insert_con_regu$correl,",5,'",data4[3,1],"','",alerta3,"');");
          dbGetQuery(con,sql_con_5dias_regu)
          

          dbDisconnect(con)   #disconnect from database
          
          #return(rs_insert_cabecera$correl)
          return(69)
          

          
        }else{
          return(-1)
          stop(safeError("Error: no coincide con el formato requerido."))
        }
        
        
      },
      error = function(e) {
        # return a safeError if a parsing error occurs
        return(-2)
        stop(safeError(e))
      }
    )

    

    return(-100)
}

if (length(args)==0) {
  stop("At least two arguments must be supplied", call.=FALSE)
} else if (length(args)==3) {
  print(func_stadaman_app()) #llamar stadman function definida arriba
}
  
  