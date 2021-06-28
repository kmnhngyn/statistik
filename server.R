#
# Projekt: statistik Hausarbeit mit Aquariumdaten
# Nguyen, Kim Anh 563958
# Melchert, Niklas 560671
#
# Hier entsteht die Logik. 
# Für jede Page, die in ui.R definiert ist,
# wird hier Logik, Funktionen definiert.
# output funktionen dienen der Ausgabe im ui.
# 

# Load libraries
library(dplyr)
library(DescTools)
library(ggplot2)
library(data.table)
library(RColorBrewer)

# Load data
aquarium_df <- read.csv(file = 'data/aquarium.csv', header = TRUE, sep = ",")

#
# Server erstellen.
# Hier drin wird die Logik definiert
#
server <- function(input, output) {
  ########### PAGE 2 ###########
  
  #
  # Ausgabe von Text, welche Auswahl der user getroffen hat.
  # input$page2 ist die Auswahl des users
  # für die Tabellenausgabe
  #
  # output$selected_page2 <- renderText({
  #   paste("Deine Auswahl ist ", input$page2)
  # })
  
  # 
  # Berechnung und Ausgabe von Mittelwert
  # basierend auf Auswahl von user
  # wenn der user 'Alle Werte' auswählt,
  # dann wird kein mittelwert berechnet.
  # 
  output$mittelwert <- renderText({
    if(input$page2 == "Alle Werte"){
      paste ("")
    } else {
      # mean() - Mittelwert, NA werden gedropped
      mean <- mean(aquarium_df[, c(input$page2)], na.rm = TRUE)
      paste("Der Mittelwert von ", input$page2, " beträgt: ", round(mean,3))
    }
  })
  
  # 
  # Berechnung und Ausgabe von Standardabweichung
  # basierend auf Auswahl von user
  # wenn der user 'Alle Werte' auswählt,
  # dann wird keine standardabweichung berechnet.
  #
  output$standardabweichung <- renderText({
    if(input$page2 == "Alle Werte"){
      paste("")
    } else{
      # sd() - Standardabweichung, NA werden gedropped
      sd <- sd(aquarium_df[, c(input$page2)], na.rm=TRUE)
      paste("Die Standardabweichung von ", input$page2, " beträgt: ", round(sd,3))
    }
  })
  
  # 
  # Funktionen zum Erstellen der Tabelle
  # basierend auf Auswahl von user.
  # wenn 'Alle Werte', dann die ganze Tabelle
  # ansonsten entsprechender Parameter
  #
  calculate_table <- reactive({
    if(input$page2 == "Alle Werte"){
      table_df <- aquarium_df
    } else {
      table_df <- subset(aquarium_df, select = c("Date",input$page2))
    }
    return (table_df)
  })
  
  #
  # Ausgabe der Tabelle
  # basierend auf Funktion 
  # calculate_table()
  #
  output$table<- DT::renderDataTable({
    paste(h2("Tabelle für ", input$page2))
    DT::datatable(calculate_table())
  })
  
  #
  # Ausgabe der Daten als Histogramm
  # Dafür wird ebenfalls das Ergebnis des Dropdownmenüs genutzt.
  #
  
  output$HistPlot <- renderPlot({
    # Anzeigen aller Werte, nur damit der Plot gerendert werden kann
    if(input$page2 == "Alle Werte"){
      g <- ggplot(aquarium_df, aes(x=Date,group = 1)) + 
        geom_line(aes(y = pH, color="pH")) + 
        geom_line(aes(y = GH, color="GH")) +
        geom_line(aes(y = kH, color="kH")) +
        geom_line(aes(y = Ammoniak, color="Ammoniak")) + 
        geom_line(aes(y = Nitrit.NO2, color="Nitrit.NO2")) + 
        geom_line(aes(y = Nitrat.NO3, color="Nitrat.NO3")) + 
        geom_line(aes(y = Phosphat.PO4, color="Phosphat.PO4")) + 
        geom_line(aes(y = Fe, color="Fe")) + 
        geom_line(aes(y = Cu, color="Cu")) +
        geom_line(aes(y = Cl, color="Cl")) +
        geom_line(aes(y = CO2, color="CO2")) +
        geom_line(aes(y = Temperatur, color="Temperatur")) + 
        labs(x = "Datum", y = "Alle Wasserwerte",colour ='Werte') + 
        theme(legend.position="bottom")
      
    } else {
      # Anzeigen von spezifischen Werten mit den Korridoren, wo diese liegen sollten
      x <- calculate_table()
      g <- ggplot(x, aes(x=Date,y = x[,c(2)],group = 1,color=input$page2)) + 
        geom_line() + 
        labs(x = "Datum", y = input$page2,colour = "Wert") +  
        theme(legend.position="bottom")
      if(input$page2 == "pH"){
        g <- g + geom_ribbon(aes(x=Date, ymin=6.5, ymax=8.5), fill="cadetblue1", alpha=0.07,colour = NA)
      }
      else if(input$page2 == "GH"){
        g <- g + geom_ribbon(aes(x=Date, ymin=8, ymax=15), fill="chartreuse", alpha=0.07,colour = NA)
      }
      else if(input$page2 == "kH"){
        g <- g + geom_ribbon(aes(x=Date, ymin=5, ymax=12), fill="chocolate1", alpha=0.07,colour = NA)
      }
      else if(input$page2 == "Ammoniak"){
        g <- g + geom_ribbon(aes(x=Date, ymin=0, ymax=0.01), fill="cornflowerblue", alpha=0.07,colour = NA)
      }
      else if(input$page2 == "Nitrit.NO2"){
        g <- g + geom_ribbon(aes(x=Date, ymin=0, ymax=0.2), fill="darkgoldenrod1", alpha=0.07,colour = NA)
      }
      else if(input$page2 == "Nitrat.NO3"){
        g <- g + geom_ribbon(aes(x=Date, ymin=15, ymax=50), fill="firebrick1", alpha=0.07,colour = NA)
      }
      else if(input$page2 == "Phosphat.PO4"){
        g <- g + geom_ribbon(aes(x=Date, ymin=0, ymax=0.4), fill="gold1", alpha=0.07,colour = NA)
      }
      else if(input$page2 == "Fe"){
        g <- g + geom_ribbon(aes(x=Date, ymin=0.05, ymax=0.2), fill="deeppink", alpha=0.07,colour = NA)
      }
      else if(input$page2 == "Cu"){
        g <- g + geom_ribbon(aes(x=Date, ymin=0, ymax=0.1), fill="gray50", alpha=0.07,colour = NA)
      }
      else if(input$page2 == "Cl"){
        g <- g + geom_ribbon(aes(x=Date, ymin=0, ymax=0.1), fill="lawngreen", alpha=0.07,colour = NA)
      }
      else if(input$page2 == "CO2"){
        g <- g + geom_ribbon(aes(x=Date, ymin=15, ymax=35), fill="hotpink1", alpha=0.07,colour = NA)
      }
      else if(input$page2 == "Temperatur"){
        g <- g + geom_ribbon(aes(x=Date, ymin=23, ymax=28), fill="purple1", alpha=0.07,colour = NA)
      }
      else{
        "Fehler"
      }
    }
    plot(g)
  })
  
  # Rendert den CO2-Plot, wenn einer der CO2 relevanten Werte selektiert ist
  output$Co2PhKh <- renderPlot({
    if(input$page2 == "pH" || input$page2 == "kH" || input$page2 == "CO2"){
      g2 <- ggplot(aquarium_df, aes(x=Date,group = 1)) +
        geom_line(aes(y = pH, color="pH")) +
        geom_line(aes(y = kH, color="kH")) +
        geom_line(aes(y = CO2, color="CO2")) +
        geom_line(aes(y = Temperatur, color="Temperatur")) +
        labs(x = "Datum", y = "Co2-Relevate Wasserwerte",colour ='Werte') + 
        theme(legend.position="bottom")
      plot(g2)
    }
  })
  
  # Rendert den CO2-Plot, wenn einer der CO2 relevanten Werte selektiert ist
  output$Co2PhKhText <- renderText({
    if(input$page2 == "pH" || input$page2 == "kH" || input$page2 == "CO2"){
      paste("CO2-Wert relevante Werte: ","Der CO2-Wert (Kohlendioxid), KH-Wert (Karbonathärte) und pH-Wert des Wassers stehen in einem festen mathematischen Verhältnis. Bei zwei bekannten Werten kann so der gesuchte fehlende Wert errechnet werden. Da die Messgrößen pH und KH über die Standard-Messverfahren (Tropfentest) leicht ermittelbar sind, eine CO2-Messung jedoch nur im Labor möglich ist, wird im Normalfall bei bekanntem KH- und pH-Wert der vorliegende CO2-Wert errechnet. Die zugrundeliegende Formel berücksichtigt nicht alle als Säuren vorliegenden Salze und ist daher nur als Näherungswert zu sehen. Das Ergebnis ist jedoch in der aquaristischen Praxis als ausreichend genau anzusehen. Bei sehr kleinen KH-Werten (Umkehrosmosewasser) sind jedoch die verfügbaren Messverfahren zu ungenau um eine vernünftige Aussage zu treffen. ", br())
    }
  })
  
  
  ########### PAGE 3 ###########
  
  # Tabelle erstellen mit den ausgewählten werten
  # na.omit löscht alle Zeilen mit NA
  getKonfiTable <- reactive({
    konfiTable <- subset(aquarium_df, select = c("Date", input$page3))
    return (na.omit(konfiTable))
  })
  
  # getKonfiMW <- reactive({
  #   konfiMW <- mean(getKonfiTable()[, c(input$page3)])
  #   return(konfiMW)
  # })
  
  getKonfiStabw <- reactive({
    konfiStabw <- sd(getKonfiTable()[, c(input$page3)])
    return(konfiStabw)
  })
  
  # getKonfiLength <- reactive({
  #   # konfiLength <- length(getKonfiTable())
  #   konfiLength <- nrow(getKonfiTable())
  #   return(konfiLength)
  # })
  
  # getKonfiFreiheitsgrad <- reactive({
  #   konfiFreiheitsgrad <- getKonfiLength() - 1
  #   return(konfiFreiheitsgrad)
  # })
  
  # erläuerung von MeanCI Konfidenzintervall für
  # mittelwerte: http://www.mathcs.emory.edu/~fox/NewCCS/ModuleV/ModVP9.html
  # 
  
  #
  # Für Konfidenzintervalle die Funktion MeanCI.
  # MeanCI gibt uns Mittelwert und obere und untere Grenze
  # basierend auf dem Konfidenzniveau
  # das niveau basiert auf auswahl von user
  #
  calculateCI <- reactive({
    mCI <- MeanCI(getKonfiTable()[, c(input$page3)], conf.level = (input$upperBoundary/100))
    mCI <- as.data.frame(t(mCI))
    return(mCI)
  })
  
  #
  # Tabelle erstellen mit den berechneten Werten
  # aus Funktion calculateCI(), um später auf die Werte zugreifen zu können
  #
  ci_table_dynamic <- reactive({
    mCI <- MeanCI(getKonfiTable()[, c(input$page3)], conf.level = (input$upperBoundary/100), na.rm = TRUE)
    
    ci_dt = data.table(
      Parameter = c(input$page3),
      mean = c(mCI["mean"]),
      lwr.ci = c(mCI["lwr.ci"]),
      upr.ci = c(mCI["upr.ci"])
    )
    return(ci_dt)
  })
  
  #
  # berechnete Werte erstmal als text/info ausgeben
  #
  output$konfiParameters <- renderUI({
    str1 <- paste("Standardabweichung für ", input$page3, ": ", round(getKonfiStabw(),3))
    str2 <- paste("Mittelwert für ", input$page3, ": ", round(calculateCI()[, c("mean")],3))
    str3 <- paste("Unterer Wert Konfidenzintervall für ", input$page3, ": ", round(calculateCI()[, c("lwr.ci")],3), "(bei ", input$upperBoundary, "% Konfidenzniveau)")
    str4 <- paste("Oberer Wert Konfidenzintervall für ", input$page3, ": ", round(calculateCI()[, c("upr.ci")],3), "(bei ", input$upperBoundary, "% Konfidenzniveau)")
    HTML(paste(str1, str2, str3, str4, sep = '<br/>'))
  })
  
  # 
  # PLOT: Konfidenzintervall
  # Hier wird das Konfidenzintervall geplottet
  # 
  output$konfiPlot <- renderPlot({
    # https://rpubs.com/techanswers88/MeanAndConfidenceIntervals
    ggplot(data = ci_table_dynamic()) +
      geom_bar(aes(x=Parameter, y=mean, fill = Parameter), stat = "identity", fill = "#69b3a2", alpha =0.7) +
      geom_errorbar(aes(x=Parameter, ymin=lwr.ci, ymax=upr.ci), width = 0.2, color = "red", size =1) +
      geom_text(aes(x=Parameter, y=lwr.ci, label = round(lwr.ci,3)), size= 3, vjust = 2) +
      geom_text(aes(x=Parameter, y=upr.ci, label = round(upr.ci,3)), size= 3, vjust = -1) +
      labs(title = paste("Konfidenzintervall für ", input$page3, " mit ", input$upperBoundary, "% Konfidenzniveau")) +
      labs(x= "Parameter", y = "Mittelwert des Parameters")
  })
}