actionButton(
  inputId = "full_change",
  label = "全部正确"
) -> full_change_button

box(
  HTML('<p style="color: red;">异常</p>'),
  br(),
  p("很抱歉，未找到该品牌该周的Publishers数据，请先前往任务提交页面提交数据获取任务")
) -> fail_example_box

box(
  width = 12,
  box(
    width = 4,
    HTML('<p style="color: blue; font-weight: bold; font-size: 18px;">TENCENT</p>'),
    br(),
    p("1 / 3"),
    full_change_button
  ),
  box(
    width = 8,
    tableOutput("first")
  )
) -> success_box_1

box(
  width = 12,
  box(
    width = 4,
    HTML('<p style="color: blue; font-weight: bold; font-size: 18px;">TENCENT</p>'),
    br(),
    p("2 / 3"),
    full_change_button
  ),
  box(
    width = 8,
    tableOutput("second")
  )
) -> success_box_2

box(
  width = 12,
  box(
    width = 4,
    HTML('<p style="color: blue; font-weight: bold; font-size: 18px;">TENCENT</p>'),
    br(),
    p("3 / 3"),
    full_change_button
  ),
  box(
    width = 8,
    tableOutput("third")
  )
) -> success_box_3

box(
  width = 12,
  box(
    width = 4,
    HTML('<p style="color: blue; font-weight: bold; font-size: 18px;">AUTONAVI</p>'),
    br(),
    p("1 / 1"),
    full_change_button
  ),
  box(
    width = 8,
    tableOutput("fourth")
  )
) -> success_box_4

box(
  width = 12,
  box(
    width = 4,
    HTML('<p style="color: blue; font-weight: bold; font-size: 18px;">BAIDU</p>'),
    br(),
    p("1 / 1"),
    full_change_button
  ),
  box(
    width = 8,
    tableOutput("five")
  )
) -> success_box_5

conditionalPanel(
  condition = "(input.recheckSelector == 'GUCCI' | (input.recheckSelector == 'PRADA' & input.week != '48')) & input.recheck_load%2 == 1",
  fail_example_box
) -> gucci_fail_con

conditionalPanel(
  condition = "input.recheckSelector == 'PRADA' & input.week == '48' & input.recheck_load%2 == 1",
  success_box_1,
  success_box_2,
  success_box_3,
  success_box_4,
  success_box_5,
) -> prada_success_con

tabItem(
  tabName = "manual_check",
  style = "min-height: 800px; overflow-y: auto;",
  column(
    12,
    column(2,pickerInput(inputId = "recheckSelector",label = "品牌:",choices =  c("GUCCI","PRADA"),options = list("live-search" = TRUE,"actions-box" = TRUE))),
    column(2,pickerInput(inputId = "week",label = "周数:",choices =  c("45","46","47","48"),options = list("live-search" = TRUE,"actions-box" = TRUE))),
    column(2,selectInput("check_method","检索方法", choices = c("全量","仅错","仅对"),selected = "仅错")),
    column(3,actionButton("recheck_load","确认加载"),actionButton("recheck_confirm","确认更新"))
  ),
  gucci_fail_con,
  prada_success_con
) -> manual_check_tab