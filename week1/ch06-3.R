### 구글 지도 API ###
library(ggmap)

# API 키 등록
register_google(key = GOOGLE_API_KEY)

# 지도 가져오기
gg_seoul <- get_googlemap("seoul", maptype = "roadmap")
ggmap(gg_seoul)

# 지도에 좌표를 점으로 표시하기
  ## 한글을 이용할 때는 enc -> utf8로 변환해야 함
geo_code <- enc2utf8("별내별가람역") %>% geocode()
geo_data <- as.numeric(geo_code)
get_googlemap(center = geo_data, maptype = "roadmap", zoom = 15) %>% ggmap() +
  geom_point(data = geo_code, aes(x = lon, y = lat))
