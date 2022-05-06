library(readxl)
customer_r <- read_excel("week4/membership_data/customer_r.xlsx")
item_r <- read_excel("week4/membership_data/item_r.xlsx")
order_info_r <- read_excel("week4/membership_data/order_info_r.xlsx")
reservation_r <- read_excel("week4/membership_data/reservation_r.xlsx")

colnames(customer_r) <- tolower(colnames(customer_r))
colnames(item_r) <- tolower(colnames(item_r))
colnames(order_info_r) <- tolower(colnames(order_info_r))
colnames(reservation_r) <- tolower(colnames(reservation_r))

library(dplyr)
library(ggplot2)

# 지점별 예약 건수 확인
table(reservation_r$branch)
no_cancel_data <- reservation_r %>% filter(cancel == "N")
table(no_cancel_data$branch)

# 주요 지점들의 메뉴 아이템 매출 구성 확인
## 예약, 주문 테이블 조인
df_f_join_1 <- inner_join(reservation_r, order_info_r, by = "reserv_no")

## df_f_join_1과 메뉴 테이블 조인
df_f_join_2 <- inner_join(df_f_join_1, item_r, by = "item_id")
head(df_f_join_2)

## 강남, 마포, 서초 지점만 선택
df_branch_sales <- df_f_join_2 %>% 
  filter(branch == "강남" | branch == "마포" | branch == "서초") %>% 
  group_by(branch, product_name) %>% 
  summarise(sales_amt = sum(sales) / 1000)

## 누적 막대 그래프
ggplot(df_branch_sales, aes(x = "", y = sales_amt, fill = product_name)) +
  facet_grid(facets = . ~ branch) +
  geom_bar(stat = "identity")

## 파이 차트
ggplot(df_branch_sales, aes(x = "", y = sales_amt, fill = product_name)) +
  facet_grid(facets = . ~ branch) +
  geom_bar(stat = "identity") +
  coord_polar("y", start = 0)

# 지점별 메뉴 아이템 주문 비율
## 주요 지점 선택
df_branch_items <- df_f_join_2 %>% filter(branch == "강남" | branch == "마포" | branch == "서초")

## 교차 빈도표 생성
table(df_branch_items$branch, df_branch_items$product_name)

## 데이터 프레임 형태로 변환
df_branch_items_table <- as.data.frame(table(df_branch_items$branch, df_branch_items$product_name))

df_branch_items_percent <- df_branch_items_table %>% 
  group_by(df_branch_items_table$Var1) %>% 
  mutate(percent_items = Freq/sum(Freq) * 100)

head(df_branch_items_percent)

## 누적 막대 그래프
ggplot(df_branch_items_percent, aes(x = Var1, y = percent_items, group = Var1, fill = Var2)) +
  geom_bar(stat = "identity") +
  labs(title = "지점별 주문 건수 그래프", x = "지점", y = "메뉴 아이템 판매비율", fill = "메뉴 아이템")


# 여러 번 방문하는 고객이 다수이며 이들이 많은 매출을 일으킬 것이다.
## 예약, 주문 테이블 조인
df_rfm_join_1 <- inner_join(reservation_r, order_info_r, by = "reserv_no")
head(df_rfm_join_1)

## 고객 번호별로 방문횟수와 매출 확인
df_rfm_data <- df_rfm_join_1 %>% 
  group_by(customer_id) %>% 
  summarise(visit_sum = n_distinct(reserv_no), sales_sum = sum(sales) / 1000) %>% 
  arrange(customer_id)
df_rfm_data
summary(df_rfm_data)

## 상자 그림
ggplot(df_rfm_data, aes(x = "", y = visit_sum)) +
  geom_boxplot(width = 0.8, outlier.size = 2, outlier.colour = "red") +
  labs(title = "방문 횟수 상자그림", x = "빈도", y = "방문횟수")

ggplot(df_rfm_data, aes(x = "", y = sales_sum)) +
  geom_boxplot(width = 0.8, outlier.size = 2, outlier.colour = "red") +
  labs(title = "매출 상자그림", x = "매출", y = "금액")


# 멤버십 등급 기준으로 고객 나누기
## 방문 횟수 60%와 90%에 해당하는 분위수 찾기
quantile(df_rfm_data$visit_sum, probs = c(0.6, 0.9))

## 매출 60%와 90%에 해당하는 분위수 찾기
quantile(df_rfm_data$sales_sum, probs = c(0.6, 0.9))

## 총 방문횟수와 총 매출 합
total_sum_data <- df_rfm_data %>% 
  summarise(t_visit_sum = sum(visit_sum), t_sales_sum = sum(sales_sum))

