# Define server logic required to draw a histogram
#
# The Server controls the data that will be displayed through the UI.
# The server will be where you load in and wrangle data,
# then define your outputs (i.e. plots) using input from the UI.

# Load libraries, data
library(dplyr)
library(DescTools)
library(ggplot2)

aquarium_df <- read.csv(file = 'data/aquarium.csv', header = TRUE, sep = ",")
# nitrat_df <- subset(aquarium_df, select = c("Nitrat"))
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
      mean <- mean(aquarium_df[, c(input$var)], na.rm = TRUE)
      paste("Der Mittelwert von ", input$var, " beträgt: ", mean)
    }
  })
  
  output$standardabweichung <- renderText({
    if(input$var == "Alle Werte"){
      paste("")
    } else{
      sd <- sd(aquarium_df[, c(input$var)], na.rm=TRUE)
      paste("Die Standardabweichung von ", input$var, " beträgt: ", sd)
    }
  })
  
  # dynamic output table
  reactive_df <- reactive({
    if(input$var == "Alle Werte"){
      table_df <- aquarium_df
    } else {
      table_df <- subset(aquarium_df, select = c("Date",input$var))
    }
    return (table_df)
  })
  
  # table with all data
  output$all_table<- DT::renderDataTable({
    # aquarium_df <- read.csv(file = 'data/aquarium.csv', header = TRUE, sep = ",")
    # DT::datatable(aquarium_df)
    # nitrat_df <- aquarium_df["Nitrat"]
    paste(h2("Tabelle"))
    DT::datatable(reactive_df())
  })
  
  # Plot
  output$aquarium_plot <- renderPlot({
    plot(nitrat_df)
  })
  
  #--------------------------------------------------------------------------------------------------------
  # Content in page 3
  
  # 
  # Folgende Funktionen dienen
  # um Konfidenz parameter zu berechnen
  # 
  
  # Tabelle erstellen mit den ausgewählten werten
  # na.omit löscht alle Zeilen mit NA
  getKonfiTable <- reactive({
    konfiTable <- subset(aquarium_df, select = c("Date", input$page3))
    return (na.omit(konfiTable))
  })
  
  getKonfiMW <- reactive({
    konfiMW <- mean(getKonfiTable()[, c(input$page3)])
    return(konfiMW)
  })
  
  getKonfiStabw <- reactive({
    konfiStabw <- sd(getKonfiTable()[, c(input$page3)])
    return(konfiStabw)
  })
  
  getKonfiLength <- reactive({
    # konfiLength <- length(getKonfiTable())
    konfiLength <- nrow(getKonfiTable())
    return(konfiLength)
  })
  
  getKonfiFreiheitsgrad <- reactive({
    konfiFreiheitsgrad <- getKonfiLength() - 1
    return(konfiFreiheitsgrad)
  })
  
  # erläuerung von MeanCI Konfidenzintervall für
  # mittelwerte: http://www.mathcs.emory.edu/~fox/NewCCS/ModuleV/ModVP9.html
  # 
  calculateCI <- reactive({
    mCI <- MeanCI(getKonfiTable()[, c(input$page3)], conf.level = input$upperBoundary)
    mCI <- as.data.frame(t(mCI))
    return(mCI)
  })
  
  output$konfiParameters <- renderUI({
    str1 <- paste("KonfiMW: ", getKonfiMW())
    str2 <- paste("KonfiStabw: ", getKonfiStabw())
    str3 <- paste("KonfiLength: ", getKonfiLength())
    str4 <- paste("KonfiFreiheitsgrad: ", getKonfiFreiheitsgrad())
    str5 <- paste("CI Tools: ", calculateCI()[, c("mean")])
    str6 <- paste("CI Tools: ", calculateCI()[, c("lwr.ci")])
    str7 <- paste("CI Tools: ", calculateCI()[, c("upr.ci")])
    HTML(paste(str1, str2, str3, str4, str5, str6, str7, sep = '<br/>'))
  })
  
  output$konfiPlot <- renderPlot({
    #Berechnung des Konfidenzintervalls - Hilfestellung: https://www.youtube.com/watch?v=1iy1_h5FuT4
    # warschein <- 1 - (input$upperBoundary- input$lowerBoundary)/100 # Warscheinlichkeit berechnen
    # t_Quantil <- qt(warschein, konfiFreiheitsgrad)
    # vertrBereich <- t_Quantil * konfiStabw / sqrt(konfiLength)
    # vertrBereichUnten <- konfiMW - vertrBereich
    # vertrBereichOben <- konfiMW + vertrBereich
    # 
    # #Visualisieren des Konfidenzintervalls
    # titleKonfi <- "Darstellung eines Konfidenzintervalls"
    # error.bars(stats=getKonfiTable()[, c(input$page3)],main="data with confidence intervals")
    
    # ggplot(my_sum) +
    #   geom_bar( aes(x=Species, y=mean), stat="identity", fill="forestgreen", alpha=0.5) +
    #   geom_errorbar( aes(x=Species, ymin=mean-ic, ymax=mean+ic), width=0.4, colour="orange", alpha=0.9, size=1.5) +
    #   ggtitle("using confidence interval")
    
    # ggplot(data = getKonfiTable()) +
    #   geom_bar(aes(x=Date, y=(getKonfiTable()[, c(input$page3)])), stat="identity", fill="forestgreen", alpha=0.5)
    
    #### TEST
    # für ganzes aquarium
    aquarium_df_test <- subset(aquarium_df, select = c("Temperatur", "pH", "kH", "CO2"))
    aqua_mean <- colMeans(aquarium_df_test[sapply(aquarium_df_test, is.numeric)])
    aquarium_df_max <- aquarium_df_test %>% summarise_if(is.numeric, max, na.rm = TRUE)
    aquarium_df_min <- aquarium_df_test %>% summarise_if(is.numeric, min, na.rm = TRUE)
    parameter_names <- colnames(aquarium_df_test)
    # parameter_names <- colnames(aquarium_df[-length(aquarium_df)])
    # parameter_names <- c(parameter_names[-1])
    aqua <- data_frame(parameter=c("Temperatur","pH", "kH", "CO2"), mean=c(25.635,7.20,7.58,12.76), lower=c(24.6,6.5,3,0), upper=c(27,7.6,11,39))

    ggplot() +
      geom_errorbar(data=aqua, mapping=aes(x=parameter, ymin=upper, ymax=lower), width=0.2, size=1, color="blue")

    
    ### TEST ENDE
    
      #geom_bar(aes(x=Date, y=), stat="identity", fill="forestgreen", alpha=0.5)
      
    # error.bars(stats=getKonfiTable()[, c(input$page3)],main="data with confidence intervals")
  })
  
  # output$konfiIntervall <- renderPlot({
  #   #Berechnung des Konfidenzintervalls - Hilfestellung: https://www.youtube.com/watch?v=1iy1_h5FuT4
  #   warschein <- 1 - (input$upperBoundary- input$lowerBoundary)/100 # Warscheinlichkeit berechnen
  #   t_Quantil <- qt(warschein, konfiFreiheitsgrad)
  #   vertrBereich <- t_Quantil * konfiStabw / sqrt(konfiLength)
  #   vertrBereichUnten <- konfiMW - vertrBereich
  #   vertrBereichOben <- konfiMW + vertrBereich
  # 
  #   #Visualisieren des Konfidenzintervalls
  #   titleKonfi <- "Darstellung eines Konfidenzintervalls"
  # 
  #   #plot(konfiTable)
  # })
  
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
