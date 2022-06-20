library(ggplot2)
library(dplyr)
source('helperFunctions.R')

chartData <- getAisleDataByDepartment('dairy eggs')

ggplot(chartData,aes(reorder(aisle,no_of_orders, decreasing = T), no_of_orders))+
    geom_bar(stat='identity')+
    scale_x_discrete(label=abbreviate)+
    geom_col(aes(fill = no_of_orders)) + 
    scale_fill_gradient2(low = "powderblue", 
                         high = "#2a5783") + 
    labs(x = "Aisle")
