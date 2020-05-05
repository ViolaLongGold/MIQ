library(psychTestR)
library(MIQ)
library(testthat)

dir <-
  system.file("tests/MIQ_EN_num-items-8", package = "MIQ", mustWork = TRUE)
app <- AppTester$new(dir)

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

app$click("answer1")
app$click("answer2")
app$click("answer3")
app$click("answer4")
app$click("answer5")
app$click("answer6")
app$click("answer7")
app$click("answer8")

app$expect_ui_text("Your results have been saved. You can close the browser window now.")

results <- app$get_results() %>% as.list()

expect_equal(names(results), c("MIQ"))
expect_equal(
  results[["MIQ"]][1:8],
  list(
    "q1" = 1,
    "q2" = 2,
    "q3" = 3,
    "q4" = 4,
    "q5" = 5,
    "q6" = 6,
    "q7" = 7,
    "q8" = 8
  )
)

expect_equal(results[["MIQ"]][11][["num_items"]], 8)

app$stop()
