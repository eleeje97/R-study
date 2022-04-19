### 홍대입구역 주변 아파트 시세 분석하기 ###

# 데이터 불러오기
subway_station_data <- read.csv("week2/data/subway_APT_data_files/역별_주소_및_전화번호.csv")
apt_price_data <- read.csv("week2/data/subway_APT_data_files/아파트_실거래가.csv")


# 지하철역 데이터 가공하기
## 1. 지하철역 좌표 정보 구하기
library(ggmap)
googleAPIkey <- "AIzaSyB1mwuV70q_AsM5VEEtE9mTekSeAKd7ONw" # "AIzaSyDpxBBQCM4v1I1-TiJmGFVz0nI3iSTxazk"
register_google(key = googleAPIkey)

station_geocode <- geocode(subway_station_data$구주소)
head(station_geocode)


# 아파트 실거래가 데이터 가공하기
table(is.na(apt_price_data$거래금액)) # 결측치 확인
class(apt_price_data$거래금액) # 거래금액 숫자형식인지 확인
apt_price_data$거래금액 <- gsub(",", "", apt_price_data$거래금액) # 쉼표 제거
head(apt_price_data)

## 1. 가장 빈도가 높은 전용면적 찾기
### 전용면적 반올림하여 정수로 표현
apt_price_data$전용면적 <- round(apt_price_data$전용면적) 
head(apt_price_data)

### 전용면적 중 빈도가 높은 값 찾기
head(count(apt_price_data, 전용면적) %>% arrange(desc(n)))

### 전용면적이 85인 데이터 추출 ###
#apt_price_data_85 <- filter(apt_price_data, 전용면적==85) # filter 함수는 dplyr 패키지
apt_price_data_85 <- subset(apt_price_data, 전용면적==85) # subset 함수는 R에서 자체제공
head(apt_price_data_85)

## 2. 전용면적이 85인 데이터의 아파트 단지별 평균 거래 금액
##### *aggregate: 데이터의 특정 컬럼을 기준으로 통계량을 구해주는 함수 
apt_price_mean <- aggregate(as.integer(거래금액) ~ 단지명, 
                            apt_price_data_85, mean)
apt_price_mean <- rename(apt_price_mean, "거래금액" = "as.integer(거래금액)")
head(apt_price_mean)

## 3. 시군구와 번지를 하나로 합치기
### 단지명이 중복된 행을 제거하고 저장
apt_price_data_85 <- apt_price_data_85[!duplicated(apt_price_data_85$단지명),]

### 단지명을 기준으로 apt_price_data_85와 apt_price_mean 합치기
apt_price_data_85 <- left_join(apt_price_data_85, apt_price_mean, by = "단지명")
apt_price_data_85 <- apt_price_data_85 %>% select(-"거래금액.x")
apt_price_data_85 <- rename(apt_price_data_85, "거래금액" = "거래금액.y")
head(apt_price_data_85)

### 시군구와 번지 합치기
apt_price_data_85$주소 <- paste(apt_price_data_85$시군구, apt_price_data_85$번지)
head(apt_price_data_85)

## 4. 좌표 정보 추가 후, 최종 데이터 만들기
apt_geocode <- apt_price_data_85$주소 %>% enc2utf8() %>% geocode()
head(apt_geocode)


# 시각화
## 1. 마포구 지도 가져오기
mapo_map <- get_googlemap("마포구", maptype = "roadmap", zoom = 12)
ggmap(mapo_map)

## 2. 지하철역 지도에 표시하기
# 마커 꽂는 방식
mapo_map_marker <- get_googlemap("마포구", maptype = "roadmap", zoom = 12,
                                 markers = station_geocode)
ggmap(mapo_map_marker) +
  geom_text(data = station_geocode, aes(x = lon, y = lat),
            size = 3, label = subway_station_data$역명, vjust = 2)

# 점 찍는 방식
ggmap(mapo_map) +
  geom_point(data = station_geocode, aes(x = lon, y = lat), size = 3, color = "red") +
  geom_text(data = station_geocode, label = subway_station_data$역명, vjust = -1)

## 3. 지하철역 위치 및 아파트 가격 정보 표시하기 (홍대입구역 기준)
hongdae_map <- get_googlemap("홍대입구역", maptype = "roadmap", zoom = 15,
                             markers = station_geocode)
ggmap(hongdae_map) +
  geom_text(data = station_geocode, label = subway_station_data$역명, 
            vjust = 1, size = 5) +
  geom_point(data = apt_geocode, aes(x = lon, y = lat), size = 3, color = "navy") +
  geom_text(data = apt_geocode, label = apt_price_data_85$단지명, vjust = -1, color = "#990085") +
  geom_text(data = apt_geocode, label = apt_price_data_85$거래금액, vjust = 2, color = "#FF5E00")
