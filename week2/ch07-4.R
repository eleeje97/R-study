### 서울시 지역별 미세먼지 농도 차이 비교하기 ###

# 데이터 가져오기
library(readxl)
dust_data <- read_excel("week2/data/ch07/dust_data.xlsx")
head(dust_data)

# 성북구와 중구 데이터 추출하기
library(dplyr)
dust_data_anal <- dust_data[, c("날짜", "성북구", "중구")]

# 결측치 확인하기
sum(is.na(dust_data_anal))

# 기술통계량
library(psych)
describe(dust_data_anal$성북구)
describe(dust_data_anal$중구)

# 상자 그래프 그리기
boxplot(dust_data_anal$성북구, dust_data_anal$중구,
        main = "Finedust Compare", xlab = "AREA", names = c("성북구", "중구"),
        ylab = "FINEDUST PM", col = c("blue", "green"))

# f-검정: 두 집단의 분산이 동일한지 확인 
  # p-value값이 0.5보다 크다 
  # -> 귀무가설을 기각 할 수 없다 
  # -> 두 집단 간 분산이 동일하다
var.test(dust_data_anal$성북구, dust_data_anal$중구)


# t-검정: 변수가 정규분포를 따르고 있을 때 사용가능한 분석 기법
t.test(dust_data_anal$중구, dust_data_anal$성북구, var.equal = T)


### 세 개 이상의 집단 간 평균 차이 검정하기: 분산분석 ###

# 데이터 불러오기
sample_data <- read_excel("week2/data/Sample1.xlsx")

# 상자 그래프 그리기
boxplot(formula = Y20_CNT ~ AREA, data = sample_data)

# 분산분석
anova(lm(Y20_CNT ~ AREA, data = sample_data))

# 일원분산분석: 독립 변수가 1개인 경우
oneway.test(data = sample_data, Y20_CNT ~ AREA, var.equal = T)
