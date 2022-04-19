vec <- c(1,2,3,4,5)
vec

vec <- append(vec, 10, after = 3)
vec

lst <- list("name" = c("Dana Lee", "Lily Lee"),
            "age" = c(26, 28))

lst$name <- NULL
lst$name <- c("Dana Lee", "Lily Lee", "Han Lee")

no <- 1:5
name <- c("서진수", "주시현", "최경우", "이동근", "윤정웅")
address <- c("서울", "대전", "포항", "경주", "경기")
tel <- c(1111, 2222, 3333, 4444, 5555)
hobby <- c("독서","미술","놀고먹기","먹고놀기","노는애감시하기")
member <- data.frame(NO=no, NAME=name, ADDRESS=address, TEL=tel, HOBBY=hobby)
member

member2 <- subset(member, select=c(NO, NAME, TEL))
member2

member3 <- subset(member, select= -TEL)
member3

colnames(member3) <- c("번호", "이름", "주소", "취미")
member3
