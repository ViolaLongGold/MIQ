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
app$click("answer6")
# 2
app$click("answer8")
# 3
app$click("answer4")
# 4
app$click("answer5")
# 5
app$click("answer8")
# 6
app$click("answer6")
# 7
app$click("answer1")
# 8
app$click("answer2")

app$expect_ui_text("Your results have been saved. You may now close the browser tab.")

results <- app$get_results() %>% as.list()

expect_equal(names(results), c("MIQ"))
expect_equal(
  results[["MIQ"]][1:8],
  list(
    "q1" = 6,
    "q2" = 8,
    "q3" = 4,
    "q4" = 5,
    "q5" = 8,
    "q6" = 6,
    "q7" = 1,
    "q8" = 2
  )
)

expect_equal(results[["MIQ"]][9][["ability"]][1], -4)
expect_equal(results[["MIQ"]][11][["num_items"]], 8)


app$stop()
