#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {

    source("loadingdata.R")
    lon.center <- mean(df.mel$Longtitude)
    lat.center <- mean(df.mel$Lattitude)

    # convertType is the function
    # converting the Type string inputted
    # into the data.frame factor Type
    
    convertType <- reactive({
        if(input$type == "House Cottage Villa")
            return("h")
        else if(input$type == "Unit Duplex")
            return("u")
        else(input$type == "Town house")
        return("t")
    })
        
    m.dim <- reactive({
        if(input$region == "Select a Region"){
            -1
        }else
        {
            ttype <- convertType()
            rrooms <- as.integer(input$rooms)
            bbathrooms <- as.integer(input$barhrooms)
            if(input$region == "All")
            {
                df.mel <- df.mel[which(df.mel$Rooms == input$rooms &
                                           df.mel$Bathroom == input$barhrooms &
                                           df.mel$Type == ttype),]
                
            }else
            {
                df.mel <- df.mel[which(df.mel$Regionname == input$region &
                                 df.mel$Rooms == input$rooms &
                                 df.mel$Bathroom == input$barhrooms &
                                     df.mel$Type == ttype),]
            }
            dim(df.mel)[1]
        }
        })
    
    output$summary <- renderText({
        if(m.dim() == -1)
            "Please select a Region"
        else if(m.dim() == 0)
            paste("No Residencies match the selected criterias: ", convertType())
        else
            paste(m.dim(), " Matching Found ", convertType())
    })
    output$housesPlot <- renderPlotly({
        if(input$region == "Select a Region")
        {
            p <- plot_ly(df.mel, type = "scattermapbox") %>%
                layout(
                    mapbox = list(
                        style = 'open-street-map',
                        zoom =9.5,
                        center = list(lon = lon.center, 
                                      lat = lat.center))
                )    
        }
        else
            {
                
                # df.mel <- df.mel[df.mel$Regionname == input$region &
                #                      df.mel$Rooms == input$rooms &
                #                      df.mel$Bathroom == input$barhrooms,]
                ttype <- convertType()
                if(input$region == "All")
                {
                    df.mel <- df.mel[which(df.mel$Rooms == input$rooms &
                                            df.mel$Bathroom == input$barhrooms &
                                            df.mel$Type == ttype),]}
                else{
                    df.mel <- df.mel[which(df.mel$Regionname == input$region &
                                           df.mel$Rooms == input$rooms &
                                           df.mel$Bathroom == input$barhrooms &
                                           df.mel$Type == ttype),]
                                            }
                if(nrow(df.mel)!= 0)
                {
                p <- plot_ly(df.mel, type = "scattermapbox") %>%
                    add_trace(lat = filter(df.mel, PriceCategory == "low")$Lattitude,
                              lon = filter(df.mel, PriceCategory == "low")$Longtitude,
                              color = "Low Price",
                              marker = list(color = "darkgreen"),
                              hoverinfo = "text",
                              hovertext = filter(df.mel, PriceCategory == "low")$HoverText,
                              mode = "markers") %>%
                    add_trace(lat = filter(df.mel, PriceCategory == "medium low")$Lattitude,
                              lon = filter(df.mel, PriceCategory == "medium low")$Longtitude,
                              color = "Medium Low Price",
                              marker = list(color = "green"),
                              hoverinfo = "text",
                              hovertext = filter(df.mel, PriceCategory == "medium low")$HoverText,
                              mode = "markers") %>%
                    add_trace(lat = filter(df.mel, PriceCategory == "medium high")$Lattitude,
                              lon = filter(df.mel, PriceCategory == "medium high")$Longtitude,
                              color = "Medium High Price",
                              marker = list(color = "orange"),
                              hovertext = filter(df.mel, PriceCategory == "medium high")$HoverText,
                              hoverinfo = "text",
                              mode = "markers")%>%
                    add_trace(lat = filter(df.mel, PriceCategory == "high")$Lattitude,
                              lon = filter(df.mel, PriceCategory == "high")$Longtitude,
                              color = "High Price",
                              marker = list(color = "red"),
                              hovertext = filter(df.mel, PriceCategory == "high")$HoverText,
                              hoverinfo = "text",
                              mode = "markers")%>%
                    layout(
                        mapbox = list(
                            style = 'open-street-map',
                            zoom =9.5,
                            center = list(lon = lon.center, 
                                          lat = lat.center))
                    )
                } else 
                {
                    p <- plot_ly(df.mel, type = "scattermapbox") %>%
                        layout(
                            mapbox = list(
                                style = 'open-street-map',
                                zoom =9.5,
                                center = list(lon = lon.center, 
                                              lat = lat.center))
                        )    
                    
                }
            }
    })
    
    output$statsummary <- renderPlotly({
        if(input$region == "Select a Region")
        {
            p <- plot_ly(y = ~rnorm(0), type = "box")
        }else{
            ttype <- convertType()
            if(input$region == "All")
            {
                df.mel1 <- df.mel[which(df.mel$Rooms == input$rooms &
                                            df.mel$Bathroom == input$barhrooms &
                                            df.mel$Type == ttype),]    
            }else
                {
            df.mel1 <- df.mel[which(df.mel$Regionname == input$region &
                                       df.mel$Rooms == input$rooms &
                                       df.mel$Bathroom == input$barhrooms &
                                       df.mel$Type == ttype),]
            }
             p <- plot_ly(y = df.mel1$Price, type = "box")
        }
    })
    #    output$text1 <- renderText(input$region)
    # output$distPlot <- renderPlot({
    # 
    #     # generate bins based on input$bins from ui.R
    #     x    <- faithful[, 2]
    #     bins <- seq(min(x), max(x), length.out = input$bins + 1)
    # 
    #     # draw the histogram with the specified number of bins
    #     hist(x, breaks = bins, col = 'darkgray', border = 'white')
    # 
    # })

})
