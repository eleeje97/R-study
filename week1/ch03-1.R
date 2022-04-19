### 내장함수 ###

# 배열 관련
array <- 1:100
sum(array)
max(array)
min(array)

# 현재 시간
Sys.Date()

### 사용자 정의 함수 ###
getSum <- function(array) {
  return(sum(array))
}
getSum(array)

getSumByLoop <- function(array) {
  sum <- 0
  for(i in 1:length(array)) {
    sum = sum + array[i]
  }
  return(sum)
}
getSumByLoop(array)
