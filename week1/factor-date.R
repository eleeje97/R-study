### 파일 가져오기 & factor ###
txt1 <- read.csv("./week1/factor_test.txt") # 데이터프레임으로 들어옴
txt1
summary(txt1)

factor1 <- factor(txt1$blood)
factor1
summary(factor1)

factor2 <- factor(txt1$sex)
factor2
summary(factor2)

### 날짜와 시간 ###
Sys.Date()
Sys.time()
date()
as.Date("2022년 04월 13일", format("%Y년 %m월 %d일"))

# 10일 후, 10일 전
as.Date(10, origin="2022-04-13")
as.Date(-10, origin="2022-04-13")

# 날짜 타입으로 변경한 후 덧셈/뺄셈 연산 가능
as.Date("2022-10-01") - as.Date("2022-04-13")

### 날짜 관련 패키지 ###
library(lubridate)
date <- now()
date

year(date)
month(date, label = T)
month(date, label = F)
day(date)
wday(date, label = T)
wday(date, label = F)

date <- date - days(2)
date

month(date) <- 2
date
date + years(1)
date + months(1)
date + hours(1)
date + minutes(1)
date + seconds(1)

date <- hm("22:30")
date

date <- hms("22:30:15")
date
