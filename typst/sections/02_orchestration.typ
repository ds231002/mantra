= Orchestration

== Agent-Orchestration
Die Grundidee ist es einen Supervisor Agent zu haben der optional auf spezialisierte Agents zugreift. Dieses Konzept ist in @fig:high-level_mantra_architecture_proposal dargestellt.

#figure(
  image("../figures/orchestration/high-level_mantra_architecture_proposal.png", width: 80%),
  caption: [High-level MANTRA architecture proposal],
) <fig:high-level_mantra_architecture_proposal>

=== Agenten
Allgemein kann ein iterativer Prozess, bei dem überprüft wird ob schon alle wichtigen Informationen enthalten sind oder weitere Agentaufrufe oder Toolaufrufe sinnvoll sind, die Qualität des Outputs verbessern. Iteration kann die Outputqualität erhöhen, benötigt aber entsprechend viele Tokens, weil immer wieder der gesamte Kontext inklusive vorheriger Outputs übergeben und analysiert werden muss. Baut man spezialisierte Agents, kann man diesen nur den Kontext geben den sie wirklich brauchen. So werden diese schneller, effizienter und in der Regel auch besser in der Erfüllung ihrer Aufgabe, weil sie weniger irrelevante Information erhalten.

==== Supervisor
Der Supervisor soll effizient und schnell sein. Sind detailierte Analysen oder Toolaufrufe notwendig soll dieser an spezialisierte Agents delegieren. Ich denke es wäre am sinnvollsten diesen iterativ zu gestalten sofern Agenten befragt werden. Kommt eine Anfrage die keine Agenten benötigt wird die Anfrage möglichst effizient verarbeitet. Wird ein Agent befragt wird der Output bewertet und entschieden ob weitere Agentenaufrufe und damit gegebenenfalls verbundene Toolaufrufe sinnvoll sind oder nicht.

==== Chatverlauf
Eine Idee um den Supervisor zu entlasten ist die spezialisierte Suche im Chatverlauf an einen Agent auslagert. Dieser soll nach Zeiträumen, Schlagwörtern usw. suchen können.

==== Energiedaten (Zeitreihendaten)
Dieser Agent soll auf Tools zugreifen können, um die Datenbank abzufragen und Berechnungen durchzuführen. Zusätzlich zu der Aufgabe Daten nur zu extrahieren könnte er auch dafür verantwortlich sein diese zu interetieren und Plots zu erzeugen.




== Tool-Orchestration
Mit Tools sind hier externe Funktionen, Programme oder Schnittstellen gemeint, die es dem Sprachmodell ermöglichen, über die reine Textgenerierung hinaus Aktionen auszuführen. Das kann sein auf Datenbanken zuzugreifen, Berechnungen durchzuführen, Grafiken genereiren und so weiter. Hiefür gibt es veschiedene Orchestrierungsmethoden die ich in folgende Kategorien einteilen möchte um einen groben Überblick über Möglichkeiten und Einschränkungen zu geben. Diese Thesen basieren teils nur auf Annahmen und sind auch Kontextabhängig.

=== Deterministisch
Hier werden fixe Pipelines definiert die jeweils eine bestimmte Intention abdecken sollen. Das LLM soll diese Intention erkennen und arbeitet dann deterministisch die zugrundeliegende Pipeline ab. Das ist sehr effizient und gut kontrollierbar. Effizient ist es deshalb, weil nur ein LLM-Aufruf für die Intentionserkennung notwendig ist und gegebenenfalls ein zweiter für die generierung der finalen Anwort. Die Pipelines sind klar vordefiniert und deswegen gut optimierbar und bieten auch eine sehr gute Kontrolle was passieren soll und was nicht. Einschränkungen sind hier, dass man nicht flexibel auf Anfragen reagieren kann die neu sind oder mehrere Intentionen so kombinieren wie man es nicht vordefiniert hat.

=== Plan-Basiert
Die Idee ist das LLM einen Plan bauen zu lassen wie die verfügbaren Tools aufgerufen werden sollen um die Nutzeranfrage optimal zu erfüllen. So wird man deutlich flexibler was neue Anfragen angeht. Allerdings verliert man auch Kontrolle und es gibt mehr Fehlerpotential.

=== Iterativ (ReAct)
ReAct (Reasoning + Acting) ist eine Methode wo das LLM den Tooloutput wieder als Input bekommt und überprüft ob die Informationen ausreichend sind oder weitere Toolaufrufe erforderlich sind. Es werden so lange neue Toolaufrufe getriggert bis das LLM entscheidet, dass es nun genügend oder die passenden Informationen erhalten hat. Es ist ratsam hierfür ein Schleifenlimit zu setzen, um die Kosten und die Laufzeit unter Kontrolle zu halten.

