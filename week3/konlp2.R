library(KoNLP)
library(wordcloud)
library(RColorBrewer)

# 사전 설정
useSejongDic()

# 사전에 단어 추가
mergeUserDic(data.frame("서진수", "ncn"))

### 서울시 응답소 데이터 분석
data1 <- readLines("week3/data/0425_pm_Data/seoul_new.txt")
data2 <- sapply(data1, extractNoun, USE.NAMES = F)
data3 <- unlist(data2)

data3 <- gsub("\\d+", "", data3)
data3 <- gsub("서울시", "", data3)
data3 <- gsub("서울", "", data3)
data3 <- gsub("요청", "", data3)
data3 <- gsub("제안", "", data3)
data3 <- gsub(" ", "", data3)
data3 <- gsub("-", "", data3)
data3

write(unlist(data3), "week3/data/0425_pm_Data/seoul_2.txt")
data4 <- read.table("week3/data/0425_pm_Data/seoul_2.txt")
head(data4)

nrow(data4)
wordcount <- table(data4)
wordcount
head(sort(wordcount, decreasing=T), 20)

data3 <- gsub("OO", "", data3)
data3 <- gsub("님", "", data3)
data3 <- gsub("한", "", data3)
data3 <- gsub("개선", "", data3)
data3 <- gsub("문제", "", data3)
data3 <- gsub("관리", "", data3)
data3 <- gsub("민원", "", data3)
data3 <- gsub("이용", "", data3)
data3 <- gsub("관련", "", data3)
data3 <- gsub("시장", "", data3)
data3 <- gsub("역", "", data3)
data3 <- gsub("동", "", data3)
data3 <- gsub("건의", "", data3)
data3 <- gsub("적", "", data3)
data3 <- gsub("앞", "", data3)
data3 <- gsub("장", "", data3)
data3 <- gsub("전", "", data3)
data3 <- gsub("내", "", data3)
data3 <- gsub("구", "", data3)
data3 <- gsub("기", "", data3)
data3 <- gsub("이", "", data3)
data3 <- gsub("시", "", data3)
data3

write(unlist(data3), "week3/data/0425_pm_Data/seoul_3.txt")
data4 <- read.table("week3/data/0425_pm_Data/seoul_3.txt")
head(data4)

nrow(data4)
wordcount <- table(data4)
wordcount
head(sort(wordcount, decreasing=T), 20)

df_word <- as.data.frame(wordcount, stringsAsFactors = F)
df_word <- rename(df_word,
                  word = data4,
                  freq = Freq)
df_word <- df_word %>% arrange(desc(freq)) %>% head(20)
head(df_word)

palete <- brewer.pal(9, "Set3")

wordcloud(names(wordcount),
          freq = wordcount,
          scale = c(5,1),
          rot.per = 0.25,
          min.freq = 1,
          random.order = F,
          random.color = T,
          colors = palete)


### 성형수술 데이터
data1 <- readLines("week3/data/remake.txt")
data2 <- sapply(data1, extractNoun, USE.NAMES = F)
data3 <- unlist(data2)
data3 <- Filter(function(x) {nchar(x) <= 10}, data3)
head(data3)

data3 <- gsub("\\d+", "", data3)
data3 <- gsub("쌍수", "쌍꺼풀", data3)
data3 <- gsub("쌍커풀", "쌍꺼풀", data3)
data3 <- gsub("메부리코", "매부리코", data3)
data3 <- gsub("\\.", "", data3)
data3 <- gsub(" ", "", data3)
data3 <- gsub("\\'", "", data3)
data3

write(unlist(data3), "week3/data/0425_pm_Data/remake_2.txt")
data4 <- read.table("week3/data/0425_pm_Data/remake_2.txt")
data4

wordcount <- table(data4)
wordcount

head(sort(wordcount, decreasing = T), 20)
gsubtxt <- readLines("week3/data/0425_pm_Data/성형gsub.txt")
cnt_txt <- length(gsubtxt)

i <- 1
for(i in 1:cnt_txt) {
  data3 <- gsub((gsubtxt[i]), "", data3)
}

data3 <- Filter(function(x) {nchar(x) >= 2}, data3)
write(unlist(data3), "week3/data/0425_pm_Data/remake_2.txt")
data4 <- read.table("week3/data/0425_pm_Data/remake_2.txt")
data4

wordcount <- table(data4)
wordcount
head(sort(wordcount, decreasing = T), 20)

palete <- brewer.pal(9, "Set3")

wordcloud(names(wordcount),
          freq = wordcount,
          scale = c(5,1),
          rot.per = 0.25,
          min.freq = 2,
          random.order = F,
          random.color = T,
          colors = palete)

