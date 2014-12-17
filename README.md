### Developing-Data-Products ui.R and Server.R  

CourseProject assignment in Developing Data Products class  
Michinori Masuda  

### Feature description  

##### This Shiny application(ui.R and Server.R) is designed to show how compulsory wearing of seat belts decreased fatal accidents in Great Britain. You can see time series plot(1969-1984) and amont of changes after law introduction(on 31 Jan 1983). This application consists of 4 pages selected by tab.  
See [Seatbelts dataset](http://stat.ethz.ch/R-manual/R-patched/library/datasets/html/UKDriverDeaths.html).  

#### Plot tab  
##### Plot page consists of two inputs, one plot and one statistic data.  
- Input1(bottom left) : Select one objective variable among 4 objective variables to show time series plot.  
- Input2(bottom center) : Select beginning year in machine learning period between 1969 and 1981 to predict objective variables after law introduction. Ending date of the period is fixed at 31 Jan 1983. Changing machine learning period is helpful to see the changes after law introduction because all the objective variables tends to be decreasing step-wise.  
- Plot(top) : According to selected two inputs, draw time series plot of survey data per 1000km drive(1969-1984) and predicted data per 1000km drive with -2se, +2se(1983 to 1984). Mean of the difference between survey data and predicted data during after law introduction is also show at bottom right in the plot. This plot immediately reacts with each input updates.  
- Statistic data(bottom right) : According to selected two inputs, show amount of changes after law introduction as ratio the difference between survey and prediction to prediction. These figures immediately react with each input updates.   

#### Model tab  
##### Model page shows prediction model and it's statistics. These figure immediately react with each input updates.   

#### Dataset tab  
##### Dataset page shows overview with reference source and relation between radio button name and Seatbelts dataset. Seatbelts dataset is also shown in this page.  

#### How to use tab  
##### This page.  


### Code description  

Shiny application consists of ui.R and Server.R.  
They should be located in the same directory to run.    

Server.R code is a litte bit tricky on reactive.  
To inform input updates to some processings in different rendering functions,use persistent variables(fit,z,afterlaw) among rendering functions and use input function even if the input variables are not directly used.I would like to study further this issue.

