= Zeitreihendaten

Energiedaten bestehen oft aus Zeitreihen. Diese direkt im Kontext zu übergeben würde relativ viele Token verbrauchen und den Kontext schnell füllen wodurch auch der Fokus auf das wesentliche verloren geht. Außerdem ist ein LLM auf Sprachverständnis optimiert und nicht unbedingt auf Mustererkennung von langen Zahlenreihen. 

== Analyse mit externen Modellen
Im Optimalfall hat man Analysemodelle auf die das LLM zugreifen kann die relevante Informationen aus Zeitreihen herausfiltern oder beschreiben ohne, dass das LLM selbst diese analysieren muss. Wenn man das richtig umsetzt ist das effizienter sowie konsistenter. Ein ganz einfaches Beispiel wäre das Herausfiltern von statistischen Werten wie Maximum, Minimum, Durchschnitt usw. Bei Mustererkennung wird das ganze schon etwas komplexer. Hier muss man sich überlegen welche Fragestellungen man beantworten möchte und entsprechende Modelle dafür entwickeln. Das kann aber aufwendig und unflexibel sein.

== Analyse mit LLMs
Das Paper "A Picture is Worth A Thousand Numbers:  Enabling LLMs Reason about Time Series via Visualization" beschäftigt sich unter anderem damit wie man Zeitreihen besser mit LLMs verarbeiten kann. Grob zusammengefasst werden die Zeitreihen nicht direkt als Array bzw. Json übergeben sondern es wird erst ein Plot erzeugt welcher anschließend übergeben wird. Nutzt man optional noch ICL (In Context Learning) kann man Beispielplots von verschiedenen Mustern und dessen Beschreibung als Vorlage für den zu analysierenden Plot zum Kontext hinzufügen. Vor allem bei spezifischen Domänen auf die das LLM nicht oder nur wenig trainiert ist kann das sehr Hilfreich sein. Laut Testergebnissen soll durch diese Methode eine Performancesteigerung von 140% und eine Tokenersparnis von 99% erreicht worden sein. Außerdem soll die Mustererkennung von Bildern deutlich besser sein @liuPictureWorthThousand.

== Eigener Test 1: Array vs Plot, single vs multiple timeseries
Das hört sich alles sehr vielversprechend an. Vor allem klang es überraschend, dass Plots besser und sogar schneller sein sollen als gut strukturierte Daten zum Beispiel im Json-Format. Vor allem gehe ich davon aus, dass die Testergebnisse stark vom verwendeten Datensatz, dem Anwendungsbereich und vor allem von der länge der Zeitreihen abhängen. Somit habe ich die Theorien im Bezug auf Energiedaten überprüft.

=== Testdaten
Hierfür habe ich zwei Testdatensätze erzeugt die Energieverbräuche simmulieren sollen. Einer stellt den Energiverbrauch von einem Tag dar was 96 Datenpunkte ergibt. Beim anderen werden 3 Tage mit unterschiedlichem Verbrauchsmuster gegenübergestellt, was in Summe 288 Datenpunkten entspricht.

#figure(
  image("../figures/vl_time/single_energy_ts.png", width: 95%),
  caption: [Energieverbrauch von einem Tag mit 96 Datenpunkten],
) <fig:single_energy_ts>

#figure(
  image("../figures/vl_time/multiple_energy_ts.png", width: 80%),
  caption: [Gegenüberstellung von 3 verschiedenen Verbrauchsmustern mit insgesamt 288 Datenpunkten],
) <fig:multiple_energy_ts>

=== Durchführung
Verwendet wurde das Modell gpt-4.1. Die Aufgabe war den Verbrauchstyp herauszufinden, also Haushalt, Büro, Industrie. Das ganze wurde jeweils getestet indem einmal das Array als Json übergeben wurde und einmal als Plot. ICL wurde nicht angewandt. Hier wurde bewusst auch die Komplexität erhöht indem auch ein Plot mit mehreren Zeitreihen getestet wurde, um die technische Umsetzung und den Umgang des LLMs mit derartigem Input zu testen.

=== Auswertung und Fazit
Die Verbrauchstypen wurden alle korrekt zugeordnet. Das dürfte ein starkes Modell in diesem Kontext gut lösen können. Allerdings ist zu bemerken, dass die Verbrauchsdaten bewusst eindeutig zuordenbar gestaltet sind und in der realität deutlich mehr Varianz aufweisen. Außerdem wird es wahrscheinlich Aufgabenstellungen geben die auch ein starkes LLM nicht versteht wofür entweder ICL oder ein externes Modell notwendig sein könnten.

