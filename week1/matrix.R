### 행과 열에 관련된 함수 ###

# apply(): 이중 for문으로 처리해야 할 연산을 간편하게 처리할 수 있음
x <- matrix(1:4, 2, 2)
apply(x, 1, sum) # margin이 1이면 행연산
apply(x, 2, sum) # margin이 2이면 열연산

View(iris)
apply(iris[, 1:4], 2, sum)
apply(iris[, 1:4], 2, mean)
apply(iris[, 1:4], 2, min)
apply(iris[, 1:4], 2, max)
apply(iris[, 1:4], 2, median)

# lapply(): 결과를 리스트로 반환
lapply(iris[, 1:4], sum)

# sapply(): 결과를벡터로 반환
sapply(iris[, 1:4], mean)
