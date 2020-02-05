library(dplyr)

df.mel <- read.csv("./Data/melb_data.csv")
df.mel <- df.mel[!(is.na(df.mel$Longtitude)),]

df.mel$PriceCategory <-cut(df.mel$Price,
                           breaks = quantile(df.mel$Price),
                           labels = c("low", "medium low", "medium high", "high"))

df.mel$MarkerColor <-cut(df.mel$Price,
                         breaks = quantile(df.mel$Price),
                         labels = c("darkgreen", "green", "red", "darkred"))

df.mel$HoverText <- with(df.mel, paste('<b>Price:</b>', Price,
                         '<br>', "Council: ", CouncilArea, 
                         '<br>', "Region: ", Regionname, 
                         '<br>', "Number of Rooms", Rooms,
                         '<br>', "Type", Type))
