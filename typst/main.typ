// ==========================
// CONFIG
// ==========================

#set document(
  title: "Multiagentengestützte Analyse von Energie- und Wasser-Zeitreihendaten",
  author: "Schwarz David",
  date: datetime.today(),
)

#set text(font: "Times New Roman", size: 11pt, lang: "de")

#set page(margin: (top: 2.5cm, bottom: 2.5cm, left: 3cm, right: 2.5cm))

#set heading(numbering: "1.")

// Titelseite
#let titlepage() = context [
  #page[
    #align(center)[
      #text(size: 24pt, weight: "bold")[#document.title]

      #v(2cm)

      #text(size: 16pt)[#document.author.first()]

      #v(1cm)

      #text(size: 12pt)[
        #document.date.display("[day].[month].[year]")
      ]
    ]
  ]
]

// ==========================
// DOCUMENT STRUCTURE
// ==========================

// title
#titlepage()
#pagebreak()

// directory
#outline(title: "Inhaltsverzeichnis")
#pagebreak()

// content
#include "sections/01_introduction.typ"
#pagebreak()
#include "sections/02_orchestration.typ"
#pagebreak()
#include "sections/03_timeseries.typ"
#pagebreak()
#include "sections/99_training.typ"
#pagebreak()

// references
#bibliography("refs.bib", style: "ieee")