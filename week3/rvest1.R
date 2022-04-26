library(rvest)

# 웹페이지 가져오기
single_table_page <- read_html("week3/data/0426_웹_스크래핑_기본_data/single-table.html")
single_table_page

# 테이블 요소 추출하기
html_table(single_table_page)
html_table(html_node(single_table_page, "table"))
single_table_page %>% html_node("table") %>% html_table()

# CSS 선택자로 데이터 추출하기
products_page <- read_html("week3/data/0426_웹_스크래핑_기본_data/products.html")
products_page %>% html_nodes(".product-list li .name")

# 선택한 노드에서 문자형 벡터 추출하기
products_page %>% html_nodes(".product-list li .name") %>% html_text()
products_page %>% html_nodes(".product-list li .price") %>% html_text()

# 테이블 추출하여 데이터프레임으로 만들기
product_items <- products_page %>% html_nodes(".product-list li")
products <- data.frame(
  name = product_items %>% 
    html_nodes(".name") %>% 
    html_text(),
  price = product_items %>% 
    html_nodes(".price") %>% 
    html_text() %>% 
    gsub("$", "", ., fixed = TRUE) %>% 
    as.numeric(),
  stringsAsFactors = FALSE)

# XPath 선택자 
page <- read_html("week3/data/0426_웹_스크래핑_기본_data/new-products.html")

# 모든 <p>노드 선택
page %>% html_nodes(xpath = "//p")

# class 속성을 갖는 모든 <li> 선택
page %>% html_nodes(xpath = "//li[@class]")

# <div id="list"><ul>의 자녀 노드 중 모든 <li> 선택
page %>% html_nodes(xpath = "//div[@id='list']/ul/li")

# <div id="list"> 안의 <li> 자녀 노드 중에서 <span class="name">을 모두 선택
page %>% html_nodes(xpath = "//div[@id='list']//li/span[@class='name']")

# <li class="selected"> 자녀 노드 중 <span class="name"> 을 모두 선택
page %>% html_nodes(xpath = "//li[@class='selected']/span[@class='name']")

# <p>를 자녀 노드로 하는 모든 <div> 선택 -> CSS선택자로 불가능
page %>% html_nodes(xpath = "//div[p]")

# <span class="info-value">Good</span>을 모두 선택
page %>% html_nodes(xpath = "//span[@class='info-value' and text()='Good']")

# 품질이 좋은 제품의 이름을 모두 선택
page %>% html_nodes(xpath = "//li[div/ul/li[1]/span[@class='info-value' and text()='Good']]/span[@class='name']")

# 내구성이 3년을 초과하는 제품의 이름을 모두 선택
page %>% html_nodes(xpath = "//li[div/ul/li[2]/span[@class='info-value' and text() > 3]]/span[@class='name']")

