### 내장 데이터 ###
data("iris")
iris

ncol(iris)
nrow(iris)
dim(iris)
ls(iris)

head(iris, n = 3)
tail(iris, n = 5)

### 기술 통계량 ###
# 분위 수
quantile(iris$Sepal.Length)
quantile(iris$Sepal.Length, probs = 0.25)
# 분산과 표준편차
var(iris$Sepal.Length)
sd(iris$Sepal.Length)
# 첨도와 왜도: 데이터의 비대칭도
kurtosi(iris$Sepal.Length)
skew(iris$Sepal.Length)
# 데이터 빈도
freq(iris$Sepal.Length, plot=F) # plot 옵션 지정안하면 막대 그래프 나옴
