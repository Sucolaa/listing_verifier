library(shiny)
library(tidyverse)

ui <- fluidPage(
  tableOutput("first")
)

server <- function(input, output, session) {
  listing %>% 
    filter(Name == FALSE | Address == FALSE | Phone == FALSE) %>% 
    mutate(平台 = toupper(平台)) -> listing
  
  rbind(
    c(listing$名称[1],listing$地址[1],listing$电话[1],listing$区[1],listing$市[1],listing$省[1]),
    c(listing$平台名称[1],listing$平台地址[1],listing$平台电话[1],listing$平台区[1],listing$平台市[1],listing$平台省[1]),
    c(listing$Name[1],listing$Address[1],listing$Phone[1],TRUE,TRUE,TRUE)
  ) %>% 
    as.data.frame() -> recheck_df
  
  colnames(recheck_df) <- c("名称对比","地址对比","电话对比","区对比","市对比","省对比")
  
  output$first <- renderTable({
    recheck_df
  })
  
  # output$first <- renderDT({
  #   datatable(
  #     recheck_df, 
  #     editable = TRUE,
  #     callback = JS(
  #       'table.on("cellEdit", function (e, datatable, cell) {',
  #       '  var col = cell.index().column;',
  #       '  if (col === (datatable.columns().indexes().length - 1)) {',
  #       '    var value = cell.data();',
  #       '    if (value !== "TRUE" && value !== "FALSE") {',
  #       '      var select = document.createElement("select");',
  #       '      select.innerHTML = "<option value=\'TRUE\'>TRUE</option><option value=\'FALSE\'>FALSE</option>";',
  #       '      cell.node().innerHTML = "";',
  #       '      cell.node().appendChild(select);',
  #       '      select.value = value;',
  #       '      select.focus();',
  #       '    }',
  #       '  }',
  #       '});'
  #     )
  #   )
  # }, server = FALSE)
}

shinyApp(ui, server)
#> 
#> Listening on http://127.0.0.1:6810



