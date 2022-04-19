### 지도에서 코로나19 선별진료소 위치 확인하기 ###

# 데이터 불러오기
library(readxl)
clinic_data <- read_excel("week1/data/ch07/clinic_data.xls")
clinic_data

# 필요한 컬럼 추출
data_raw <- clinic_data[,c(2:4, 7)]

# 한글 열이름 저장하고 영문 열이름으로 바꾸기
colnames_kr <- colnames(data_raw)
colnames(data_raw) <- c("state", "city", "name", "addr")

# 빈도분석하기
barplot(table(data_raw$state))

# 대전시 데이터 추출하기
daejeon_data <- data_raw[data_raw$state == "대전",]

# 지도에 시각화하기
library(ggmap)
ggmap_key <- GOOGLE_API_KEY
register_google(ggmap_key)

## 지오코드 받아오기 
daejeon_data <- mutate_geocode(data = daejeon_data, location = addr, source = 'google')

## 지도에 그리기 (산점도)
daejeon_map <- get_googlemap('대전', maptype = "roadmap", zoom = 11)
ggmap(daejeon_map) +
  geom_point(data = daejeon_data, 
             aes(x = lon, y = lat, color = factor(name)), size = 3)

## 지도에 그리기 (markers 옵션)
daejeon_data_marker <- data.frame(daejeon_data$lon, daejeon_data$lat)
daejeon_map <- get_googlemap('대전', maptype = "roadmap",
                             zoom = 11, markers = daejeon_data_marker)
ggmap(daejeon_map) +
  geom_text(data = daejeon_data, aes(x = lon, y = lat),
            size = 3, label = daejeon_data$name)
