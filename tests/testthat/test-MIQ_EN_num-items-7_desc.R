library(psychTestR)
library(MIQ)
library(testthat)

dir <-
  system.file("tests/MIQ_EN_num-items-7", package = "MIQ", mustWork = TRUE)
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

app$click("answer7")
app$click("answer6")
app$click("answer5")
app$click("answer4")
app$click("answer3")
app$click("answer2")
app$click("answer1")

app$expect_ui_text("Your results have been saved. You may now close the browser tab.")

results <- app$get_results() %>% as.list()

expect_equal(names(results), c("MIQ"))
expect_equal(
  results[["MIQ"]][1:7],
  list(
    "q1" = 7,
    "q2" = 6,
    "q3" = 5,
    "q4" = 4,
    "q5" = 3,
    "q6" = 2,
    "q7" = 1
  )
)

# expect_equal(results[["MIQ"]][8][["ability"]][1], -2.4391771)
# expect_equal(results[["MIQ"]][9][["ability_sem"]][1], 1.52087095)
expect_equal(results[["MIQ"]][10][["num_items"]], 7)

app$stop()
