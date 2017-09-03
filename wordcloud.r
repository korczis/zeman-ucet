library(tm)
library(SnowballC)
library(wordcloud)

words <- read.csv('data/data.csv', stringsAsFactors = FALSE)

corpus <- Corpus(VectorSource(words$msg))

# corpus <- tm_map(corpus, PlainTextDocument)

corpus <- tm_map(corpus, removePunctuation)
# corpus <- tm_map(corpus, removeWords, stopwords('russian'))

corpus <- tm_map(corpus, stemDocument)

wordcloud(corpus)
