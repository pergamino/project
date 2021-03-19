library(tidyverse)
library(reshape)

rm(list = objects())

incidencia <- readr::read_csv(file="input/matriz.csv") %>% 
  dplyr::mutate(fecha_median = as.Date(fecha_median, format = "%Y-%m-%d")) %>%
  tibble::as_tibble()

ggplot(data=incidencia) +
  geom_point(mapping = aes(x = incidencia_observada,y = incidencia_pronosticada, color = pais), size = 3) +
  xlim(0,50) + 
  ylim(0,50) + 
  geom_abline(intercept = 0, slope = 1, size = 0.8, linetype = 3) + 
  labs(x = "Incidencia observada", y = "Incidencia pronosticada") + 
  scale_color_hue(labels = c("El Salvador", "Honduras", "Republica Dominicana")) + 
  theme(legend.title = element_blank(),legend.position="top",text = element_text(size=14))

# calculo del error (fcts - obs)
incidencia <- mutate(incidencia,
                     error = incidencia_pronosticada - incidencia$incidencia_observada)
# Graficar el error
ggplot(data=incidencia) +
  geom_point(mapping = aes(x = months(fecha_median),y = error, color = pais), size = 3)

names <- c("el_salvador" = "El Salvador","honduras" = "Honduras","republica_dominicana" = "Republica Dominicana")

# filtrar por paises
incidencia %>% 
  select(fecha_median,incidencia_observada,incidencia_pronosticada,pais) %>% 
  gather("class","incidencia",-pais,-fecha_median) %>%
  ggplot(aes(x = fecha_median, y=incidencia, color =class)) +
  geom_line(linetype = "dashed") + 
  geom_point(size =3) + 
  scale_x_date(date_breaks = "1 month",date_labels = "%b-%Y") + 
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)) +
  facet_wrap(~pais, labeller = labeller(pais = names)) + 
  scale_color_hue(labels = c("Incidencia observada", "Incidencia pronosticada")) + 
  labs(x = "Fecha", y = "Incidencia") + 
  theme(legend.title = element_blank(),legend.position="top",text = element_text(size=14))



