library(DBI)

con <- dbConnect(
  drv = RMySQL::MySQL(),
  user = "root",
  password = "1234",
  dbname = "unidb"
)

dbSendQuery(conn = con,
            "create table economics(
            date Date,
            pce double,
            pop double,
            psavert double,
            uempmed double,
            unemploy double)"
            )

dbSendQuery(conn = con,
            "set GLOBAL local_infile = TRUE;")

economics = ggplot2::economics
economics = data.frame(economics)

dbWriteTable(con,
             "economics",
             economics[1:300, ],
             overwrite = TRUE,
             row.names = FALSE)

dbWriteTable(con,
             "economics",
             economics[301:574, ],
             append = TRUE,
             row.names = FALSE)

dbSendQuery(con,
            "insert into economics (date, pce, pop, psavert, uempmed, unemploy)
            values ('2022-04-29', '112300', '32100', '0', '12', '8600')")

dbSendQuery(con,
            "update economics
            set psavert=7.9, uempmed=14
            where date = '2022-04-29'")

dbSendQuery(con,
            "delete from economics
            where date = '2022-04-29'")

