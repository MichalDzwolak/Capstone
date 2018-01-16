library(shiny)
library(stringi)
library(tidyr)
library(dplyr)
library(hunspell)


server <- function(input, output) {
  
  bigramtable <- read.csv("C:/Users/m.dzwolak/Documents/bigramtable.csv", stringsAsFactors = FALSE)
  #trigramtable <- read.csv("C:/Users/m.dzwolak/Documents/trigramtable.csv", stringsAsFactors = FALSE)
  
  engine <- function(input){
    
    numberofspaces <- sapply(regmatches(input, gregexpr(" ", input)), length)
    
    if(numberofspaces==0){
      bestmatch <- bigramtable %>% filter(bigramtable$word1==input)
      output <- head(bestmatch,10)[2:3]
      return(output)
    }
  }
  
  output$predictedtext <- shiny::renderTable({
    
    engine(input$text)
    
    })

  
}
  


  

