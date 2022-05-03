### 군집분석 ###
x <- matrix(1:9, nrow=3, by=T)

# 유클리드 거리 생성 함수
dist <- dist(x, method = "euclidean")

# 유클리드 거리 계산 식
sqrt(sum((x[1,] - x[2,])^2))
sqrt(sum((x[1,] - x[3,])^2))
sqrt(sum((x[2,] - x[3,])^2))

### 계층적 군집분석 - 상향식 ###
# 데이터 읽어오기
body <- read.csv("week4/bodycheck.csv", header = TRUE)

# 칼럼 확인
names(body)

# 불필요한 칼럼 제거
body <- body[, -1]
body

# 유클리드 거리 구하기
idist <- dist(body, method = "euclidean")
idist

# hclust()함수를 이용하여 클러스터링
hc <- hclust(idist)
hc

# 클러스터링 시각화 하기
plot(hc, hang=-1)

# 3개 그룹 선정, 선 색 지정
rect.hclust(hc, k=3, border="red")

