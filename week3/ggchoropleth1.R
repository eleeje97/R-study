### 미국 주별 강력 범죄율 단계 구분도 만들기 ###

library("ggiraphExtra")

# 미국 강력범죄 데이터
head(USArrests)

# 인덱스(state 이름)을 컬럼화
library(tibble)
crime <- rownames_to_column(USArrests, var = "state")

# state 이름을 소문자로 수정
crime$state <- tolower(crime$state)
head(crime)

# 미국 state 지도 데이터 준비하기
library(ggplot2)
states_map <- map_data("state")
head(states_map)

# 단계 구분도 만들기
ggChoropleth(data = crime,
             aes(fill = Murder,
                 map_id = state),
             map = states_map)

# 인터랙티브 단계 구분도 만들기
ggChoropleth(data = crime,
             aes(fill = Murder,
                 map_id = state),
             map = states_map,
             interactive = T)
