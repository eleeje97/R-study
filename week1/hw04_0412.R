# Q1. 아래 그림과 같은 형태의 행렬을 만드세요.
v <- c("봄", "여름", "가을", "겨울")
seasons <- matrix(v, 2, 2)
seasons

seasons <- matrix(v, 2, 2, byrow = TRUE)
seasons

# Q2. 아래 그림과 같이 seasons 행렬에서 여름과 겨울만 조회하는 방법을 쓰세요.
seasons
seasons[,2]

# Q3. 아래 그림과 같이 seasons 행렬에 3번 행을 추가하여 seasons_2 행렬을 만드세요.
seasons
seasons_2 <- rbind(seasons, c("초봄", "초가을"))
seasons_2

# Q4. 아래 그림처럼 seasons_2 변수에 열을 추가하여 seasons_3 행렬을 만드세요.
seasons_2
seasons_3 <- cbind(seasons_2, c("초여름", "초겨울", "한겨울"))
seasons_3
