#Capstone

library(ggplot2)
library(tm)
library(textreg)
library(tidytext)
library(dplyr)
library(stringi)

# download
if(!file.exists("./Capstone")){dir.create("./Capstone")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip"
download.file(fileUrl,destfile="./Capstone/Dataset.zip")

# Unzip 
unzip(zipfile="./Capstone/Dataset.zip",exdir="./Capstone")

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
con3 <- file(twitter,open="r")
linetwitt <- readLines(con3)
close(con3)

#Blogs dataset
data.frame(File = "Blog", Numbers = stri_stats_general(lineblogs))
summary(lineblogs)

#xlim changed to 500 to be able to see clear words count distribution 
qplot(stri_count_words(lineblogs), xlim = c(0, 500))

#News dataset
data.frame(File = "News", Numbers = stri_stats_general(linenews))
summary(linenews)

qplot(stri_count_words(linenews), xlim = c(0, 500))

#Twitter dataset
data.frame(File = "Twitter", Numbers = stri_stats_general(linetwitt))
summary(linetwitt)

qplot(stri_count_words(linetwitt), xlim = c(0, 500))

#sampling
set.seed(1234)
lineblogss = sample(lineblogs, length(lineblogs)*0.05)
linenewss = sample(linenews, length(linenews)*0.05)
linetwitts = sample(linetwitt, length(linetwitt)*0.05)

data = c(lineblogss, linenewss, linetwitts)

#dataset before cleaning
stri_stats_general(data)
summary(data)

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

#dataset after cleaning 
stri_stats_general(mytext)
summary(mytext)

patterns = c('Á', 'ê','ã','ç', 'à', 'ú', 'ü', 'â', 'ã', '¢')

unigram = data_frame(text = mytext) %>% 
  unnest_tokens(word, text) %>% 
  anti_join(stop_words) %>%
  group_by(word) %>% 
  count(word, sort = TRUE) %>%
  mutate(badword = ifelse(grepl(paste(patterns, collapse="|"), word)==TRUE | grepl("fuck", word)==TRUE,1,0)) %>% 
  filter(badword==0) %>%
  select(word, n)

summary(unigram)

#delete unigrams with a frequency below mean
unigram = unigram %>% filter(n>mean(unigram$n))

#new summary
summary(unigram)

#most frequent unigrams graph
plot1 = ggplot(head(unigram,15), aes(x=reorder(word,-n), y=n)) + 
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

plot2 = ggplot(head(bigram,15), aes(x=reorder(bigram,-n), y=n)) + 
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

plot3 = ggplot(head(trigram,15), aes(x=reorder(trigram,-n), y=n)) + 
  geom_col() + 
  theme_light() +
  ylab("Count") + 
  xlab("Trigram") + 
  ggtitle("Most frequent trigrams") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))

plot3

#save
write.table(unigram, file = "unigram.txt", row.names = FALSE)
write.table(bigram, file = "bigram.txt", row.names = FALSE)
write.table(trigram, file = "trigram.txt", row.names = FALSE)