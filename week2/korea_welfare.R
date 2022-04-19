### 한국복지패널 데이터 분석

# 패키지 로드
library(foreign) # SPSS 파일 로드
library(dplyr) # 전처리
library(ggplot2) # 시각화
library(readxl) # 엑셀 파일 로드

# 데이터 불러오기
raw_welfare <- read.spss("week2/data/한국복지패널데이터/Koweps_hpc10_2015_beta1.sav", to.data.frame = T)

# 복사본 만들기
welfare <- raw_welfare

# 데이터 검토하기
head(welfare)
tail(welfare)
dim(welfare)

# 변수명 변경
welfare <- rename(welfare,
                  sex = h10_g3,
                  birth = h10_g4,
                  marriage = h10_g10,
                  religion = h10_g11,
                  income = p1002_8aq1,
                  code_job = h10_eco9,
                  code_region = h10_reg7)

### 성별에 따른 월급 차이 ###

# 성별 변수 검토 및 전처리
class(welfare$sex)
table(welfare$sex) # 이상치 확인

welfare$sex <- ifelse(welfare$sex == 9, NA, welfare$sex) # 이상치를 결측치 처리
table(is.na(welfare$sex))

welfare$sex <- ifelse(welfare$sex == 1, "male", "female") # 성별 항목 이름 부여
table(welfare$sex)

qplot(welfare$sex) # 막대 그래프로 성별 변수 확인

# 월급 변수 검토 및 전처리
class(welfare$income)
summary(welfare$income) # NA값이 많은 것을 확인

welfare$income <- ifelse(welfare$income %in% c(0, 9999), NA, welfare$income)
table(is.na(welfare$income))
qplot(welfare$income) + xlim(0, 1000)

# 성별 월급 평균표 만들기
sex_income <- welfare %>% 
  filter(!is.na(income)) %>% 
  group_by(sex) %>% 
  summarise(mean_income = mean(income))
sex_income

# 시각화
ggplot(data = sex_income, aes(x = sex, y = mean_income)) + geom_col()


### 나이와 월급의 관계 ###

# 변수 검토하기
class(welfare$birth)
summary(welfare$birth) # 이상치 확인
table(is.na(welfare$birth)) # 결측치 확인
welfare$birth <- ifelse(welfare$birth == 9999, NA, welfare$birth) # 이상치를 결측치 처리

# 파생변수 만들기 - 나이
welfare$age <- 2015 - welfare$birth + 1
summary(welfare$age)
qplot(welfare$age)

# 나이에 따른 월급 평균표 만들기
age_income <- welfare %>% 
  filter(!is.na(income)) %>% 
  group_by(age) %>% 
  summarise(mean_income = mean(income))

head(age_income)

# 시각화
ggplot(data = age_income, aes(x = age, y = mean_income)) + geom_line()

# 파생변수 만들기 - 연령대
welfare <- welfare %>% 
  mutate(ageg = ifelse(age<30, "young",
                      ifelse(age<=59, "middle", "old")))
table(welfare$ageg)
qplot(welfare$ageg)

# 연령대에 따른 월급 평균표 만들기
ageg_income <- welfare %>% 
  filter(!is.na(income)) %>% 
  group_by(ageg) %>% 
  summarise(mean_income = mean(income))

# 시각화
ggplot(data = ageg_income, aes(x = ageg, y = mean_income)) +
  geom_col() +
  scale_x_discrete(limits = c("young", "middle", "old")) # 출력순서 변경하기 위해 (디폴트는 알파벳순)

### 연령대, 성별에 따른 급여 차이 ###
# 성별 연령별 월급 평균표 만들기
sex_age_income <- welfare %>% 
  filter(!is.na(income)) %>% 
  group_by(ageg, sex) %>% 
  summarise(mean_income = mean(income))

# 시각화
ggplot(data = sex_age_income, aes(x = ageg, y = mean_income, fill = sex)) +
  geom_col() +
  scale_x_discrete(limits = c("young", "middle", "old"))