## 우수고객 이상의 방문횟수와 매출 합
loyalty_sum_data <- df_rfm_data %>% 
  summarise(l_visit_sum = sum(ifelse(visit_sum > 2, visit_sum, 0)), l_sales_sum = sum(ifelse(sales_sum > 135, sales_sum, 0)))

## 우수고객이 차지하는 비율
loyalty_sum_data / total_sum_data


# 스테이크와 와인의 매출에 대한 상관 분석
## 동시 주문 건 찾기
target_item <- c("M0005", "M0009")

df_stime_order <- df_f_join_2 %>% 
  filter(item_id %in% target_item) %>% 
  group_by(reserv_no) %>% 
  mutate(order_cnt = n()) %>% 
  distinct(branch, reserv_no, order_cnt) %>% 
  filter(order_cnt == 2) %>% 
  arrange(branch)

## 메뉴 아이템별 매출 계산
stime_order_rsv_no <- df_stime_order$reserv_no
df_stime_sales <- df_f_join_2 %>% 
  filter((reserv_no %in% stime_order_rsv_no) & (item_id %in% target_item)) %>% 
  group_by(reserv_no, product_name) %>% 
  summarise(sales_amt = sum(sales) / 1000) %>% 
  arrange(product_name, reserv_no)
df_stime_sales

steak <- df_stime_sales %>% filter(product_name == "STEAK")
wine <- df_stime_sales %>% filter(product_name == "WINE")

## 매출 상관도
plot(steak$sales_amt, wine$sales_amt)

## 상관 분석
cor.test(steak$sales_amt, wine$sales_amt)



# 의사 결정 나무 기법
## 고객별 스테이크 주문 여부 (종속 변수)

df_rsv_customer <- reservation_r %>% 
  select(customer_id, reserv_no) %>% 
  arrange(customer_id, reserv_no)
head(df_rsv_customer)

df_steak_order_rsv_no <- order_info_r %>% 
  filter(item_id == "M0005") %>% 
  mutate(steak_order = "Y") %>% 
  arrange(reserv_no)
head(df_steak_order_rsv_no)

df_steak_order_1 <- left_join(df_rsv_customer, df_steak_order_rsv_no, by = "reserv_no") %>% 
  group_by(customer_id) %>% 
  mutate(steak_order = ifelse(is.na(steak_order), "N", "Y")) %>% 
  summarise(steak_order = max(steak_order)) %>% 
  arrange(customer_id)

df_dpd_var <- df_steak_order_1
df_dpd_var

## 결측치 제거
df_customer <- customer_r %>% filter(!is.na(sex_code))

## 고객테이블과 예약테이블 조인
df_table_join_1 <- inner_join(df_customer, reservation_r, by = "customer_id")

## df_table_join_1과 주문 테이블 조인
df_table_join_2 <- inner_join(df_table_join_1, order_info_r, by = "reserv_no")
str(df_table_join_2)

## 고객 정보, 성별 정보와 방문 횟수, 방문객 수, 매출 합을 요약
df_table_join_3 <- df_table_join_2 %>% 
  group_by(customer_id, sex_code, reserv_no, visitor_cnt) %>% 
  summarise(sales_sum = sum(sales)) %>% 
  group_by(customer_id, sex_code) %>% 
  summarise(visit_sum = n_distinct(reserv_no), visitor_sum = sum(visitor_cnt), sales_sum = sum(sales_sum) / 1000) %>% 
  arrange(customer_id)
df_idp_var <- df_table_join_3
df_idp_var # 독립변수


df_final_data <- inner_join(df_idp_var, df_dpd_var, by = "customer_id")

df_final_data$sex_code <- as.factor(df_final_data$sex_code)
df_final_data$steak_order <- as.factor(df_final_data$steak_order)

df_final_data <- df_final_data[, c(2:6)]
df_final_data


library(rpart)
library(caret)
library(e1071)

# 난수 생성할 때 계속 무작위 수 생성하지 않고 1만 번대 값을 고정으로 가져옴
set.seed(10000)

# 80% 데이터는 train을 위해 준비하고, 20% 데이터는 test를 위해 준비함
train_data <- createDataPartition(y = df_final_data$steak_order, p = 0.8, list = FALSE)
train <- df_final_data[train_data, ]
test <- df_final_data[-train_data, ]

# rpart를 사용해서 의사 결정 나무 생성
decision_tree <- rpart(steak_order~., data =train)
decision_tree

# 모델의 정확도
predicted <- predict(decision_tree, test,type='class')
confusionMatrix(predicted, test$steak_order)

# 의사 결정 나무 그리기
plot(decision_tree, margin = 0.1)
text(decision_tree)


library(rattle)
fancyRpartPlot(decision_tree)
