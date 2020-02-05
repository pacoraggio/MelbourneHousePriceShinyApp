## Plotly an Empty map of Melbourne

rm(list = ls())
library(plotly)

source("loadingdata.R")

names(df.mel)
median(df.mel$Lattitude); median(df.mel$Longtitude)

plot_ly(df.mel, type = "scattermapbox") %>%
    layout(
        mapbox = list(
            style = 'open-street-map',
            zoom =9.5,
            center = list(lon = mean(df.mel$Longtitude), 
                          lat = mean(df.mel$Lattitude)))
    )
    