# 성별에 따른 막대그래프 분리 (position: dodge)
ggplot(data = sex_age_income, aes(x = ageg, y = mean_income, fill = sex)) + 
  geom_col(position = "dodge") + 
  scale_x_discrete(limits = c("young", "middle", "old"))

### 나이, 성별 급여 차이 분석 ###
# 평균표 만들기
sex_age <- welfare %>% 
  filter(!is.na(income)) %>% 
  group_by(age, sex) %>% 
  summarise(mean_income = mean(income))

# 시각화
ggplot(data = sex_age, aes(x = age, y = mean_income, col=sex)) + geom_line()


### 직업별 급여 차이 ###
# 변수 검토 및 전처리
class(welfare$code_job)
table(welfare$code_job)

# 직업코드를 직업명으로 변경
library(readxl)
list_job <- read_excel("week2/data/한국복지패널데이터/Koweps_Codebook.xlsx", col_names = T, sheet = 2)
head(list_job)

welfare <- left_join(welfare, list_job, id = "code_job")
welfare %>% 
  filter(!is.na(code_job)) %>% 
  select(code_job, job) %>% 
  head(10)

# 평균표 만들기
job_income <- welfare %>% 
  filter(!is.na(job) & !is.na(income)) %>% 
  group_by(job) %>% 
  summarise(mean_income = mean(income))

# 상위 10개 추출
top10 <- job_income %>% 
  arrange(desc(mean_income)) %>% 
  head(10)
top10

# 시각화
ggplot(data = top10, aes(x = job, y = mean_income)) + geom_col()
ggplot(data = top10, aes(x = job, y = mean_income)) + geom_col() + coord_flip() # x축과 y축 바꾸기
ggplot(data = top10, aes(x = reorder(job, mean_income), y = mean_income)) # reorder: job을 mean_income 기준으로 정렬)
+ geom_col() + coord_flip()

# 하위 10위 추출
bottom10 <- job_income %>% 
  arrange(mean_income) %>% 
  head(10)
bottom10

# 시각화
ggplot(data = bottom10, aes(x = reorder(job, -mean_income), y = mean_income)) +
  geom_col() +
  coord_flip() +
  ylim(0, 850)


### 성별 직업 빈도 ###
# 성별 직업 빈도표 만들기
job_male <- welfare %>% 
  filter(!is.na(job) & sex == "male") %>% 
  group_by(job) %>% 
  summarise(n = n()) %>% 
  arrange(desc(n)) %>%
  head(10)
job_male

job_female <- welfare %>% 
  filter(!is.na(job) & sex == "female") %>% 
  group_by(job) %>% 
  summarise(n = n()) %>% 
  arrange(desc(n)) %>% 
  head(10)
job_female

# 시각화
ggplot(data = job_male, aes(x = reorder(job, n), y = n)) +
  geom_col() + 
  coord_flip()

ggplot(data = job_female, aes(x = reorder(job, n), y = n)) +
  geom_col() + 
  coord_flip()


### 종교 유무에 따른 이혼율 ###
# 변수 검토 및 전처리 - 종교
class(welfare$religion)
table(welfare$religion)

welfare$religion <- ifelse(welfare$religion == 1, "yes", "no")
table(welfare$religion)
qplot(welfare$religion)

# 변수 검토 및 전처리 - 혼인상태
class(welfare$marriage)
table(welfare$marriage)

welfare$group_marriage <- ifelse(welfare$marriage == 1, "marriage",
                                 ifelse(welfare$marriage == 3, "divorce", NA))
table(welfare$group_marriage)
table(is.na(welfare$group_marriage))
qplot(welfare$group_marriage)

# 종교 유무에 따른 이혼율 분석하기
religion_marriage <- welfare %>% 
  filter(!is.na(group_marriage)) %>% 
  group_by(religion, group_marriage) %>% 
  summarise(n = n()) %>% 
  mutate(tot_group = sum(n)) %>% 
  mutate(pct = round(n/tot_group*100, 1))
