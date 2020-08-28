func_table_comb_var <- function(table_RF){
  
comb_var <- data.frame(unique(table_RF$comb_var))
names(comb_var) <- "FACTOR"

return(comb_var)
}