#figure(
  image("../figures/vl_time/prompt_token_comparison.png", width: 50%),
  caption: [Tokenverbrauch von Array und Plots für einen Tag (96 Datenpunkte) und drei Tage (288 Datenpunkte)],
) <fig:token_comparison>

Wie in @fig:token_comparison zu sehen zeigt sich, dass der Tokenverbrauch selbst bei so einem kleinen Zeitraum wie einem Tag mit 96 Datenpunkten schon deutlich geringer ist wenn man einen Plot übergibt. Man kann die Struktur der übergebenen Json optimieren, aber der Datenverbrauch trotzdem linear steigen sofern man jeden Datenpunkt behalten möchte. Man kann natürlich überlegen die Frequenz zu verringern, aber dann wird das Gesamtmuster immer unschärfer und Muster können verloren gehen. Ein Plot kann auch bei längeren Zeitreihen relativ ähnlich groß bleiben, je nach Größe und Pixeldichte ohne viel Informationsgehalt zu verlieren was das Muster angeht. Auf eine 99% Tokenreduktion bin ich zwar nicht gekommen, aber das war bei so kleinen Zeitreihen auch nicht zu erwarten. Es ist anzunehmen dass mit länge der Zeitreihe auch der Unterschied deutlich zunimmt. Der Grund dafür, dass hier der Unterschied im Tokenverbrauch nicht so groß ist ist, dass die Systeminformation relativ lang ist. Ein weiterer Test mit deutlich längeren Zeitreihen wäre sinnvoll um das zu überprüfen und in einem Linechart die Steigungen gegenüberzustellen.

#figure(
  image("../figures/vl_time/execution_time_comparison.png", width: 50%),
  caption: [Berechnungszeit von Array und Plots für einen Tag (96 Datenpunkte) und drei Tage (288 Datenpunkte)],
) <fig:execution_time_comparison>

In @fig:execution_time_comparison wird die Berechnungszeit gegenübergestellt. Bei einem Tag wird ist das Array noch deutlich schneller als der Plot. Aber beim anderen Datensatz wo drei Tage verglichen werden sollen ist der Plot klar schneller. Die Erklärung könnte sein, dass die längere Json für das LLM ab diesem Punkt schon deutlich schwieriger zu überblicken ist. Es gitl zu beachten, dass die Zeitreihe des einen Tages deutlich realistischer mit mehr Varianz generiert ist und die drei Verbrauchstypen sehr glatte, saubere Linien sind. Das ist sehr interessant, weil man hier klar sehen kann, dass das Array trotz einfacherer Datenpunkte deutlich länger braucht, aber der Plot scheinbar sogar tortz mehr Datenpunkten von der vereinfachten Darstellung massiv profitiert und viel schneller verarbeitet wird. Darauf könnte man Aufbauen und testen ob man aus realen geglättenten Daten noch die gewünschten Muster gut oder sogar besser erkennen kann bei erhöhter Effizienz. Außerdem wäre eine Hybridlösung denkbar bei der man sehr kurze Zeitreihen als Array übergibt, weil diese dann schneller verarbeitet werden und das LLM noch gut den Überblick behält und ab einer gewissen Anzahl an Datenpunkten dann auf Plotanalyse wechselt.

== Eigener Test 2: single timeseries, different amount of datapoints
Hier ist geplant längere Zeitreihen zu testen und in einem Linechart darzustellen, um die tatsächliche Tokenersparnis zu überprüfen.

== Weitere Ideen

=== Optimierung von Json-Struktur
Man kann zum Beispiel Metadaten wie Einheit, Startzeitpunkt, Frequenz einmal definieren und anschließend die Werte in einem langen Array übergeben. Durch diese Struktur kann das LLM die Zeitpunkte für jeden Wert anhand deren Position im Array rekonstruieren. Zusätzlich kann man die originale Auflösung und somit auch die Datenpunkte reduzieren.

Bei den Daten die wir verwenden gilt es zu beachten, dass Energiedaten üblicherweise in einer Frequenz von 15 Minuten vorliegen und unsere Vorhersagen eine Frequenz von einer Stunde hat. Hier ist es sinnvoll diese in zwei verschiedenen Jsons zu übergeben.

=== Kontextmanagement
Um auf optional auf Zeitreihen zuzugreifen die bereits im Chatverlauf erzeugt wurden wäre es sinnvoll wichtige Metadaten zu speichern und das entsprechende Array oder den entsprechenden Plot dann auf Basis dieser wieder aufzurufen, wenn die Useranfrage das erfordert.

#bibliography("../refs.bib", style: "ieee")