library(stringi)
library(tidyr)
library(dplyr)
library(hunspell)


bigramtable = read.csv("C:/Users/m.dzwolak/Documents/bigram.csv")
trigramtable = read.csv("C:/Users/m.dzwolak/Documents/trigram.csv")

bigramtable$bigram = as.character(bigramtable$bigram)
trigramtable$trigram = as.character(trigramtable$trigram)

#separate
bigramtable = bigramtable %>% separate(bigram, c("word1", "word2"), sep = " ")

trigramtable = trigramtable %>% separate(trigram, c("word1", "word2", "word3"), sep = " ")
trigramtable = trigramtable %>% unite(duo, word1, word2, sep = " ")


#Algorithm

engine <- function(input){
  
  numberofspaces <- sapply(regmatches(input, gregexpr(" ", input)), length)
  bad <- hunspell(input)
  bad <- hunspell_suggest(bad[[1]])
  
  if(numberofspaces==0){
    bestmatch <- bigramtable %>% filter(bigramtable$word1==input)
    output <- head(bestmatch)
    if(nrow(output)!=0){
      return(output)
    }else{
      print(paste0("Did you meant"," ", bad,"?"))
      #tu jest autokorekta
    }
  }
  
  if(numberofspaces==1){
    bestmatch <- trigramtable %>% filter(trigramtable$duo==input)
    output <- head(bestmatch)
    if(nrow(output)!=0){
      return(output)
    }else{
      modifyinput <- as.data.frame(stri_locate_all(pattern = " ", input, fixed = TRUE))
      modifyinput <- substr(input, tail(modifyinput,1)[1,1]+1,nchar(input))
      bestmatch <- bigramtable %>% filter(bigramtable$word1==modifyinput)
      output <- head(bestmatch)
      return(output)
    }
  }
  
  if(numberofspaces>1){
    modifyinput <- as.data.frame(stri_locate_all(pattern = " ", input, fixed = TRUE))
    modifyinput <- substr(input, tail(modifyinput,2)[1,1]+1,nchar(input))
    bestmatch <- trigramtable %>% filter(trigramtable$duo==modifyinput)
    output <- head(bestmatch)
    
    if(nrow(output)!=0){
      return(output)
    }else{
      modifyinput <- as.data.frame(stri_locate_all(pattern = " ", input, fixed = TRUE))
      modifyinput <- substr(input, tail(modifyinput,1)[1,1]+1,nchar(input))
      bestmatch <- bigramtable %>% filter(bigramtable$word1==modifyinput)
      output <- head(bestmatch)
      return(output)

     }
   }
}

#aaa <- substr(input,1,2)
#aaa = strsplit(input, " ")

input = "hello my friend welcome"

engine(input)

#backoff dla trigram na 2 gram

modifyinput <- as.data.frame(stri_locate_all(pattern = " ", input, fixed = TRUE))
modifyinput <- substr(input, tail(modifyinput,2)[1,1]+1,nchar(input))

modifyinput <- as.data.frame(stri_locate_all(pattern = " ", input, fixed = TRUE))
modifyinput <- substr(input, tail(modifyinput,1)[1,1]+1,nchar(input))

 
modifyinput
