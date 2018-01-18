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
      textInput("text", "Please enter a word"),
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
        
        tabPanel("Author", 
                 h4("About author"),
                 shiny::textOutput("author"),
                 h4("Contact:"),
                 shiny::textOutput("author1")
                 )
        
      )

      
      # Output: Verbatim text for data summary ----
      # h4("Frequency Plot"),
      # shiny::plotOutput("plot"),
      # h4("Frequency Table"),
      # shiny::tableOutput("predictedtext"),
      # h5("Median of words frequency is:"),
      # shiny::textOutput("median"),
      # h5("Mean of words frequency is:"),
      # shiny::textOutput("mean")
      
      # Output: HTML table with requested number of observations ----
      #tableOutput("view")
      
    )
  )
)