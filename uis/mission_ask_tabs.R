box(
  title = "Detail提交",
  width = 12,
  column(
    12,
    column(
      6,
      pickerInput(inputId = "brand_select",label = "选择品牌:",choices =  c("GUCCI","BURBERRY"),options = list("live-search" = TRUE,"actions-box" = TRUE))
    ),
    column(
      3,
      conditionalPanel(condition = "input.brand_select == 'GUCCI'",HTML('<p style="color: red; font-weight: bold; font-size: 18px;">异常</p>')),
      conditionalPanel(condition = "input.brand_select == 'BURBERRY'",HTML('<p style="color: green; font-weight: bold; font-size: 18px;">正常</p>'))
    )
  ),
  actionButton(
    inputId = "mission_confirm",
    label = "确认提交",
    width = "5%"
  ),
  actionButton(
    inputId = "queue_check",
    label = "查看队列",
    width = "5%"
  )
) -> mission_ask_box

box(
  title = "Publisher Check下载",
  width = 12,
  column(
    12,
    column(3,pickerInput(inputId = "brand_dw_select",label = "选择品牌:",choices =  c("GUCCI","BURBERRY"),options = list("live-search" = TRUE,"actions-box" = TRUE))),
    column(3,pickerInput(inputId = "brand_dw_week",label = "选择星期:",choices = c("45","46","47","48"),options = list("live-search" = TRUE,"actions-box" = TRUE))),
    column(3,selectInput(inputId = "download_method",label = "下载格式", choices = c("HTML","PDF","Both"),selected = "HTML")),
    downloadButton(outputId = "brand_dw_bt", label = "下载")
  )
) -> pc_download_box

box(
  title = "商户通数据日报下载",
  width = 12,
  column(
    12,
    column(3,pickerInput(inputId = "brand_data_select", label = "选择品牌:", choices = c("GUCCI","BURBERRY"), options = list("live-search" = TRUE, "actions-box" = TRUE))),
    column(3, dateInput(inputId = "data_date", label = "选择日期", value = Sys.Date()-1, min = Sys.Date() - 30, max = Sys.Date() - 1)),
    column(3, selectInput(inputId = "download_method",label = "下载格式", choices = c("HTML","PDF","Both"),selected = "Both")),
    downloadButton(outputId = "data_date_bt", label = "下载")
  )
) -> data_date_box

tabItem(
  tabName = "mission_ask",
  style = "min-height: 800px; overflow-y: auto;",
  column(
    12,
    mission_ask_box,
    pc_download_box,
    data_date_box
  )
) -> mission_ask_tab