### 그래프 그리기 ###
library(ggplot2)

# 그래프 기본 틀 생성하기
str(airquality)
ggplot(airquality, aes(x = Day, y = Temp)) # aes는 x축과 y축 지정하는 옵션

# 산점도 그리기
ggplot(airquality, aes(x = Day, y = Temp)) + geom_point(size = 3, color = "orange")

# 그래프 지우기
plot.new()

# 선 그래프 그리기
ggplot(airquality, aes(x = Day, y = Temp)) + geom_line()

# 막대 그래프 그리기
ggplot(mtcars, aes(x = cyl)) + geom_bar(width = 0.5)
ggplot(mtcars, aes(x = factor(cyl))) + geom_bar(width = 0.5)

# 누적 막대 그래프 그리기
ggplot(mtcars, aes(x = factor(cyl))) + geom_bar(aes(fill = factor(gear)))

# 선버스트 차트 (누적 막대 그래프 이용)
ggplot(mtcars, aes(x = factor(cyl))) + 
  geom_bar(aes(fill = factor(gear))) + 
  coord_polar()

ggplot(mtcars, aes(x = factor(cyl))) + 
  geom_bar(aes(fill = factor(gear))) + 
  coord_polar(theta = "y")

# 상자 그림 그리기
ggplot(airquality, aes(x = Day, y = Temp, group = Day)) + geom_boxplot()

# 히스토그램
ggplot(airquality, aes(Temp)) + geom_histogram(binwidth = 1)

# 선 그래프와 산점도 함께 그리기
ggplot(airquality, aes(x = Day, y = Temp)) +
  geom_line(color = "blue") +
  geom_point(size = 3)
