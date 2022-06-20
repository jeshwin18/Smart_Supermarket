# This file contains functions for operations in different files.

#load dataset
getOrders <- function(){
    results <- dbGetQuery(connection, 'select * from orders')
    return(results)
}

#Load data seggregated by departments
getAisleDataByDepartment <- function(department){
    
    query <- paste0('select aisle, count(order_id) as no_of_orders from orders where department = "',department,'" group by aisle order by no_of_orders desc')
    results <- dbGetQuery(connection, query)
    return(results)
}


#calculating support
calculateSupport <- function(){
    items <- eclat(transactions)
    inspect(items)
    supportValue <- inspect(items)$support
    paste(supportValue)
    support(items(items), transactions)
}


