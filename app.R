#
# Projekt: statistik Hausarbeit mit Aquariumdaten
# Nguyen, Kim Anh 563958
# Melchert, Niklas 
#
# Zusammenführung von Logik ui.R
# und dem interface app.R.
# 

---
output: html_document
runtime: shiny
---

library(shiny)

# Deploy app to shinyapps.io
# https://shiny.rstudio.com/articles/shinyapps.html?_ga=2.32781886.1071253345.1623331937-2125071896.1623331937
# library(rsconnect)
# rsconnect::deployApp('path/to/your/app') # deployApp()

# Run the application 
source("ui.R")
source("server.R")
shinyApp(ui = ui, server = server)