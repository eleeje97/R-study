### 자유연습 ###
print('Hello World!')
print("Halo")
print(1+4)

matrix(1:10, 2, 5, byrow = T)

### 데이터 종류 ###
# Vector 벡터: 1차원 배열
ex_vector1 <- c(-1, 0, 1) # combine 함수

mode(ex_vector1) # [1] "numeric"
length(ex_vector1) # [1] 3
str(ex_vector1) # num [1:3] -1 0 1
typeof(ex_vector1) # [1] "double"

rm(ex_vector1) # remove(ex_vector1) >> 동일한 결과

# Category 범주형 자료: factor()
ex_vector2 <- c(1,3,2,2,3,1)
cate_vector <- factor(ex_vector2, labels = c("피자","치킨","곱창"))

# Matrix 행렬: 2차원 배열
ex_matrix <- matrix(1:15, 3, 5) # 열우선
ex_matrix <- matrix(1:15, 5, 3, byrow = T) # 행우선

# Array 배열: n차원 배열
ex_array1 <- array(1:30, dim = c(2, 5, 3)) # 3차원 배열
ex_array2 <- array(1:30, dim = c(2, 5, 3, 2)) # 4차원 배열

# List 리스트
ex_list1 <- list(1:3, "Hello")
ex_list2 <- list(1,2,'3',4,'5')

# Data Frame 데이터 프레임
ID <- 1:10
SEX <- c("F", "M", "F", "M", "M", "F", "F", "F", "M", "F")
AGE <- c(50, 40, 28, 50, 27, 23, 56, 47, 20, 38)
AREA <- c("서울", "경기", "제주", "서울", "서울", "서울", "경기", "서울", "인천", "경기")
ex_dataframe <- data.frame(ID, SEX, AGE, AREA)

