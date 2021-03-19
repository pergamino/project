#' ---
#' Titulo: "Multilayer Perceptron Artificial Neural Networks (MLP-ANN) para pronostico de error en incidencia"
#' Author: "Jose Valles"
#' Fecha: "10/01/2021"
#' ---

# Importar datos ----------------------------------------------------------
# Importar libreria
library(tidyverse)
library(neuralnet)
library(Metrics)
# Remover variables del ambiente de trabajo de R
rm(list = objects())
# Importar datos de entrada
incidencia <- readr::read_csv(file="input/datamodel.csv") %>% 
  tibble::as_tibble()
# Eliminar variables que no seran utilizadas en el experimento
  
# Normalizar entradas y salidas en base a la propuesta del paquete neuralnet
incidencia.norm <- scale(incidencia)

# Neural Network con algortimo rprop+  ------------------------------------
# Entrenamiento 14 instancias y 4 instancias para validacion cruzada
train <- 1:14
cross <- 15:18
# Entrenar una Red Neuronal Artificial usando como algoritmo el RPROG+ 

nn.rp <- neuralnet(formula = error_t1 ~ Infeccion + Lavado + incidencia_observada + incidencia_pronosticada + error_t,
                   data = incidencia.norm[train,],
                   hidden = 4,
                   threshold = 0.01,
                   stepmax = 1e7,
                   err.fct = "sse",
                   act.fct = "logistic",
                   linear.output = TRUE,
                   lifesign = "full")

# Graficar Architectura de la Red Neuronal Artificial
plot(nn.rp)
# Ver salidas de entrenamiento
predTrain.rp <- neuralnet::compute(nn.rp,incidencia.norm[train,])
predCross.rp <- neuralnet::compute(nn.rp,incidencia.norm[cross,])
# Desnormalizar los valores
predTrain.rp <- predTrain.rp$net.result * attr(incidencia.norm, "scaled:scale")["error_t1"] + 
  attr(incidencia.norm, "scaled:center")["error_t1"]
predCross.rp <- predCross.rp$net.result * attr(incidencia.norm, "scaled:scale")["error_t1"] + 
  attr(incidencia.norm, "scaled:center")["error_t1"]
# Graficar x = Target, y = fits
prediction.rp = c(predTrain.rp,predCross.rp)
actual.rp = c(incidencia$error_t1[train],incidencia$error_t1[cross])
output.rp = tibble(actual = actual.rp, prediction = prediction.rp) %>%
  mutate(id = row_number()) %>%
  mutate(dataset = case_when(id <= 14 ~ "Training",
                             id > 14 ~ "CrossValidation"))
ggplot(data=output.rp) +
  geom_point(mapping = aes(x = actual,y = prediction), size = 3) +
  geom_abline(intercept = 0, slope = 1, size = 0.8, linetype = 3) + 
  xlim(-20,20) +
  ylim(-20,20) +
  facet_wrap(~dataset)

errorTrain.rp = rmse(actual = incidencia$error_t1[train], predicted =  predTrain.rp)
errorCross.rp = rmse(actual = incidencia$error_t1[cross], predicted =  predCross.rp)

print(paste0("Utilizando el algortimo rprop+, el error en entrenamiento es: ", round(errorTrain.rp,2)))
print(paste0("Utilizando el algortimo rprop+, el error en validacion cruzada es: ", round(errorCross.rp,2)))

# Neural Network con algortimo backpropagation  --------------------------------------------------------------------
nn.bp <- neuralnet(formula = error_t1 ~ Infeccion + Lavado + incidencia_observada + incidencia_pronosticada + error_t,
                   data = incidencia.norm[train,],
                   hidden = 4,
                   threshold = 0.01,
                   stepmax = 1e7,
                   learningrate = 0.01,
                   algorithm = "backprop",
                   err.fct = "sse",
                   act.fct = "logistic",
                   linear.output = TRUE,
                   lifesign = "full")

# Graficar Architectura de la Red Neuronal Artificial
plot(nn.bp)
# Ver salidas de entrenamiento
predTrain.bp <- neuralnet::compute(nn.bp,incidencia.norm[train,])
predCross.bp <- neuralnet::compute(nn.bp,incidencia.norm[cross,])
# Desnormalizar los valores
predTrain.bp <- predTrain.bp$net.result * attr(incidencia.norm, "scaled:scale")["error_t1"] + 
  attr(incidencia.norm, "scaled:center")["error_t1"]
predCross.bp <- predCross.bp$net.result * attr(incidencia.norm, "scaled:scale")["error_t1"] + 
  attr(incidencia.norm, "scaled:center")["error_t1"]
# Graficar x = Target, y = fits
prediction.bp = c(predTrain.bp,predCross.bp)
actual.bp = c(incidencia$error_t1[train],incidencia$error_t1[cross])
output.bp = tibble(actual = actual.bp, prediction = prediction.bp) %>%
  mutate(id = row_number()) %>%
  mutate(dataset = case_when(id <= 14 ~ "Training",
                             id > 14 ~ "CrossValidation"))
ggplot(data=output.bp) +
  geom_point(mapping = aes(x = actual,y = prediction), size = 3,color = "blue") +
  geom_abline(intercept = 0, slope = 1, size = 0.8, linetype = 3) + 
  xlim(-20,20) +
  ylim(-20,20) +
  facet_wrap(~dataset)

errorTrain.bp = rmse(actual = incidencia$error_t1[train], predicted =  predTrain.bp)
errorCross.bp = rmse(actual = incidencia$error_t1[cross], predicted =  predCross.bp)

print(paste0("Utilizando el algortimo backpropagation, el error en entrenamiento es: ", round(errorTrain.bp,2)))
print(paste0("Utilizando el algortimo backpropagation, el error en validacion cruzada es: ", round(errorCross.bp,2)))
