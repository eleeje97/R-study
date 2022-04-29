library(mongolite)

### products 컬렉션 ###
m <- mongo("products", "test", "mongodb://localhost")
m$count()

# 문서 입력
m$insert('
         {
            "code": "A0000001",
            "name": "Product-A",
            "type": "Type-I",
            "price": 29.5,
            "amount": 500,
            "comments": [
                {
                    "user": "david",
                    "score": 8,
                    "text": "This is a good product"
                },
                {
                    "user": "jenny",
                    "score": 5,
                    "text": "Just so so"
                }
            ]
        }')
m$count()

m$insert(list(
  code = "A0000002",
  name = "Product-B",
  type = "Type-II",
  price = 59.9,
  amount = 200L,
  comments = list(
    list(user = "tom", score = 6L, text = "Just fine"),
    list(user = "mike", score = 9L, text = "Great product!")
  )
), auto_unbox = TRUE)

# 문서 조회
products <- m$find()
str(products)

iter <- m$iterate()
products <- iter$batch(2)
str(products)

# 필터링 하여 조회
m$find('{"code": "A0000001"}', '{"_id": 0, "name": 1, "price": 1, "amount": 1}')
m$find('{"price": {"$gte": 40}}', '{"_id": 0, "name": 1, "price": 1, "amount": 1}')
m$find('{"comments.score": 9}', '{"_id": 0, "code": 1, "name": 1}')
m$find('{"comments.score": {"$lt": 6}}', '{"_id": 0, "code": 1, "name": 1}')



### students 컬렉션 ###

# 컬렉션 생성
m <- mongo("students", "test", "mongodb://localhost")
m$count()

# 문서 입력을 위한 데이터프레임 & 문서 입력
students <- data.frame(
  name = c("David", "Jenny", "Sara", "John"), 
  age = c(25, 23, 26, 23),
  major = c("Statistics", "Physics", "Computer Science", "Statistics"),
  projects = c(2, 1, 3, 1), 
  stringsAsFactors = FALSE
)
m$insert(students)
m$count()
m$find()


# 문서 삭제 (TRUE: 하나만 삭제, FALSE: 모두 삭제)
m$remove('{"name": "John"}', TRUE)
m$remove('{}') # 전체 삭제
m$drop() # 컬렉션 삭제

# 문서 조회
m$find('{"name": "Jenny"}')
m$find('{"projects": {"$gte": 2}}')
m$find('{"projects": {"$gte": 2}}', fields = '{"_id": 0, "name": 1, "major": 1}')
m$find('{"projects": {"$gte": 2}}', fields = '{"_id": 0, "name": 1, "age": 1}', sort = '{"age": -1}')
m$find('{"projects": {"$gte": 2}}', fields = '{"_id": 0, "name": 1, "age": 1}', sort = '{"age": -1}', limit = 1)
m$distinct("major")
m$distinct("major", '{"projects": {"$gte": 2}}')

# 문서 업데이트
m$update('{"name": "Jenny"}', '{"$set": {"age": 24}}')
m$find()

# 인덱스 생성
m$index('{"name": 1}')
m$find('{"name": "Sara"}')
m$find('{"name": "Jane"}')


### simulation 컬렉션 ###
set.seed(123)
m <- mongo("simulation", "test")

# 모든 조합 데이터 생성
sim_data <- expand.grid(
  type = c("A", "B", "C", "D", "E"),
  category = c("P-1", "P-2", "P-3"),
  group = 1:20000,
  stringsAsFactors = FALSE)
)

sim_data$score1 <- rnorm(nrow(sim_data), 10, 3)
sim_data$test1 <- rbinom(nrow(sim_data), 100, 0.8)

m$insert(sim_data)

# 인덱스 유무에 따른 처리시간 측정

## 인덱스 없는 경우
system.time(rec <- m$find('{"type": "C", "category": "P-3", "group": 87}'))
rec
system.time(recs <- m$find('{"type": {"$in": ["B", "D"]}, 
                          "category": {"$in": ["P-1", "P-2"]},
                          "group": {"$gte": 25, "$lte": 75}}'))
recs
system.time(recs2 <- m$find('{"score1": {"$gte": 20}}'))
recs2

## 인덱스 있는 경우
m$index('{"type": 1, "category": 1, "group": 1}')
system.time(rec <- m$find('{"type": "C", "category": "P-3", "group": 87}'))
rec
system.time(recs <- m$find('{"type": {"$in": ["B", "D"]}, 
                          "category": {"$in": ["P-1", "P-2"]},
                          "group": {"$gte": 25, "$lte": 75}}'))
recs
system.time(recs2 <- m$find('{"score1": {"$gte": 20}}'))
recs2


# 그룹화하기
m$aggregate('[
            {
                "$group": {
                    "_id": "$type",
                    "count": {"$sum": 1},
                    "avg_score": {"$avg": "$score1"},
                    "min_test": {"$min": "$test1"},
                    "max_test": {"$max": "$test1"}
                }
            }
            ]')

m$aggregate('[
            {
                "$group": {
                    "_id": {"type": "$type", "category": "$category"},
                    "count": {"$sum": 1},
                    "avg_score": {"$avg": "$score1"},
                    "min_test": {"$min": "$test1"},
                    "max_test": {"$max": "$test1"}
                }
            }
            ]')


# MapReduce
bins <- m$mapreduce(
  map = 'function() {
      emit(Math.floor(this.score1 / 2.5) * 2.5, 1);
  }',
  reduce = 'function(id, counts) {
      return Array.sum(counts);
  }'
)
bins

# 막대 그래프
with(bins, barplot(value/sum(value), names.arg = '_id',
                   main = "점수 히스토그램", xlab = "score1", ylab = "Percentage"))
