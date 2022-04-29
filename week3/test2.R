library(readxl)
library(dplyr)
library(ggplot2)

#############################################################################

# 1. 엑셀 데이터 불러오기
data <- read_excel("week3/data/Cafe_Sales.xlsx")

# 2. 카페에서 가장 많이 판매한 메뉴 확인하기
freq_df <- table(data$item) %>% data.frame()
freq_df %>% filter(Freq==max(freq_df$Freq))

# 3. 요일별로 판매한 메뉴 확인하기 & 5. 시각화
data$weekdays <- weekdays(as.Date(data$order_date))
data_by_weekdays <- data %>% select(item, weekdays) %>% table() %>% data.frame()
ggplot(data_by_weekdays, aes(x=weekdays, y=Freq, fill=item)) + 
  geom_bar(stat="identity", position="stack")

# 4. 계절별로 판매한 메뉴 확인하기 & 5. 시각화화
data$month <- months(as.Date(data$order_date))
data$season <- ifelse(data$month %in% c('3월', '4월', '5월'), '봄', 
                      ifelse(data$month %in% c('6월', '7월', '8월'), '여름',  
                             ifelse(data$month %in% c('9월', '10월', '11월'), '가을', '겨울')))
data_by_season <- data %>% select(item, season) %>% table() %>% data.frame()
ggplot(data_by_season, aes(x=season, y=Freq, fill=item)) + 
  geom_bar(stat="identity", position="stack")


# 6. 매출 현황 그래프로 분석하기
## 6-1. 카테고리별 판매 건수 시각화하기
table(data$category)
ggplot(data = data,
       aes(x = category)) +
  geom_bar()

## 6-2. 월별 판매 건수 시각화하기
table(data$month)
ggplot(data = data,
       aes(x = month)) +
  geom_bar()

## 6-3. 요일별 판매 건수 시각화하기
table(data$weekdays)
ggplot(data = data,
       aes(x = weekdays)) +
  geom_bar()


#############################################################################

# 데이터 불러오기
data <- read_excel("week3/data/abtest.xlsx")

# raster 패키지를 이용하여 대한민국 지도 그리기
library(raster)

# 국가
korea = getData(name = "GADM",
                country = "kor",
                level = 0)

# 시도
korea_sido = getData(name = "GADM",
                     country = "kor",
                     level = 1)

# 시군구
korea_sigungu = getData(name = "GADM",
                        country = "kor",
                        level = 2)

# 국가
p1 = ggplot(korea) +
  geom_polygon(aes(x = long, y = lat, group = group),
               fill = "white", color = "black") +
  labs(title = "Korea") +
  theme(axis.ticks = element_blank(),
        axis.title = element_blank(),
        axis.text = element_blank())
p1

# 시도
p2 = ggplot(korea_sido) +
  labs(title = "Sido") +
  geom_polygon(aes(x = long, y = lat, group = group),
               fill = "white", color = "black") +
  theme(axis.ticks = element_blank(),
        axis.title = element_blank(),
        axis.text = element_blank())
p2

# 시군구
p3 = ggplot(korea_sigungu) +
  geom_polygon(aes(x = long, y = lat, group = group),
               fill = "white", color = "black") +
  labs(title = "Sigungu") +
  theme(axis.ticks = element_blank(),
        axis.title = element_blank(),
        axis.text = element_blank())
p3


# stats 패키지 기반 통계적 검정하기
library(stats)



# ggplot1 패키지를 이용하여 광고 효과가 없는 지역 표현하기

#############################################################################

library(rvest)

# 데이터 불러오기
url <- "https://search.naver.com/search.naver?where=news&sm=tab_jum&query=%EC%A0%84%EA%B8%B0%EC%9E%90%EB%8F%99%EC%B0%A8"
page <- read_html(url)
page

# 뉴스리스트 추출하기
newslist <- html_node(page, ".group_news")
newslist

# 뉴스 제목
titles <- html_nodes(newslist, "a[title]") %>% html_text()
titles

# 뉴스 내용
contents <- html_nodes(newslist, "a.dsc_txt_wrap") %>% html_text()
contents

# 뉴스 제목과 내용 합치기
news_df <- data.frame(titles, contents)
news_df


# 명사 추출
newsnoun <- sapply(c(news_df$contents, news_df$titles), extractNoun, USE.NAMES = F)
newsnoun <- unlist(newsnoun)
newsnoun

newsnoun <- Filter(function(x) {nchar(x) >= 2}, newsnoun)
head(newsnoun)

wordcount <- table(newsnoun)
head(sort(wordcount, decreasing = T),30)


# 워드클라우드
palete<- brewer.pal(9,"Set1")
wordcloud(names(wordcount),
          freq=wordcount,
          scale=c(2,1),
          rot.per = 0.25,
          min.freq = 2,
          random.order = F,
          random.color = T,
          colors=palete)




