box(
  width = 12,
  selectInput(
    inputId = "brand_select",
    label = "品牌：",
    choices = c("GUCCI","BURBERRY"),
    width = "15%"
  ),
  actionButton(
    inputId = "mission_confirm",
    label = "确认提交",
    width = "5%"
  ),
  actionButton(
    inputId = "status_check",
    label = "查看状态",
    width = "5%"
  ),
  actionButton(
    inputId = "queue_check",
    label = "查看队列",
    width = "5%"
  )
) -> mission_ask_box

tabItem(
  tabName = "mission_ask",
  style = "min-height: 800px; overflow-y: auto;",
  column(
    12,
    mission_ask_box
  )
) -> mission_ask_tab