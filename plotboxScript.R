# Scripting for testing plotbox configurations
library(plotly)

region <- c("Select a Region", 
              "Northern Metropolitan", 
              "Western Metropolitan", 
              "Southern Metropolitan", 
              "Eastern Metropolitan", 
              "South-Eastern Metropolitan", 
              "Eastern Victoria", 
              "Northern Victoria", 
              "Western Victoria",
              "All")

n.rooms <- 4
n.bath <- 2
t.type <- "h"
r.region <- region[2] 

df.mel1 <- df.mel[which(df.mel$Rooms == n.rooms &
                            df.mel$Bathroom == n.bath &
                            df.mel$Type == t.type),]   

df.mel2 <- df.mel[which(df.mel$Rooms == n.rooms &
                            df.mel$Bathroom == n.bath &
                            df.mel$Type == t.type &
                            df.mel$Regionname == r.region),]   


p <- plot_ly(y = ~df.mel1$Price, 
            type = "box") %>%
    add_trace(y = ~df.mel2$Price)

p