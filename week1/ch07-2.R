### 해외 입국자 추이 확인하기 ###

# 데이터 불러오기
library(readxl)
entrance_data <- read_excel("week1/data/ch07/entrance_data.xls")

# 컬럼명 변경
colnames(entrance_data) <- c("country", "JAN", "FEB", "MAR", "APR", "MAY", "JUN", 
                             "JUL", "AUG", "SEP", "OCT", "NOV", "DEC")

# 공백 제거
entrance_data$country <- gsub(" ", "", entrance_data$country)

# 상위 5개국 추출하기
nrow(entrance_data) # 총 국가 수 확인
top5_country <- entrance_data[order(-entrance_data$JAN),] |> head(n = 5)

# 데이터 재구조화
library(reshape2)
top5_melt <- melt(top5_country, id.vars = "country", variable.name = "month")
head(top5_melt)

## 시각화하기
# 선 그래프
library(ggplot2)
ggplot(top5_melt, aes(x = month, y = value, group = country)) +
  geom_line(aes(color = country)) +
  ggtitle("2020년 국적별 입국 수 변화 추이") +
  scale_y_continuous(breaks = seq(0, 500000, 50000))

# 막대 그래프
ggplot(top5_melt, aes(x = month, y = value, fill = country)) +
  geom_bar(stat = "identity", position = "dodge")

# 누적 막대 그래프
ggplot(top5_melt, aes(x = month, y = value, fill = country)) +
  geom_bar(stat = "identity", position = "stack")
