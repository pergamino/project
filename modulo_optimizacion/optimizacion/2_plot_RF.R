# Plot des resultats d'analyse Random Forest

func_plot_RF <- function(importance_sorted){
  
library(ggplot2)
    
rect <- data.frame(xstart = min(importance_sorted$IncNodePurity)-1000, xend = max(importance_sorted$IncNodePurity+1000),
                   ystart = importance_sorted[2,]$var_names, yend = importance_sorted[1,]$var_names)

# Plot
ggplot() +
  geom_point(data=transform(importance_sorted, var_names = reorder(var_names, IncNodePurity)),
             aes(x=IncNodePurity, y=var_names),stat="identity",size=2, shape=21)+
  # geom_point(data=transform(importance_sorted[1:2,], var_names = reorder(var_names, IncNodePurity)),
             # aes(x=IncNodePurity, y=var_names),stat="identity",color="red",size=3)+
  geom_rect(data=rect, aes(xmin=xstart, xmax=xend, ymin=ystart,
                            ymax=yend),fill="red",alpha=0.2) +
  theme_bw()+
  theme(
    legend.position="none",
    axis.line.x = element_line(color = "black"), 
    # axis.line.y = element_line(color = "black"),
    panel.border = element_blank(),
    # panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    axis.ticks.y=element_blank(),
    strip.background = element_blank())+
  xlab("") + ylab("Importance de las variables")

}
