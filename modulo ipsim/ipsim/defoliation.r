defoliacion_plot <- 30*(0.0125*output_incDefoliacion$inc_mediana + 0.2186)

plot(output_incDefoliacion$inc_mediana,defoliacion_plot)

defoliacion <- c(6,20)

inc <- (defoliacion/30 - 0.2186)/0.0125
