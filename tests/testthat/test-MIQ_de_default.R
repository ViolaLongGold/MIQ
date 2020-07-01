library(psychTestR)


context("default")

app <- AppTester$new("apps/MIQ_de_default")

app$expect_ui_text("Bitte gib Deine ID ein Weiter")
app$set_inputs(p_id = "abcde")
app$click_next()

app$expect_ui_text("Willkommen beim visuellen Puzzletest! Weiter")
app$click_next()
app$expect_ui_text("In diesem Test siehst du Bilder mit Puzzles, die du lösen sollst. Zuerst kommen ein paar Beispiele zum Üben. Weiter")
app$click_next()
app$expect_ui_text("Du siehst nun eine Reihe von Puzzlebildern. In jedem Puzzle fehlt ein Puzzleteil. Du bekommst 8 mögliche Puzzleteile, die unter dem Puzzle angezeigt sind. Nur eins dieser Teile ist das richtige. Deine Aufgabe ist es, auf das richtige Teil zu klicken. Weiter")
app$click_next()

app$expect_ui_text("Probefrage 1: Welches ist das richtige fehlende Puzzleteil? Nur eins dieser Teile ist das richtige Puzzleteil. Deine Aufgabe ist es, auf das richtige Teil zu klicken.")
app$click("answer8")
app$expect_ui_text("Probefrage 1: Richtig! Nächstes Übungsbeispiel.")
app$click_next()
app$expect_ui_text("Probefrage 2: Welches ist das richtige fehlende Puzzleteil? Nur eins dieser Teile ist das richtige Puzzleteil. Deine Aufgabe ist es, auf das richtige Teil zu klicken.")
app$click("answer3")
app$expect_ui_text("Probefrage 2: Richtig! Weiter zum Haupttest")
app$click_next()

app$expect_ui_text("In diesem Haupttest hast du für jede Frage nur 120 Sekunden Zeit zu antworten. Nach 120 Sekunden verschwindet das große Bild und es bleiben nur noch die 8 Teile, aus denen du auswählen musst. Du bekommst keine Rückmeldung bei diesem Teil des Tests. Weiter")
app$click_next()

app$expect_ui_text("Welches ist das fehlende Puzzleteil? (1/5) Du hast 120 Sekunden Zeit ein Antwort zu geben, bevor die Frage verschwindet!")
app$click("answer1")
app$expect_ui_text("Welches ist das fehlende Puzzleteil? (2/5) Du hast 120 Sekunden Zeit ein Antwort zu geben, bevor die Frage verschwindet!")
app$click("answer2")
app$expect_ui_text("Welches ist das fehlende Puzzleteil? (3/5) Du hast 120 Sekunden Zeit ein Antwort zu geben, bevor die Frage verschwindet!")
app$click("answer3")
app$expect_ui_text("Welches ist das fehlende Puzzleteil? (4/5) Du hast 120 Sekunden Zeit ein Antwort zu geben, bevor die Frage verschwindet!")
app$click("answer4")
app$expect_ui_text("Welches ist das fehlende Puzzleteil? (5/5) Du hast 120 Sekunden Zeit ein Antwort zu geben, bevor die Frage verschwindet!")
app$click("answer5")

app$expect_ui_text("Deine Ergebnisse wurden gespeichert. Du kannst das Browserfenster jetzt schließen.")

results <- app$get_results() %>% as.list()

expect_equal(names(results), c("MIQ"))
expect_equal(
  results[["MIQ"]][1:5],
  list(
    "q1" = 1,
    "q2" = 2,
    "q3" = 3,
    "q4" = 4,
    "q5" = 5
  )
)

expect_equal(results[["MIQ"]][8][["num_items"]], 5)

app$stop()
