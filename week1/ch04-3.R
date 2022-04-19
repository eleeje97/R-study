### 그래프 ###

# 데이터 로드
data = read_excel("week1/data/Sample1.xlsx")
data

# 막대 그래프
freq(data$SEX, plot = T, main = "성별") # 빈도분포 막대그래프로 그리기

barplot(table(data$SEX)) # 데이터만 지정한 경우
barplot(table(data$SEX), ylim = c(0, 14), main = "BARPLOT", 
        xlab = "SEX", ylab = "FREQUENCY",
        names = c("Female", "Male"),
        col = c("navy", "purple"))

# 상자 그림
boxplot(data$Y20_CNT, data$Y21_CNT, main = "BOXPLOT",
        ylim = c(0, 60),
        names = c("20년 건수", "21년 건수"),
        col = c("green", "yellow"))

# 히스토그램
hist(data$AGE, main = "AGE 분포",
     xlim = c(0, 60), ylim = c(0, 7))

# 파이차트
data(mtcars)
pie(table(mtcars$gear))
pie(table(data$AREA))

# 줄기 잎 그림
stem(c(1, 2, 3, 4, 5, 5, 6, 7, 8, 8, 8), scale = 2)

# 산점도(산포도)
plot(x = iris$Sepal.Length, y = iris$Petal.Width)
pairs(iris)
pairs.panels(iris)


## 확인 문제
y1 <- c(10, 15, 20, 30, 40, 50, 55, 66, 77, 80, 90, 100, 200, 225)
# Q1
boxplot(y1)
# Q2
stem(y1)
# Q3
plot(y1)
