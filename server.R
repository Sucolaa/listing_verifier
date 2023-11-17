library(shiny)
source("share_loads.R")
walk(list.files("ui_scripts", full.names = TRUE), ~ source(.x))

function(input, output, session) {
  observeEvent(
    input$mission_confirm,
    {
      if(input$brand_select == "GUCCI") {
        showModal(modalDialog(
          HTML('<p style="color: red;">ERROR</p>'),
          br(),
          p("很抱歉，您所选择的品牌 GUCCI 无法被操作"),
          br(),
          p("原因：门店信息表中存在未被确认的门店信息修改，请前往确认")
        ))
      } else if (input$brand_select == "BURBERRY") {
        showModal(modalDialog(
          HTML('<p style="color: green;">SUCCESS</p>'),
          br(),
          p("任务已创建，任务ID：114516")
        ))
      }
    }
  )
  
  observeEvent(
    input$status_check,
    {
      if(input$brand_select == "GUCCI") {
        showModal(modalDialog(
          HTML('<p style="color: red;">异常</p>'),
          br(),
          p("该品牌存在未确认的门店信息修改，请前往确认")
        ))
      } else if (input$brand_select == "BURBERRY") {
        showModal(modalDialog(
          HTML('<p style="color: green;">正常</p>'),
          br(),
          p("该品牌所有门店信息均已确认，无异常")
        ))
      }
    }
  )
  
  observeEvent(
    input$queue_check,
    {
      if(input$brand_select == "GUCCI") {
        showModal(modalDialog(
          tableOutput("queue_table")
        ))
      } else if (input$brand_select == "BURBERRY") {
        showModal(modalDialog(
          tableOutput("queue_table")
        ))
      }
    }
  )
  
  queue_example <- data.frame(
    `任务ID` = c("114514","114515","114516"),
    `发起者` = c("Su Xu", "Su", "Xu"),
    `状态` = c("运行中", "运行中", "队列中")
  )
  
  output$queue_table <- renderTable({
    queue_example
  })
  
  
  listing %>% 
    filter(Name == FALSE | Address == FALSE | Phone == FALSE) %>% 
    mutate(平台 = toupper(平台)) -> listing
  
  the_recheck_df <- function(the_row){
    rbind(
      c(listing$名称[the_row],listing$地址[the_row],listing$电话[the_row],listing$区[the_row],listing$市[the_row],listing$省[the_row]),
      c(listing$平台名称[the_row],listing$平台地址[the_row],listing$平台电话[the_row],listing$平台区[the_row],listing$平台市[the_row],listing$平台省[the_row]),
      c(listing$Name[the_row],listing$Address[the_row],listing$Phone[the_row],TRUE,TRUE,TRUE)
    ) %>% 
      as.data.frame() -> recheck_df
    colnames(recheck_df) <- c("名称对比","地址对比","电话对比","区对比","市对比","省对比")
    return (recheck_df)
  }
  
  # output$first <- renderTable({
  #   the_recheck_df(the_row = 1)
  # })
  
  output$first <- renderDT({
    datatable(the_recheck_df(the_row = 1), editable = TRUE, options = list(paging = FALSE, searching = FALSE, info = FALSE),rownames = FALSE)
  })
  
  output$second <- renderDT({
    datatable(the_recheck_df(the_row = 2), editable = TRUE, options = list(paging = FALSE, searching = FALSE, info = FALSE),rownames = FALSE)
  })
  
  output$third <- renderDT({
    datatable(the_recheck_df(the_row = 3), editable = TRUE, options = list(paging = FALSE, searching = FALSE, info = FALSE),rownames = FALSE)
  })
  
  output$fourth <- renderDT({
    datatable(the_recheck_df(the_row = 4), editable = TRUE, options = list(paging = FALSE, searching = FALSE, info = FALSE),rownames = FALSE)
  })
  
  output$five <- renderDT({
    datatable(the_recheck_df(the_row = 5), editable = TRUE, options = list(paging = FALSE, searching = FALSE, info = FALSE),rownames = FALSE)
  })
  
  observeEvent(
    input$recheck_confirm,
    {
      if(input$recheckSelector == "GUCCI") {
        showModal(modalDialog(
          HTML('<p style="color: red;">ERROR</p>'),
          br(),
          p("很抱歉，您所选择的品牌 GUCCI 无法被操作"),
          br(),
          p("原因：本周Publishers数据未被获取，请前往脚本运行获取相关数据")
        ))
      } else if (input$recheckSelector == "PRADA") {
        showModal(modalDialog(
          HTML('<p style="color: green;">SUCCESS</p>'),
          br(),
          p("Publisher Check已更新")
        ))
      }
    }
  )
  
  observeEvent(input$recheck_load, {
    # 在按钮点击事件中将按钮的值设置为0
    updateActionButton(session, "recheck_load", label = "确认加载")
  })
}