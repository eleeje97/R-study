# Q1. data.frame()과 c()를 조합해서 표의 내용을 데이터 프레임으로 만들어 출력해보세요.
df_fruit <- data.frame(product = c("Apple", "Strawberry", "Watermelon"),
                       price = c(1800, 1500, 3000),
                       sale = c(24, 38, 13))
df_fruit

# Q2. 앞에서 만든 데이터 프레임을 이용해서 과일 가격 평균, 판매량 평균을 구해보세요.
print(paste("가격 평균: ", mean(df_fruit$price)))
print(paste("판매량 평균: ", mean(df_fruit$sale)))