### 샤이니 앱 만들기 ###
# shinyapp 누르면 기본 코드 생성
library(shiny)

ui <- fluidPage(
  textInput("myText", "텍스트를 입력하세요."),
  verbatimTextOutput("txt"),
  
  passwordInput("password", "패스워드"),
  
  numericInput("obs", "Observations:", 10, min=1, max=100),
  verbatimTextOutput("value")
)

server <- function(input, output, session) {
  output$txt <- renderPrint({
    req(input $ myText)
    input $ myText
  })
  
  output $ value <- renderText({input $ obs})
}

shinyApp(ui, server)

