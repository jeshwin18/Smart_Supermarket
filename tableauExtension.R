# filetype: shinyApp


# This file is intended to make an extension for tableau to integrate R shiny data in tableau.
# We are doing this to add association rules in tableau dashboard.

# installing library...
#remotes::install_github("rstudio/shinytableau")

# creating yaml file to make extension configurations...
#shinytableau::yaml_skeleton()

#-----------------------------------------------------------------------#
# This code below will create extension and let you download the .trex file.

library(shiny)
library(shinytableau)

manifest <- tableau_manifest_from_yaml()

source('aprioriModel.R')

ui <- function(req) {
    fluidPage(
        sidebarLayout(
            sidebarPanel(
                selectInput('support',
                            'Select Support Value',
                            c(.1,.01,.05,.001,.005)),
                selectInput('confidence',
                            'Select Confidence Value',
                            c(.5,.6,.7,.8,.9)),
                width = 3
            ),
            mainPanel(
                verbatimTextOutput('rules'),
                width=9,
            )
        )
    )
}

server <- function(input, output, session) {
    transactions <- readTransactions()
    output$rules <- renderPrint({
        rules <- showRules(transactions, 
                           as.numeric(input$support), 
                           as.numeric(input$confidence))
        inspect(rules)
        })
}

tableau_extension(manifest, ui, server,
                  options = ext_options(port = 3456)
)
