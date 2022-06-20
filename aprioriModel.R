# install.packages('arules')
library(arules) # library to read transaction data and generate rules.

#Loading db connection file and helper functions...
source('dbConnection.R')
source('helperFunctions.R')

#reading dataset.
orders <- getOrders()

#function to create dataset into transactional data.
#Reading transactional data from file and generating rules.
readTransactions <- function(){
  transactionData <- orders[c('order_id','product_name')]
  
  write.csv(transactionData,'myTransactions.csv')
  transactions <- read.transactions("myTransactions.csv", sep = ",", format = "single", cols=c(2,3))
  #transactions <- read.transactions(transactions,sep=',',format='single', cols = c(1,2))
  #items <- eclat(transactionData, support=0.1)
  #inspect(items)
  #supportValue <- inspect(items)$support
  #paste(supportValue)
  #support(items(items), transactions)
  return(transactions)  
}
 
showRules <- function(transactions, support=0.001,confidence=0.5, control=list(verbose = 0)){
  
  rules <- apriori(transactions, parameter = list(supp=support, conf=confidence))
  rules <- sort(rules, by='confidence', decreasing = TRUE)
  return(rules)
}

#Calling function.
#transactions <- readTransactions()
#rules <- showRules(transactions)
#inspect(rules)
