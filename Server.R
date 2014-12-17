## Server.R
##              
## This code creates Shiny Server for Course Project in Developing Data Products.
## According to selected two inputs, run machine learing by AR model and 
## predict data after law introduction without introduction. 
## Then draw time series plot of survey data per 1000km drive(1969-1984) and 
## predicted data per 1000km drive with -2se, +2se(1983 to 1984). 
## Mean of the difference between survey data and predicted data during 
## after law introduction is also calculated.  
## These plot and mean figure are immediately react with input updates.
## This code also calculate mount of changes after law introduction 
## as ratio the difference between survey and prediction to prediction.
## And Markdown data is rendered to dataset tab and howtouse tab.
##
## preposition  : Shiny application consists of ui.R and Server.R
##              : They are located in the same directory to run.
##              :
## argument     : no arguments
##              :
## return       : no return
##              :
## remarks      : This code is a litte bit tricky on reactive.
##              : To inform input updates to some processings in different 
##              : rendering functions, use persistent variables(fit,z,afterlaw)
##              : among rendering functions and use input function 
##              : even if the input variables are not directly used. 
##              : I would like to study further this issue.
##              :
## author       : Michinori.Masuda
##              :

library(shiny)
# Rely on the 'Seatbelts' dataset in the datasets package
# (which generally comes preloaded).
library(datasets)

# Define a server for the Shiny app
shinyServer(function(input, output) {
    
    # Render a time series plot    
    output$CasualtiesPlot <- renderPlot({
        
        # Read designated objective variable from radioButton input
        # and set index to access designated column in 'Seatbelts'
        passenger <- input$rl 
        if (passenger == "Drivers killed") {
            index <- 1
        } else if (passenger == "Drivers killed or seriously injured") {
            index <- 2
        } else if (passenger == "Front-seat passengers killed or seriously injured") {
            index <- 3
        } else {               # means "Rear-seat passengers"
            index <- 4
        }
        # Read designated learning period from slider input
        period <- input$sl
        
        # Predict objective variable after law(Jan.31,1983) by learning in the designated period
        # objective variable is divided by 1000 kms
        # Use simple AutoRegressive model ARIMA(1,0,0) among ARIMA models
        beforelaw <- window((Seatbelts[,index]/Seatbelts[,5]*1000), start=period,end = 1983)
        fit <<- arima(beforelaw, c(1, 0, 0), seasonal = list(order = c(1, 0, 0))) # write persistent variable to share it with renderPrint() 
        z <<- predict(fit, n.ahead = 23) # write persistent variable to share it with renderPrint() 
        
        # Create ts plot of survey data and predicted data with -2se, +2se
        whole <- window((Seatbelts[,index]/Seatbelts[,5]*1000), start=period)
        ts.plot(whole, z$pred, z$pred+2*z$se, z$pred-2*z$se,
                lty = c(1, 3, 2, 2), col = c("black", "red", "blue", "blue"))
        
        # Add title and legend
        title(paste(passenger,"( per 1000km drive)"))
        legend("bottomleft", legend = c("survey","prediction","prediction-2se/+2se"), 
               col = c("black", "red", "blue"), lty =c(1, 3, 2) )
        
        # Add abline to show law introduction date(Jan.31,1983)
        abline(v=1983+1/12,lwd=3,lty="dotted",col="red")
        
        # Calculate the difference between survey and prediction 
        afterlaw <<- window((Seatbelts[,index]/Seatbelts[,5]*1000), start=1983+1/12) # write persistent variable to share it with renderPrint() 
        difference <- afterlaw - z$pred    
        text(1984,min(afterlaw,(z$pred-2*z$se)),
             paste("mean difference = ",sprintf("%.2f", mean(difference))))       
    })
    
    # Render the difference between survey and prediction
    # Read persistent variables in renderPlot()
    output$vld <- renderPrint({
        dummy_period <- input$sl      ## dummy reactive to update  
        dummy_passenger <- input$rl   ## dummy reactive to update
        
        # calculate the difference 
        diff <- (afterlaw - z$pred)/z$pred ## persistent variables
        print(paste("mean = ",sprintf("%.2f", mean(diff))))
        print(paste("sd   = ",sprintf("%.2f", sd(diff))))
    })
    
    # Render prediction model  
    output$vlm <- renderPrint({
        dummy_period <- input$sl      ## dummy reactive to update  
        dummy_passenger <- input$rl   ## dummy reactive to update
        print(fit)  ## persistent variables
    })    
    
    # Render Seatbelts raw dataset  
    output$vlr <- renderPrint({
        print(Seatbelts)
    })    
})