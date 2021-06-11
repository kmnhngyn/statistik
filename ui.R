# Define UI for application that draws a histogram

# Load libraries, data
#characters <- read.csv(url("https://github.com/yhejazi/tutorials/blob/main/rshiny/data/characters.csv"))

# Page 1 - Introduction "Intro"
intro_panel <- tabPanel(
  "Intro",
  
  titlePanel("Intro"),
  
  #  img(src = "img source"),
  h2("Aufgabe der Hausarbeit"),
  p("Aufgabe der Hausarbeit ist, eine interaktive Visualisierung mit Shiny in R zu bauen, welche ein statistisches Konzept aus der Vorlesung demonstriert. Beispiele wären die Regel von Bayes, Konfidenzintervalle oder Hypothesentests. So könnten Sie z.B. Daten auf Knopfdruck künstlich erzeugen und visualisieren und dabei Parametereinstellungen wie die Größe des Datensatzes, Wahrscheinlichkeitsverteilung, Streuung, Konfidenz- oder Signifikanzniveau ermöglichen. Darauf basierend könnten Sie z.B. Konfidenzintervalle berechnen oder Hypothesentests durchführen und die Ergebnisse visualisieren. Die Shiny-App könnte dann interaktiv den Einfluss der Parameter auf die Ergebnisse demonstrieren wie etwa den Einfluss von Stichprobengröße und Konfidenz-/Signifikanzniveau auf die Größe des Konfidenzintervalls oder auf das Ergebnis des Hypothesentests. 
    Als Alternative zu künstlichen Daten können Sie auch echte Daten (z.B. COVID-19-Daten vom Robert-Koch-Institut) benutzen - entweder komplett oder Stichproben daraus.
    Ich erwarte Visualisierungen von Daten und Ergebnissen, welche z.B. durch Drop-Down-Menüs, Slider und Knöpfe verändert werden können, um die Daten und Ergebnisse zu explorieren. Weiterhin können Sie sich von interaktiven Visualisierungen im Internet inspirieren lassen und diese teilweise in Shiny nachbauen."), 
  
  p("Wichtig: Geben Sie wie bei den bewerteten Aufgaben bitte immer die Quellen an, egal ob von Daten, Code, Beschreibungen oder anderen Visualisierungen. Einfaches Kopieren einer Visualisierung durch Kopieren des Codes werte ich als Plagiat, aber inhaltliche Inspiration mit eigener Implementierung ist in Ordnung."), 
  
  p("Unter https://shiny.rstudio.com/tutorial/ finden Sie ausführliche Tutorials zum Bauen von Shiny-Apps mit vielen Beispielen. Links zu anderen Beispielen, welche wir in der Vorlesung besprochen haben, finden Sie in unserem Moodlekurs (zu den Themen Würfelwahrscheinlichkeit und Genauigkeit von COVID-19-Tests)."), 
  
  h4("Abgabetermin ist der 28.06.2021 um 23:59."), 
  
  h4("Abgabe in Ihrer Gruppe:"),
  p("Quellcode der Shiny-App in Moodle hochladen. Stellen Sie sicher, dass dieser ausführbar ist und geben Sie die Quellen in der laufenden Shiny-App sichtbar an. 
    Stellen Sie Ihre Shiny-App auf https://www.shinyapps.io zur Verfügung und geben den Link an."),
  
  p("Beschreiben Sie die interaktive Visualisierung auf einer Seite Text mit Quellenangaben und geben das Dokument in Moodle ab."),
  
  p("Präsentation: Am 30.06.2021 müssen Sie in den Übungen Kurzpräsentationen Ihrer Shiny-Apps geben, alle Gruppenmitglieder müssen anwesend sein und präsentieren."),
  
  br(),
  h4("Quellen"),
  p(a(href = "https://github.com/kmnhngyn/statistik", "Eigene GitHub Repo")),
  p(a(href = "https://riptutorial.com/shiny/example/32449/uploading-csv-files-to-shiny", "CSV laden und darstellen (Page 3)"))
  
)

# ------------------------------------------------------------------------------

# Page 2 - Vizualization "Daten"
daten_sidebar <- sidebarPanel(
  selectInput(
    # select widget var
    "var",
    label = "Auswahl",
    #select_values = colnames(data),
    #choices = colnames(data),
    #selected = "Speed"
    choices = c( "Auswahl 1",
                 "Auswahl 2",
                 "Auswahl 3"),
    selected = "Keine Auswahl"
  )
)

main_content <- mainPanel(
  #plotOutput("plot")
  textOutput("selected_var"),
  DT::dataTableOutput("data_table")
)

daten_panel <- tabPanel(
  "Daten",
  titlePanel("Daten"),
  sidebarLayout(
    daten_sidebar, main_content
  )
)


# Page 3 - Vizualization "CSV"
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

# Navigation - show all tabs
ui <- navbarPage(
  "Statistik Hausarbeit",
  intro_panel,
  daten_panel,
  csv_panel
)