library(shiny)
library(DT)

ui <- fluidPage(
  titlePanel("可编辑表格示例"),
  DTOutput("table_output")
)

server <- function(input, output, session) {
  # 初始数据框
  data <- data.frame(
    ID = c(1, 2, 3),
    Name = c("John", "Jane", "Jim"),
    Age = c(25, 30, 22)
  )
  
  # 渲染可编辑表格
  output$table_output <- renderDT({
    datatable(data, editable = TRUE, options = list(paging = FALSE, searching = FALSE, info = FALSE),rownames = FALSE)
  })
  
  # 当用户编辑表格时，更新数据
  observeEvent(input$table_output_cell_edit, {
    info <- input$table_output_cell_edit
    str(info)  # 输出编辑信息，你可以根据需要处理这些信息
    
    modified_data <- data
    modified_data[info$row, info$col] <- info$value
    
    # 更新表格
    replaceData(proxy = dataTableProxy("table_output"), data = modified_data, resetPaging = FALSE, rownames = FALSE)
  })
}

shinyApp(ui, server)
