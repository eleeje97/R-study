library(RSQLite)

# 데이터베이스 생성 및 연결
if (!dir.exists("week3/sqldata")) dir.create("week3/sqldata")
con <- dbConnect(SQLite(), "week3/sqldata/example.sqlite")

# 데이터프레임
example1 <- data.frame(
  id = 1:5,
  type = c("A", "A", "B", "B", "C"),
  score = c(8, 9, 8, 10, 9),
  stringsAsFactors = FALSE
)
example1

# DB에 데이터 넣기
dbWriteTable(con, "example1", example1)
dbDisconnect(con)


# ggplot2의 diamonds 데이터와 nycflights13의 flights 데이터 DB에 넣기
library(ggplot2)
library(nycflights13)

# 데이터 불러오기
data("diamonds", package = "ggplot2")
data("flights", package = "nycflights13")

# DB연결 & 데이터 넣기
con <- dbConnect(SQLite(), "week3/sqldata/datasets.sqlite")
dbWriteTable(con, "diamonds", diamonds, row.names = FALSE)
dbWriteTable(con, "flights", flights, row.names = FALSE)
dbDisconnect(con)

class(diamonds)
class(flights)

con <- dbConnect(SQLite(), "week3/sqldata/datasets2.sqlite")
dbWriteTable(con, "diamonds", as.data.frame(diamonds), row.names = FALSE)
dbWriteTable(con, "flights", as.data.frame(flights), row.names = FALSE)
dbDisconnect(con)


con <- dbConnect(SQLite(), "week3/sqldata/example2.sqlite")
chunk_size <- 10
id <- 0
for (i in 1:6) {
  chunk <- data.frame(id = ((i - 1L) * chunk_size):(i * chunk_size - 1L),
                      type = LETTERS[[i]],
                      score = rbinom(chunk_size, 10, (10 - i)/10),
                      stringsAsFactors = FALSE)
  dbWriteTable(con, "products", chunk, append = i > 1, row.names = FALSE)
}
dbDisconnect(con)


con <- dbConnect(SQLite(), "week3/sqldata/datasets.sqlite")
dbExistsTable(con, "diamonds")
dbExistsTable(con, "mtcars")
dbListTables(con)
dbListFields(con, "diamonds")

# 테이블 읽기
db_diamonds <- dbReadTable(con, "diamonds")
dbDisconnect(con)

# 원본데이터와 DB에서 읽어온 데이터 비교
head(db_diamonds, 3)
head(diamonds, 3)
identical(diamonds, db_diamonds) # --> FALSE
str(db_diamonds)
str(diamonds)


# DB 쿼리문 사용해보기
con <- dbConnect(SQLite(), "week3/sqldata/datasets.sqlite")
dbListTables(con)

db_diamonds <- dbGetQuery(con, "select * from diamonds")
head(db_diamonds, 3)

db_diamonds <- dbGetQuery(con, "select carat, cut, color, clarity, depth, price from diamonds")
head(db_diamonds, 3)

# dbGetQuery는 데이터프레임 형태로 반환한다.
dbGetQuery(con, "select distinct cut from diamonds")
dbGetQuery(con, "select distinct clarity from diamonds")[[1]]

# as 옵션 사용할 때
db_diamonds <- dbGetQuery(con, "select carat, price, clarity as clarity_level from diamonds")
head(db_diamonds, 3)

db_diamonds <- dbGetQuery(con, "select carat, price, x * y * z as size from diamonds")
head(db_diamonds, 3)

# 에러남 -> 이런 경우, 중첩된 쿼리 사용해야 함
db_diamonds <- dbGetQuery(con, "select carat, price, x * y * z as size, price/size as value_density from diamonds")
db_diamonds <- dbGetQuery(con, "select *, price/size as value_density from 
                          (select carat, price, x * y * z as size from diamonds)")
head(db_diamonds, 3)

# 조건문
good_diamonds <- dbGetQuery(con, "select carat, cut, price from diamonds where cut = 'Good'")
head(good_diamonds, 3)

nrow(good_diamonds)/nrow(diamonds)

good_e_diamonds <- dbGetQuery(con, "select carat, cut, color, price from diamonds where cut = 'Good' and color = 'E'")
head(good_e_diamonds, 3)

color_ef_diamonds <- dbGetQuery(con, "select carat, cut, color, price from diamonds where color in ('E', 'F')")
nrow(color_ef_diamonds)
table(diamonds$color)

some_price_diamonds <- dbGetQuery(con, "select carat, cut, color, price from diamonds where price between 5000 and 5500")
nrow(some_price_diamonds)/nrow(diamonds)

good_cut_diamonds <- dbGetQuery(con, "select carat, cut, color, price from diamonds where cut like '%Good'")
nrow(good_cut_diamonds)/nrow(diamonds)

head(dbGetQuery(con, "select carat, price from diamonds where cut = 'Ideal' and clarity = 'IF' and color = 'J' order by price"))

