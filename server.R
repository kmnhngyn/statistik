# Define server logic required to draw a histogram
#
# The Server controls the data that will be displayed through the UI.
# The server will be where you load in and wrangle data,
# then define your outputs (i.e. plots) using input from the UI.

# Load libraries, data
library(dplyr)
#library(ggplot2)
#characters <- read.csv(url("www"))

aquarium_df <- read.csv(file = 'data/aquarium.csv', header = TRUE, sep = ",")
nitrat_df <- subset(aquarium_df, select = c("Nitrat"))
# co2_df <- aquarium_df["CO2"]
# nitrat_c02 <- aquarium_df[, c("Nitrat","CO2")]

# Create server
server <- function(input, output) {
  
  # Side panel in page 2
  output$selected_var <- renderText({
    paste("Deine Auswahl ist ", input$var)
  })
  
#--------------------------------------------------------------------------------------------------------  
# Main content in page 2
  
  output$mittelwert <- renderText({
    if(input$var == "Alle Werte"){
      paste ("")
    } else {
      if(input$var == "Nitrat-NO3"){
        mean <- mean(aquarium_df$Nitrat)
      } else if(input$var == "CO2"){
        mean <- mean(aquarium_df$CO2)
      }
      paste("Der Mittelwert von ", input$var, " beträgt: ", mean)
    }
  })
  
  output$standardabweichung <- renderText({
    if(input$var == "Alle Werte"){
      paste("")
    } else{
      if(input$var == "Nitrat-NO3"){
        sd <- sd(aquarium_df$Nitrat)
      }
      if(input$var == "CO2"){
        sd <- sd(aquarium_df$CO2)
      }
      paste("Die Standardabweichung von ", input$var, " beträgt: ", sd)
    }
  })
  
  # dynamic output table
  reactive_df <- reactive({
    if(input$var == "Alle Werte"){
      table_df <- aquarium_df
    }
    if(input$var == "Nitrat-NO3"){
      table_df <- subset(aquarium_df, select = c("Date","Nitrat"))
    }
    if(input$var == "CO2"){
      table_df <- subset(aquarium_df, select = c("Date","CO2"))
    }
    return 
  })
  
  # table with all data
  output$all_table<- DT::renderDataTable({
    # aquarium_df <- read.csv(file = 'data/aquarium.csv', header = TRUE, sep = ",")
    # DT::datatable(aquarium_df)
    # nitrat_df <- aquarium_df["Nitrat"]
    paste(h2("Tabelle"))
    DT::datatable(reactive_df())
  })
  
  #table only nitrat
  output$nitrat_table<- DT::renderDataTable({
    # aquarium_df <- read.csv(file = 'data/aquarium.csv', header = TRUE, sep = ",")
    # DT::datatable(aquarium_df)
    # nitrat_df <- aquarium_df["Nitrat"]
    DT::datatable(nitrat_df)
  })
  
  # Plot
  output$aquarium_plot <- renderPlot({
    plot(nitrat_df)
  })
  
  #--------------------------------------------------------------------------------------------------------
  # Content in page 3
  # Analysieren des Inputs - "Temperatur", "pH","Nitrat","Phosphat", "kH", "GH", "Fe", "CO2"
  konfiWerteTyp <- reactive({
    if(input$analyticType == "Temperatur"){
      konfiTable <- subset(aquarium_df, select = c("Temperatur"))
      konfiMW <- mean(konfiTable$Temperatur)
      konfiStabw <- sd(konfiTable$Temperatur)
      konfiLength <- length((konfiTable$Temperatur))
      konfiFreiheitsgrad <- konfiLength - 1
    }
    if(input$analyticType == "pH"){
      konfiTable <- subset(aquarium_df, select = c("pH"))
      konfiMW <- mean(konfiTable$pH)
      konfiStabw <- sd(konfiTable$pH)
      konfiLength <- length((konfiTable$pH))
      konfiFreiheitsgrad <- konfiLength - 1
    }
    if(input$analyticType == "Nitrat"){
      konfiTable <- subset(aquarium_df, select = c("Nitrat"))
      konfiMW <- mean(konfiTable$Nitrat)
      konfiStabw <- sd(konfiTable$Nitrat)
      konfiLength <- length((konfiTable$Nitrat))
      konfiFreiheitsgrad <- konfiLength - 1
    }
    if(input$analyticType == "Phosphat"){
      konfiTable <- subset(aquarium_df, select = c("Phosphat"))
      konfiMW <- mean(konfiTable$Phosphat)
      konfiStabw <- sd(konfiTable$Phosphat)
      konfiLength <- length((konfiTable$Phosphat))
      konfiFreiheitsgrad <- konfiLength - 1
    }
    if(input$analyticType == "kH"){
      konfiTable <- subset(aquarium_df, select = c("kH"))
      konfiMW <- mean(konfiTable$kH)
      konfiStabw <- sd(konfiTable$kH)
      konfiLength <- length((konfiTable$kH))
      konfiFreiheitsgrad <- konfiLength - 1
    }
    if(input$analyticType == "GH"){
      konfiTable <- subset(aquarium_df, select = c("GH"))
      konfiMW <- mean(konfiTable$GH)
      konfiStabw <- sd(konfiTable$GH)
      konfiLength <- length((konfiTable$GH))
      konfiFreiheitsgrad <- konfiLength - 1
    }
    if(input$analyticType == "Fe"){
      konfiTable <- subset(aquarium_df, select = c("Fe"))
      konfiMW <- mean(konfiTable$Fe)
      konfiStabw <- sd(konfiTable$Fe)
      konfiLength <- length((konfiTable$Fe))
      konfiFreiheitsgrad <- konfiLength - 1
    }
    if(input$analyticType == "CO2"){
      konfiTable <- subset(aquarium_df, select = c("CO2"))
      konfiMW <- mean(konfiTable$CO2)
      konfiStabw <- sd(konfiTable$CO2)
      konfiLength <- length((konfiTable$CO2))
      konfiFreiheitsgrad <- konfiLength - 1
    }
    return 
  })
  
  output$konfiIntervall <- renderPlot({
    #Berechnung des Konfidenzintervalls
    warschein <- 1 - (input$upperBoundary- input$lowerBoundary)/100 # Warscheinlichkeit berechnen
    t_Quantil <- qt(warschein, konfiFreiheitsgrad)
    vertrBereich <- t_Quantil * konfiStabw / sqrt(n)
    vertrBereichUnten <- konfiMW - vertrBereich
    vertrBereichOben <- konfiMW + vertrBereich
    
    #Visualisieren des Konfidenzintervalls
    plot(konfiTable)
  })
  
  #--------------------------------------------------------------------------------------------------------
  # Content in page 4
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
