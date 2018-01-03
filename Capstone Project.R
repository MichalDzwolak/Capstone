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
lineblogss = sample(lineblogs, length(lineblogs)*0.05)
linenewss = sample(linenews, length(linenews)*0.05)
linetwitts = sample(linetwitt, length(linetwitt)*0.05)

data = c(lineblogss, linenewss, linetwitts)

#creating a copus
datacorpus = VCorpus(VectorSource(data))
datacorpus
