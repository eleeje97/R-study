### 대한민국 시도별 인구 수 단계 구분도 만들기 ###

# 한국 데이터 가져오기
devtools::install_github("cardiomoon/kormaps2014")
library(kormaps2014)
str(changeCode(korpop1))

# 필요한 컬럼 이름 바꾸기
library(dplyr)
korpop1 <- rename(korpop1,
                  pop = 총인구_명,
                  name = 행정구역별_읍면동)
str(changeCode(kormap1))

# 단계 구분도 만들기
ggChoropleth(data = korpop1,
             aes(fill = pop,
                 map_id = code,
                 tolltip = name),
             map = kormap1,
             interactive = T)


### 대한민국 시도별 결핵환자 수 단계 구분도 만들기 ###
str(changeCode(tbc))
tbc$name <- iconv(tbc$name, "UTF-8", "CP949")
ggChoropleth(data = tbc,
             aes(fill = NewPts,
                 map_id = code,
                 tooltip = name),
             map = kormap1,
             interactive = T)
