# Statistik Hausarbeit

## Inhalt der Hausarbeit
Diese Hausarbeit wurde von Nguyen, Kim Anh (563958) und Melchert, Niklas (560671) erstellt. 
Wir haben uns für das Visualisieren von Konfidenzintervallen entschieden. 
Dafür haben wir in R/Shiny diese App umgesetzt, welche die Daten durch den Nutzer steuerbar anzeigen kann. 
Um die Möglichkeiten aufzuzeigen, haben wir verschiedene Reiter implementiert, in welchen die verschiedenen Funktionen präsentiert werden. 
Als Datenquelle wurden echte Werte eines Aquariums genutzt, diese enthalten die Wasserwerte, welche über einen Zeitraum von 4 Monaten zum Teil automatisch ermittelt wurden.
Deployment auf shinyapps.io: http://nguyenkim.shinyapps.io/statistik_hausarbeit/

## Aufbau der shinyapp
- Seite 1 'Intro': Ist eine Intro Seite, mit Erläuterungen, wie die App funktioniert. 
- Seite 2 'Datentabelle': Stellt die Daten in einer Tabelle da und ermöglicht eine Darstellung, welche die einzelnen Werte selektierbar macht und nur für diese dann eine Anzeige erstellt. 
- Seite 3 'Konfidenzintervalle': Auf dieser Seite werden die Konfidenzintervalle dargestellt. Die Darstellung bzw. das Konfidenzintervall lässt sich durch einen Slider für das Konfidenzniveau beeinflussen und stellt dies dann entsprechend visualisiert dar. 

## Quellen & Links

- Aquariumdaten / Wasserwerte: Eigener Datensatz
- Erläuterung der Wasserwerte: https://www.garnelio.de/blog/wasserchemie/die-wichtigsten-wasserwerte-im-aquarium
- Erläuterung des CO2-Wertes: https://www.aquaristik-hilfe.de/calc01.htm

- Konfidenzintervalle erklärt: https://statistikgrundlagen.de/ebook/chapter/konfidenzintervalle/
- Berechnung von Mittelwert und Konfidenzintervalle in R: https://rpubs.com/techanswers88/MeanAndConfidenceIntervals
- Erläuterung und Verwendung von R-Funktion MeanCI: http://www.mathcs.emory.edu/~fox/NewCCS/ModuleV/ModVP9.html

- Eigene GitHub Repo: https://github.com/kmnhngyn/statistik
- Deployment auf shinyapps.io: http://nguyenkim.shinyapps.io/statistik_hausarbeit/

## Contributors
- Nguyen, Kim Anh (563958)
- Melchert, Niklas (560671)
