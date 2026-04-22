// ==========================
// CONFIG
// ==========================

#set document(
  title: "Forschungsprojekt",
  author: "Dein Name",
  date: datetime.today(),
)

#set text(font: "Times New Roman", size: 11pt, lang: "de")

#set page(margin: (top: 2.5cm, bottom: 2.5cm, left: 3cm, right: 2.5cm))

#set heading(numbering: "1.")

// Inhaltsverzeichnis
#outline(title: "Inhaltsverzeichnis")
#pagebreak()

// ==========================
// DOCUMENT STRUCTURE
// ==========================

#include "sections/00_Einleitung.typ"
#include "sections/01_Zeitreihendaten.typ"

#pagebreak()

#bibliography("refs.bib", style: "ieee")