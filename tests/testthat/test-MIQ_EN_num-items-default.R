library(psychTestR)
library(MIQ)
library(testthat)

dir <-
  system.file("tests/MIQ_EN_num-items-default", package = "MIQ", mustWork = TRUE)
app <- AppTester$new(dir)

app$expect_ui_text("Please enter your particpant ID. Continue")
app$set_inputs(p_id = "abcde")
app$click_next()
app$click_next()
app$click_next()
app$click("answer8")
app$click_next()
app$click("answer3")
app$click_next()
app$click_next()

app$click("answer1")
app$click("answer2")
app$click("answer3")
app$click("answer4")
app$click("answer5")

app$expect_ui_text("Your results have been saved. You may now close the browser tab.")

results <- app$get_results() %>% as.list()

expect_equal(names(results), c("results", "MIQ"))
expect_equal(
  results[["results"]],
  list(
    training1 = 8,
    training2 = 3
  )
)

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
