library(psychTestR)
library(MIQ)
library(testthat)

dir <-
  system.file("tests/MIQ_EN_num-items-8_asc", package = "MIQ", mustWork = TRUE)
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

# 1
app$click("answer4")
# 2
app$click("answer1")
# 3
app$click("answer6")
# 4
app$click("answer3")
# 5
app$click("answer7")
# 6
app$click("answer1")
# 7
app$click("answer2")
# 8
app$click("answer5")

app$expect_ui_text("Your results have been saved. You may now close the browser tab.")

results <- app$get_results() %>% as.list()

expect_equal(names(results), c("MIQ"))
expect_equal(
  results[["MIQ"]][1:8],
  list(
    "q1" = 4,
    "q2" = 1,
    "q3" = 6,
    "q4" = 3,
    "q5" = 7,
    "q6" = 1,
    "q7" = 2,
    "q8" = 5
  )
)

expect_equal(results[["MIQ"]][9][["ability"]][1], 3.0497726)
expect_equal(results[["MIQ"]][11][["num_items"]], 8)

app$stop()
