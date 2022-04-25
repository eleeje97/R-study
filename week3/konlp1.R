# 깃허브와 같은 저장소로부터 파일을 다운받을 때
library(remotes)

# 패키지 파일 다운로드
remotes::install_github("mrchypark/multilinguer")
library(multilinguer)

# jdk 설치
multilinguer::install_jdk()

# 패키지 설치
install.packages(c('stringr', 'hash', 'tau', 'Sejong', 'RSQLite', 'devtools'), type = "binary")

# KoNLP 패키지 다운로드
remotes::install_github('haven-jeon/KoNLP', upgrade='never', INSTALL_opts=c("--no-multiarch"))
library(KoNLP)

# 사전 설정하기
useNIADic()

# 데이터 준비
txt <- readLines("week3/data/hiphop.txt")

# 특수문자 제거
library(stringr)
txt <- str_replace_all(txt, "\\W", " ")
txt

# 명사 추출하기
extractNoun("대한민국의 영토는 한반도와 그 부속도서로 한다")

# 힙합가사에서 명사추출
nouns <- extractNoun(txt)
head(nouns)

# 명사 list를 문자열 벡터로 변환, 단어별 빈도표 생성
wordcount <- table(unlist(nouns))

# 데이터 프레임으로 변환
df_word <- as.data.frame(wordcount, stringsAsFactors = F)

# 변수명 수정
df_word <- rename(df_word,
                  word = Var1,
                  freq = Freq)

# 두 글자 이상 단어 추출
library(dplyr)
df_word <- filter(df_word, nchar(word) >= 2)

top_20 <- df_word %>% 
  arrange(desc(freq)) %>% 
  head(20)
top_20

# 워드클라우드
library(wordcloud)
library(RColorBrewer)

# 단어 색상 목록 만들기
pal <- brewer.pal(8, "Dark2")

# 워드 클라우드 생성
set.seed(1234)
wordcloud(words = df_word$word,
          freq = df_word$freq,
          min.freq = 2,
          max.words = 200,
          random.order = F, # 고빈도 단어 중앙 배치
          rot.per = .1, # 회전 단어 비율
          scale = c(4, 0.3), # 글자크기: 최대 4배, 0.3%
          colors = pal) # 팔레트 지정


### 국정원 트위터 텍스트 마이닝
# 데이터 로드
twitter <- read.csv("week3/data/twitter.csv",
                    header = T,
                    stringsAsFactors = F,
                    fileEncoding = "UTF-8")

# 변수명 수정
twitter <- rename(twitter,
                  no = 번호,
                  id = 계정이름,
                  date = 작성일,
                  tw = 내용)

# 특수문자 제거
twitter$tw <- str_replace_all(twitter$tw, "\\W", " ")
head(twitter)

# 트윗에서 명사 추출
nouns <- extractNoun(twitter$tw)

# 명사 list를 벡터로 변환, 단어별 빈도표 생성
wordcount <- table(unlist(nouns))

# 데이터 프레임으로 변환
df_word <- as.data.frame(wordcount, stringsAsFactors = F)

# 변수명 수정
df_word <- rename(df_word,
                  word = Var1,
                  freq = Freq)

# 두 글자 이상으로 된 단어 추출
df_word <- filter(df_word, nchar(word) >= 2)

# 상위 20개 추출
top_20 <- df_word %>%
  arrange(desc(freq)) %>% 
  head(20)
top_20

# 단어 빈도 막대 그래프 만들기
library(ggplot2)
order <- arrange(top_20, freq)$word
ggplot(data = top_20, aes(x = word, y = freq)) +
  ylim(0, 2500) +
  geom_col() +
  coord_flip() +
  scale_x_discrete(limit = order) +
  geom_text(aes(label = freq), hjust = -0.3)

# 워드 클라우드 만들기
pal <- brewer.pal(8, "Dark2")
set.seed(1234)

