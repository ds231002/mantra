= Orchestrierung

Die Grundidee ist es einen Supervisor Agent zu haben der optional auf spezialisierte Agents zugreift. Dieses Konzept ist in @fig:high-level_mantra_architecture_proposal dargestellt.

#figure(
  image("../figures/orchestration/high-level_mantra_architecture_proposal.png", width: 80%),
  caption: [High-level MANTRA architecture proposal],
) <fig:high-level_mantra_architecture_proposal>

== Toolorchestration
Mit Tools sind hier externe Funktionen, Programme oder Schnittstellen gemeint, die es dem Sprachmodell ermöglichen, über die reine Textgenerierung hinaus Aktionen auszuführen. Das kann sein auf Datenbanken zuzugreifen, Berechnungen durchzuführen, Grafiken genereiren und so weiter. Hiefür gibt es veschiedene Orchestrierungsmethoden die ich in folgende Kategorien einteilen möchte um einen groben Überblick über Möglichkeiten und Einschränkungen zu geben. Diese Thesen basieren teils nur auf Annahmen und sind auch Kontextabhängig.

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
Allgemein kann ein iterativer Prozess, bei dem überprüft wird ob schon alle wichtigen Informationen enthalten sind oder weitere Agentaufrufe oder Toolaufrufe sinnvoll sind, die Qualität des Outputs verbessern. Iteration kann die Outputqualität erhöhen, benötigt aber entsprechend viele Tokens, weil immer wieder der gesamte Kontext inklusive vorheriger Outputs übergeben und analysiert werden muss. Baut man spezialisierte Agents, kann man diesen nur den Kontext geben den sie wirklich brauchen. So werden diese schneller, effizienter und in der Regel auch besser in der Erfüllung ihrer Aufgabe, weil sie weniger irrelevante Information erhalten.

=== Supervisor
Der Supervisor soll effizient und schnell sein. Sind detailierte Analysen oder Toolaufrufe notwendig soll dieser an spezialisierte Agents delegieren. Ich denke es wäre am sinnvollsten diesen iterativ zu gestalten sofern Agenten befragt werden. Kommt eine Anfrage die keine Agenten benötigt wird die Anfrage möglichst effizient verarbeitet. Wird ein Agent befragt wird der Output bewertet und entschieden ob weitere Agentenaufrufe und damit gegebenenfalls verbundene Toolaufrufe sinnvoll sind oder nicht.

=== Chatverlauf
Eine Idee um den Supervisor zu entlasten ist die spezialisierte Suche im Chatverlauf an einen Agent auslagert. Dieser könnte nach Zeiträumen, Schlagwörtern usw. suchen können.

=== Energiedaten (Zeitreihendaten)
Dieser Agent soll auf Tools zugreifen können, um die Datenbank abzufragen und Berechnungen durchzuführen. Zusätzlich zu der Aufgabe Daten nur zu extrahieren könnte er auch dafür verantwortlich sein diese zu interetieren und Plots zu erzeugen.

== MCP (Model Context Protocol)
Das Model Context Protocol (MCP) ist ein Standard zur strukturierten Integration von Tools und Datenquellen in LLM-basierte Systeme. Es definiert, wie externe Funktionen beschrieben, entdeckt und aufgerufen werden können.

Im Gegensatz zu Orchestrierungsstrategien wie deterministischen Pipelines, plan-basierten Ansätzen oder iterativen Verfahren (z. B. ReAct), beschreibt MCP nicht die Entscheidungslogik, sondern die Schnittstelle zwischen Modell und Tools.

=== Vorteile
- Einheitliche Tool-Schnittstelle (ähnlich wie eine API-Norm)
- Wiederverwendbarkeit von Tool-Integrationen
- Reduzierter Implementierungsaufwand
- Bessere Interoperabilität zwischen verschiedenen Modellen und Systemen

=== Einschränkungen
- MCP löst keine Probleme der Entscheidungslogik oder Planung
- Qualität hängt weiterhin stark von Prompting und Agent-Design ab
- Zusätzliche Abstraktion kann Overhead erzeugen

=== Sinnvoll
- bei komplexen Systemen mit vielen Tools
- bei modularen oder skalierbaren Architekturen
- wenn mehrere Modelle oder Teams beteiligt sind

=== weniger sinnvoll
- bei sehr kleinen, festen Pipelines
- wenn nur wenige, statische Tool-Aufrufe benötigt werden
- bei extrem latency-kritischen Anwendungen

=== Fazit
In frühen Prototypenphasen ist der Einsatz von MCP oft nicht erforderlich, da der Fokus hier auf schneller Iteration, Validierung von Konzepten und minimalem Implementierungsaufwand liegt. Direkte Tool-Integrationen ohne zusätzliche Abstraktionsschicht sind in diesem Kontext meist einfacher umzusetzen, leichter zu debuggen und verursachen weniger Overhead.

Mit zunehmender Systemkomplexität ändern sich jedoch die Anforderungen: Die Anzahl an Tools, Agenten und Schnittstellen wächst, wodurch individuelle Integrationen schnell unübersichtlich und schwer wartbar werden. An diesem Punkt bietet MCP einen entscheidenden Vorteil, da es eine standardisierte und konsistente Struktur für Toolzugriffe schafft.

In produktiven Systemen trägt MCP somit wesentlich zur Skalierbarkeit, Wartbarkeit und Erweiterbarkeit bei. Insbesondere in modularen Architekturen mit mehreren spezialisierten Agenten oder bei der Zusammenarbeit mehrerer Teams ermöglicht es eine klare Trennung von Verantwortlichkeiten und reduziert langfristig die Komplexität des Gesamtsystems.

== Datenbankabfrage

=== Text to SQL
Wie der Name schon sagt wird hier ein Inputtext in eine SQL-Query übersetzt mit der dann auf eine Datenbank zugegriffen wird. Tabellennamen sind teilweise nicht selbsterklärend und müssen definiert werden.

=== Funktionen
Man kann ebenso fixe SQL Abfragen in Funktionen verpacken. Dann kann man Funktions- und Parameternamen selbsterklärend definieren und so weniger Erklärungsbedarf notwendig ist. Meine These ist, dass dieses vorgehen mit guter Struktur weniger Token verbraucht, effizienter und schneller sowie kontrollierter läuft. Aber das könnte man noch vergleichen.


#bibliography("../refs.bib", style: "ieee")