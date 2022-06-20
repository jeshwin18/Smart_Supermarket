library(RMySQL) # Library to connect R with MySQL Server...
#install.packages('emayili')
library(emayili)


#Connection String to connect with db.
connectDB<- function(){
    all_conns <- dbListConnections(MySQL())
    if(length(all_conns)<1){
        connection <- dbConnect(MySQL(),'mbaDb','root','password','localhost')
        return(connection)
    }
    else{
        for(connection in all_conns){
            return(connection)
        }
    }
}

connection <- connectDB()


#Creating db tables according to the reglog library requirement..
DBI_tables_create(
  conn = connection,
  hash_passwords = FALSE
)

# Creating SMTP connection to gmail..to send emails as required by reglog package.
gmailConnector <- emayili::gmail('chakshu1998022@gmail.com', 'Malerkotla.1')


killDbConnections <- function(){
    all_conns <- dbListConnections(MySQL())
    for(connection in all_conns){
        dbDisconnect(connection)
    }
}

# killDbConnections()
