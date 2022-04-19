### 별내동 역주변 아파트 시세 분석하기 ###

# 데이터 불러오기
subway_station_data <- read.csv("week2/data/subway_byeollae.csv")
apt_price_data <- read.csv("week2/data/apt_price_byeollae.csv")
head(subway_station_data)
head(apt_price_data)

# 지하철역 데이터 가공하기
library(ggmap)
googleAPIkey <- "AIzaSyB1mwuV70q_AsM5VEEtE9mTekSeAKd7ONw"
register_google(key = googleAPIkey)

library(tidyverse)
library(dplyr)
subway_station_data <- subway_station_data %>% 
  filter(str_detect(지번주소, "별내"))
station_geocode <- subway_station_data$지번주소 %>% geocode()
subway_station_data <- cbind(subway_station_data, station_geocode)
head(subway_station_data)

# 아파트 실거래가 데이터 가공하기
apt_price_data$전용면적 <- round(apt_price_data$전용면적)
count(apt_price_data, 전용면적) %>% arrange(desc(n)) %>% head()

apt_price_data <- apt_price_data %>% filter(전용면적 == 85)
head(apt_price_data)

apt_price_data$거래금액 <- gsub(",", "", apt_price_data$거래금액)
apt_price_data$거래금액 <- apt_price_data$거래금액 %>% as.integer()

apt_price_mean <- aggregate(거래금액 ~ 단지명, apt_price_data, mean)
apt_price_data <- left_join(apt_price_data, apt_price_mean, by = "단지명")
apt_price_data <- apt_price_data %>% select(-"거래금액.x")
apt_price_data <- apt_price_data %>% rename("거래금액" = "거래금액.y")
apt_price_data$거래금액 <- apt_price_data$거래금액 %>% as.integer()
head(apt_price_data)

apt_price_data <- apt_price_data[!duplicated(apt_price_data$단지명),]
head(apt_price_data)

apt_price_data$주소 <- paste(apt_price_data$시군구, apt_price_data$번지)
head(apt_price_data)

#apt_geocode <- apt_price_data$주소 %>% geocode()
#apt_geocode <- apt_price_data$도로명 %>% geocode()
apt_geocode <- apt_price_data$단지명 %>% geocode()
head(apt_geocode)

# 시각화
byeollae_map <- get_googlemap("byeollae-dong", maptype = "roadmap", zoom = 14, 
                              markers = station_geocode)
ggmap(byeollae_map) +
  geom_text(data = station_geocode, label = paste(subway_station_data$역명, "역"),
            vjust = 1, size = 5) +
  geom_point(data = apt_geocode, aes(x = lon, y = lat), size = 3, color = "navy") +
  geom_text(data = apt_geocode, aes(label = apt_price_data$단지명, vjust = -1), color = "#FF5E00") +
  geom_text(data = apt_geocode, aes(label = apt_price_data$거래금액, vjust = 2), color = "#990085")
