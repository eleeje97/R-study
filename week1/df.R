### 데이터 프레임 ###
english <- c(90, 80, 60, 70)
math <- c(50, 60, 100, 20)
df_midterm <- data.frame(english, math)

class <- c(1, 1, 2, 2)
df_midterm <- data.frame(english, math, class)

# 열을 가져오는 두 가지 방법
mean(df_midterm$english)
mean(df_midterm[,1])

# 데이터 프레임 한 번에 만들기
df_midterm <- data.frame(english = c(90, 80, 60, 70),
                         math = c(50, 60, 100, 20),
                         class = c(1, 1, 2, 2))
