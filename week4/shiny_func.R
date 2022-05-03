### 샤이니에서 유용한 함수들 ###
# paste0 : 공백없이 문자열 이어 붙이기
for (i in 1:10) {
  vs <- paste0("x", i)
  print(vs)
}

# assign(이름, 값): 이름에 대한 바인딩
# --> 입력 위젯에서 어떤 것을 선택하고, 선택한 그 이름을 가진 R데이터 셋을 얻을 때 사용
for (i in 1:10) {
  vs <- paste0("x", i)
  assign(vs, i)
  print(get(vs))
}

# switch(statement, list): statement가 숫자인 경우, list부분의 그 숫자에 해당되는 표현식을 실행
x <- 3
switch(x, 2+2, mean(1:10), rnorm(5))
x <- 4
switch(x, 2+2, mean(1:10), rnorm(5))

# statement가 문자인 경우, list 이름들을 조회하여 매칭되는 이름에 할당된 표현식을 실행
center <- function(x, type) {
  switch(type,
         mean = mean(x),
         median = median(x),
         trimmed = mean(x, trim=.1)
         )
}

x <- rcauchy(10)
x
center(x, "median")
