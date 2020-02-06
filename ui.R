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
    
    fluidPage(
        tabsetPanel(
            tabPanel("Welcome Page", fluid = TRUE,
                     #mainPanel(
                     br(),
                     h1(" Melbourne Price Map Application"),
                     br(),
                     h3(" Check what is the average price of the house house you are searching for in Melbourne"),
                     h3(" Go to the Map tab, select the number of Rooms and Bathroom, the type of house and the Melborne district
                            and it will displayed how many houses matches your criteria and what are the prices"),
                     h3(" You can also see the comparison of the average price of your selected distric and overall in Melbourn"),
                     br()
                     #textOutput("outWelcome")
                     #   )
            ),
            tabPanel("Map", fluir = TRUE,
                     fluidRow(
                         column(
                             3,
                             h4("Number of Rooms"),
                             h5(" bedrooms and bathrooms"),
                             hr(),
                             selectInput(
                                 "rooms",
                                 "Number of Bedrooms",
                                 choices = c("1", "2", "3", "4", "5", "6", "7", "8", "10", "12"),
                                 selected = "3"
                             ),
                             selectInput(
                                 "barhrooms",
                                 "Number of Bathrooms: ",
                                 choices = c("0", "1", "2", "3", "4", "5", "6", "7", "8"),
                                 selected = "1"
                             )
                         ),
                         column(
                             3,
                             h4("Parameters"),
                             h5(" Type and city Region "),
                             hr(),
                             selectInput(
                                 "type",
                                 "Type of Residency: ",
                                 choices = c("House Cottage Villa", "Unit Duplex", "Town house"),
                                 selected = "House/Cottage/Villa"
                             ),
                             selectInput(
                                 "region",
                                 "Select a region: ",
                                 choices = c(
                                     "Select a Region",
                                     "Northern Metropolitan",
                                     "Western Metropolitan",
                                     "Southern Metropolitan",
                                     "Eastern Metropolitan",
                                     "South-Eastern Metropolitan",
                                     "Eastern Victoria",
                                     "Northern Victoria",
                                     "Western Victoria",
                                     "All"
                                 ),
                                 selected = "Select a Region"
                             )
                         ),
                         column(
                             3,
                             h4("Summary Data"),
                             h5("per Region"),
                             hr(),
                             htmlOutput("summary")
                         ),
                         column(3,
                                HTML(paste(
                                    h4("Summary Data"), h5("All Region")
                                )),
                                hr(),
                                htmlOutput("summaryType"))
                         
                     ),
                     br(),
                     fluidRow(column(8,
                                     plotlyOutput("housesPlot")),
                              column(4,
                                     plotlyOutput("statsummary"))),
                     br())
        )
    )
)
)
