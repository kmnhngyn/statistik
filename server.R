# Define server logic required to draw a histogram
#
# The Server controls the data that will be displayed through the UI.
# The server will be where you load in and wrangle data,
# then define your outputs (i.e. plots) using input from the UI.

server <- function(input, output) {
  
  output$distPlot <- renderPlot({
    # generate bins based on input$bins from ui.R
    x    <- faithful[, 2]
    bins <- seq(min(x), max(x), length.out = input$bins + 1)
    
    # draw the histogram with the specified number of bins
    hist(x, breaks = bins, col = 'darkgray', border = 'white')
  })
}