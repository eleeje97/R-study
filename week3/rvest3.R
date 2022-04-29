### 공공데이터포털 OpenAPI 목록 ###
library(rvest)
openapi_page <- read_html("https://www.data.go.kr/tcs/dss/selectDataSetList.do")
title <- openapi_page %>% html_nodes("#apiDataList .title") %>% html_text()
desc <- openapi_page %>% html_nodes("#apiDataList .publicDataDesc") %>% html_text()

title <- gsub("[|\r|\n|\t]", "", title)
title

desc <- gsub("[|\r|\n|\t]", "", desc)
desc

api_list <- data.frame(title, desc)
api_list


### 네이버 영화 네티즌 평점 ###
movie_page <- read_html("https://movie.naver.com/movie/point/af/list.naver")
list <- movie_page %>% html_node(".list_netizen")
title <- list %>% html_nodes(".title a.movie") %>% html_text()
review_score <- list %>% html_nodes(".list_netizen_score em") %>% html_text()

# 리뷰 데이터
review <- list %>% html_nodes(".title") %>% html_text()
index.start <- regexpr("\t별점 -", review)
index.end <- regexpr("\t신고", review)
review <- substring(review, index.start, index.end)
review <- substring(review, 16)
review <- gsub("[|\r|\n|\t]", "", review)
review <- trimws(review, "both")

movie_review <- data.frame(title, review_score, review)
movie_review


### 네이버 영화 리뷰 1-5페이지 추출 ###
url.page <- "https://movie.naver.com/movie/point/af/list.naver?&page="
page.start <- 1
page.end <- 5

review.page <- NULL
for (p in page.start:page.end) {
  page <- read_html(paste(url.page, p, sep = ""))
  list <- page %>% html_node(".list_netizen")
  title <- list %>% html_nodes(".title a.movie") %>% html_text()
  review_score <- list %>% html_nodes(".list_netizen_score em") %>% html_text()
  
  review <- list %>% html_nodes(".title") %>% html_text()
  index.start <- regexpr("\t별점 -", review)
  index.end <- regexpr("\t신고", review)
  review <- substring(review, index.start, index.end)
  review <- substring(review, 16)
  review <- gsub("[|\r|\n|\t]", "", review)
  review <- trimws(review, "both")
  
  movie_review <- data.frame(title, review_score, review)
  review.page <- rbind(review.page, movie_review)
}