Das Paper "ReAct Modular Agent: Orchestrating Tool-Use and Retrieval for Financial Workflows" versucht den klassische ReAct Agent zu verbessern indem Reasoning und Acting voneinander getrennt werden @hernandezReActModularAgent2025.

==== Monolithic ReAct
Der klassische ReAct Agent wird als monolitisch beschrieben, weil sowohl Reasoning und Acting in einem Aufruf abgearbeitet werden. Es wird erklärt, dass das zu einer hohen Latenz und inkonsistenten Entscheidungsgrenzen führt @hernandezReActModularAgent2025.

==== Hierarchical ReAct
Hier werden Planung und Toolaufruf voneinander getrennt wie in @fig:hierarchical_react_agent_architecture zu sehen. Der Planner erhält die Nutzeranfrage und entscheidet ob und welche Tools gebraucht werden. Fällt die Entscheidung, dass Tools aufgerufen werden sollen erhält diese Information der Dispatcher. Dieser ist ausschließlich für die technische Übersetzung zuständig, dass die Tools richtig aufgerufen werden können. Die Tooloutputs werden dann wieder an den Planner zurückgegeben. Dieser entscheidet nun ob er weitere Tools aufrufen möchte oder die alle Informationen an den Synthesizer weitergibt der die finale Antwort generiert. Der Planner und der Synthesizer (High-Reasoning Roles) nutzen GPT-4o, ein relativ starkes Modell. Für den Dispatcher (Low-Latency Role) wird GPT-4.1-Nano verwendet, ein leichtgewichtigeres und schnelleres Modell @hernandezReActModularAgent2025.

#figure(
  image("../figures/orchestration/hierarchical_react_agent_architecture.png", width: 80%),
  caption: [Hierachical ReAct agent architecture @hernandezReActModularAgent2025],
) <fig:hierarchical_react_agent_architecture>

==== Auswertung des Papers
Ausgewertet werden die Ergebnisse mit zwei Metriken die sich jeweils aus drei binären Kriterien zusammensetzen. Die Metriken sind Synthesis Quality (SQ) und Planning Efficiency (PE). Außerdem wird auch die Execution Latency (EL) verglichen @hernandezReActModularAgent2025.

Es zeigt sich, dass die EL sich von 9,26s auf 8,61s um 0.65s reduziert hat und das trotz komplexerer Struktur und mehreren Aufrufen. Das liegt daran, dass der Dispatcher mit dem leichtgewichtigeren Modell deutlich effizienter arbeitet @hernandezReActModularAgent2025.

Die SQ ist von 64,8% auf 72,4% um 7,6% höher. Das ist zwar eine Steigerung aber es besteht noch Verbesserungspotential @hernandezReActModularAgent2025.

Die PE steigt von 61.8% auf 99% um 37,2%. Das ist nahezu perfekt und zeigt, dass die Aufteilung der Aufgaben durch isolierte und klare Prompts einen deutlichen Mehrwert bieten @hernandezReActModularAgent2025.

Im Paper wurde zwar mit LangGraph gearbeitet, aber das erfordert die Komplexität des Workflows nicht zwingend. Ich denke darüber nach diese Methode mit lokalen Modellen zu testen und zu eruieren ob sie für unseren Anwendungsfall geeignet ist @hernandezReActModularAgent2025.

=== OpenAI Tool Search
Mit der OpenAI API gibt es die Möglichkeit tools als Json zu übergeben. Auf openai.com findet man die Dokumentation die unter anderem beschreibt wie genau die Json strukturiert sein muss. Auf genau diese Struktur wurde das zugrundeliegende Modell trainiert. Sobald man tools auf diese Weise übergibt verändert sich der Output und man bekommt falls notwendig eine Toolauswahl und Reasoning zurück. Man kann aber auch direkt Content generieren lassen den man als Antwort verwenden kann. Zum Beispiel wird dann nachgefragt wenn Informationen fehlen um ein Tool auszuführen.

