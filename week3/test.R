### 은행 데이터 분석 ###

# 데이터 불러오기
bank_data_raw <- read.csv("week3/testdata/bnk05.csv")
bank_data <- bank_data_raw
head(bank_data)

# age, job, marital 컬럼 뽑기
library(dplyr)
temp <- bank_data %>% select(age, job, marital)
temp

# pdays 컬럼 데이터 빈도수 확인 -> 이상치 확인
table(bank_data$pdays)

# 이상치를 결측치로 변환
bank_data$pdays <- ifelse(bank_data$pdays == 999, NA, bank_data$pdays)
sum(is.na(bank_data$pdays))
summary(bank_data$pdays)

# 나이대별 평균연간잔고 선 그래프
library(ggplot2)
ggplot(data = bank_data,
       aes(x = age, y = balance)) +
  geom_line()
summary(bank_data$balance)

# 직업 빈도 수 막대 그래프 (내림차순)
table(bank_data$job)
temp <- bank_data %>% filter(!job == "unknown")
table(temp$job)
job_cnt <- table(temp$job) %>% data.frame
job_cnt <- rename(job_cnt, Job = "Var1", Frequency = "Freq")
job_cnt <- job_cnt %>% arrange(desc(Frequency))

barplot(job_cnt$Frequency, names = job_cnt$Job,
        main = "직업별 빈도 수", ylim = c(0,2500),
        las=2)

ggplot(data = job_cnt, 
       aes(x = reorder(Job, -Frequency), y = Frequency)) + geom_col()
ggplot(data = job_cnt, 
       aes(x = reorder(Job, Frequency), y = Frequency)) + geom_col() + coord_flip()

library(psych)
describe(bank_data$age)

library(tibble)
tmp <- tibble(bank_data)
