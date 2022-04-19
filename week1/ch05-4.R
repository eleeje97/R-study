### 데이터 정제하기 ###

# 결측치 확인하기
x <- c(1, 2, NA, 4, 5)
x
sum(x)
is.na(x)
table(is.na(x))
sum(is.na(x)) # 결측치 개수 확인

# 결측치 제외하기
sum(x, na.rm = T)
colSums(is.na(airquality))

# 결측치 제거하기
na.omit(airquality) # 결측치가 있는 행 제거

# 결측치 대체하기
airquality[is.na(airquality)] <- 0
colSums(is.na(airquality))

# 이상치 확인하기
data(mtcars)
boxplot(mtcars$wt)
boxplot(mtcars$wt)$stats

# 이상치 처리하기
mtcars$wt <- ifelse(mtcars$wt > 5.25, NA, mtcars$wt)