Ich habe ein Notebook erstellt um zu verstehen wie genau das funktioniert und wie gut das tatsächlich funktioniert. Dafür habe ich zwei Funktionen erstellt die Zeitreihen für Stromverbrauch und Stromproduktion erzeugen. Als Parameter habe ich Startzeit, Endzeit und Pattern definiert. Pattern definiert einfach nur ob es einen Haushalt oder eine Industrieanlage simulieren soll. Fragt man nun nach dem Verbrauch der letzten Woche gibt das LLM die strukturiert den entsprechenden Funktionsnamen mit den notwendigen Parametern zurück. Mit diesen kann man dann den Funktionsaufruf starten und den Output wieder in das LLM einspeisen. Fehlt beim Input ein Zeitraum gibt das LLM keine Funktion zurück und fragt nach den Informationen die ihm noch fehlen. In diesem Fall wäre das der Zeitraum.

Dieses Vorgehen sollte besser und zuverlässiger funktionieren als die Tools nur in der Message einzubinden, weil es auch speziell darauf trainiert wurde. Allerdings ist diese Anwendung sehr spezifisch und nicht so auf andere LLMs übertragbar. Es ist quasi schon eine fertige Lösung. Leider scheint diese Funktion nur auf den API-Zugriff beschränkt zu sein und ist somit nicht lokal nutzbar. Aber es kann als Inspiration dienen wie wir das selbst umsetzen wollen.

=== MCP (Model Context Protocol)
Das Model Context Protocol (MCP) ist ein Standard zur strukturierten Integration von Tools und Datenquellen in LLM-basierte Systeme. Es definiert, wie externe Funktionen beschrieben, entdeckt und aufgerufen werden können.

Im Gegensatz zu Orchestrierungsstrategien wie deterministischen Pipelines, plan-basierten Ansätzen oder iterativen Verfahren (z. B. ReAct), beschreibt MCP nicht die Entscheidungslogik, sondern die Schnittstelle zwischen Modell und Tools.

==== Vorteile
- Einheitliche Tool-Schnittstelle (ähnlich wie eine API-Norm)
- Wiederverwendbarkeit von Tool-Integrationen
- Reduzierter Implementierungsaufwand
- Bessere Interoperabilität zwischen verschiedenen Modellen und Systemen

==== Einschränkungen
- MCP löst keine Probleme der Entscheidungslogik oder Planung
- Qualität hängt weiterhin stark von Prompting und Agent-Design ab
- Zusätzliche Abstraktion kann Overhead erzeugen

==== Sinnvoll
- bei komplexen Systemen mit vielen Tools
- bei modularen oder skalierbaren Architekturen
- wenn mehrere Modelle oder Teams beteiligt sind

==== weniger sinnvoll
- bei sehr kleinen, festen Pipelines
- wenn nur wenige, statische Tool-Aufrufe benötigt werden
- bei extrem latency-kritischen Anwendungen

==== Fazit
In frühen Prototypenphasen ist der Einsatz von MCP oft nicht erforderlich, da der Fokus hier auf schneller Iteration, Validierung von Konzepten und minimalem Implementierungsaufwand liegt. Direkte Tool-Integrationen ohne zusätzliche Abstraktionsschicht sind in diesem Kontext meist einfacher umzusetzen, leichter zu debuggen und verursachen weniger Overhead.

Mit zunehmender Systemkomplexität ändern sich jedoch die Anforderungen: Die Anzahl an Tools, Agenten und Schnittstellen wächst, wodurch individuelle Integrationen schnell unübersichtlich und schwer wartbar werden. An diesem Punkt bietet MCP einen entscheidenden Vorteil, da es eine standardisierte und konsistente Struktur für Toolzugriffe schafft.

In produktiven Systemen trägt MCP somit wesentlich zur Skalierbarkeit, Wartbarkeit und Erweiterbarkeit bei. Insbesondere in modularen Architekturen mit mehreren spezialisierten Agenten oder bei der Zusammenarbeit mehrerer Teams ermöglicht es eine klare Trennung von Verantwortlichkeiten und reduziert langfristig die Komplexität des Gesamtsystems.

=== Datenbankabfrage

==== Text to SQL
Wie der Name schon sagt wird hier ein Inputtext in eine SQL-Query übersetzt mit der dann auf eine Datenbank zugegriffen wird. Tabellennamen sind teilweise nicht selbsterklärend und müssen definiert werden.

==== Funktionen
Man kann ebenso fixe SQL Abfragen in Funktionen verpacken. Dann kann man Funktions- und Parameternamen selbsterklärend definieren und so weniger Erklärungsbedarf notwendig ist. Meine These ist, dass dieses vorgehen mit guter Struktur weniger Token verbraucht, effizienter und schneller sowie kontrollierter läuft. Aber das könnte man noch vergleichen.

// #bibliography("../refs.bib", style: "ieee")