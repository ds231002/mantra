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

  #pagebreak()
]

#titlepage()

// Inhaltsverzeichnis
#outline(title: "Inhaltsverzeichnis")
#pagebreak()

// ==========================
// DOCUMENT STRUCTURE
// ==========================

// = Thema 1
// Testzitat @liuPictureWorthThousand

// == Thema 1.1

// = Thema 2

// == Thema 2.2

// #include "sections/00_introduction.typ"
// #pagebreak()
// #include "sections/01_orchestration.typ"
// #pagebreak()
// #include "sections/03_timeseries.typ"

#pagebreak()

#bibliography("refs.bib", style: "ieee")