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
    source("coption.R")
    
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
        else if(input$type == "Town house")
            return("t")
        return("All")
    })

    # Compute data.frame dimension 
    # based on the Selected Region        
    
    m.dimAll <- reactive({
        ttype <- c.option(convertType(), 
                          unique(as.character(df.mel$Type))) 
        rrooms <- c.option(input$rooms, 
                           unique(df.mel$Rooms))
        bbathrooms <- c.option(input$barhrooms,
                               unique(df.mel$Bathroom))
        
        n.res <- dim(df.mel[which(df.mel$Rooms %in% rrooms &
                                      df.mel$Bathroom %in% bbathrooms &
                                      df.mel$Type %in% ttype),])[1]
        
        return(n.res)
    })
    
    m.dim <- reactive({
        if(input$region == "Select a Region"){
            -1
        }else
        {
            ttype <- c.option(convertType(), 
                              unique(as.character(df.mel$Type))) 
            rrooms <- c.option(input$rooms, 
                               unique(df.mel$Rooms))
            bbathrooms <- c.option(input$barhrooms,
                                   unique(df.mel$Bathroom))
            
            if(input$region == "All")
            {
                df.mel <- df.mel[which(df.mel$Rooms %in% rrooms &
                                           df.mel$Bathroom %in% bbathrooms &
                                           df.mel$Type %in% ttype),]
                
            }else
            {
                df.mel <- df.mel[which(df.mel$Regionname == input$region &
                                           df.mel$Rooms %in% rrooms &
                                           df.mel$Bathroom %in% bbathrooms &
                                           df.mel$Type %in% ttype),]
            }            
            dim(df.mel)[1]
        }
        })
    
    # Compute data.frame based on 
    # Imputted Parameters
    
    computeDF <- reactive({
        ttype <- c.option(convertType(), 
                          unique(as.character(df.mel$Type))) 
        rrooms <- c.option(input$rooms, 
                           unique(df.mel$Rooms))
        bbathrooms <- c.option(input$barhrooms,
                               unique(df.mel$Bathroom))
        
        if(input$region == "All")
            {
            df.mel <- df.mel[which(df.mel$Rooms %in% rrooms &
                                       df.mel$Bathroom %in% bbathrooms &
                                       df.mel$Type %in% ttype),]
            }else
            {
                df.mel <- df.mel[which(df.mel$Regionname == input$region &
                                           df.mel$Rooms %in% rrooms &
                                           df.mel$Bathroom %in% bbathrooms &
                                           df.mel$Type %in% ttype),]
            }
            df.mel

    })
    
    compute.meanAll <- reactive({
        ttype <- c.option(convertType(), 
                          unique(as.character(df.mel$Type))) 
        rrooms <- c.option(input$rooms, 
                           unique(df.mel$Rooms))
        bbathrooms <- c.option(input$barhrooms,
                               unique(df.mel$Bathroom))
        
        round(mean(df.mel[which(df.mel$Rooms %in% rrooms &
                                    df.mel$Bathroom %in% bbathrooms &
                                    df.mel$Type %in% ttype),]$Price))    })

    compute.sdAll <- reactive({
        ttype <- c.option(convertType(), 
                          unique(as.character(df.mel$Type))) 
        rrooms <- c.option(input$rooms, 
                           unique(df.mel$Rooms))
        bbathrooms <- c.option(input$barhrooms,
                               unique(df.mel$Bathroom))
        
        round(mean(df.mel[which(df.mel$Rooms %in% rrooms &
                                    df.mel$Bathroom %in% bbathrooms &
                                    df.mel$Type %in% ttype),]$Price))
        })
    
    compute.meanRegion <- reactive({
        ttype <- c.option(convertType(), 
                          unique(as.character(df.mel$Type))) 
        rrooms <- c.option(input$rooms, 
                           unique(df.mel$Rooms))
        bbathrooms <- c.option(input$barhrooms,
                               unique(df.mel$Bathroom))
        
        round(mean(df.mel[which(df.mel$Rooms %in% rrooms &
                                    df.mel$Bathroom %in% bbathrooms &
                                    df.mel$Type %in% ttype),]$Price))
        })
    
    compute.sdRegion <- reactive({
        ttype <- c.option(convertType(), 
                          unique(as.character(df.mel$Type))) 
        rrooms <- c.option(input$rooms, 
                           unique(df.mel$Rooms))
        bbathrooms <- c.option(input$barhrooms,
                               unique(df.mel$Bathroom))
        
        round(sd(df.mel[which(df.mel$Rooms %in% rrooms &
                                  df.mel$Bathroom %in% bbathrooms &
                                  df.mel$Type %in% ttype),]$Price))
        })
    
    output$outWelcome <- renderText("Welcome to the App")
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
                ttype <- c.option(convertType(), 
                                  unique(as.character(df.mel$Type))) 
                rrooms <- c.option(input$rooms, 
                                   unique(df.mel$Rooms))
                bbathrooms <- c.option(input$barhrooms,
                                       unique(df.mel$Bathroom))

                if(input$region == "All")
                {
                    df.mel <- df.mel[which(df.mel$Rooms %in% rrooms &
                                               df.mel$Bathroom %in% bbathrooms &
                                               df.mel$Type %in% ttype),]}
                else{
                    df.mel <- df.mel[which(df.mel$Regionname == input$region &
                                               df.mel$Rooms %in% rrooms &
                                               df.mel$Bathroom %in% bbathrooms &
                                               df.mel$Type %in% ttype),]
                    }
                
                if(nrow(df.mel)!= 0)
                {
                p <- plot_ly(df.mel, type = "scattermapbox") %>%
                    add_trace(lat = filter(df.mel, PriceCategory == "low")$Lattitude,
                              lon = filter(df.mel, PriceCategory == "low")$Longtitude,
                              color = paste("<b>Low Price</b>","<br> < 660k"),
                              marker = list(color = "darkgreen"),
                              hoverinfo = "text",
                              hovertext = filter(df.mel, PriceCategory == "low")$HoverText,
                              mode = "markers") %>%
                    add_trace(lat = filter(df.mel, PriceCategory == "medium low")$Lattitude,
                              lon = filter(df.mel, PriceCategory == "medium low")$Longtitude,
                              color = paste("<b>Medium Low Price</b>", "<br> 660k - 910k"),
                              marker = list(color = "green"),
                              hoverinfo = "text",
                              hovertext = filter(df.mel, PriceCategory == "medium low")$HoverText,
                              mode = "markers") %>%
                    add_trace(lat = filter(df.mel, PriceCategory == "medium high")$Lattitude,
                              lon = filter(df.mel, PriceCategory == "medium high")$Longtitude,
                              color = paste("<b>Medium High Price</b>","<br> 910K - 1.33M"),
                              marker = list(color = "orange"),
                              hovertext = filter(df.mel, PriceCategory == "medium high")$HoverText,
                              hoverinfo = "text",
                              mode = "markers")%>%
                    add_trace(lat = filter(df.mel, PriceCategory == "high")$Lattitude,
                              lon = filter(df.mel, PriceCategory == "high")$Longtitude,
                              color = paste("<b>High Price</b>","<br> > 1.33M"),
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
        ttype <- c.option(convertType(), 
                          unique(as.character(df.mel$Type))) 
        rrooms <- c.option(input$rooms, 
                           unique(df.mel$Rooms))
        bbathrooms <- c.option(input$barhrooms,
                               unique(df.mel$Bathroom))
        
        df.mel1 <- df.mel[which(df.mel$Rooms %in% rrooms &
                                    df.mel$Bathroom %in% bbathrooms &
                                    df.mel$Type %in% ttype ),]   
        p <- plot_ly(y = df.mel1$Price, type = "box")
        })
    
    output$statsummary <- renderPlotly({
        ttype <- c.option(convertType(), 
                          unique(as.character(df.mel$Type))) 
        rrooms <- c.option(input$rooms, 
                           unique(df.mel$Rooms))
        bbathrooms <- c.option(input$barhrooms,
                               unique(df.mel$Bathroom))
        
        df.mel1 <- df.mel[which(df.mel$Rooms %in% rrooms &
                                    df.mel$Bathroom %in% bbathrooms &
                                    df.mel$Type %in% ttype ),]   
        
        if (input$region == "All")
        {
            df.mel2 <- df.mel[which(df.mel$Rooms %in% rrooms &
                                        df.mel$Bathroom %in% bbathrooms &
                                        df.mel$Type %in% ttype ),]   
        }else
        {
            df.mel2 <- df.mel[which(df.mel$Rooms %in% rrooms &
                                        df.mel$Bathroom %in% bbathrooms &
                                        df.mel$Type %in% ttype  &
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
