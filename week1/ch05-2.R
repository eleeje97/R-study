### 데이터 가공하기 ###

# 패키지와 데이터 로드
library(readxl)
exdata <- read_excel("week1/data/0414/Sample1.xlsx")
    # CAR_YN = 차량 소유 여부
    # AMT = 금액
    # CNT = 이용건수

# 선택한 변수만 추출하기
exdata %>% select(ID, AREA, Y21_CNT)
exdata %>% select(-AREA)
exdata %>% filter(AREA=="서울")
exdata %>% filter(AREA=="경기" & CAR_YN==1)
exdata %>% filter(AREA=="제주" & SEX=="F") %>% summarise(count=n())
exdata %>% arrange(AGE, desc(AREA))
exdata %>% group_by(AREA) %>% summarise(TOTAL=sum(Y21_AMT))

## 데이터 결합하기
data_m <- read_excel("week1/data/0414/Sample2_m_history.xlsx")
data_f <- read_excel("week1/data/0414/Sample3_f_history.xlsx")

# 1) 세로결합 (행 결합)
bind_rows(data_m, data_f)

# 2) 가로결합 (열 결합)
data_y21 <- read_excel("week1/data/0414/Sample4_y21_history.xlsx") # 데이터개수: 8
daya_y20 <- read_excel("week1/data/0414/Sample5_y20_history.xlsx") # 데이터개수: 9

# 2-1) left join: 지정한 변수와 테이블1을 기준으로 결합한다.
left_join(data_y21, daya_y20, by = "ID") # 데이터개수: 8
left_join(daya_y20, data_y21, by = "ID") # 데이터개수: 9

# 2-2) inner join: 테이블1과 테이블2 기준으로 지정한 변수 값이 동일할 때만 결합한다.
inner_join(data_y21, daya_y20, by = "ID") # 데이터개수: 7

# 2-3) full join: 테이블1과 테이블2 기준으로 지정한 변수 값 전체를 결합한다.
full_join(data_y21, daya_y20, by = "ID") # 데이터개수: 10

# 연습문제
exdata %>% filter(AGE<=30 & Y20_CNT>=10) %>% arrange(desc(AGE), Y20_CNT)
