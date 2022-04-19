### 데이터 구조 변형하기 ###
library(reshape2)
data("airquality")
airquality

# 1) melt(): 변수가 많고 데이터가 적을 때 (열이 긴 형태 -> 행이 긴 형태)
names(airquality) <- tolower(names(airquality)) # 변수명을 소문자로 바꿈
melt_test <- melt(airquality, id.vars = c("month", "wind"), measure.vars = "ozone")

# 2) cast(): 변수가 적고 데이터가 많을 때 (행이 긴 형태 -> 열이 긴 형태)
aq_melt <- melt(airquality, id.vars = c("month", "day"), na.rm = TRUE)
dcast_test <- dcast(aq_melt, month + day ~ variable)
dcast_test

acast_test <- acast(aq_melt, day ~ month ~ variable)
acast_test

# 데이터 요약
acast(aq_melt, month ~ variable, mean)
dcast(aq_melt, month ~ variable, sum)