wordcloud(words = df_word$word,
          freq = df_word$freq,
          min.freq = 10,
          max.words = 200,
          random.order = F,
          rot.per = .1,
          scale = c(6, 0.2),
          colors = pal)


### 프로포즈 데이터
propose_txt <- readLines("week3/data/propose.txt")
propose_txt <- str_replace_all(propose_txt, "\\W", " ")
head(propose_txt)

nouns <- extractNoun(propose_txt)
head(nouns)
wordcount <- table(unlist(nouns))

df_word <- as.data.frame(wordcount, stringsAsFactors = F)
df_word <- rename(df_word,
                  word = Var1,
                  freq = Freq)

df_word <- filter(df_word, nchar(word) >= 2) %>% arrange(desc(freq))
head(df_word)

df_word <- df_word[-c(1:6),]

top_20 <- df_word %>% 
  head(20)
top_20

pal <- brewer.pal(8, "Dark2")

set.seed(1234)
wordcloud(words = df_word$word,
          freq = df_word$freq,
          min.freq = 2,
          max.words = 200,
          random.order = F, 
          rot.per = .1, 
          scale = c(4, 0.3), 
          colors = pal) 

order <- arrange(top_20, freq)$word
ggplot(data = top_20, aes(x = word, y = freq)) +
  ylim(0, 55) +
  geom_col() +
  coord_flip() +
  scale_x_discrete(limit = order) +
  geom_text(aes(label = freq), hjust = -0.3)


### 성형수술 데이터
remake_txt <- readLines("week3/data/remake.txt")
remake_txt <- str_replace_all(remake_txt, "\\W", " ")
head(remake_txt)

nouns <- extractNoun(remake_txt)
head(nouns)
wordcount <- table(unlist(nouns))

df_word <- as.data.frame(wordcount, stringsAsFactors = F)
df_word <- rename(df_word,
                  word = Var1,
                  freq = Freq)

df_word <- filter(df_word, nchar(word) >= 2)
head(df_word)

top_20 <- df_word %>% 
  arrange(desc(freq)) %>% 
  head(20)
top_20

pal <- brewer.pal(8, "Dark2")

set.seed(1234)
wordcloud(words = df_word$word,
          freq = df_word$freq,
          min.freq = 2,
          max.words = 200,
          random.order = F, 
          rot.per = .1, 
          scale = c(4, 0.3), 
          colors = pal) 

order <- arrange(top_20, freq)$word
ggplot(data = top_20, aes(x = word, y = freq)) +
  ylim(0, 150) +
  geom_col() +
  coord_flip() +
  scale_x_discrete(limit = order) +
  geom_text(aes(label = freq), hjust = -0.3)


### 레이 데이터
ray_txt <- readLines("week3/data/new_myray.txt")
ray_txt <- str_replace_all(ray_txt, "\\W", " ")
ray_txt <- str_replace_all(ray_txt, "\\d", "")
head(ray_txt)

nouns <- extractNoun(ray_txt)
head(nouns)
wordcount <- table(unlist(nouns))

df_word <- as.data.frame(wordcount, stringsAsFactors = F)
df_word <- rename(df_word,
                  word = Var1,
                  freq = Freq)

df_word <- filter(df_word, nchar(word) >= 2) %>% arrange(desc(freq))
head(df_word)
df_word <- df_word[-1,]

top_20 <- df_word %>% 
  head(20)
top_20

pal <- brewer.pal(8, "Dark2")

set.seed(1234)
wordcloud(words = df_word$word,
          freq = df_word$freq,
          min.freq = 2,
          max.words = 200,
          random.order = F, 
          rot.per = .1, 
          scale = c(4, 0.3), 
          colors = pal) 

order <- arrange(top_20, freq)$word
ggplot(data = top_20, aes(x = word, y = freq)) +
  ylim(0, 10) +
  geom_col() +
  coord_flip() +
  scale_x_discrete(limit = order) +
  geom_text(aes(label = freq), hjust = -0.3)

