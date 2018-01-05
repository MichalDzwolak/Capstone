#Capstone

# download
if(!file.exists("./Capstone")){dir.create("./Capstone")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip"
download.file(fileUrl,destfile="./Capstone/Dataset.zip")

# Unzip 
unzip(zipfile="./Capstone/Dataset.zip",exdir="./Capstone")

#readlines
#read blogs
blogs <- "C:/Users/m.dzwolak/Documents/Capstone/final/en_US/en_US.blogs.txt"
con1 <- file(blogs,open="r")
lineblogs <- readLines(con1)
close(con1)

#read blogs
news <- "C:/Users/m.dzwolak/Documents/Capstone/final/en_US/en_US.news.txt"
con2 <- file(news,open="r")
linenews <- readLines(con2)
close(con2)

#read twitter
twitter <- "C:/Users/m.dzwolak/Documents/Capstone/final/en_US/en_US.twitter.txt"
con3 <- file(news,open="r")
linetwitt <- readLines(con3)
close(con3)

#data cleaning
#for data cleaning i decided to use tm package
library(tm)

#accorind to requirements given by instructiors, we do not need to take all data to create a model. This is why im going to use a sample of each dataset.

#sampling
set.seed(1234)
lineblogss = sample(lineblogs, length(lineblogs)*0.01)
linenewss = sample(linenews, length(linenews)*0.01)
linetwitts = sample(linetwitt, length(linetwitt)*0.01)

data = c(lineblogss, linenewss, linetwitts)

library(textreg)
library(tidytext)
library(dplyr)

corpus <- VCorpus(VectorSource(data))
toSpace <- content_transformer(function(x, pattern) gsub(pattern, " ", x))
corpus <- tm_map(corpus, toSpace, "(f|ht)tp(s?)://(.*)[.][a-z]+")
corpus <- tm_map(corpus, toSpace, "@[^\\s]+")
corpus <- tm_map(corpus, tolower)
#corpus <- tm_map(corpus, removeWords, stopwords("english"))
corpus <- tm_map(corpus, removePunctuation)
corpus <- tm_map(corpus, removeNumbers)
corpus <- tm_map(corpus, stripWhitespace)
corpus <- tm_map(corpus, PlainTextDocument)

#conversion in to character vector
mytext = convert.tm.to.character(corpus)

unigram = data_frame(text = mytext) %>% 
  unnest_tokens(word, text) %>% 
  anti_join(stop_words) %>%
  group_by(word) %>% 
  count(word, sort = TRUE) %>%
  mutate(badword = ifelse(grepl("fuck", word)==TRUE | grepl("œ", word)==TRUE | grepl("â", word)==TRUE,1,0)) %>% filter(badword==0) %>%
  select(word, n)

#most frequent unigrams graph
library(ggplot2)
library(tidyr)

plot1 = ggplot(head(unigram,10), aes(x=reorder(word,-n), y=n)) + 
  geom_col() + 
  theme_light() +
  ylab("Count") + 
  xlab("Word") + 
  ggtitle("Most frequent unigrams")
  
plot1

#most frequent twograms graph
twogram = data_frame(text = mytext) %>% 
  unnest_tokens(bigram, text, token = "ngrams", n = 2) %>%
  group_by(bigram) %>% 
  count(bigram, sort = TRUE) %>%
  mutate(badword = ifelse(grepl("fuck", bigram)==TRUE | grepl("œ", bigram)==TRUE | grepl("â", bigram)==TRUE,1,0)) %>% filter(badword==0) %>%
  select(bigram, n)
  
bigrams_separated = twogram %>% separate(bigram, c("word1", "word2"), sep = " ")
bigrams_filtered <- bigrams_separated %>%
  filter(!word1 %in% stop_words$word) %>%
  filter(!word2 %in% stop_words$word)

#count new twogram
bigram_counts <- bigrams_filtered %>% 
  count(word1, word2, sort = TRUE)

bigrams_united <- bigrams_filtered %>%
  unite(bigram, word1, word2, sep = " ")

#most frequent twograms graph
