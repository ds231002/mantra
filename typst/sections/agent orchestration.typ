= Agent-Orchestration
Die Grundidee ist es einen Supervisor Agent zu haben der optional auf spezialisierte Agents zugreift. Dieses Konzept ist in @fig:high-level_mantra_architecture_proposal dargestellt.

#figure(
  image("../figures/orchestration/high-level_mantra_architecture_proposal.png", width: 80%),
  caption: [High-level MANTRA architecture proposal],
) <fig:high-level_mantra_architecture_proposal>

== Agenten
Allgemein kann ein iterativer Prozess, bei dem überprüft wird ob schon alle wichtigen Informationen enthalten sind oder weitere Agentaufrufe oder Toolaufrufe sinnvoll sind, die Qualität des Outputs verbessern. Iteration kann die Outputqualität erhöhen, benötigt aber entsprechend viele Tokens, weil immer wieder der gesamte Kontext inklusive vorheriger Outputs übergeben und analysiert werden muss. Baut man spezialisierte Agents, kann man diesen nur den Kontext geben den sie wirklich brauchen. So werden diese schneller, effizienter und in der Regel auch besser in der Erfüllung ihrer Aufgabe, weil sie weniger irrelevante Information erhalten.

=== Supervisor
Der Supervisor soll effizient und schnell sein. Sind detailierte Analysen oder Toolaufrufe notwendig soll dieser an spezialisierte Agents delegieren. Ich denke es wäre am sinnvollsten diesen iterativ zu gestalten sofern Agenten befragt werden. Kommt eine Anfrage die keine Agenten benötigt wird die Anfrage möglichst effizient verarbeitet. Wird ein Agent befragt wird der Output bewertet und entschieden ob weitere Agentenaufrufe und damit gegebenenfalls verbundene Toolaufrufe sinnvoll sind oder nicht.

=== Chatverlauf
Eine Idee um den Supervisor zu entlasten ist die spezialisierte Suche im Chatverlauf an einen Agent auslagert. Dieser soll nach Zeiträumen, Schlagwörtern usw. suchen können.

=== Energiedaten (Zeitreihendaten)
Dieser Agent soll auf Tools zugreifen können, um die Datenbank abzufragen und Berechnungen durchzuführen. Zusätzlich zu der Aufgabe Daten nur zu extrahieren könnte er auch dafür verantwortlich sein diese zu interetieren und Plots zu erzeugen.