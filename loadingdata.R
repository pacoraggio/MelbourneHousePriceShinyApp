library(dplyr)
rm(list = ls())
# df.mel <- read.csv("./Data/melb_data.csv")
df.mel <- read.csv("./Data/Melbourne_housing_FULL.csv")
df.mel <- df.mel[which(!is.na(df.mel$Lattitude) &
                           !is.na(df.mel$Price) &
                           !is.na(df.mel$Bathroom)),]

# df1_FULL <- df1_FULL[which(!is.na(df1_FULL$Lattitude) & 
#                                !is.na(df1_FULL$Price) &
#                                !is.na(df1_FULL$Bathroom)),]

df.mel$PriceCategory <-cut(df.mel$Price,
                           breaks = quantile(df.mel$Price),
                           labels = c("low", "medium low", "medium high", "high"))

df.mel$MarkerColor <-cut(df.mel$Price,
                         breaks = quantile(df.mel$Price),
                         labels = c("darkgreen", "green", "red", "darkred"))

residency.type <- function(ttype)
{
    if (ttype == "h")
    {
        return("House Cottage Villa")
    }else if (ttype == "u")
    {
        return("Unit Duplex")
    }else
    {
        return("Town house")
    }
}

df.mel$HoverText <- with(df.mel, paste('<b>Price:</b>', Price,
                         '<br>', "Council: ", CouncilArea, 
                         '<br>', "Region: ", Regionname, 
                         '<br>', "# Rooms: ", Rooms,  " # Bathrooms: ", Bathroom,
                         '<br>', "Type", lapply(Type,residency.type)))
