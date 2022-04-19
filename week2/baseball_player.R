### 야구선수 연봉 대비 기록 분석 ###

# 데이터 불러오기
library(readxl)
player_data <- read.csv("week2/data/주요선수별성적-2013년.csv")
head(player_data)

### 연봉대비 출루율 시각화
bp <- barplot(player_data$연봉대비출루율,
        main="야구 선수별 연봉 대비 출루율 분석",
        col = rainbow(25), # 무지개 색깔
        cex.names = 0.7, # label 크기
        las = 2, # label 세로로 찍히게
        names.arg = player_data$선수명, 
        ylim = c(0, 50))

title(ylab = "연봉 대비 출루율", col.lab = "navy")

# 연봉대비 출루율 평균값 구해서 선 그리기
avg <- 0
for (i in 1:length(player_data$연봉대비출루율)) {
  avg <- avg + player_data$연봉대비출루율[i]
}
avg <- avg/length(player_data$연봉대비출루율)
avg

abline(h = avg, col="orange")

# 평균선에 평균출루율 데이터 추가
text(x = avg-11, y = 15, col = "black", cex = 0.8, 
     labels = paste("평균출루율: ", avg, "%"))

# 각 막대그래프에 데이터 추가
text(x = bp*1.01, y = player_data$연봉대비출루율+1, col = "black", cex = 0.7,
     labels = paste(player_data$연봉대비출루율, "%"))

### 나이팅게일 차트로 시각화
# 인덱싱을 선수명으로 변경
row.names(player_data) <- player_data$선수명
head(player_data)
player_data2 <- player_data[, c(7,8,11,12,13,14,17,19)]
head(player_data2)

# 나이팅게일 차트
stars(player_data2,
      flip.labels = FALSE, 
      draw.segments = TRUE,
      frame.plot = TRUE,
      full = TRUE,
      main = "야구 선수별 주요 성적 분석 - 2013년")

# 범례용 그래프 만들기
label <- names(player_data2)
val <- table(label)
color <- c("black", "red", "green", "blue", "cyan", "violet", "yellow", "grey")
pie(val, labels = label, col = color, radius = 0.1, cex = 0.6)

### 연봉대비출루율과 연봉대비타점율 선 그래프로 시각화
player_data3 <- player_data[, c(2, 21,22)]
head(player_data3)

# par() 함수를 이용하여 마진 설정
par(mar = c(5,4,4,4) + 0.1)

line1 <- player_data$연봉대비출루율
line2 <- player_data$연봉대비타점율

# 연봉대비타점율 시각화
plot(line1, type = "o", axes = F,
     ylab = "", xlab = "", ylim = c(0, 50),
     lty = 2, lwd = 2, col = "blue",
     main = "한국 프로야구 선수별 기록분석 - 2013년")

# x축 설정
axis(1, at = 1:25, lab = player_data3$선수명, las = 2)

# y축 설정 (왼쪽)
axis(2, las = 1)

# 새로운 그래프 추가
par(new =T)

# 시각화
plot(line2, type = "o", axes = F, 
     ylab = "", xlab = "", ylim = c(0, 50),  lty = 2, col = "red")

# y축 설정 (오른쪽)
axis(4, las =1)

# y축 레이블 설정 (오른쪽)
mtext(side = 4, line = 2.5, "연봉대비 타점율")

# x축 레이블 설정 (왼쪽)
mtext(side = 2, line = 2.5, "연봉대비 출루율")

# 배경에 가이드라인을 격자 모양으로 추가
abline(h = seq(0, 50, 5), v = seq(1, 25, 1), col = "gray", lty = 2)

# 범례 추가
legend(18, 50, names(player_data[21:22]), cex = 0.8, col = c("red", "blue"), 
       lty = 1, lwd = 2, bg = "white")


