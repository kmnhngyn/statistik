# Define server logic required to draw a histogram
#
# The Server controls the data that will be displayed through the UI.
# The server will be where you load in and wrangle data,
# then define your outputs (i.e. plots) using input from the UI.

# Load libraries, data
library(dplyr)
#library(ggplot2)

aquarium_df <- read.csv(file = 'data/aquarium.csv', header = TRUE, sep = ",")
nitrat_df <- aquarium_df["Nitrat.NO3"]
# co2_df <- aquarium_df["CO2"]
# nitrat_c02 <- aquarium_df[, c("Nitrat.NO3","CO2")]

# Create server
server <- function(input, output) {
  
  # PAGE 2: Side panel
  output$selected_var <- renderText({
    paste("Deine Auswahl ist ", input$var)
  })
  
  # PAGE 2: main content
  
  # PAGE 2: mean
  output$mittelwert <- renderText({
    if(input$var == "Alle Werte"){
      paste ("")
    } else {
      if(input$var == "Nitrat-NO3"){
        mean <- mean(aquarium_df$Nitrat.NO3)
      } else if(input$var == "CO2"){
        mean <- mean(aquarium_df$CO2)
      }
      paste("Der Mittelwert von ", input$var, " beträgt: ", mean)
    }
  })
  
  # PAGE 2: stadnard deviation
  output$standardabweichung <- renderText({
    if(input$var == "Alle Werte"){
      paste("")
    } else{
      if(input$var == "Nitrat-NO3"){
        sd <- sd(aquarium_df$Nitrat.NO3)
      }
      if(input$var == "CO2"){
        sd <- sd(aquarium_df$CO2)
      }
      paste("Die Standardabweichung von ", input$var, " beträgt: ", sd)
    }
  })
  
  # function to set df based on user input
  # necessary for dynamic table view output
  reactive_df <- reactive({
    if(input$var == "Alle Werte"){
      table_df <- aquarium_df
    }
    if(input$var == "Nitrat-NO3"){
      table_df <- subset(aquarium_df, select = c("Date","Nitrat.NO3"))
    }
    if(input$var == "CO2"){
      table_df <- subset(aquarium_df, select = c("Date","CO2"))
    }
    return(table_df)
  })
  
  # PAGE 2: output table view
  output$all_table<- DT::renderDataTable({
    # aquarium_df <- read.csv(file = 'data/aquarium.csv', header = TRUE, sep = ",")
    # DT::datatable(aquarium_df)
    # nitrat_df <- aquarium_df["Nitrat.NO3"]
    paste(h2("Tabelle"))
    DT::datatable(reactive_df())
  })
  
  # PAGE 2: Plot
  output$aquarium_plot <- renderPlot({
    plot(nitrat_df)
  })
  
# ------------------------------------------------------------------------------
  
  # PAGE 3: Content
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
