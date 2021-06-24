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
  img(src = "Aquarium_Foto.PNG"),br(),
  h2("Aufgabe der Hausarbeit"),
  p(
    "Bei dieser Hausarbeit haben wir uns für das visualiseren von Konfidenzintervallen entschieden.",br(),
    "Dafür haben wir in R/ shiny diese App umgesetzt, welche die Daten durch den Nutzer steuerbar anzeigen kann.",br(),
    "Um die Möglichkeiten aufzuzeigen, haben wir verschiedene 'Reiter' implementiert, in welchen die verschiednen Funktionen präsentiert werden.",br(),
    h3("Funktionen:"),br(),
    " - Seite 1: Ist diese Intro Seite, mit den Erläuterungen, wie die App funktioniert.",br(),
    " - Seite 2: Stellt die Daten in einer Tabelle da und ermöglicht eine Darstellung, welche die einzelnen Werte selektierbar macht und nur für diese dann eine Anzeige erstellt.",br(),
    " - Seite 3: Auf dieser Seite wurden die Konfidenzintervalle dargestellt, die Darstellung bzw. das Konfidenzintervall lässt sich durch einen Slider beeinflussen und stellt dies dann entsprechend visualisiert dar.",br(),
    "   Dafür wird ein Graph erzuegt, welcher die Datenwerte anzeigt, so wie die Sicherheit/ das Konfidenzintervall.", br(),br(),
    h3("Daten/ Erläuterung:"),br(),
    "Als Datenquelle wurden echte Werte eines Aquariums genutzt, diese enthalten die Wasserwerte, welche über einen Zeitraum von 4 Monaten zum eil automatisch ermittelt wurden.",br(),
    h4("Gesamthärte (GH)"),"Die Gesamthärte setzt sich aus allen Erdalkali-Ionen zusammen, die im Wasser gelöst sind. Die wichtigsten Härtebildner im Aquarium sind Kalzium (Ca) und Magnesium (Mg). Strontium und Barium spielen im Süßwasser nur eine sehr untergeordnete Rolle.Der Bereich von 0-7 °dGH gilt als weich, 7-14 als mittelhart und alles über 14 Grad deutscher Gesamthärte gilt als hartes Wasser.",br(),
    h4("Karbonathärte (KH):"),"Die Karbonathärte (KH) misst den Anteil der an Karbonate und Hydrogenkarbonate gebundenen Erdalkali-Ionen - damit ist sie eigentlich Teil der Gesamthärte. Die in der Aquaristik gängigen Tests messen jedoch nicht die 'echte' Karbonathärte, sondern lediglich das Säurebindungsvermögen, Dieser Test ist gröber und schließt alle Karbonate und Hydrogenkarbonate ein, auch die, die an Nicht-Erdalkali-Metalle gebunden sind (wie zum Beispiel an Natrium).",br(),
    h4("pH-Wert (pH):") ,"Der pH-Wert beschreibt, ob das Wasser im Aquarium sauer, neutral oder basisch ist. Jede Stufe der Skala erhöht sich um den Faktor 10 - ein pH von 6 ist zehnmal so sauer wie ein pH von 7. Bei einem pH-Wert von 0 bis 7 spricht man von saurem Wasser. Der Bereich um 7,5 ist neutral, und alles über 7,5 ist basisch.",br(),
    h4("Kohlendioxid-Wert (CO2):"),"CO2 spielt im Zusammenhang mit dem pH-Wert und der Karbonathärte ebenfalls eine wichtige Rolle in der allgemeinen Aquaristik. Ein CO2-Wert von 20-30 mg/Liter sollte im Aquarium zu keiner Zeit überschritten werden. CO2 ist ein Abfallstoff der Atmung von Fischen, Wirbellosen und Pflanzen und gleichzeitig ein sehr wichtiger Nährstoff für die Pflanzen, ohne den sie keine Energie produzieren und keinen Sauerstoff synthetisieren können. Fische und Wirbellose geben das CO2 aus ihrem Blut über einfache Osmose ans Wasser ab. Das bedeutet, dass der Stoff immer aus der stärkeren in die schwächere Lösung wandert.",br(),
    h4("Nitritwert (NO2):"),"Nitrit (NO2) ist eine Stickstoffverbindung, die im Verlauf des Stickstoffkreislaufs von Bakterien aus Ammonium oder Ammoniak gebildet wird. Nitrit ist für Fische sehr giftig, weil es sich an die Stelle von Sauerstoff andockt und die Rezeptoren für Sauerstoff blockiert. Die Fische können so im schlimmsten Fall ersticken. Bei Garnelen und anderen Wirbellosen ist die Giftigkeit von Nitrit unterschiedlich stark ausgeprägt. Caridina-Garnelen aus Weichwasser sind fast genauso empfindlich gegenüber NO2 wie Fische, während Neocaridina-Garnelen beispielsweise von zehnfach überhöhten Nitritwerten vollkommen unbeeindruckt erscheinen.",br(),
    h4("Ammonium und Ammoniak (NH4 und NH3):"),"Die Stickstoffverbindung Ammonium (NH4) entsteht, wenn sich Eiweiß aus dem Futter und dem Kot der Aquarientiere zersetzt. Es wird von Bakterien zu Nitrit verstoffwechselt und von Pflanzen sehr gerne als Stickstoffquelle genutzt. Ammonium ist daher im Aquarienwasser bei einem gut arbeitenden Filter und ordentlich wachsenden Pflanzen nicht nachweisbar, und der Stoff selbst ist für Fische und Wirbellose nicht giftig.",br(),
    h4("Nitratwert (NO3):"),"Die Stickstoffverbindung Nitrat (NO3) ist das Endprodukt der Nitrifizierung, also das letzte Abbauprodukt in der Kette der Eiweißverwertung im Aquarium. Die Reihenfolge lautet: Eiweiß -> Ammonium/Ammoniak -> Nitrit -> Nitrat. Nitrat ist ein wichtiger Pflanzennährstoff und eine gute Stickstoffquelle für die Aquarienpflanzen.",br(),
    h4("Kupferwert (Cu):"),"Kupfer (Cu) ist für Fische zwar auch giftig, jedoch ist das Schwermetall für Garnelen noch deutlich toxischer.",br(),  
    h4("Phosphatwert (PO4):"),"Ein zu hoher Phosphatwert (PO4) im Aquarium steht im Verdacht, für Häutungsprobleme oder Missbildungen bei Garnelen und für mangelnde Zuchterfolge generell bei Krebstieren verantwortlich zu sein. Des weiteren kann ein zu hoher Phosphatgehalt im Aquarium die Ursache für Algenplagen sein.",br(),  
    h4("Eisenwert (Fe):"),"Eisen (Fe) brauchen die Aquarienpflanzen zur Ausbildung des Blattgrüns. Ohne Eisen keine Photosynthese und damit keine Energiegewinnung. Eisenmangel lässt zuerst die jungen Blätter und die Triebspitzen gelblich-blass wirken, während die Blattadern grün bleiben - die Pflanze entwickelt eine sogenannte Chlorose. Eisen gehört zu den Mikronährstoffen, die Pflanzen brauchen also nicht sehr viel davon. Ein zu hoher Eisenwert im Aquarium kann die Bildung von Rotalgen (Pinselalgen, Bartalgen, Froschlaichalgen und Co.) fördern.",br(),
  ),  br(),
  
  h4("Abgabe in Ihrer Gruppe:"),
  p("Quellcode der Shiny-App in Moodle hochladen.", br(),h4("Abgabetermin ist der 28.06.2021 um 23:59."),
  "Stellen Sie sicher, dass dieser ausführbar ist und geben Sie die Quellen in der laufenden Shiny-App sichtbar an.", br(),
  "Stellen Sie Ihre Shiny-App auf https://www.shinyapps.io zur Verfügung und geben den Link an.",br(),br(),
  
  "Beschreiben Sie die interaktive Visualisierung auf einer Seite Text mit Quellenangaben und geben das Dokument in Moodle ab.",br(),br(),
  
  "Präsentation: Am ", strong("30.06.2021"), "müssen Sie in den Übungen Kurzpräsentationen Ihrer Shiny-Apps geben, alle Gruppenmitglieder müssen anwesend sein und präsentieren."),
  
  h2("Quellen"),
  pre (a(href = "https://github.com/kmnhngyn/statistik", "Eigene GitHub Repo"),
       a(href = "http://nguyenkim.shinyapps.io/statistik_hausarbeit/", "Deployment auf shinyapps.io"),
       "Wasserwerte - Eigener Datensatz",
       a(href = "https://www.garnelio.de/blog/wasserchemie/die-wichtigsten-wasserwerte-im-aquarium", "Erläuterung der Wasserwerte"),
       a(href = "https://www.aquaristik-hilfe.de/calc01.htm", "Erläuterung des CO2-Wertes")
       
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
  DT::dataTableOutput("table"),
  br(),
  h3("Hier werden berechnete Daten visualisert."),
  plotOutput(outputId = "HistPlot"), br(),
  textOutput(outputId = "Co2PhKhText"),br(),
  plotOutput(outputId = "Co2PhKh")
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