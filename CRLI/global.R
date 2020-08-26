suppressPackageStartupMessages({
  library("SHAPforxgboost"); library("ggplot2"); library("xgboost")
  library("data.table"); library("here") 
})

library(DT)

#instance structure
dataX <- data.frame(matrix(ncol = 9, nrow = 0))
x <- c('rDay14-11','pre11-8','tMax9-6','pre6-3','tMin4-1','hGrowth','rP','shade','management')
colnames(dataX) <- x

#load model
mod <- xgb.load('xgbModel14D.model')
