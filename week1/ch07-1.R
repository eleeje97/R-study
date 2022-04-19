### 지역별 국내 휴양림 분포 비교하기 ###

# 데이터 불러오기
library(readxl)
forest_data <- read_excel("week1/data/ch07/forest_data.xls")

# 컬럼명 변경 (한글->영어)
colnames(forest_data) <- c("name", "city", "gubun", "area", 
                           "number", "stay", "city_new",
                           "code", "codename")

# 빈도 분석
library(descr)
freq(forest_data$city, plot = T, main = "City")
barplot(table(forest_data$city), main = "City")

# 빈도분석 - 정렬하여 시각화
library(dplyr)

## 1) 시도명 기준 오름차순
sorted_city_count <- count(forest_data, city) %>% arrange(n)
barplot(sorted_city_count$n, names = sorted_city_count$city, 
        main = "시도명 기준", ylim = c(0,35))

## 2) 소재지_시도명 기준 내림차순
sorted_city_new_count <- count(forest_data, city_new) %>% arrange(desc(n))
barplot(sorted_city_new_count$n, names = sorted_city_new_count$city_new, 
        main = "소재지_시도명 기준", ylim = c(0,35))

## 3) 제공기관명 기준
sorted_codename_count <- count(forest_data, codename) %>% arrange(n)
barplot(sorted_codename_count$n, names = sorted_codename_count$codename, 
        main = "제공기관명 기준", ylim = c(0,20))
