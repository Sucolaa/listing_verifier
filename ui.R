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
  dashboardSidebar(),
  dashboardBody()
)