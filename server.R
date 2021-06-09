# Define server logic required to draw a histogram
#
# The Server controls the data that will be displayed through the UI.
# The server will be where you load in and wrangle data,
# then define your outputs (i.e. plots) using input from the UI.

# Load libraries, data
#library(ggplot2)
#characters <- read.csv(url("www"))


# Create server
server <- function(input, output) {
  
  output$selected_var <- renderText({
    paste("Deine Aushwal ist ", input$var)
  })
}
