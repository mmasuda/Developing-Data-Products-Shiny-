### Developing-Data-Products ui.R and Server.R  

Course Project assignment in Developing Data Products class  
Masuda Michinori  

### Feature   

##### This Shiny application is designed to show visualy and interactively how effective compulsory wearing of seat belts decreased fatal accidents in Great Britain. You can see time series plot(1969-1984) and changes after law introduction(on 31 Jan 1983). This application consists of 4 pages selected by tab. 

#### Plot tab  
##### Plot page consists of two inputs, one plot and one statistic data.
- Input1(bottom left) : Select one number among 4 objective variables to show time series plot.  
- Input2(bottom center) : Select beginning year in machine learning period between 1969 and 1981 to predict objective variables after law introduction. Ending date of the period is fixed at 31 Jan 1983. Changing machine learning period is helpful to see the changes after law introduction because all the objective variables tends to be decreasing step-wise and it effects on prediction.
You may remarkably see the changes in Drivers killed and Rear-seat passengers.
- Plot(top) : According to selected two inputs, draw time series plot of survey data per 1000km drive(1969-1984) and predicted data per 1000km drive with -2se, +2se(1983 to 1984). Mean of the difference between survey data and predicted data during law introduction is also shown at bottom right in the plot. This plot immediately reacts with each input updates.  
- Statistic data(bottom right) : According to selected two inputs, show amount of changes after law introduction as ratio of the difference between survey and prediction to prediction. You may see these two values to calculate the ratio in the Plot. These figures immediately react with each input updates.  

#### Model tab  
##### Model page shows machine learning model and it's evaluation. This figure immediately react with each input updates.   

#### Dataset tab  
##### Dataset page shows overview with reference source, relation between radio button name and Seatbelts dataset. Seatbelts dataset is also shown in this page.  

#### How to use tab  
##### Explain how to use this Shiny application. 


### Code description  

Shiny application consists of ui.R and Server.R.  
They should be located in the same directory to run.    

