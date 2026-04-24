= Orchestrierung

Die Grundidee ist es einen Supervisor Agent zu haben der optional auf spezialisierte Agents zugreift. Dieses Konzept ist in @fig:high-level_mantra_architecture_proposal dargestellt.

#figure(
  image("../figures/orchestration/high-level_mantra_architecture_proposal.png", width: 80%),
  caption: [High-level MANTRA architecture proposal],
) <fig:high-level_mantra_architecture_proposal>

== Toolorchestration
Mit Tools sind hier externe Funktionen, Programme oder Schnittstellen gemeint, die es dem Sprachmodell ermöglichen, über die reine Textgenerierung hinaus Aktionen auszuführen. Das kann sein auf Datenbanken zuzugreifen, Berechnungen durchzuführen, Grafiken genereiren und so weiter. Hiefür gibt es veschiedene Orchestrierungsmethoden die ich in folgende Kategorien einteilen möchte um einen groben Überblick über Möglichkeiten und Einschränkungen zu geben. Diese Thesen basieren teils nur auf Annahmen und sind auch Kontextabhängig.

MCP

=== Deterministisch
Hier werden fixe Pipelines definiert die jeweils eine bestimmte Intention abdecken sollen. Das LLM soll diese Intention erkennen und arbeitet dann deterministisch die zugrundeliegende Pipeline ab. Das ist sehr effizient und gut kontrollierbar. Effizient ist es deshalb, weil nur ein LLM-Aufruf für die Intentionserkennung notwendig ist und gegebenenfalls ein zweiter für die generierung der finalen Anwort. Die Pipelines sind klar vordefiniert und deswegen gut optimierbar und bieten auch eine sehr gute Kontrolle was passieren soll und was nicht. Einschränkungen sind hier, dass man nicht flexibel auf Anfragen reagieren kann die neu sind oder mehrere Intentionen so kombinieren wie man es nicht vordefiniert hat.

=== Plan-Basiert
Die Idee ist das LLM einen Plan bauen zu lassen wie die verfügbaren Tools aufgerufen werden sollen um die Nutzeranfrage optimal zu erfüllen. So wird man deutlich flexibler was neue Anfragen angeht. Allerdings verliert man auch Kontrolle und es gibt mehr Fehlerpotential.

=== Iterativ (ReAct)
ReAct (Reasoning + Acting) ist eine Methode wo das LLM den Tooloutput wieder als Input bekommt und überprüft ob die Informationen ausreichend sind oder weitere Toolaufrufe erforderlich sind. Es werden so lange neue Toolaufrufe getriggert bis das LLM entscheidet, dass es nun genügend oder die passenden Informationen erhalten hat. Es ist ratsam hierfür ein Schleifenlimit zu setzen, um die Kosten und die Laufzeit unter Kontrolle zu halten.

React beschreiben: @hernandezReActModularAgent2025

#figure(
  image("../figures/orchestration/hierarchical_react_agent_architecture.png", width: 80%),
  caption: [Hierachical ReAct agent architecture @hernandezReActModularAgent2025],
) <fig:hierarchical_react_agent_architecture>

== Agenten

=== Supervisor
Iterativ / deterministisch

=== Chatverlauf
Iterativ

=== Energiedaten (Zeitreihendaten)
Iterativ


== Datenbankabfrage

=== Text to SQL
Tabellennamen usw. müssen vielleicht erklärt werden

=== Funktionen
Funktionsnamen und Parameter können gut verständlich formuliert und zusätzlich beschrieben werden


#bibliography("../refs.bib", style: "ieee")