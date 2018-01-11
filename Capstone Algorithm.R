library(stringi)
library(tidyr)
library(dplyr)



bigramtable = read.csv("C:/Users/m.dzwolak/Documents/bigram.csv")
trigramtable = read.csv("C:/Users/m.dzwolak/Documents/trigram.csv")

bigramtable$bigram = as.character(bigramtable$bigram)
trigramtable$trigram = as.character(trigramtable$trigram)


#separate
bigramtable = bigramtable %>% separate(bigram, c("word1", "word2"), sep = " ")

trigramtable = trigramtable %>% separate(trigram, c("word1", "word2", "word3"), sep = " ")
trigramtable = trigramtable %>% unite(duo, word1, word2, sep = " ")


#Algorithm
input = "welcme you must"
split = strsplit(input, " ")
correct <- hunspell_check(split)
suggest <- hunspell_suggest(input[!correct])

engine <- function(input){
  
  numberofspaces <- sapply(regmatches(input, gregexpr(" ", input)), length)
  
  if(numberofspaces==0){
    bestmatch <- bigramtable %>% filter(bigramtable$word1==input)
    output <- head(bestmatch)
    if(nrow(output)!=0){
      return(output)
    }else{
      print("There is no output!!!!")
      #tu jest autokorekta
    }
  }
  
  if(numberofspaces==1){
    bestmatch <- trigramtable %>% filter(trigramtable$duo==input)
    output <- head(bestmatch)
    if(nrow(output)!=0){
      return(output)
    }else{
      print("There is no output!!!!")
      #tu musi byc backoff an 2 gram drugiego slowa
    }
  }
  
  if(numberofspaces>1){
    modifyinput <- as.data.frame(stri_locate_all(pattern = " ", input, fixed = TRUE))
    modifyinput <- substr(input,modifyinput[1,1]+1,nchar(input))
    bestmatch <- trigramtable %>% filter(trigramtable$duo==modifyinput)
    output <- head(bestmatch)
    
    if(nrow(output)!=0){
      return(output)
    }else{
      print("There is no output!!!!")
      #tu musi byc backoff an 2 gram trzeciego slowa
    }
  }
}

#aaa <- substr(input,1,2)
#aaa = strsplit(input, " ")

# modifyinput <- as.data.frame(stri_locate_all(pattern = " ", input, fixed = TRUE))
# modifyinput <- substr(input,modifyinput[1,1],nchar(input))
# 
# modifyinput

engine(input)


