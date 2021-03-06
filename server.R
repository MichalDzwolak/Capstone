library(shiny)
library(stringi)
library(tidyr)
library(dplyr)
library(ggplot2)
library(wordcloud)

#setwd("~/CapstonrFinal")

server <- function(input, output) {

  #bigramtable <- read.csv("C:/Users/m.dzwolak/Documents/CapstonrFinal/bigramtable.csv", stringsAsFactors = FALSE)
  #trigramtable <- read.csv("C:/Users/m.dzwolak/Documents/CapstonrFinal/trigramtable.csv", stringsAsFactors = FALSE)
  
  bigramtable <- read.csv("bigramtable.csv", stringsAsFactors = FALSE)
  trigramtable <- read.csv("trigramtable.csv", stringsAsFactors = FALSE)
  
  engine <- function(input){
    
    numberofspaces <- sapply(regmatches(input, gregexpr(" ", input)), length)
    input = gsub('[[:punct:] ]+',' ',input)
    input = tolower(input)
    
    if(numberofspaces==0){
      bestmatch <- bigramtable %>% filter(bigramtable$word1==input)
      output <- head(bestmatch,30)
      output <- output %>% mutate(Rank = row_number())
      if(nrow(output)!=0){
        return(output)
      }
    }
    
    if(numberofspaces==1){
      bestmatch <- trigramtable %>% filter(trigramtable$duo==input)
      output <- head(bestmatch,30)
      output <- output %>% mutate(Rank = row_number())
      if(nrow(output)!=0){
        return(output)
      }else{
        modifyinput <- as.data.frame(stri_locate_all(pattern = " ", input, fixed = TRUE))
        modifyinput <- substr(input, tail(modifyinput,1)[1,1]+1,nchar(input))
        bestmatch <- bigramtable %>% filter(bigramtable$word1==modifyinput)
        output <- head(bestmatch,30)
        output <- output %>% mutate(Rank = row_number())
        return(output)
      }
    }
    
    if(numberofspaces>1){
      modifyinput <- as.data.frame(stri_locate_all(pattern = " ", input, fixed = TRUE))
      modifyinput <- substr(input, tail(modifyinput,2)[1,1]+1,nchar(input))
      bestmatch <- trigramtable %>% filter(trigramtable$duo==modifyinput)
      output <- head(bestmatch,30)
      output <- output %>% mutate(Rank = row_number())
      
      if(nrow(output)!=0){
        return(output)
      }else{
        modifyinput <- as.data.frame(stri_locate_all(pattern = " ", input, fixed = TRUE))
        modifyinput <- substr(input, tail(modifyinput,1)[1,1]+1,nchar(input))
        bestmatch <- bigramtable %>% filter(bigramtable$word1==modifyinput)
        output <- head(bestmatch,30)
        output <- output %>% mutate(Rank = row_number())
        return(output)
        
      }
    }
  }
  
  # output$predictedtext <- shiny::renderTable({
  #   
  #   head(engine(input$text),5)
  #   
  #   })

  output$plot <- shiny::renderPlot({
    # wordcloud(words = engine(input$text)[,1], freq = engine(input$text)[,2], min.freq = 1,
    #                  max.words=200, random.order=FALSE, rot.per=0.35,
    #                  colors=brewer.pal(8, "Dark2"))
    ggplot(engine(input$text), aes(x=engine(input$text)[,4], y=engine(input$text)[,3])) +
      geom_area( fill="purple", alpha=.3)+
      geom_line() + 
      xlab("Word rank") + 
      ylab("Freq") + 
      ggtitle("Words frequency drop")
  
  })
  
  output$predictedtext <- shiny::renderTable({
    
    head(engine(input$text),5)[,2:4]
    
  })
  
  output$median <- shiny::renderText({
    
    median(engine(input$text)[,3])
    
  })
  
  output$mean <- shiny::renderText({
    
    round(mean(engine(input$text)[,3]),3)
    
  })
  
  output$author <- shiny::renderText("Hi my name is Michal. I come from Poland but live in Brussels. I'm working as a data analyst for almost four years. Six months ago i decided to learn next programing language (R) which will help me to analyse data more efficient. This is how i found Hopkins Data Science specialisation. Tool which you are using now was created as a Capstone project to receive final cerificate.")
  output$author1 <- shiny::renderText("In terms of contact please use my email address : michal.dzwolak@gmail.com")
  output$app <- shiny::renderText("Based on implemented dataset, application calculates next word in relation to entered ones. It means, if entered word is hello, application will calculate which following word was most frequent in analysed dataset.")
  output$aboutplot <- shiny::renderText("Plot is a visualisation of next words frequency. It shows next words frequency and a rank of words in a dataset in relation to entered ones.")
  output$abouttable <- shiny::renderText("Table shows top five frequent words observed in a dataset. Predicted column: shows top next words after entered ones. Freq column: shows frequency, how many times word from column Predicted appeared after entered word. Rank: Shows ranking of next word in relation to entered ones. It means that next words which appearded most frequent after entered word will be ranked as first.")
}
  


  

