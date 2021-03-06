#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(plotly)

# Define UI for application that draws a histogram
shinyUI(fluidPage(

    # Application title
    titlePanel("Melbourne House Prices"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            selectInput("rooms", "Number of Rooms",
                        choices = c("1","2","3","4","5","6","7 or more"),
                        selected = "3"),
            selectInput("barhrooms", "Number of Bathrooms: ",
                        choices = c("0","1","2","3","4 or more"),
                        selected = "1"),
            selectInput("type", "Type of Residency: ",
                        choices = c("House Cottage Villa", "Unit Duplex","Town house"),
                        selected = "House/Cottage/Villa"),
            selectInput("region",
                        "Select a region: ",
                        choices = c("Select a Region", 
                                    "Northern Metropolitan", 
                                    "Western Metropolitan", 
                                    "Southern Metropolitan", 
                                    "Eastern Metropolitan", 
                                    "South-Eastern Metropolitan", 
                                    "Eastern Victoria", 
                                    "Northern Victoria", 
                                    "Western Victoria",
                                    "All"),
                        selected = "Select a Region"
                        )#,
            # submitButton("Select")
            
        ),
        # Show a plot of the generated distribution
        mainPanel(
            plotlyOutput("housesPlot"),
            textOutput("summary"),
            plotlyOutput("statsummary")
            # fluidRow(
            #     splitLayout(cellWidths = c("50%", "50%"), plotOutput("plotgraph1"), plotOutput("plotgraph2"))
            # fluidRow(
            #     splitLayout(cellWidths = c("50%", "50%"), 
            #                 plotlyOutput("globalstat"), 
            #                 plotlyOutput("statsummary"))
            # )
        )
    )
))
