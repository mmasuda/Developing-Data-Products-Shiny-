## ui.R
##              
## This code creates Shiny ui for Course Project in Developing Data Products.
## This ui consistes of 4 pages with navbar tab. The main plot page has 
## two inputs,one plot and one text output. These two outputs immediately react 
## with input updates by Server code.
##
## preposition  : Shiny application consists of ui.R and Server.R
##              : They are located in the same directory to run.
##              :
## argument     : no arguments
##              :
## return       : no return
##              :
## author       : Michinori.Masuda
##

library(shiny)
# Rely on the 'Seatbelts' dataset in the datasets package 
# (which generally comes preloaded).
library(datasets)
library(markdown)

# Define the overall UI, use a NavBar Layout
shinyUI(navbarPage(strong("Road Casualties in Great Britain 1969-84"),inverse = TRUE,windowTitle = "Seatbelts",
                   tabPanel(strong("Plot"),
                            fluidPage(
                                # Create a time series plot
                                fluidRow(plotOutput("CasualtiesPlot")),
                                # Generate a row with a radioButtons, a sidebar and a verbatimTextOutput
                                fluidRow(
                                    # radioButtons for selecting an objective variable from 'Seatbels' dataset
                                    column(5,wellPanel(
                                        radioButtons("rl",strong("which objective variable?"), c("Drivers killed","Drivers killed or seriously injured","Front-seat passengers killed or seriously injured","Rear-seat passengers killed or seriously injured"))
                                    )),
                                    # a slider bar for selecting learning period
                                    column(3,wellPanel(
                                        sliderInput("sl",strong("period for learning"),min=1969,max=1981,value=1969,step=1)
                                    )),
                                    # verbatimTextOutput to show the effect of Compulsory wearing of seat belts
                                    column(4,wellPanel(
                                        h5("ratio the difference between survey and prediction to prediction"),
                                        verbatimTextOutput("vld")
                                    ))
                                )
                            )
                   ),
                   tabPanel(strong("Model"),
                            fluidRow(
                                column(10,offset = 1,wellPanel(
                                    h5("Regression model : simple AutoRegressive model"),
                                    verbatimTextOutput("vlm")
                                ))
                            )
                   ),
                   tabPanel(strong("Dataset"),
                            fluidRow(
                                column(9,offset = 1,includeMarkdown("datasets.md"),
                                       br()
                                )
                            ),
                            fluidRow(
                                column(9,offset = 1,wellPanel(
                                    h5("Seatbelts Raw dataset"),
                                    verbatimTextOutput("vlr")
                                )
                                ))
                   ),
                   tabPanel(strong("How to use"),
                            fluidRow(
                                column(9,offset = 1,includeMarkdown("howtouse.md"),
                                       br()
                                )
                            )
                   )
))
