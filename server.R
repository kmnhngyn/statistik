# Define server logic required to draw a histogram
#
# The Server controls the data that will be displayed through the UI.
# The server will be where you load in and wrangle data,
# then define your outputs (i.e. plots) using input from the UI.

# Load libraries, data
library(dplyr)
library(DescTools)
library(ggplot2)
library(data.table)

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
  
  # TEST HARDCODE
  calculateCI_table <- reactive({
    mCI_Temp <- MeanCI(aquarium_df$Temperatur, conf.level = input$upperBoundary)
    mCI_Nitrat <- MeanCI(aquarium_df$Nitrat.NO3, conf.level = input$upperBoundary)
    mCI_CO2 <- MeanCI(aquarium_df$CO2, conf.level = input$upperBoundary)
    
    dt = data.table(
      Parameter = c("Temperatur", "Nitrat", "CO2"),
      mean = c(mCI_Temp["mean"],mCI_Nitrat["mean"],mCI_CO2["mean"]),
      lwr.ci = c(mCI_Temp["lwr.ci"],mCI_Nitrat["lwr.ci"],mCI_CO2["lwr.ci"]),
      upr.ci = c(mCI_Temp["upr.ci"],mCI_Nitrat["upr.ci"],mCI_CO2["upr.ci"])
    )
    return(dt)
  })
  
  # table mit mean, untere grenze und obere grenze berechnen
  # auf basis von user input
  # user inout: parameter und vertrauensniveau
  ci_table_dynamic <- reactive({
    mCI <- MeanCI(getKonfiTable()[, c(input$page3)], conf.level = input$upperBoundary, na.rm = TRUE)
    
    ci_dt = data.table(
      Parameter = c(input$page3),
      mean = c(mCI["mean"]),
      lwr.ci = c(mCI["lwr.ci"]),
      upr.ci = c(mCI["upr.ci"])
    )
    return(ci_dt)
  })
  
  output$konfiParameters <- renderUI({
    str1 <- paste("KonfiMW: ", round(getKonfiMW(),3))
    str2 <- paste("KonfiStabw: ", round(getKonfiStabw(),3))
    str3 <- paste("KonfiLength: ", getKonfiLength())
    str4 <- paste("KonfiFreiheitsgrad: ", getKonfiFreiheitsgrad())
    str5 <- paste("mean of function MeanCI: ", round(calculateCI()[, c("mean")],3))
    str6 <- paste("Unterer Wert Konfidenzintervall: ", round(calculateCI()[, c("lwr.ci")],3))
    str7 <- paste("Oberer Wert Konfidenzintervall: ", round(calculateCI()[, c("upr.ci")],3))
    HTML(paste(str1, str2, str3, str4, str5, str6, str7, sep = '<br/>'))
  })
  
  # PLOT: Konfidenzintervall
  output$konfiPlot <- renderPlot({
    #### TEST
    
    ggplot(data = ci_table_dynamic()) +
      geom_bar(aes(x=Parameter, y=mean, fill = Parameter), stat = "identity", fill = "#69b3a2", alpha =0.7) +
      geom_errorbar(aes(x=Parameter, ymin=lwr.ci, ymax=upr.ci), width = 0.2, color = "red", size =1) +
      geom_text(aes(x=Parameter, y=lwr.ci, label = round(lwr.ci,3)), size= 3, vjust = 2) +
      geom_text(aes(x=Parameter, y=upr.ci, label = round(upr.ci,3)), size= 3, vjust = -1) +
      labs(title = paste("Konfidenzintervall für ", input$page3, " mit ", input$upperBoundary, " Vertrauensniveau")) +
      labs(x= "Parameter", y = "Mittelwert des Parameters")
    
    ### TEST ENDE
    
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
