library(shiny)

ui <- fluidPage(
  selectInput("sel", "다음에서 선택:",
              choices = c("초급", "중급", "고급")),
  
  selectInput("sel", "다음에서 선택:",
              choices = list(
                "컴파일러 언어" = c("C++", "Java"),
                "스크립트 언어" = c("R", "JavaScript", "Python")
              )),
  
  radioButtons("dist", "Distribution type:",
               c("Noraml" = "norm",
                 "Uniform" = "unif",
                 "Log-normal" = "lnorm",
                 "Exponential" = "exp")),
  plotOutput("distPlot"),
  
  checkboxGroupInput("sels",
                     "전공 언어(복수 선택 가능)",
                     c("C와 그 방언들", "Java", "JavaScripts", "R", "Perl")),
  verbatimTextOutput("langs"),
  
  dateInput("date", "날짜 선택", value=Sys.Date(), language="ko"),
  dateRangeInput("date", "날짜 선택",
                 start = Sys.Date(),
                 end = Sys.Date() + 30,
                 language = "ko"),
  
  sliderInput("obs", "Number of observations", 0, 1000, 500),
  actionButton("goButton", "Go!"),
  plotOutput("distPlot2"),
  
  h2(textOutput("txt")),
  verbatimTextOutput("sum1"),
  
  fluidRow(
    column(12,
           dataTableOutput('table')
           )
  ),
  
  plotOutput("myPlot")
)

server <- function(input, output, session) {
  output $ distPlot <- renderPlot({
    dist <- switch(input $ dist,
                   norm = rnorm,
                   unif = runif,
                   lnorm = rlnorm,
                   exp = rexp,
                   rnorm)
    
    hist(dist(500))
  })
  
  output $ langs <- renderPrint({
    input $ sels
  })
  
  output$distPlot2 <- renderPlot({
    input$goButton
    dist <- isolate(rnorm(input$obs))
    hist(dist)
  })
  
  output$txt <- renderText({
    "mtcars를 사용한 회귀 분석"
  })
  
  output$sum1 <- renderPrint({
    summary(lm(mpg ~ wt + qsec, data = mtcars))
  })
  
  output$table <- renderDataTable(iris,
                                  options = list(pageLength = 10,
                                                 initComplete = I("function(settings, json) {alert('Done.');}")
                                                 ))
  
  output$myPlot <- renderPlot({
    plot(mtcars$wt, mtcars$mpg)
  })
  
}

shinyApp(ui, server)
