library(shiny)

#setwd("~/CapstonrFinal")

# Define UI for dataset viewer app ----
ui <- fluidPage(
  tags$style(type="text/css",
             ".shiny-output-error { visibility: hidden; }",
             ".shiny-output-error:before { visibility: hidden; }"
  ),
  
  # App title ----
  titlePanel("Predictive tool"),
  
  # Sidebar layout with a input and output definitions ----
  sidebarLayout(
    
    # Sidebar panel for inputs ----
    sidebarPanel(
      
      # Input: Selector for choosing dataset ----
      textInput("text", "Enter a word to predict what follows"),
      helpText("Note: first prediction can take approximately 10 seconds. Please do not leave space after inputed text.")
    ),
    
    # Main panel for displaying outputs ----
    mainPanel(
      
      shiny::tabsetPanel(
        tabPanel("Results",
                 
                 h4("Frequency Plot"),
                 shiny::plotOutput("plot"),
                 h4("Frequency Table"),
                 shiny::tableOutput("predictedtext"),
                 h5("Median of words frequency is:"),
                 shiny::textOutput("median"),
                 h5("Mean of words frequency is:"),
                 shiny::textOutput("mean")),
        
        tabPanel("Guide", 
                 h4("About application"),
                 shiny::textOutput("app"),
                 h4("About plot"),
                 shiny::textOutput("aboutplot"),
                 h4("About table"),
                 shiny::textOutput("abouttable")
        ),
        
        tabPanel("Author", 
                 h4("About author"),
                 shiny::textOutput("author"),
                 h4("Contact:"),
                 shiny::textOutput("author1")
                 )
        
      )

      
    )
  )
)