### 연관 분석 ###
library(arules)

# transactions 데이터 가져오기
data("Groceries")

# 최대 길이 3 이내로 규칙 생성
rules <- apriori(Groceries, parameter = list(supp=0.001, conf=0.80, maxlen=3))
inspect(rules)

# confidence 기준 내림차순으로 규칙 정렬
rules <- sort(rules, decreasing=T, by="confidence")
inspect(head(rules))

# 시각화
library(arulesViz)
plot(rules, method="graph", control=list(type="items"))
