library(psychTestR)
library(MIQ)
library(testthat)

dir <-
  system.file("tests/MIQ_EN", package = "MIQ", mustWork = TRUE)
app <- AppTester$new(dir)

app$expect_ui_text("Please enter your particpant ID. Continue")
app$set_inputs(p_id = "abcde")
app$click_next()

app$expect_ui_text("In this test you will be given a number of picture puzzles to solve. First you will complete a couple of practice questions. Continue")
app$click_next()

app$expect_ui_text("You will be presented with a number of picture puzzles. Each puzzle will be missing a piece. Eight potential replacement pieces are given below each picture puzzle. Only one of these pieces is the correct replacement. Your task is to click on the correct one. Continue")
app$click_next()

app$expect_ui_text("Practice Question 1: Which is the correct missing piece? Only one of these pieces is the correct replacement. Your task is to click on the correct one.")
app$click("answer8")

app$expect_ui_text("Practice Question 1: Correct! Next practice question")
app$click_next()

app$expect_ui_text("Practice Question 2: Which is the correct missing piece? Only one of these pieces is the correct replacement. Your task is to click on the correct one.")
app$click("answer3")

app$expect_ui_text("Practice Question 2: Correct! Continue to main test")
app$click_next()

app$expect_ui_text("In the main test, you will only have 120 seconds to answer each question. After 120 seconds, the large image will disappear, leaving only the 8 answers to choose from. You won't get any feedback for this part of the test. Continue")
app$click_next()


# app$expect_ui_text("Congratulations! You have completed the picture puzzle test.")
# app$click_next()

# results <- app$get_results() %>% as.list()
# expect_equal(names(results), c("DAC"))
# expect_equal(
#   results[["DAC"]],
#   list(
#     q1 = "btn1_text",
#     q2 = "btn2_text",
#     q3 = "btn3_text",
#     q4 = "btn4_text",
#     General = 2.5
#   )
# )

app$stop()