religion_marriage

# 이혼에 해당하는 값만 추출
divorce <- religion_marriage %>% 
  filter(group_marriage == "divorce") %>% 
  select(religion, pct)
divorce

# 시각화
ggplot(data = divorce, aes(x = religion, y = pct)) + geom_col()

### 연령대별 이혼율 분석 ###
# 연령대별 이혼율 표 만들기
ageg_marriage <- welfare %>% 
  filter(!is.na(group_marriage)) %>% 
  group_by(ageg, group_marriage) %>% 
  summarise(n = n()) %>% 
  mutate(tot_group = sum(n)) %>% 
  mutate(pct = round(n/tot_group*100, 1))
ageg_marriage

# 초년 제외, 이혼 추출
ageg_divorce <- ageg_marriage %>% 
  filter(ageg != "young" & group_marriage == "divorce") %>% 
  select(ageg, pct)
ageg_divorce

# 시각화
ggplot(data = ageg_divorce, aes(x = ageg, y = pct)) + geom_col()


### 연령대 및 종교 유무에 따른 이혼율 분석 ###
# 비율표 만들기
ageg_religion_marriage <- welfare %>% 
  filter(!is.na(group_marriage) & ageg != "young") %>%
  group_by(ageg, religion, group_marriage) %>%
  summarise(n = n()) %>%
  mutate(tot_group = sum(n)) %>%
  mutate(pct = round(n/tot_group*100), 1)

# 이혼 추출
ageg_religion_divorce <- ageg_religion_marriage %>% 
  filter(group_marriage == "divorce") %>% 
  select(ageg, religion, pct)

# 시각화
ggplot(data = ageg_religion_divorce, aes(x = ageg, y = pct, fill = religion)) +
  geom_col()
ggplot(data = ageg_religion_divorce, aes(x = ageg, y = pct, fill = religion)) +
  geom_col(position = "dodge")


### 지역별 연령대 비율 ###
# 변수 검토 및 전처리
class(welfare$code_region)
table(welfare$code_region)

# welfare$code_region 와 매핑(합하기)을 위한 데이터 프레임 생성
list_region <- data.frame(code_region = c(1:7),
                          region = c("서울", "수도권(인천/경기)", 
                                     "부산/경남/울산", "대구/경북", 
                                     "대전/충남", "강원/충북", 
                                     "광주/전남/전북/제주도"))

welfare <- left_join(welfare, list_region, id = "code_region")
welfare %>% select(code_region, region) %>% head

# 지역별 연령대 비율표 만들기
region_ageg <- welfare %>% 
  group_by(region, ageg) %>% 
  summarise(n = n()) %>% 
  mutate(tot_group = sum(n)) %>% 
  mutate(pct = round(n/tot_group*100, 2))

head(region_ageg)

# 시각화
ggplot(data = region_ageg, aes(x = region, y = pct, fill = ageg)) + geom_col() 
ggplot(data = region_ageg, aes(x = region, y = pct, fill = ageg)) + geom_col() + coord_flip()

# 노년층 비율이 높은 순으로 정렬
list_order_old <- region_ageg %>% filter(ageg == "old") %>% arrange(pct)

# 지역명 순서 저장 변수 : 시각화 작업에서 사용될 변수
order <- list_order_old$region

ggplot(data = region_ageg, aes(x = region, y = pct, fill = ageg)) +
  geom_col() +
  coord_flip() +
  scale_x_discrete(limits = order)

# 막대 색상 순서 변경 : fill에 지정할 변수의 범주(level)의 순서를 지정
# 연령대(ageg) 의 데이터 형태가 문자. => 1. ageg => factor => 2. level 을 설정

class(region_ageg$ageg)

levels(region_ageg$ageg)

region_ageg$ageg <- factor(region_ageg$ageg,
                           level = c("old", "middle", "young")
) 

ggplot(data = region_ageg, aes(x = region, y = pct, fill = ageg)) +
  geom_col() +
  coord_flip() +
  scale_x_discrete(limits = order)