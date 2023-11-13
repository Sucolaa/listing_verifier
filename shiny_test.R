library(shiny)
library(shinydashboard)
library(shinyjs)

# 定义模块
page_module_ui <- function(id) {
  ns <- NS(id)
  tagList(
    fluidPage(
      titlePanel(paste("Page", id)),
      actionButton(ns("btnToPage2"), "Go to Page 2"),
      textOutput(ns("output"))
    )
  )
}

page_module <- function(input, output, session) {
  output$output <- renderText({
    paste("This is content for Page", input$id)
  })
  
  observeEvent(input$btnToPage2, {
    # 发送自定义消息，通知主应用切换页面
    session$sendCustomMessage(type = "changePage", message = list(id = 2))
  })
}

# 主应用
ui <- dashboardPage(
  dashboardHeader(title = "Multi-Page App Example"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Page 1", tabName = "page1")
    )
  ),
  dashboardBody(
    useShinyjs(),
    # 页面切换的输出区域
    textOutput("outputSwitch"),
    
    # 插入模块化页面
    uiOutput("pageContent")
  )
)

server <- function(input, output, session) {
  # 初始化页面ID
  current_page <- reactiveVal(1)
  
  # 监听自定义消息，切换页面
  observe({
    input_change <- input$changePage
    if (!is.null(input_change)) {
      current_page(input_change$id)
    }
  })
  
  # 输出当前页面ID
  output$outputSwitch <- renderText({
    paste("Current Page:", current_page())
  })
  
  # 渲染页面内容
  output$pageContent <- renderUI({
    page_module_ui(current_page())
  })
  
  # 调用模块
  callModule(page_module, id = "page1")
}

shinyApp(ui, server)
