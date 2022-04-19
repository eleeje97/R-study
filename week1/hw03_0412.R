# Q1. seq() 함수를 사용하여 date4라는 변수에 2015년 1월 1일부터 2015년 1월 31일까지 
# 1일씩 증가하는 31개의 날짜를 입력하는 방법을 쓰세요.
date4 <- seq(as.Date("2015-01-01"), as.Date("2015-01-31"), by = "day")
date4

# Q2. vec1에서 3번째 요소인 '감'을 제외하고 vec1의 값을 출력하세요.
vec1 <- c("사과", "배", "감", "버섯", "고구마")
vec1[-3]

# Q3.
vec1 <- c("봄", "여름", "가을", "겨울")
vec2 <- c("봄", "여름", "늦여름", "초가을")

# 1) vec1과 vec2의 내용을 모두 합친 결과를 출력하는 코드를 쓰세요.
union(vec1, vec2)

# 2) vec1에는 있는데 vec2에는 없는 결과를 출력하는 코드를 쓰세요.
##### 내장함수 사용
setdiff(vec1, vec2)

##### for문 사용
for (i in 1:length(vec1)) {
  if (vec1[i] != vec2[i]) {
    print(vec1[i])
  }
}

# 3) vec1과 vec2 모두에 있는 결과를 출력하는 코드를 쓰세요.
##### 내장함수 사용
intersect(vec1, vec2)

##### for문 사용
for (i in 1:length(vec1)) {
  if (vec1[i] == vec2[i]) {
    print(vec1[i])
  }
}