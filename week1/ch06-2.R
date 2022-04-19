### 그래프에 객체 추가하기 ###
library(ggplot2)

# 사선 그리기
ggplot(economics, aes(x = date, y = psavert)) +
  geom_line() +
  geom_abline(intercept = 12.18671, slope = -0.0005444)

# 평행선 그리기 
ggplot(economics, aes(x = date, y = psavert)) +
  geom_line() +
  geom_hline(yintercept = mean(economics$psavert))

# 수직선 그리기
library(dplyr)
x_inter <- filter(economics, psavert == min(economics$psavert))$date
ggplot(economics, aes(x = date, y = psavert)) +
  geom_line() +
  geom_vline(xintercept = x_inter) #geom_vline(xintercept = as.Date("2005-07-01"))

# 레이블 입력하기
ggplot(airquality, aes(x = Day, y = Temp)) +
  geom_point() +
  geom_text(aes(label = Temp, vjust = 0, hjust = 0))

# 도형 및 화살표 넣기
ggplot(mtcars, aes(x = wt, y = mpg)) +
  geom_point() +
  annotate("rect", xmin = 3, xmax = 4, ymin = 12, ymax = 21,
           alpha = 0.5, fill = "skyblue")

ggplot(mtcars, aes(x = wt, y = mpg)) +
  geom_point() +
  annotate("rect", xmin = 3, xmax = 4, ymin = 12, ymax = 21,
           alpha = 0.5, fill = "skyblue") +
  annotate("segment", x = 2.5, xend = 3.7, y = 10, yend = 17,
           color = "red", arrow = arrow()) +
  annotate("text", x = 2.5, y = 10, label = "point")

# 그래프 제목 및 축 제목 추가하기
ggplot(mtcars, aes(x = gear)) + geom_bar() +
  labs(x = "기어수", y = "자동차수", title = "변속기 기어별 자동차수")

### 회귀분석 ###
library(readxl)
exdata <- read_excel("week1/data/0414/Sample1.xlsx")

# 상관분석: 두 변수 간의 상관관계 확인하기
cor.test(exdata$Y20_CNT, exdata$Y21_CNT)

# 절편과 기울기 구하기
reg_result <- lm(Y20_CNT ~ Y21_CNT, data = exdata)
reg_result

# 시각화
library(ggplot2)
ggplot(exdata, aes(x = Y20_CNT, y = Y21_CNT)) +
  geom_line() +
  geom_abline(intercept = reg_result$coefficients[1], slope = reg_result$coefficients[2])
