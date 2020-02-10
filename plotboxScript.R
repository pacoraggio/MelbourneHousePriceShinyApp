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

df.mel1 <- df.mel[which(df.mel$Rooms == n.rooms &
                            df.mel$Bathroom == n.bath &
                            df.mel$Type == t.type),]   
r.region <- region[9] 
if(r.region == "Select a Region")
   {
       print(r.region)
    } else if (r.region == "All")
    {
    print(r.region)
    df.mel2 <- df.mel[which(df.mel$Rooms == n.rooms &
                                df.mel$Bathroom == n.bath &
                                df.mel$Type == t.type),]   
    }else
        {
            df.mel2 <- df.mel[which(df.mel$Rooms == n.rooms &
                            df.mel$Bathroom == n.bath &
                            df.mel$Type == t.type &
                            df.mel$Regionname == r.region),]   
}

p <- plot_ly(y = ~df.mel1$Price, 
            type = "box") %>%
    add_trace(y = ~df.mel2$Price)

p

# rsconnect::setAccountInfo(name='pacoraggio',
#                           token='1C95A63CF4106221EE1B090217430620',
#                           secret='u9sx+jPOVcYZyTcmWfZUsqIpIT4f1CMppQ4Ko6ES')
# 
# rsconnect::deployApp('C:/Users/pacor/Desktop/Paolo/WIP/Coursera/09_Developing_Data_Products-master/GIT/Week4Assignment/Beta/MelbourneHousePriceShinyApp')
