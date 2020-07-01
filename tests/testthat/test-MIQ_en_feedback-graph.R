library(psychTestR)


context("feedback")

app <- AppTester$new("apps/MIQ_en_feedback-graph")

app$expect_ui_text("Please enter your particpant ID. Continue")
app$set_inputs(p_id = "abcde")
app$click_next()

app$expect_ui_text("Welcome to the Visual Puzzles Test! Continue")
app$click_next()
app$click_next()
app$click_next()

app$click("answer8")
app$click_next()
app$click("answer3")
app$click_next()
app$click_next()

app$click("answer4")
app$click("answer1")
app$click("answer6")
app$click("answer3")
app$click("answer1")

app$expect_ui_text("You solved 4 out of 5 puzzles correctly. Continue")
app$click_next()

app$expect_ui_text("Your results have been saved. You can close the browser window now.")

results <- app$get_results() %>% as.list()

expect_equal(names(results), c("MIQ"))
expect_equal(
  results[["MIQ"]][1:5],
  list(
    "q1" = 4,
    "q2" = 1,
    "q3" = 6,
    "q4" = 3,
    "q5" = 1
  )
)

expect_equal(results[["MIQ"]][8][["num_items"]], 5)

app$stop()
