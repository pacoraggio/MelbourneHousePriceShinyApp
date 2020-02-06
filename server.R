#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

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

    # Compute data.frame dimension 
    # based on the Selected Region        
    
    m.dimAll <- reactive({
        
        # file <- "./Data/output.txt"
        
        n.res <- dim(df.mel[which(df.mel$Rooms == input$rooms &
                         df.mel$Bathroom == input$barhrooms &
                         df.mel$Type == convertType()),])[1]

        # if(!file.exists("./Data/output.txt"))
        # {
        #     file.create("./Data/output.txt")
        #     write("file created", file = file, append = TRUE)
        # }else
        # {
        #     write(paste("# Rooms", input$rooms, 
        #                 "# Bathroom: ", input$barhrooms, 
        #                 "Type:", convertType(),
        #                 "nrows: ", dim(df.mel[which(df.mel$Rooms == input$rooms &
        #                                                 df.mel$Bathroom == input$barhrooms &
        #                                                 df.mel$Type == convertType()),])[1]), file = file, append = TRUE)
        # }
        return(n.res)
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
    
    # Compute data.frame based on 
    # Imputted Parameters
    
    computeDF <- reactive({
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
            df.mel

    })
    
    compute.meanAll <- reactive({
            round(mean(df.mel[which(df.mel$Rooms == input$rooms &
                             df.mel$Bathroom == input$barhrooms &
                             df.mel$Type == convertType()),]$Price))
    })

    compute.sdAll <- reactive({
        round(sd(df.mel[which(df.mel$Rooms == input$rooms &
                                    df.mel$Bathroom == input$barhrooms &
                                    df.mel$Type == convertType()),]$Price))
    })
    
    compute.meanRegion <- reactive({
        round(mean(df.mel[which(df.mel$Rooms == input$rooms &
                                    df.mel$Bathroom == input$barhrooms &
                                    df.mel$Type == convertType() &
                                    df.mel$Regionname == input$region),]$Price))
    })
    
    compute.sdRegion <- reactive({
        round(sd(df.mel[which(df.mel$Rooms == input$rooms &
                                    df.mel$Bathroom == input$barhrooms &
                                    df.mel$Type == convertType() &
                                    df.mel$Regionname == input$region),]$Price))
    })
    
    # Outputting brief summary of the data
    output$summary <- renderUI({
            if(m.dim() == -1)
                HTML("Please select a Region")
            else if(m.dim() == 0)
                HTML("No Residencies match the selected criterias: ")
            else
            {
                str1 <- paste(m.dim(), " Matching Found in Selected Region with")
                str2 <- paste("Mean Price: ", round(mean(computeDF()$Price),0))
                str3 <- paste("Standard Deviation: ", round(sd(computeDF()$Price),0))
                HTML(paste(str1, str2, str3, sep = '<br/>'))
            }
        
    })
    
    # Outputting brief summary of the data
    output$summaryType <- renderUI({
        if(m.dimAll() == 0)
            HTML("No Residencies match the selected criterias: ")
        else
        {
            str1 <- paste(m.dimAll(), " Matching Found For this type with")
            str2 <- paste("Mean Price: ", compute.meanAll())
            str3 <- paste("Standard Deviation: ", compute.sdAll())
            HTML(paste(str1, str2, str3, sep = '<br/>'))
        }
    })
    

        output$summary <- renderUI({
        if(m.dim() == -1)
            HTML("Please select a Region")
        else if(m.dim() == 0)
            HTML("No Residencies match the selected criterias: ")
        else
        {
            str1 <- paste(m.dim(), " Matching Found in Selected Region with")
            str2 <- paste("Mean Price: ", round(mean(computeDF()$Price),0))
            str3 <- paste("Standard Deviation: ", round(sd(computeDF()$Price),0))
            HTML(paste(str1, str2, str3, sep = '<br/>'))
        }
        
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
                            center = list(lon = mean(df.mel$Longtitude), 
                                          lat = mean(df.mel$Lattitude)))
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
    
    output$globalstat <- renderPlotly({
        ttype <- convertType()
        df.mel1 <- df.mel[which(df.mel$Rooms == input$rooms &
                                    df.mel$Bathroom == input$barhrooms &
                                    df.mel$Type == ttype),]   
        p <- plot_ly(y = df.mel1$Price, type = "box")
        })
    
    output$statsummary <- renderPlotly({
        ttype <- convertType()
        df.mel1 <- df.mel[which(df.mel$Rooms == input$rooms &
                                    df.mel$Bathroom == input$barhrooms &
                                    df.mel$Type == ttype),]   

        if (input$region == "All")
        {
            df.mel2 <- df.mel[which(df.mel$Rooms == input$rooms &
                                        df.mel$Bathroom == input$barhrooms &
                                        df.mel$Type == ttype),]   
        }else
        {
            df.mel2 <- df.mel[which(df.mel$Rooms == input$rooms &
                                        df.mel$Bathroom == input$barhrooms &
                                        df.mel$Type == ttype &
                                        df.mel$Regionname == input$region),]   
        }
        
        y <- list(
            title = "Residency Price"
        )
        
        p <- plot_ly(y = ~df.mel2$Price, 
                     type = "box",
                     name = input$region) %>%
            add_trace(y = ~df.mel1$Price,
                      name = "All region") %>%
            layout(yaxis = y)
        
        p    
        })
})
