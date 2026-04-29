= Training

== Toolformer
Im Paper "Toolformer: Language Models Can Teach Themselves to Use Tools" wird 2023 das erste mal der Toolformer vorgestellt. Hier wird gezeigt wie ein LLM selbst externe Tools über APIs lernen kann. Grob gesagt wird ein kleineres Modell durch ein Größeres trainiert. Durch Webscraping wird ein Trainingsdatenset aus vielen Texten generiert. Nun generiert das kleinere LLM einen Token nach dem anderen und kann auch Toolaufrufe einfügen. Das größere Modell beurteilt dann ob ein Toolaufruf sinnvoll ist oder nicht. Wenn es sinnvoll ist wird es behalten, wenn nicht verworfen. So bleiben Trainingstexte mit sinnvollen Toolaufrufen anhand dessen dann das Fine Tuning des kleineren Modells erfolgt. Es zeigt sich, dass kleinere Modelle davon stark profitieren und bei der Toolauswahl deutlich besser werden. Aber desto größer das Modell, desto weniger Mehrwert bietet dieses Vorgehen @schick2023.

Hier stellt sich die Frage ob das für unseren Anwendungsfall sinnvoll ist. Wir wollen die Ergebnisse der Toolaufrufe möglicherweise nicht nur direkt in den Text einbinden wie es in dem Paper gezeigt wird. Außerdem erfordert es sehr viel Textmaterial die am besten den späteren Suchanfragen ähnlich sind oder den selben Kontext haben. Das erfordert trotzdem noch sehr viel Arbeit, deckt unsere Anforderungen nicht vollständig ab und bietet bei Verwendung eines größeren Modells keinen großen Mehrwert. Ein ReAct Agent mit einem starken Modell bietet bereits eine sehr gute Toolauswahl @hernandezReActModularAgent2025.

== GPT4Tools
Im Paper "GPT4Tools: Teaching Large Language Models (LLMs) to Use Tools via Self-instruction" gezeigt wie man mit einem starkes Modell Trainingsdaten erzeugt, mit denen ein kleineres Modell lernt Tools zu benutzen mit dem man auch neue (unseen) Tools einlernen kann. Diesen Vorgang nennen sie GPT4Tools welcher in drei Schritte unterteilt ist @yangGPT4ToolsTeachingLarge2023.

=== Schritt 1:
Wie bereits erklärt werden hier Trainingsdaten von einem stärkeren Modell erzeugt. In diesem Fall wird GPT-3.5 verwendet. Die Struktur dieser Trainingsdaten sieht wie folgt aus: Thought: Do I need to use a tool? Yes, Action: \<tool name\>, Action Input: \<arguments\>, Observation: \<result\> @yangGPT4ToolsTeachingLarge2023.

=== Schritt 2:
Mit diesen Trainingsdaten werden kleinere Daten trainiert. Im Paper sind das OPT-13B, LLaMa-13B und Vicuna-13B. Diese lernen durch Toolauswahl, Toolargumente und Toolaufrufsequenzen @yangGPT4ToolsTeachingLarge2023.

=== Schritt 3:
Anschließend wird das Ergebnis mit der Successful Rate (SR) evaluiert. DIe SR setzt sich aus Sucessful Rate of Thought (SRt), Successful Rate of Action (SRact) und Successful Rate of Arguments (SRargs) zusammen. Bei jeder dieser Metriken gibt es Wahr oder Falsch welche in 0 oder 1 ausgedrückt werden. Alle drei müssen 1 sein damit SR ebenfalls 1 ist. Dadurch stellt man fest, dass kleine Modelle durch dieses Training signifikant verbessert werden und sogar neue (unseen) Tools sehr gute SR Werte erzielen können. Da wir beim Forschungsprojekt voraussichtlich auf ein lokales LLM setzen werden ist dies durchaus eine interessante Methode die man in Betracht ziehen kann @yangGPT4ToolsTeachingLarge2023.

GPT4Tools ermöglicht es LLMs auf multi-modal tools zuzugreifen. Aber für den praktischen Einsatz sind noch weitere Verbesserungen notwendig @yangGPT4ToolsTeachingLarge2023.

== Proactive Agent
Im Paper "Proactive Agent: Shifting LLM Agents from Reactive Responses to Active Assistance" wird versucht einen Agenten zu entwickeln der nicht nur auf explizite Nutzeranfragen reagiert sondern proaktiv Hilfe anbietet. Er soll die Bedrüfnisse des Nutzers basierend auf User-Aktivitäten (z. B. Maus, Tastatur, Browser) implizit erkennen. Behandelt wurden unter anderem die Szenarien Programmieren und Schreiben. Ein LLM neigt dazu zu häufig Hilfe anzubieten was schnell nervig werden kann. Daher werden Vorschläge von Menschen gelabelt und zum Training verwendet. Das führt zu einer deutlichen Verbesserung aber der Agent bietet trotzdem noch unnötige Hilfe an. Außerdem ist das Timing schwer wann Hilfe angeboten wird. Zu früh ist nervig, zu spät ist nutzlos. Und es ist sehr schwierig automatisch zu erkenne was der Nutzer wirklich möchte. Außerdem braucht es viel Kontext den man oft nicht hat. Zusätzlich sind Datenschutz und Privatsphäre kritisch. Das Paper zeigt, dass es theoretisch geht, aber es noch nicht zuverlässig genug für eichen praktischen Einsatz funktioniert. Wählt man ein sehr kontrolliertes Setting wie Coding oder Schreibtools kann es schon sinnvoll eingesetzt werden da der Kontext stark strukturiert vorliegt @luProactiveAgentShifting2024.

Proaktive Hilfe anzubieten kann für den Assitenten den wir entwickeln wollen durchaus interessant sein. Allerdings ist das eher zweitrangig zumal es wie beschrieben für unseren Anwendungsfall noch zu fehleranflällig ist und der Kontext nicht klar genug ist.

#bibliography("../refs.bib", style: "ieee")