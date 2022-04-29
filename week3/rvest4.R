### 네이버 영화 현재 상영작 페이지 ###
# 1. 제목 추출
# 2. 관람 제한 연령 추출
# 3. 제한연령에 따른 분포 시각화

library(rvest)
movie_page <- read_html("https://movie.naver.com/movie/running/current.naver")
movie_list <- movie_page %>% html_nodes(".tit")
movie_title <- movie_list %>% html_nodes("a") %>% html_text()
movie_age_limit <- movie_list %>% html_nodes("span") %>% html_text()

barplot(table(movie_age_limit)[c(3,1,2,4)], 
        main = "제한 연령별 현재 상영작 수",
        ylim = c(0, 50))
#####################################
movie_df <- NULL
i <- 1
for (i in 1:length(movie_list)) {
  movie_title <- movie_list[i] %>% html_node("a") %>% html_text()
  movie_age_limit <- movie_list[i] %>% html_node("span") %>% html_text()
  movie_df <- rbind(movie_df, data.frame(movie_title, movie_age_limit))
}

library(dplyr)
filter(movie_df, movie_age_limit == "15세 관람가")$movie_title

barplot(table(movie_df$movie_age_limit)[c(3,1,2,4)], 
        main = "제한 연령별 현재 상영작 수",
        ylim = c(0, 50))

