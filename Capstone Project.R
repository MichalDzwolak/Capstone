#Capstone

library(ggplot2)
library(tm)
library(textreg)
library(tidytext)
library(dplyr)

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
#accorind to requirements given by instructiors, we do not need to take all data to create a model. This is why im going to use a sample of each dataset.

#sampling
set.seed(1234)
lineblogss = sample(lineblogs, length(lineblogs)*0.01)
linenewss = sample(linenews, length(linenews)*0.01)
linetwitts = sample(linetwitt, length(linetwitt)*0.01)

data = c(lineblogss, linenewss, linetwitts)

corpus <- VCorpus(VectorSource(data))
toSpace <- content_transformer(function(x, pattern) gsub(pattern, " ", x))
corpus <- tm_map(corpus, toSpace, "(f|ht)tp(s?)://(.*)[.][a-z]+")
corpus <- tm_map(corpus, toSpace, "@[^\\s]+")
corpus <- tm_map(corpus, tolower)
corpus <- tm_map(corpus, removePunctuation)
corpus <- tm_map(corpus, removeNumbers)
corpus <- tm_map(corpus, stripWhitespace)
corpus <- tm_map(corpus, PlainTextDocument)

#conversion in to character vector
mytext = convert.tm.to.character(corpus)

patterns = c('Á', 'ê','ã','ç', 'à', 'ú', 'ü', 'â', 'ã', '¢')

unigram = data_frame(text = mytext) %>% 
  unnest_tokens(word, text) %>% 
  anti_join(stop_words) %>%
  group_by(word) %>% 
  count(word, sort = TRUE) %>%
  mutate(badword = ifelse(grepl(paste(patterns, collapse="|"), word)==TRUE | grepl("fuck", word)==TRUE,1,0)) %>% 
  filter(badword==0) %>%
  select(word, n)

#most frequent unigrams graph
plot1 = ggplot(head(unigram,10), aes(x=reorder(word,-n), y=n)) + 
  geom_col() + 
  theme_light() +
  ylab("Count") + 
  xlab("Word") + 
  ggtitle("Most frequent unigrams")
  
plot1

#most frequent twograms graph
bigram = data_frame(text = mytext) %>% 
  unnest_tokens(bigram, text, token = "ngrams", n = 2) %>%
  group_by(bigram) %>% 
  count(bigram, sort = TRUE) %>%
  mutate(badword = ifelse(grepl(paste(patterns, collapse="|"), bigram)==TRUE | grepl("fuck", bigram)==TRUE,1,0)) %>%
  filter(badword==0) %>%
  select(bigram, n)

plot2 = ggplot(head(bigram,10), aes(x=reorder(bigram,-n), y=n)) + 
  geom_col() + 
  theme_light() +
  ylab("Count") + 
  xlab("Bigram") + 
  ggtitle("Most frequent bigrams")

plot2

#most frequent trigrams graph
trigram = data_frame(text = mytext) %>% 
  unnest_tokens(trigram, text, token = "ngrams", n = 3) %>%
  group_by(trigram) %>% 
  count(trigram, sort = TRUE) %>%
  mutate(badword = ifelse(grepl(paste(patterns, collapse="|"), trigram)==TRUE | grepl("fuck", trigram)==TRUE,1,0)) %>%
  filter(badword==0) %>%
  select(trigram, n)

plot3 = ggplot(head(trigram,10), aes(x=reorder(trigram,-n), y=n)) + 
  geom_col() + 
  theme_light() +
  ylab("Count") + 
  xlab("Trigram") + 
  ggtitle("Most frequent trigrams")

plot3

#save
write.table(unigram, file = "unigram.txt", row.names = FALSE)
write.table(bigram, file = "bigram.txt", row.names = FALSE)
write.table(trigram, file = "trigram.txt", row.names = FALSE)
