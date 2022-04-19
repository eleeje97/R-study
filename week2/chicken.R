### 치킨집이 가장 많은 지역 찾기 ###

# 데이터 불러오기
library(readxl)
chicken_data <- read_excel("week2/data/치킨집_가공.xlsx")
head(chicken_data)

# 주소에서 동이름만 추출
addr <- c()
for (i in 1:length(chicken_data$소재지전체주소)) {
  addr <- c(addr, unlist(strsplit(chicken_data$소재지전체주소[i], " "))[3])
}

# addr <- substr(chicken_data$소재지전체주소, 11, 16)
# addr <- gsub("[0-9]", "", addr)
# addr <- gsub(" ", "", addr)

library(dplyr)
addr_count <- addr %>% table() %>% data.frame()
head(addr_count)

# 트리맵 시각화
library(treemap)
treemap(addr_count, index=".", vSize="Freq", title="서대문구 동별 치킨집 분포")

# 내림차순 정렬
addr_count_arrange <- arrange(addr_count, desc(Freq)) %>% head()
treemap(addr_count_arrange, index=".", vSize="Freq", title="서대문구 동별 치킨집 분포")

