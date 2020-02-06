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

shinyUI(fluidPage(

    # Application title
    titlePanel("Melbourne House Prices"),
    fluidRow(
        column(3,
               h4("Number of Rooms"),
               br(),
               selectInput("rooms", "Number of Bedrooms",
                           choices = c("1","2","3","4","5","6","7", "8", "10", "12"),
                           selected = "3"),
               selectInput("barhrooms", "Number of Bathrooms: ",
                           choices = c("0","1","2","3","4","5","6","7","8"),
                           selected = "1")),
        column(3,
               h4("Parameters"),
               br(),
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
               )
        ),
        column(3,
               h4("Summary Data per Region"),
               htmlOutput("summary")),
        column(3,
               h4("Summary Data per Type (All Region)"),
               htmlOutput("summaryType"))
        
    ),
    br(),
    fluidRow(
        column(8,
               plotlyOutput("housesPlot")),
        column(4,
               plotlyOutput("statsummary"))
    ),
    br(),
))
