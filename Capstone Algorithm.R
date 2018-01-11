#Algorithm

library(stringi)
library(tidyr)

bigramtable = read.csv("C:/Users/m.dzwolak/Documents/bigram.csv")
trigramtable = read.csv("C:/Users/m.dzwolak/Documents/trigram.csv")
fourgramtable = read.csv("C:/Users/m.dzwolak/Documents/fourgram.csv")

bigramtable$bigram = as.character(bigramtable$bigram)
trigramtable$trigram = as.character(trigramtable$trigram)
fourgramtable$fourgram = as.character(fourgramtable$fourgram)

bigramtable = bigramtable %>% separate(bigram, c("word1", "word2"), sep = " ")

trigramtable = trigramtable %>% separate(trigram, c("word1", "word2", "word3"), sep = " ")
trigramtable = trigramtable %>% unite(duo, word1, word2, sep = " ")

# Tylko sprawdzam
# data.frame(File = "Bigram", Numbers = stri_stats_general(bigrams))
# data.frame(File = "Trigram", Numbers = stri_stats_general(trigram))

input = "welcome to the"

engine <- function(input){
  
  numberofspaces <- sapply(regmatches(input, gregexpr(" ", input)), length)
  
  if(numberofspaces==0){
    bestmatch <- bigramtable %>% filter(bigramtable$word1==input)
    return(head(bestmatch))
  }
  if(numberofspaces==1){
    bestmatch <- trigramtable %>% filter(trigramtable$duo==input)
    return(head(bestmatch))
  }
  if(numberofspaces>1){
    modifyinput <- as.data.frame(stri_locate_all(pattern = " ", input, fixed = TRUE))
    modifyinput <- substr(input,modifyinput[1,1]+1,nchar(input))
    bestmatch <- trigramtable %>% filter(trigramtable$duo==modifyinput)
    return(head(bestmatch))
  }
}

#aaa <- substr(input,1,2)
#aaa = gregexpr(" ", input)

# modifyinput <- as.data.frame(stri_locate_all(pattern = " ", input, fixed = TRUE))
# modifyinput <- substr(input,modifyinput[1,1],nchar(input))
# 
# modifyinput

engine(input)


