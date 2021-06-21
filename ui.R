# Define UI for application that draws a histogram

# Load libraries, data
#characters <- read.csv(url("https://github.com/yhejazi/tutorials/blob/main/rshiny/data/characters.csv"))

# Page 1 - Introduction "Intro"
intro_panel <- tabPanel(
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
       a(href = "https://riptutorial.com/shiny/example/32449/uploading-csv-files-to-shiny", "CSV laden und darstellen (Page 3)")
      )
)

# ------------------------------------------------------------------------------

# Page 2 - Vizualization "Daten"
daten_sidebar <- sidebarPanel(
  selectInput(
    # select widget var
    "var",
    label = "Was möchtest du anzeigen lassen?",
    #select_values = colnames(data),
    #choices = colnames(data),
    #selected = "Speed"
    choices = c( "Alle Werte",
                 "Nitrat-NO3",
                 "CO2"),
    selected = "Nitrat"
  )
)

daten_main <- fluidPage(
  #plotOutput("plot")
  # textOutput("selected_var"),
  # h2("Tabellenausgabe"),
  DT::dataTableOutput("all_table"),
  br(),
  h2("Hier werden berechnete Daten ausgegeben."),
  textOutput("mittelwert"),
  textOutput("standardabweichung"),
  textOutput("untergrenze"),
  textOutput("obergrenze"),
  # TODO: diese ansicht dynamisch machen
  # h3("Tabelle für Nitrat"),
  # DT::dataTableOutput("nitrat_table")
  # plotOutput("aquarium_plot")
)

daten_panel <- tabPanel(
  "Daten",
  titlePanel("Daten"),
  sidebarLayout(
    daten_sidebar, daten_main
  )
)
#--------------------------------------------------------------------------------------------------------
#Page 3 - Slider für das Festlegen der Größe der Konfidenzintervalle
konfi_sidebar <- sidebarPanel(
  inputPanel(
    sliderInput("lowerBoundary", "Untere Grenze", min = 0, max = 100, step = 1, value = 7)
  ),
  inputPanel(
    sliderInput("upperBoundary", "Obere Grenze", min = 0, max = 100, step = 1, value = 7)
  ),
  selectInput(
    "analyticType",
    label = "Welchen Wert möchtest du gernauer betrachten?",
    #select_values = colnames(data),
    choices = c("Temperatur","pH","Nitrat","Phosphat","kH","GH","Fe","CO2"),
    selected = "Temperatur"
  )
)

#Page 3 - Anzeigen des Konfidenzintervalls (Mit Selector für welchen Wert dies berechnet werden soll???)
konfi_main <- fluidPage(
  plotOutput("konfiIntervall"),
  
 # plot(1, sapply(2, function(z) erwartete_kosten(z)), xlab = "Anzahl bestellter Ersatzteile", pch=16, col="darkblue", cex=2,
 #      ylab = "Kosten", main = "Gesamtkosten für Lagerung und Nachbestellungen über der Anzahl bestellter Ersatzteile")
 
)

# Page 3 - Visualisierung Konfidenzintervalle
konfi_panel <- tabPanel("Konfidenzintervalle",
  titlePanel("Konfidenzintervalle"),
  sidebarLayout(
    konfi_sidebar, konfi_main
  )
)

#--------------------------------------------------------------------------------------------------------
# Page 4 - Vizualization "CSV"
csv_panel <- tabPanel(
  "CSV-Umwandlung",
  titlePanel("CSV-Umwandlung"),
  fluidPage(
    fileInput('target_upload', 'Choose file to upload',
              accept = c(
                'text/csv',
                'text/comma-separated-values',
                '.csv'
              )
    ),
    radioButtons("separator","Please select separator: ",choices = c(";",",",":"), selected=";",inline=TRUE),
    DT::dataTableOutput("sample_table")
  )
)

#--------------------------------------------------------------------------------------------------------------
# Navigation - show all tabs
ui <- navbarPage(
  "Statistik Hausarbeit",
  intro_panel,
  daten_panel,
  konfi_panel,
  csv_panel
)