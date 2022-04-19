### 외부 데이터 불러오기 ###
ex_data1 <- read.table("week1/data/data_ex.txt", 
                      encoding = "EUC-KR", 
                      fileEncoding = "UTF-8",
                      header = TRUE)
ex_data1

col_names <- c("ID", "SEX", "AGE", "AREA")
ex_data2 <- read.table("week1/data/data_ex_col.txt", 
                       encoding = "EUC-KR",
                       fileEncoding = "UTF-8",
                       header = TRUE,
                       col.names = col_names)
ex_data2

ex_data3 <- read.table("week1/data/data_ex1.txt",
                       fileEncoding = "UTF-8",
                       header = TRUE,
                       sep = ",")
ex_data3

ex_data4 <- read.csv("week1/data/data_ex.csv")
ex_data4

ex_data5 <- read_excel("week1/data/data_ex.xlsx")
ex_data5

ex_data6 <- xmlToDataFrame("week1/data/data_ex.xml")
ex_data6

ex_data7 <- fromJSON("week1/data/data_ex.json")
str(ex_data7)
