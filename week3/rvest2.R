### R 패키지 긁어 오기 ###
page <- read_html("https://cran.rstudio.com/web/packages/available_packages_by_name.html")
pkg_table <- page %>% 
  html_node("table") %>% 
  html_table(fill = TRUE)

pkg_table <- pkg_table[complete.cases(pkg_table), ]
colnames(pkg_table) <- c("name", "title")

### MSFT의 최신 주가 추출하기 ###
page <- read_html("https://finance.yahoo.com/quote/MSFT")
page %>% html_node("#quote-header-info div:nth-child(3) fin-streamer") %>% 
  html_text() %>% 
  as.numeric()


# 주가를 확인할 회사이름을 받아 주가 추출하기
get_price <- function(symbol) {
  page <- read_html(sprintf("https://finance.yahoo.com/quote/%s", symbol))
  list(symbol = symbol,
       company = page %>% 
         html_node("#quote-header-info div:nth-child(2) h1") %>% 
         html_text(),
       price = page %>% 
         html_node("#quote-header-info div:nth-child(3) fin-streamer") %>% 
         html_text() %>% 
         as.numeric())
}

get_price("AAPL")

### stackoverflow 상위에 있는 R질문 긁어오기 ###
page <- read_html("https://stackoverflow.com/questions/tagged/r?sort=votes&pageSize=15")
questions <- page %>% html_node("#questions")
questions %>% html_nodes(".s-post-summary--content-title a") %>% 
  html_text()
questions %>% html_nodes(".s-link") %>% html_text()

questions %>% html_node


