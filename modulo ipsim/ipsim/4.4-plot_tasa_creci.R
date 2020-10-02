func_tasa_creci <- function(df_data_prono,
                            datos_epidemio){
  

  
  # date_init <- as.Date(as.mondate(df_data_prono$Fecha_median[1]) - 1)
  date_fin <- as.Date(as.mondate(df_data_prono$Fecha_median[nrow(df_data_prono)]) + 1)
  df_data_prono$end30 <- c(df_data_prono$Fecha_median[-1],date_fin)
  df_data_prono$creci_obs30 <- c(df_data_prono$creci_obs[-1],NA)
  
  # premiere valeur de creci_obs
  df_data_prono$creci_obs[1] <- 0
  
  
  prono_long <- gather(df_data_prono, condition, crecimiento, c(creci_prono,creci_obs30), factor_key=TRUE)
  levels(prono_long$condition)[levels(prono_long$condition)=="creci_prono"] <- "Pronostico"
  levels(prono_long$condition)[levels(prono_long$condition)=="creci_obs30"] <- "Observado"

  
ggplot() +

  # geom_segment(data=df_data_prono, mapping=aes(x=Fecha_median, y=0,
  #                                              xend=end30, yend=creci_obs30),
  #              arrow=arrow(length = unit(3, "mm"),type='closed'), size=1.5, color="blue") +
  # 
  # geom_segment(data=df_data_prono, mapping=aes(x=Fecha_median, y=0,
  #                                              xend=end30, yend=creci_prono),
  #              arrow=arrow(length = unit(3, "mm"),type='closed'), size=1.5, color="red") +

  geom_segment(data=prono_long, mapping=aes(x=Fecha_median, y=0,
                                            xend=end30, yend=crecimiento,
                                            color=condition),
               arrow=arrow(length = unit(3, "mm"),type='closed'), size=1.5) +
  
  # geom_text(data=df_data_prono,mapping=aes(x=Fecha_median, y=max(df_data_prono$creci_obs)),
  #           label = df_data_prono$inicial_categoria,
  #           fontface="bold",color="red", size=5)+ # ,vjust = "top"


  labs(x = "Fecha de monitoreo",
       y="Tasa de crecimiento")+
  scale_x_date(date_labels = "%d/%m/%y",
               breaks=unique(df_data_prono$Fecha_median))+

  theme_bw()+
  theme(
    # legend.position="none",
    panel.grid.minor = element_blank(),
    strip.background = element_blank())+
  theme(legend.title=element_blank(),
        axis.text.x = element_text(size=12,angle = 90,face="bold"),
        legend.text=element_text(size=12))
  
  

  
}