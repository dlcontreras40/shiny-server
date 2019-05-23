#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shinydashboard)
library(leaflet)
#library(shiny.semantic)
#library(semantic.dashboard)
#library(plotly)
#library(DT)

dashboardPage(
    dashboardHeader(title = "Allegheny County"),
    dashboardSidebar(sidebarMenu(
        menuItem("Business Patterns", tabName = "ZCBP", icon = icon("business-time")),
        menuItem("Sociodemographic Variables", tabName = "Socio", icon =icon("users")),
        menuItem("Skills on demand", tabName = "Skills", icon = icon("file")),
        menuItem("Occupation and Industries", tabName = "Occupation", icon = icon("city"))
        
    )),
    dashboardBody(
        tabItems(
        tabItem(tabName = "ZCBP",
                leafletOutput("Plot", height = 700),
                absolutePanel(id="controls", class="panel panel-default", fixed = TRUE,
                              draggable = TRUE, top = 60, left = "auto", right = 20,
                              bottom = "auto", width = 330, height = "auto",
                              h2("Business Pattern Explorer"),
                              sliderInput(inputId = "year",
                                label = "Select the year to plot:",
                                value = 1, min = 2013, max = 2016),
                              selectInput(inputId = "industry_code", "Select the Industry:", choices = c(
                                                                       "11. Agriculture, Forestry, Fishing and Hunting",
                                                                       "21. Mining",
                                                                       "22. Utilities",
                                                                       "23. Construction",
                                                                       "42. Wholesale Trade",
                                                                       "51. Information",
                                                                       "52. Finance and Insurance",
                                                                       "53. Real State Rental and Leasing",
                                                                       "54. Professional, Scientific, and Technical Services",
                                                                       "55. Management of Companies and Enterprises",
                                                                       "56. Administrative and Support",
                                                                       "61. Educational Services",
                                                                       "62. Health Care and Social Assistance",
                                                                       "71. Arts, Entertainment, and Recreation",
                                                                       "72. Accomodation and Food Services",
                                                                       "81. Other Services",
                                                                       "92. Public Administration")
                              ),
                              plotOutput("Plot2", height = 200))),
        tabItem(
            tabName = "Socio",
            fluidRow(
                box(
                    title = "Select the year to plot",
                    status = "warning",
                    solidHeader = TRUE,
                    color="red",
                    sliderInput(inputId = "year2",
                                label = "Select the year to plot:",
                                value = 1, min = 2011, max = 2017)),
                fluidRow(
                    box(
                        title = "Select the demographic variable to plot",
                        status = "warning",
                        solidHeader = TRUE,
                        
                    style="width:350%",
                                 selectInput(inputId = "socio", "Select the Variable:", choices = c(
                                     "Population",
                                     "Sex",
                                     "Education",
                                     "Poverty")
                                 ) ,
                    conditionalPanel(
                        condition="input.socio=='Education'",
                        selectInput(
                            inputId="education", "Select the education variable to plot:", 
                            choices = c("Less than 24 years:No high school",
                                        "Less than 24 years:High School",
                                        "Less than 24 years:Some College",
                                        "Less than 24 years:Bachelor",
                                        "Older than 25 years:Less than 9th grade",
                                        "Older than 25 years:9th to 12th",
                                        "Older than 25 years:high school",
                                        "Older than 25 years:some college, no degree",
                                        "Older than 25 years:associate degree",
                                        "Older than 25 years:bachelor degree",
                                        "Older than 25 years:graduate degree"
                                        )
                        )
                    ),
                    
                    conditionalPanel(
                        condition="input.socio=='Sex'",
                        selectInput(
                            inputId="sex", "Select the gender to plot:", 
                            choices = c("Male", "Female")
                        ) 
                        
                    )
                    
                    ))),
            fluidRow(column(10, offset=2,align="center",
                box(title = "Map of the variable chosen",
                    status = "primary",
                    width = 8,
                    solidHeader = TRUE,
                    plotOutput("plotsocio", height = 400),
                    helpText("Source: Zip Code Business Patterns. Census Bureau. 2019.")
                    ))
                    
                
                )
            )
            
            
            ),
        
        tabItem(
            tabName = "Skills"
            
        ),
        
        tabItem(
            tabName = "Occupation"
            
        )
        
        
        
        ))




# 
# fluidRow(
#     box(
#         title="Map of the Zip Code Business Patterns: Years and Industry",
#         color="blue",
#         status = "primary",
#         solidHeader = TRUE,
#         leafletOutput("Plot"),
#         textOutput("headerOne", container = span), 
#         helpText("Source: Zip Code Business Patterns. Census Bureau. 2019.")),
#     box(
#         title="Evolution of the number of establishments for the selected industry",
#         plotOutput("Plot2", height = 400), 
#         helpText("Source: Zip Code Business Patterns. Census Bureau. 2019."),
#         solidHeader = TRUE,
#         status = "primary")),
# 
# fluidRow(column(12,offset=3,
#                 box(
#                     title = "Zip Code Business Patterns: Years and Industry.",
#                     status = "warning",
#                     solidHeader = TRUE,
#                     color="red",
#                     sliderInput(inputId = "year",
#                                 label = "Select the year to plot:",
#                                 value = 1, min = 2013, max = 2016),
#                     sidebarPanel(style="width:330%",
#                                  selectInput(inputId = "industry_code", "Select the Industry:", choices = c(
#                                      "11. Agriculture, Forestry, Fishing and Hunting",
#                                      "21. Mining",
#                                      "22. Utilities",
#                                      "23. Construction",
#                                      "42. Wholesale Trade",
#                                      "51. Information",
#                                      "52. Finance and Insurance",
#                                      "53. Real State Rental and Leasing",
#                                      "54. Professional, Scientific, and Technical Services",
#                                      "55. Management of Companies and Enterprises",
#                                      "56. Administrative and Support",
#                                      "61. Educational Services",
#                                      "62. Health Care and Social Assistance",
#                                      "71. Arts, Entertainment, and Recreation",
#                                      "72. Accomodation and Food Services",
#                                      "81. Other Services",
#                                      "92. Public Administration")
#                                  ) )))) 
