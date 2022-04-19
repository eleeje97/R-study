### dplyr 패키지 ### 

# 데이터 불러오기
data("mtcars")

# 데이터 셋 구조 확인하기
nrow(mtcars)
str(mtcars)

# 데이터 추출하기 (filter(), select())
filter(mtcars, am == 1 & vs == 0)
filter(mtcars, cyl >= 6 & mpg >20)
head(select(mtcars, am, gear))

# 데이터 정렬하기
arrange(mtcars, wt)
arrange(mtcars, mpg, desc(wt))

# 데이터 추가하기 (열 추가)
mutate(mtcars, years = "1974")
head(mutate(mtcars, mpg_rank = rank(mpg))) # rank()로 순위 계산하여 추가하기
    # rank(): 동일한 값이 있을 경우, 순위가 소수점으로 매겨짐

# 데이터 중복 값 제거하기
distinct(mtcars, cyl)
distinct(mtcars, gear)
distinct(mtcars, cyl, gear) # cyl과 gear가 모두 같을 때만 동일한 값으로 보고 중복 제거한다.

# 데이터 요약하기
summarise(mtcars, cyl_mean=mean(cyl))

# 그룹별로 요약하기
summarise(group_by(mtcars, cyl), n())
summarise(group_by(mtcars, cyl), n_distinct(gear))

# 데이터 샘플 추출하기
sample_n(mtcars, 10) # 샘플 몇개 뽑기
sample_frac(mtcars, 0.2) # 샘플 몇 퍼센트 뽑기

# 파이프 연산자 %>% (단축키: Ctrl+Shift+M)
group_by(mtcars, cyl) %>% summarise(n())
mutate(mtcars, mpg_rank=rank(mpg)) %>% arrange(mpg_rank)

# 데이터셋을 재구성하여 새로운 데이터셋 생성
mtcars2 <- within(mtcars, {
  vs <- factor(vs, labels = c("V", "S"))
  am <- factor(am, labels = c("automatic", "manual"))
  cyl <- ordered(cyl)
  gear <- ordered(gear)
  carb <- ordered(carb)
})
library(dplyr)
summarise(mtcars2)

