#
# Projekt: statistik Hausarbeit mit Aquariumdaten
# Nguyen, Kim Anh 563958
# Melchert, Niklas 
#
# Hier entsteht das user interface. 
# Dieses ist eingeteilt in 3 panels/tabs/pages
# Page 1: Intro: Aufgabenstellung und Zusammenfassung der App
# Page 2: Daten visualisierung (nur Tabelle) als Überblick
# Page 3: Konfidenzintervall - dynamische Anzeige durch User input
# 

#
# PAGE 1 - Introduction "Intro"
#
page1_panel <- tabPanel(
  "Intro",
  
  titlePanel("Intro"),
  
  #  img(src = "img source"),
  h2("Aufgabe der Hausarbeit"),
  p(
  "Aufgabe der Hausarbeit ist, eine interaktive Visualisierung mit Shiny in R zu bauen, welche ein statistisches Konzept aus der Vorlesung demonstriert.",br(),
  "Beispiele wären die Regel von Bayes, Konfidenzintervalle oder Hypothesentests.", br(),
  "So könnten Sie z.B. Daten auf Knopfdruck künstlich erzeugen und visualisieren und dabei Parametereinstellungen", br(),
  "wie die Größe des Datensatzes, Wahrscheinlichkeitsverteilung, Streuung, Konfidenz- oder Signifikanzniveau ermöglichen.", br(),
  "Darauf basierend könnten Sie z.B. Konfidenzintervalle berechnen oder Hypothesentests durchführen und die Ergebnisse visualisieren.", br(),
  "Die Shiny-App könnte dann interaktiv den Einfluss der Parameter auf die Ergebnisse demonstrieren wie etwa den Einfluss", br(),
  "von Stichprobengröße und Konfidenz-/Signifikanzniveau auf die Größe des Konfidenzintervalls oder auf das Ergebnis des Hypothesentests.",br(),br(), 
  
  "Als Alternative zu künstlichen Daten können Sie auch echte Daten (z.B. COVID-19-Daten vom Robert-Koch-Institut) benutzen - entweder komplett oder Stichproben daraus.", br(),br(),
  
  "Ich erwarte Visualisierungen von Daten und Ergebnissen, welche z.B. durch Drop-Down-Menüs, Slider und Knöpfe verändert werden können, um die Daten und Ergebnisse zu explorieren.",br(),
  "Weiterhin können Sie sich von interaktiven Visualisierungen im Internet inspirieren lassen und diese teilweise in Shiny nachbauen.",br(),br(),
  
  "Wichtig: Geben Sie wie bei den bewerteten Aufgaben bitte immer die Quellen an, egal ob von Daten, Code, Beschreibungen oder anderen Visualisierungen.",br(),
  "Einfaches Kopieren einer Visualisierung durch Kopieren des Codes werte ich als Plagiat, aber inhaltliche Inspiration mit eigener Implementierung ist in Ordnung.",br(),br(), 
  
  "Unter https://shiny.rstudio.com/tutorial/ finden Sie ausführliche Tutorials zum Bauen von Shiny-Apps mit vielen Beispielen.",br(),
  "Links zu anderen Beispielen, welche wir in der Vorlesung besprochen haben, finden Sie in unserem Moodlekurs (zu den Themen Würfelwahrscheinlichkeit und Genauigkeit von COVID-19-Tests)."), 
  
  h4("Abgabetermin ist der 28.06.2021 um 23:59."), 
  br(),
  h4("Abgabe in Ihrer Gruppe:"),
  p("Quellcode der Shiny-App in Moodle hochladen.", br(),
  "Stellen Sie sicher, dass dieser ausführbar ist und geben Sie die Quellen in der laufenden Shiny-App sichtbar an.", br(),
  "Stellen Sie Ihre Shiny-App auf https://www.shinyapps.io zur Verfügung und geben den Link an.",br(),br(),
  
  "Beschreiben Sie die interaktive Visualisierung auf einer Seite Text mit Quellenangaben und geben das Dokument in Moodle ab.",br(),br(),
  
  "Präsentation: Am ", strong("30.06.2021"), "müssen Sie in den Übungen Kurzpräsentationen Ihrer Shiny-Apps geben, alle Gruppenmitglieder müssen anwesend sein und präsentieren."),
  
  h2("Quellen"),
  pre (a(href = "https://github.com/kmnhngyn/statistik", "Eigene GitHub Repo"),
       a(href = "http://nguyenkim.shinyapps.io/statistik_hausarbeit/", "Deployment auf shinyapps.io")
      )
)

################################################################################

#
# PAGE 2 - Vizualization Tabelle "Datentabelle"
#
page2_sidebar <- sidebarPanel(
  selectInput(
    # select widget var
    "page2",
    label = "Was möchtest du anzeigen lassen?",
    #select_values = colnames(data),
    #choices = colnames(data),
    #selected = "Speed"
    choices = c( "Alle Werte", "Temperatur","Ammoniak","pH","Nitrit.NO2", "Nitrat.NO3","Phosphat.PO4","kH","GH","Fe","CO2"),
    selected = ""
  )
)

page2_main <- fluidPage(
  textOutput("selected_page2"),
  h2("Hier werden berechnete Daten ausgegeben."),
  textOutput("mittelwert"),
  textOutput("standardabweichung"),
  DT::dataTableOutput("table")
  # br(),
)

page2_panel <- tabPanel(
  "Datentabelle",
  titlePanel("Datentabelle"),
  sidebarLayout(
    page2_sidebar, page2_main
  )
)

################################################################################

#
# PAGE 3 - "Konfidenzintervalle" 
#
page3_sidebar <- sidebarPanel(
  inputPanel(
    sliderInput("upperBoundary", "Vertrauensniveau bestimmen", min = 0, max = 0.99, step = 0.01, value = 0.95)
  ),
  selectInput(
    "page3",
    label = "Welchen Wert möchtest du genauer betrachten?",
    #select_values = colnames(data),
    choices = c("Temperatur","Ammoniak","pH","Nitrit.NO2", "Nitrat.NO3","Phosphat.PO4","kH","GH","Fe","CO2"),
    selected = "Temperatur"
  )
)

page3_main <- fluidPage(
  h2("Hier werden berechnete Daten ausgegeben."),
  htmlOutput("konfiParameters"),
  plotOutput("konfiPlot"),
 
)

page3_panel <- tabPanel("Konfidenzintervalle",
  titlePanel("Konfidenzintervalle"),
  sidebarLayout(
    page3_sidebar, page3_main
  )
)

################################################################################

# Navigation - alle pages sichtbar machen
ui <- navbarPage(
  "Statistik Hausarbeit",
  page1_panel,
  page2_panel,
  page3_panel
)