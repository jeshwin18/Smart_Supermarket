#install.packages("RMySQL")
# Library to connect with MySQL...
library(RMySQL)

# Connection with DB...
db <- dbConnect(MySQL(),
                user='root',password='password',
                dbname='mbaDB',host='localhost')

# Reading superstore orders data...
setwd('D:/dataScience')
data <- read.csv(paste0(getwd(),'/fiverr/dataset/final_train_data.csv'))
head(data)

set.seed(123) # to reproduce.

data_sample <- data[seq_len(floor(nrow(data))*0.50),]

tail(data_sample)

which(data['order_id'] == 843370,)

# library(dplyr)
# 
# orders$dayOfWeek <- recode(orders$order_dow,
#                            "0"="Sunday",
#                            "1"="Monday",
#                            "2"="Tuesday",
#                            "3"="Wednesday",
#                            "4"="Thursday",
#                            "5"="Friday",
#                            "6"="Saturday") 


# prior_orders <- orders[orders['eval_set'] == 'prior',]
# 
# length(prior_orders$order_id)
# 
# train_orders <- orders[orders['eval_set'] == 'train',]
# 
# length(train_orders$order_id)
# 
# head(orders)

# Creating a sample of 25% to add to db.
smp_size <- floor(0.25*nrow(orders))

index.to.write <- sample(seq_len(nrow(orders)),smp_size)

data.to.write <- data[index.to.write,]

# Writing sampled superstore data to a table 'orders' in db...
dbWriteTable(db,'orders',data_sample,
             overwrite=TRUE,
             field.types=NULL,
             row.names=FALSE,
             append=FALSE,
             header=TRUE,
             sep=',')

data <- read.csv(paste0(getwd(),'/dataset/orders_trainProductsAdded.csv'))


dataProducts <- read.csv(paste0(getwd(),'/dataset/productsDepartmentAdded.csv'))
head(dataProducts)

dbWriteTable(db,'products',dataProducts,
             overwrite=TRUE,
             field.types=NULL,
             row.names=FALSE,
             append=FALSE,
             header=TRUE,
             sep=',')

