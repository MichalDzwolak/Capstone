library(shiny)
library(stringi)
library(tidyr)
library(dplyr)
library(hunspell)
library(ggplot2)

bigramtable <- read.csv("C:/Users/m.dzwolak/Documents/bigramtable.csv", stringsAsFactors = FALSE)
trigramtable <- read.csv("C:/Users/m.dzwolak/Documents/trigramtable.csv", stringsAsFactors = FALSE)

pl = ggplot(bigramtable, aes(x=bigramtable$Freq, y=bigramtable$Rank)) + 
  geom_line() + 
  theme_light() + 
  ggtitle("Frequency Plot") + 
  ylab("Words Rank") + 
  xlab("Frequency")


pl



engine <- function(input){
  
  
  numberofspaces <- sapply(regmatches(input, gregexpr(" ", input)), length)
  
  if(numberofspaces==0){
    bestmatch <- bigramtable %>% filter(bigramtable$word1==input)
    output <- head(bestmatch,10)[,2]
    return(output)
  }
}

input = "hello"

engine(input)

