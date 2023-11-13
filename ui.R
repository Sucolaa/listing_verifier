library(shiny)
source("share_loads.R")
walk(list.files("uis", full.names = TRUE), ~ source(.x))
walk(list.files("scripts", full.names = TRUE), ~ source(.x))

dashboardPage(
  skin = "black",
  dashboardHeader(
    title = span("Listing Verifier",
                 style = "font-weight:bold;"),
    disable = FALSE
  ),
  dashboardSidebar(
    disable = TRUE,
    sidebarMenu(
      id = "tabs",
      menuSubItem(text = "original", tabName = "original"),
      menuSubItem(text = "tencent", tabName = "tencent")
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(
        tabName = "original", titlePanel(title = "A"),
        actionButton("btn1", "Go to tab tencent" )
      ),
      tabItem(
        tabName = "tencent", titlePanel(title = "B")
      )
    )
  )
)