# ***  Graphics ***
# S and S2 should be available from previous simulation
S$Sim$Date <- S$Meteo$Date
plotLAIs(S, S2)

S$Sim <-subset(S$Sim, Date<=S2$Sim$Date[currentStepDynacof])
S2$Sim <-subset(S2$Sim, Date<=S2$Sim$Date[currentStepDynacof])
library(ggplot2)
ggplot()+
  geom_point(data=S$Sim,aes(x=S$Sim$Date, y=CM_Fruit/10),color="orange")+
  geom_point(data=S$Meteo,aes(x=S$Meteo$Date, y=Rain,))
geom_point(data=S$Sim,aes(x=3$Sim$Date, y=Harvest_Fruit,color="orange")) 

# Calcul charge fruitiere
S2$Sim$sum_fruits <- 0
for (i in 2: nrow(S2$Sim)){
  if(S2$Sim$BudBreak[i]>0) {S2$Sim$sum_fruits[i] <- S2$Sim$sum_fruits[i-1]+S2$Sim$BudBreak[i]}
}
plot(S2$Sim$sum_fruits)    
plot(S2$Sim$BudBreak)

fruits =
  S2$Sim%>%
  group_by(Plot_Age)%>%
  summarise(nodes = mean(ratioNodestoLAI * LAI),
            buds = sum(BudBreak))%>%
  mutate(n_fruitsPerNode = buds / nodes)

plot(fruits$Plot_Age, fruits$buds) 
plot(fruits$Plot_Age, fruits$n_fruitsPerNode) 

