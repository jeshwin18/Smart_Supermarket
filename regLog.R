library(shiny)
library(RMySQL)
#install.packages('shiny.reglog')
library(shiny.reglog)
library(ggplot2)
library(plotly)

#Loading the dbConnection file...to connect to db first.

source('dbConnection.R')
source('helperFunctions.R')

ui <- fluidPage(
  uiOutput('header'),
  verbatimTextOutput('logging'),
  uiOutput('loginUI'),
  uiOutput('signupUI'),
  titlePanel(uiOutput('titlePanel')),
  uiOutput('sidePanel'),
  uiOutput('contents', style='margin:2% 5% 0px'),
  verbatimTextOutput('inputVars'),
  plotlyOutput('aisleChart'),
  # uiOutput("dynamic")
) 

server<- function(input, output, session){
  options(shiny.maxRequestSize=300*1024^2) 
  #Creating RegLog Database Connection
  RegLogDbConnector <- RegLogDBIConnector$new(
    driver = MySQL(),
    dbname = 'mbaDb',
    'root',
    'password',
    'localhost'
  )
  chartData <- getAisleDataByDepartment('dairy eggs')
  
  
  #Creating Mail Connector with Gmail connector as smtp(A required field for reglog).
  mailConnector <- RegLogEmayiliConnector$new(
    from = 'chakshu1998022@gmail.com',
    smtp = gmailConnector
  )
  
  RegLog <- RegLogServer$new(
    dbConnector = RegLogDbConnector,
    mailConnector=mailConnector
  )
  
  output$header <- renderUI({
    fluidPage(
      fluidRow(
        column(width = 3,tags$img(src='debugninja.jpg', height=110,width=110)),
        column(8),
        column(width=1)
      ),
      fluidRow(
        column(12,
               tags$h1("Market Basket Analysis Using R and Tableau"),
               style='background-color:#4e79a7;
                      text-align:center;
                      color:white;
                      border-radius:5px;'
        ),
      ),
    )
  })
  
  output$loginUI <- renderUI({
    req(!RegLog$is_logged())
    fluidPage(
      fluidRow(
        column(5),
        column(4,RegLog_login_UI()),
      ),
      fluidRow(
        column(5),
        column(7,tags$h4('Don\'t have an Account?', actionLink('signup', 'Signup Below'))),
      ),
    )
  })
  
  output$logging <- renderPrint({RegLog$is_logged()})
  
  output$signupUI <- renderUI({
    req(!RegLog$is_logged())
    req(eval(input$signup > 0))
    fluidPage(
      fluidRow(
        column(7,RegLog_register_UI())
      )
    )
  })
  
  output$titlePanel <- renderUI({
    req(RegLog$is_logged())
    fluidPage(
      fluidRow(
        column(11,
               tags$h1(
                 paste('Greetings of the day, ',RegLog$user_id())
               )
              ),
        column(1,actionButton('logout', 'Logout', icon = icon('sign-out-alt')),style='margin-top:5px'),
        column(12,tags$hr())
        )
    )
  })
  
  output$sidePanel <- renderUI({
    req(RegLog$is_logged())
    fluidPage(
      fluidRow(
        column(1),
        column(5,tags$p("Market Basket Analysis in R for leading supermarket chain. This Predictive Analytics Dashboard represents data in a visual and interactive way which helps to Identify customer buying pattern such as which items purchase together, or how the purchase of one item influence customer to buy another item being purchased or one item avoid the customer to buy another item.  It eventually helps the supermarket to explore the ample opportunity which includes but not limited to Optimize Promotion, Items Multipack, Store planograms, Store Segmentations, Inventory, cross-selling, and many more."),
        tags$br(),
        tags$p("The market basket analysis provides an affinity analysis of Sales Pattern for product categories, subcategories, and items.  It also provides the sociation rules for the category, sub-category, and items using cutting edge machine learning algorithm which helps to optimize marketing strategy in near real time."),
        tags$br(),
        tags$p("Here is the glimpse of the market basket analysis dashboard."),
                style=' border-right-width: 3px;
                border-left-width: 0px;
                  border-style: solid;
                  border-image: 
                    radial-gradient(
                      circle, 
                      powderblue,
                      rgba(0, 0, 0, 0)
                    ) 1 100%;
                  font-size:20px'),
        # #4e79a7,
        column(3,fileInput("csvFile", "Choose CSV File",
                           multiple = FALSE,
                           accept = c("text/csv",
                                      "text/comma-separated-values,text/plain",
                                      ".csv"),
                          ),
              ),
      )
    )
  })
  
  observeEvent(input$logout, RegLog$logout())
  
  output$contents <- renderTable({
    
    # input$file1 will be NULL initially. After the user selects
    # and uploads a file, head of that data file by default,
    # or all rows if selected, will be shown.
    
    req(input$csvFile)
    
    # when reading semicolon separated files,
    # having a comma separator causes `read.csv` to error
    tryCatch(
      {
        df <- read.csv(input$csvFile$datapath)
      },
      error = function(e) {
        # return a safeError if a parsing error occurs
        stop(safeError(e))
      }
    )
    head(df,5)
    
  })
  
  output$inputVars <- renderPrint({names(input)})
  output$aisleChart <- renderPlotly({
    req(RegLog$is_logged())
    selectInput("no_of_orders", "Y-Axis", choices = names(chartData))
    ggplot(chartData,aes(reorder(aisle,no_of_orders, decreasing = T), no_of_orders))+
      geom_bar(stat='identity')+
      scale_x_discrete(label=abbreviate)+
      geom_col(aes(fill = no_of_orders)) +
      scale_fill_gradient2(low = "powderblue",
                           high = "#2a5783") +
      labs(x = "Aisle")
  })
  
  output$dynamic <- renderUI({
    req(input$plot_hover) 
    verbatimTextOutput("vals")
  })
  
  output$vals <- renderPrint({
    hover <- input$plot_hover 
    # print(str(hover)) # list
    y <- nearPoints(chartData, input$plot_hover)[input$no_of_orders]
    req(nrow(y) != 0)
    y
  })
}

shinyApp(ui = ui, server = server)