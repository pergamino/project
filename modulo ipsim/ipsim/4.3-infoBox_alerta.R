# Descripcion del riesgo en el infoBox


func_infoBox <- function(df_data_prono,
                         datos_epidemio,
                         date_floracion,
                         date_ini_cosecha,
                         date_fin_cosecha) {
  
library(mondate)
  
  ano_en_curso <- subset(df_data_prono,ano==max(ano))
  
  mes_en_curso <- max(ano_en_curso$num_mes)
  
  # Nombre del mes del ano
  df_mes <- data.frame(num_mes = c(1:12),
                       nombre_mes = c("Enero", "Febrero", "Marzo", "Abril", 
                                      "Mayo", "Junio", "Julio", "Agosto", 
                                      "Setiembre", "Octubre", "Noviembre", 
                                      "Diciembre")
  )
  
  nombre_mes_en_curso <- df_mes$nombre_mes[df_mes$num_mes==mes_en_curso]
  
  riesgo_del_mes <- ano_en_curso$riesgo[ano_en_curso$num_mes==mes_en_curso]
  

  incidencia_va <- df_data_prono$categoria[nrow(df_data_prono)]
  

col_alerta <- factor(c("Azul","Verde","Amarillo","Naranja","Rojo"),
                     levels=c("Azul","Verde","Amarillo","Naranja","Rojo"))


# Definition des periodes 
#################

date_init <- as.Date(as.mondate(df_data_prono$Fecha_median[1]) - 1)
date_fin <- as.Date(as.mondate(df_data_prono$Fecha_median[nrow(df_data_prono)]) + 1)


rect0 <- data.frame(xstart = min(date_init,date_floracion), xend = date_floracion,
                    ystart = c(0,5,15,20,30), yend = c(5,15,20,30,(max(35,datos_epidemio$incidencia,
                                                                       df_data_prono$incidencia_ipsim,
                                                                       na.rm=T))),
                    col = col_alerta,
                    periodo=0)

rect1 <- data.frame(xstart = date_floracion, xend = date_ini_cosecha,
                    ystart = c(0,2.5,5,10,20), yend = c(2.5,5,10,20,(max(35,datos_epidemio$incidencia,
                                                                         df_data_prono$incidencia_ipsim,
                                                                         na.rm=T))),
                    col = col_alerta,
                    periodo=1)

rect2 <- data.frame(xstart = date_ini_cosecha, xend = date_fin_cosecha,
                    ystart = c(0,5,15,20,30), yend = c(5,15,20,30,(max(35,datos_epidemio$incidencia,
                                                                       df_data_prono$incidencia_ipsim,
                                                                       na.rm=T))),
                    col = col_alerta,
                    periodo=2)

rect3 <- data.frame(xstart = date_fin_cosecha, xend = max(date_fin,date_fin_cosecha),
                    ystart = c(0,2.5,5,10,20), yend = c(2.5,5,10,20,(max(35,datos_epidemio$incidencia,
                                                                         df_data_prono$incidencia_ipsim,
                                                                         na.rm=T))),
                    col = col_alerta,
                    periodo=3)


df_periodo <- rbind(rect0,rect1,rect2,rect3)


# Buscar la color de alerta del mes en curso


for(fecha in 1:nrow(df_periodo)){
  col_alerta_del_mes <-
    if (df_data_prono$Fecha_median[nrow(df_data_prono)] > df_periodo$xstart[fecha] &
        df_data_prono$Fecha_median[nrow(df_data_prono)] < df_periodo$xend[fecha] &
        df_data_prono$incidencia_median[nrow(df_data_prono)] >= df_periodo$ystart[fecha] &
        df_data_prono$incidencia_median[nrow(df_data_prono)] <= df_periodo$yend[fecha])
    {
      df_periodo$col[fecha]
    } else {
      next
    }
  

}


# Buscar la color de alerta del proximo mes 


sub <- subset(df_periodo, xend==df_periodo$xend[nrow(df_periodo)])

for(fecha2 in 1:nrow(sub)){
  
  col_alerta_proximo_mes <-
    if (df_data_prono$incidencia_ipsim[nrow(df_data_prono)] >
        sub$ystart[fecha2] &
        df_data_prono$incidencia_ipsim[nrow(df_data_prono)] <
        sub$yend[fecha2])
    {
      df_periodo$col[fecha2]
    } else {
      next
    }
}


df_riesgo <- data.frame(
  nombre_mes_en_curso = nombre_mes_en_curso,
  incidencia_va = incidencia_va,
  col_alerta_del_mes = col_alerta_del_mes,
  col_alerta_proximo_mes = col_alerta_proximo_mes
)

return(df_riesgo)
}