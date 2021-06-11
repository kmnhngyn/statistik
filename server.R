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
    paste("Deine Auswahl ist ", input$var)
  })
  
  output$data_table<- DT::renderDataTable({
    df <- read.csv(file = 'data/aquarium.csv', header = TRUE, sep = ",")
    DT::datatable(df)
  })
  
  df_products_upload <- reactive({
    inFile <- input$target_upload
    if (is.null(inFile))
      return(NULL)
    df <- read.csv(inFile$datapath, header = TRUE,sep = input$separator)
    return(df)
  })

  output$sample_table<- DT::renderDataTable({
    df <- df_products_upload()
    DT::datatable(df)
  })
}
