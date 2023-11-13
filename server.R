source("share_loads.R")
walk(list.files("ui_scripts", full.names = TRUE), ~ source(.x))

