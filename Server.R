## Server.R
##              
## This code creates a Shiny Server for Course Project in Developing Data Products.
## According to selected two inputs, run machine learing by AR model and 
## predict data without law introduction. 
## Then draw time series plot of survey data per 1000km drive(1969-1984) and 
## predicted data per 1000km drive with -2se, +2se(1983 to 1984). 
## Mean of the difference between survey data and predicted data during 
## law introduction is also calculated.  
## These plots and mean figure are immediately react with input updates.
## This code also calculate ratio of the difference between survey and prediction 
## to prediction as mount of changes by law introduction.
## And explanatory Markdown data is rendered to dataset tab and howtouse tab.
##
## preposition  : Shiny application consists of ui.R and Server.R
##              : They are located in the same directory to run.
## argument     : no arguments
## return       : no return
## author       : Masuda.Michinori

library(shiny)
library(datasets)   # 'Seatbelts' dataset (generally preloaded)

# Define a server for the Shiny app
shinyServer(function(input, output) {
    
    # Read designated objective variable from radioButton input and set reactive
    passenger <- reactive({input$rl}) 
    
    # Read designated learning period from slider input and set reactive 
    period <- reactive({input$sl})
    
    # common function makeindex 
    # make index to select colum in Seatbelts from radioButton input character
    # argument x: may be passenger()
    # return index
    makeindex <- function(x) {
        i <- switch(x,
                    "Drivers killed" = 1,
                    "Drivers killed or seriously injured" = 2,
                    "Front-seat passengers killed or seriously injured" = 3,
                    "Rear-seat passengers killed or seriously injured" = 4)
        return(i)  
    }
    
    # common function makestats
    # calculate prediction model and ratio of the difference between survey and prediction 
    # to prediction
    # argument x: may be index, y: may be period(), Seatbelts(shared implicitly)
    # return list(fit,ratiodiff)
    makestats <- function(x,y){
        beforelaw <- window((Seatbelts[,x]/Seatbelts[,5]*1000), start=y,end = 1983)
        afterlaw <- window((Seatbelts[,x]/Seatbelts[,5]*1000), start=1983+1/12) 
        fit <- arima(beforelaw, c(1, 0, 0), seasonal = list(order = c(1, 0, 0))) 
        z <- predict(fit, n.ahead = 23) 
        ratiodiff <- (afterlaw - z$pred)/z$pred  
        return(list(fit,ratiodiff))
    }
    
    # Render a time series plot
    output$CasualtiesPlot <- renderPlot({
        
        # Read designated objective variable from radioButton input
        # and set index to access designated column in 'Seatbelts'
        index <- makeindex(passenger())
        
        # Predict objective variable after law(Jan.31,1983) by learning in the designated period
        # objective variable is divided by 1000 kms
        # Use simple AutoRegressive model ARIMA(1,0,0) among ARIMA models
        beforelaw <- window((Seatbelts[,index]/Seatbelts[,5]*1000), start=period(),end = 1983)
        fit <- arima(beforelaw, c(1, 0, 0), seasonal = list(order = c(1, 0, 0))) 
        z <- predict(fit, n.ahead = 23) 
        
        # Create ts plot of survey data and predicted data with -2se, +2se
        whole <- window((Seatbelts[,index]/Seatbelts[,5]*1000), start=period())
        ts.plot(whole, z$pred, z$pred+2*z$se, z$pred-2*z$se,
                lty = c(1, 3, 2, 2), col = c("black", "red", "blue", "blue"))
        
        # Add title and legend
        title(paste(passenger(),"( per 1000km drive)"))
        legend("bottomleft", legend = c("survey","prediction","prediction-2se/+2se"), 
               col = c("black", "red", "blue"), lty =c(1, 3, 2) )
        
        # Add a line to show law introduction date(Jan.31,1983)
        abline(v=1983+1/12,lwd=3,lty="dotted",col="red")
        
        # Calculate the difference between survey and prediction 
        afterlaw <- window((Seatbelts[,index]/Seatbelts[,5]*1000), start=1983+1/12) 
        difference <- afterlaw - z$pred
        text(1984,max(afterlaw,(z$pred+2*z$se)),
            paste("mean difference = ",sprintf("%.2f", mean(difference)))
            )
        text(1984,mean(z$pred),
            paste("mean prediction = ",sprintf("%.2f", mean(z$pred)))
            )
    })
    
    # Render the difference between survey and prediction
    output$vld <- renderPrint({
                
        # Read designated objective variable from radioButton input
        # and set index to access designated column in 'Seatbelts'
        index <- makeindex(passenger())
                
        # Calculate the difference between survey and prediction  
        ratiodiff <- makestats(index,period())[[2]]
        print(paste("mean = ",sprintf("%.2f", mean(ratiodiff))))
        print(paste("sd   = ",sprintf("%.2f", sd(ratiodiff))))
    })
    
    # Render prediction model  
     output$vlm <- renderPrint({
        
        # Read designated objective variable from radioButton input
        # and set index to access designated column in 'Seatbelts'
        index <- makeindex(passenger())

        # eveluate simple AutoRegressive model 
        print(makestats(index,period())[[1]])  
    })    
    
    # Render Seatbelts raw dataset  
    output$vlr <- renderPrint({
        print(Seatbelts)
    })    
})