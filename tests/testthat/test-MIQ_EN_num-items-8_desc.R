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

app$click("answer8")
app$click("answer7")
app$click("answer6")
app$click("answer5")
app$click("answer4")
app$click("answer3")
app$click("answer2")
app$click("answer1")

app$expect_ui_text("Your results have been saved. You can close the browser window now.")

results <- app$get_results() %>% as.list()

expect_equal(names(results), c("MIQ"))
expect_equal(
  results[["MIQ"]][1:8],
  list(
    "q1" = 8,
    "q2" = 7,
    "q3" = 6,
    "q4" = 5,
    "q5" = 4,
    "q6" = 3,
    "q7" = 2,
    "q8" = 1
  )
)

expect_equal(results[["MIQ"]][11][["num_items"]], 8)

app$stop()
