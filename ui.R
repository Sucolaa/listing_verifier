library(shiny)
source("share_loads.R")
walk(list.files("uis", full.names = TRUE), ~ source(.x))
walk(list.files("scripts", full.names = TRUE), ~ source(.x))

dashboardPage(
  skin = "black",
  dashboardHeader(
    title = span("PROTOTYPES",
                 style = "font-weight:bold;"),
    disable = FALSE
  ),
  dashboardSidebar( 
    sidebarMenu(
      mission_ask_menu,
      manual_check_menu
    )
  ),
  dashboardBody(
    tabItems(
      mission_ask_tab,
      manual_check_tab
    )
  )
)