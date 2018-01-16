library(shiny)


# Define UI for dataset viewer app ----
ui <- fluidPage(
  
  # App title ----
  titlePanel("Predictive tool"),
  
  # Sidebar layout with a input and output definitions ----
  sidebarLayout(
    
    # Sidebar panel for inputs ----
    sidebarPanel(
      
      # Input: Selector for choosing dataset ----
      textInput("text", "Please enter a word")
      # Input: Numeric entry for number of obs to view ----
      # numericInput(inputId = "obs",
      #              label = "Number of predicted words",
      #              value = 5)
    ),
    
    # Main panel for displaying outputs ----
    mainPanel(
      
      # Output: Verbatim text for data summary ----
      shiny::tableOutput("predictedtext")
      
      # Output: HTML table with requested number of observations ----
      #tableOutput("view")
      
    )
  )
)