### 은행 데이터 분석 ###

# 데이터 불러오기
bank_data_raw <- read.csv("week3/testdata/bnk05.csv")

# 20대와 30대 연령대에 해당하는 고객 추출
library(dplyr)
bank_data <- bank_data_raw %>% filter(age >= 20 & age < 40)
head(bank_data)

# 1. 20대에 해당하는 고객 추출
bank_data_20 <- bank_data %>% filter(age < 30)
table(bank_data_20$job)

# 2-1. 연령 분포 플롯
library(ggplot2)
bank_data_age <- table(bank_data$age) %>% data.frame()
bank_data_age <- rename(bank_data_age, Age = "Var1", Count = "Freq")
ggplot(data = bank_data_age,
       aes(x = Age, y = Count)) +
  geom_col()

# 2-2. duration 분포 플롯
temp <- (bank_data$duration %/% 100) * 100
bank_data_duration <- table(temp) %>% data.frame()
bank_data_duration <- rename(bank_data_duration, Duration = "temp", Count = "Freq")
ggplot(data = bank_data_duration,
       aes(x = Duration, y = Count)) +
  geom_col()

# 2-3. 연령과 잔고의 scatterplot
bank_data_age_bal <- bank_data %>% select(age, balance)
plot(x = bank_data_age_bal$age, y = bank_data_age_bal$balance,
     xlab = "연령", ylab = "잔고")

# 2-4. jitter를 활용한 플롯 (point는 반투명한 blue) 
plot(x = jitter(bank_data_age_bal$age), y = bank_data_age_bal$balance,
     xlab = "연령", ylab = "잔고",
     col = adjustcolor("blue", alpha=0.3),
     cex = 0.5)

# 2-5. 결혼상태별 고객 수 막대 차트
bank_data_marital <- bank_data_20$marital %>% table() %>% data.frame()
bank_data_marital <- rename(bank_data_marital, state=".", count="Freq")
barplot(bank_data_marital$count, main = "<20대의 결혼상태 분포>",
        xlab = "결혼 상태", ylab = "고객 수(명)",
        name = bank_data_marital$state)

# 2-6. 잔고와 duration간 분포를 보여주는 scatterplot과 선형회귀선
lm(balance ~ duration, data = bank_data) # 절편: 1040.1741, 기울기: 0.3808
ggplot(bank_data,
       aes(x = balance, y = duration)) +
  geom_point(size=1) +
  geom_abline(intercept = 1040.1741, slope = 0.3808, col = "red")

# 2-7. 결혼상태가 single인 경우는 blue, 아니라면 red인 반투명 point로 색상 변경
ggplot(bank_data,
       aes(x = balance, y = duration, color = marital)) +
  scale_colour_manual(values=alpha(c("red", "red", "blue"), 0.3)) +
  geom_point(size=1) +
  geom_abline(intercept = 1040.1741, slope = 0.3808, col = "red")

# 2-8. duration과 balance 각각에 대한 중위수를 기준으로 수직, 수평의 보조 구분 선
ggplot(bank_data,
       aes(x = balance, y = duration, color = marital)) +
  scale_colour_manual(values=alpha(c("red", "red", "blue"), 0.3)) +
  geom_point(size=1) +
  geom_abline(intercept = 1040.1741, slope = 0.3808, col = "red") +
  geom_hline(yintercept = median(bank_data$duration), col = "purple") +
  geom_vline(xintercept = median(bank_data$balance), col = "navy")

# 2-9. 개인대출여부 별 잔고분포 boxplot
bank_data_loan_bal <- bank_data %>% select(loan, balance)
ggplot(bank_data_loan_bal,
       aes(x = loan, y = balance, group = loan)) +
  geom_boxplot()

# 2-10. 직업별 잔고의 중위수 막대 플롯
bank_data_job_bal <- bank_data %>% group_by(job) %>% summarise(bal_median = median(balance))
ggplot(bank_data_job_bal,
       aes(x = job, y = bal_median)) +
  geom_col() +
  labs(x = "직업", y = "잔고 중위 수")

# 2-11. 직업이 학생이면 blue, 아니면 grey
bank_data_job_bal$isStudent <- ifelse(bank_data_job_bal$job == "student", "yes", "no")
ggplot(bank_data_job_bal,
       aes(x = job, y = bal_median, fill = isStudent)) +
  scale_fill_manual(values=c("grey", "blue")) +
  geom_col() +
  labs(x = "직업", y = "잔고 중위 수") +
  theme(axis.text.x = element_text(angle = 90))

# 2-12. 20대 전체의 잔고 중위수 값을 기준으로 수평 보조선 추가
bank_data_bal_mean_20 <- median(bank_data_20$balance)
ggplot(bank_data_job_bal,
       aes(x = job, y = bal_median, fill = isStudent)) +
  scale_fill_manual(values=c("grey", "blue")) +
  geom_col() +
  labs(x = "직업", y = "잔고 중위 수") +
  theme(axis.text.x = element_text(angle = 90)) +
  geom_hline(yintercept = bank_data_bal_mean_20)

# 2-13. 20대의 직업별 고객 수 비율
bank_data_job_prop_20 <- prop.table(table(bank_data_20$job))

# 2-14. 전체 고객의 직업별 비율을 구한 수, 하나의 데이터프레임으로 결합
bank_data_job_prop <- prop.table(table(bank_data$job))
bank_data_job_prop_20 <- bank_data_job_prop_20 %>% data.frame() %>% rename(Job="Var1", Prop_20="Freq")
bank_data_job_prop <- bank_data_job_prop %>% data.frame() %>% rename(Job="Var1", Prop_all="Freq")
bank_data_job_prop <- merge(bank_data_job_prop, bank_data_job_prop_20, by="Job")

# 2-15. 20대와 전체의 각 직업별 구성비 차이를 비교하는 막대 플롯
barplot()

# 2-16. 30대 고객의 연령과 잔고 간 scatterplot과 20대의 것을 각각의 플롯으로 비교
