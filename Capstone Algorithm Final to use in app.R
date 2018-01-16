library(stringi)
library(tidyr)
library(dplyr)
library(hunspell)

bigramtable = read.csv("C:/Users/m.dzwolak/Documents/bigramtable.csv", stringsAsFactors = FALSE)
trigramtable = read.csv("C:/Users/m.dzwolak/Documents/trigramtable.csv", stringsAsFactors = FALSE)

#Algorithm

engine <- function(input){
  
  numberofspaces <- sapply(regmatches(input, gregexpr(" ", input)), length)
  input = gsub('[[:punct:] ]+',' ',input)
  bad <- hunspell(input)
  bad <- hunspell_suggest(bad[[1]])
  
  if(numberofspaces==0){
    bestmatch <- bigramtable %>% filter(bigramtable$word1==input)
    output <- head(bestmatch,10)
    if(nrow(output)!=0){
      return(output)
    }else{
      print(paste0("Did you meant"," ", bad,"?"))
      #tu jest autokorekta
    }
  }
  
  if(numberofspaces==1){
    bestmatch <- trigramtable %>% filter(trigramtable$duo==input)
    output <- head(bestmatch,10)
    if(nrow(output)!=0){
      return(output)
    }else{
      modifyinput <- as.data.frame(stri_locate_all(pattern = " ", input, fixed = TRUE))
      modifyinput <- substr(input, tail(modifyinput,1)[1,1]+1,nchar(input))
      bestmatch <- bigramtable %>% filter(bigramtable$word1==modifyinput)
      output <- head(bestmatch,10)
      return(output)
    }
  }
  
  if(numberofspaces>1){
    modifyinput <- as.data.frame(stri_locate_all(pattern = " ", input, fixed = TRUE))
    modifyinput <- substr(input, tail(modifyinput,2)[1,1]+1,nchar(input))
    bestmatch <- trigramtable %>% filter(trigramtable$duo==modifyinput)
    output <- head(bestmatch,10)
    
    if(nrow(output)!=0){
      return(output)
    }else{
      modifyinput <- as.data.frame(stri_locate_all(pattern = " ", input, fixed = TRUE))
      modifyinput <- substr(input, tail(modifyinput,1)[1,1]+1,nchar(input))
      bestmatch <- bigramtable %>% filter(bigramtable$word1==modifyinput)
      output <- head(bestmatch,10)
      return(output)
      
    }
  }
}

input = "hello"

engine(input)

