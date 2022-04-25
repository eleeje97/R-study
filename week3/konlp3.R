### 제주도 추천 여행코스 찾기 ###

# 사전 설정
useSejongDic()

# 사전에 단어 추가하기
mergeUserDic(data.frame(readLines("week3/data/0425_pm_Data/제주도여행지.txt"), "ncn"))

# 데이터 가져오기
jeju_txt <- readLines("week3/data/0425_pm_Data/jeju.txt")

# 명사 추출
place <- sapply(jeju_txt, extractNoun, USE.NAMES = F)
cdata <- unlist(place)

# 영문과 한글 제외하고 제거
place <- str_replace_all(cdata, "[^[:alpha:]]", "")
place <- gsub(" ", "", place)
head(place)

# 제거할 단어 불러와서 제거
gsub_txt <- readLines("week3/data/0425_pm_Data/제주도여행코스gsub.txt")
i <- 1
for(i in 1:length(gsub_txt)) {
  place <- gsub(gsub_txt[i], "", place)
}

# 단어가 두글자 이상인 것만 추출
place <- Filter(function(x) {nchar(x) >= 2}, place)

# 텍스트파일로 저장하고 다시 공백 제거해서 불러오기
write(unlist(place), "week3/data/0425_pm_Data/jeju_2.txt")
rev <- read.table("week3/data/0425_pm_Data/jeju_2.txt")
nrow(rev)

# 단어 개수로 정렬하여 30개 뽑아보기
wordcount <- table(rev)
head(sort(wordcount, decreasing = T), 30)

# 팔레트
palette <- brewer.pal(9, "Set1")

# 워드클라우드로 시각화
wordcloud(names(wordcount),
          freq = wordcount,
          scale = c(4,1),
          rot.per = 0.25,
          min.freq = 2,
          random.order = F,
          random.color = T,
          colors = palette)


### 서울 명소 데이터 ###

# 사전에 단어 추가하기
mergeUserDic(data.frame(readLines("week3/data/0425_pm_Data/서울명소dic.txt"), "ncn"))

# 데이터 불러오기
seoul_go_txt <- readLines("week3/data/0425_pm_Data/seoul_go.txt")

# 명사 추출
place <- sapply(seoul_go_txt, extractNoun, USE.NAMES = F)
cdata <- unlist(place)

# 영문과 한글 제외하고 제거
place <- str_replace_all(cdata, "[^[:alpha:]]", "")
place <- gsub(" ", "", place)
head(place)

# 제거할 단어 불러와서 제거
gsub_txt <- readLines("week3/data/0425_pm_Data/서울명소gsub.txt", encoding = "UTF-8")
i <- 1
for(i in 1:length(gsub_txt)) {
  place <- gsub(gsub_txt[i], "", place)
}

# 단어가 두글자 이상인 것만 추출
place <- Filter(function(x) {nchar(x) >= 2}, place)

# 텍스트파일로 저장하고 다시 공백 제거해서 불러오기
write(unlist(place), "week3/data/0425_pm_Data/seoul_go_2.txt")
rev <- read.table("week3/data/0425_pm_Data/seoul_go_2.txt")
nrow(rev)

# 단어 개수로 정렬하여 30개 뽑아보기
wordcount <- table(rev)
head(sort(wordcount, decreasing = T), 30)

# 팔레트
palette <- brewer.pal(9, "Set1")

# 워드클라우드로 시각화
wordcloud(names(wordcount),
          freq = wordcount,
          scale = c(4,1),
          rot.per = 0.25,
          min.freq = 2,
          random.order = F,
          random.color = T,
          colors = palette)


### 故 노무현 대통령 연설문
txt <- readLines("week3/data/0425_pm_Data/noh.txt")
nouns <- sapply(txt, extractNoun, USE.NAMES = F)
head(unlist(nouns), 30)

nouns <- Filter(function(x) {nchar(x) >= 2}, unlist(nouns))

write(unlist(nouns), "week3/data/0425_pm_Data/noh_2.txt")
rev <- read.table("week3/data/0425_pm_Data/noh_2.txt")

wordcount <- table(rev)
head(sort(wordcount, decreasing = T), 30)

palette <- brewer.pal(9, "Set1")

wordcloud(names(wordcount),
          freq = wordcount,
          scale = c(5,0.5),
          rot.per = 0.25,
          min.freq = 1,
          random.order = F,
          random.color = T,
          colors = palette)
