library(httr)
library(dplyr)

# api에 보낼 파라미터 값
auth <- read.table("miniProject/data/auth_data.txt")
url <- auth[1,2]
api_key <- auth[2,2]
usrId <- auth[3,2]

# 경기도 시군구 행정구역 리스트
gyeonggi_sigungu <- readLines("miniProject/data/gyeonggi_sigungu.txt", encoding = 'UTF-8')
gyeonggi_sigungu <- c("경기도", gyeonggi_sigungu)

# api 요청 결과 값을 데이터프레임으로 반환하는 함수
getResponseByDataFrame <- function(pid) {
  res <- GET(url = url,
             query = list(KEY=api_key,
                          USRID=usrId,
                          PID=pid,
                          YEAR="2019"))
  res_df <- res %>% content(as = "text", encoding = "UTF-8") %>% fromJSON()
  return(res_df$data)
}


### PPP007 음식물류 폐기물 종량제 물품 판매현황 ###
data_ppp007 <- getResponseByDataFrame("PPP007") %>% filter(CTS_JIDT_NM %in% gyeonggi_sigungu)
head(data_ppp007)


### PPP015 음식물류 폐기물 주민부담률 ###
data_ppp015 <- getResponseByDataFrame("PPP015") %>% filter(CTS_JIDT_NM %in% gyeonggi_sigungu)
head(data_ppp015)


### STRR006 발생원별 음식물류 폐기물 조성에 따른 원단위 발생량 ###
data_strr006 <- getResponseByDataFrame("STRR006")
head(data_strr006)


### STRR007 도시규모별 음식물류 폐기물 물리적 조성에 따른 밀도 ###
data_strr007 <- getResponseByDataFrame("STRR007")
head(data_strr007)


### STRR008 음식물류 폐기물 가정부문 및 비가정부문 발생 원단위 ###
data_strr008 <- getResponseByDataFrame("STRR008")
head(data_strr008)


### STRR009 도시규모별 음식물류 폐기물 분리배출현황 ###
data_strr009 <- getResponseByDataFrame("STRR009")
head(data_strr009)


### STRR020 도시규모별 음식물류 폐기물 물리적조성에 따른 삼성분 및 pH (봄철) ###
data_strr020 <- getResponseByDataFrame("STRR020")
head(data_strr020)


### STRR062 조사대상 음식물자원화 시설 수 ###
data_strr062 <- getResponseByDataFrame("STRR062")


### STRR063 음식물자원화시설 가동 및 처리현황 ###
data_strr063 <- getResponseByDataFrame("STRR063")

### STRR064 시도별 음식물자원화 시설 반입현황 ###
data_strr064 <- getResponseByDataFrame("STRR064")

### STRR065 음식물자원화시설 처리현황 ###
data_strr065 <- getResponseByDataFrame("STRR065")

### STRR066 음식물자원화시설 폐기물 발생 및 처리현황 ###
data_strr066 <- getResponseByDataFrame("STRR066")

### STRR067 시도별 음식물자원화시설 시설용량대비 반입비율 ###
data_strr067 <- getResponseByDataFrame("STRR067")


