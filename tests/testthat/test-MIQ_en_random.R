library(psychTestR)
library(testthat)

context("default")

w_dir <- getwd()

if (substr(w_dir, nchar(w_dir)-7, nchar(w_dir)) != "testthat") {
  dir_app <- "tests/testthat/apps/MIQ_en_default"
} else {
  dir_app <-  "apps/MIQ_en_default"
}

app <<- AppTester$new(dir_app)

number_items <- 5 #number of items

# ID
app$expect_ui_text("Please enter your particpant ID. Continue")
app$set_inputs(p_id = "abcde")
app$click_next()

app$expect_ui_text("Welcome to the Visual Puzzles Test! Continue")
app$click_next()

# Training
app$expect_ui_text("In this test you will be given a number of picture puzzles to solve. First you will complete a couple of practice questions. Continue")
app$click_next()
app$expect_ui_text("You will be presented with a number of picture puzzles. Each puzzle will be missing a piece. Eight potential replacement pieces are given below each picture puzzle. Only one of these pieces is the correct replacement. Your task is to click on the correct one. Continue")
app$click_next()

# Practice Question 1
app$expect_ui_text("Practice Question 1: Which is the correct missing piece? Only one of these pieces is the correct replacement. Your task is to click on the correct one.")
app$click("answer8")
app$expect_ui_text("Practice Question 1: Correct! Next practice question")
app$click_next()

app$expect_ui_text("Practice Question 2: Which is the correct missing piece? Only one of these pieces is the correct replacement. Your task is to click on the correct one.")
app$click("answer3")
app$expect_ui_text("Practice Question 2: Correct! Continue to main test") # www_MIQ/image/x2/m_x2.png
app$click_next()

app$expect_ui_text("In the main test, you will only have 120 seconds to answer each question. After 120 seconds, the large image will disappear, leaving only the 8 answers to choose from. You won't get any feedback for this part of the test. Continue")
app$click_next()

# Main test
q <- 1 # Number of question
for (i in sample(1:8, number_items, replace = TRUE)) {
  app$expect_ui_text(paste0("Which is the correct missing piece? (", q, "/5) You have 120 seconds to choose an answer before the question disappears!"))
  app$click(paste0("answer", i))
  print(paste0("answer", i))
  q <- q + 1
}

app$expect_ui_text("Your results have been saved. You can close the browser window now.")

results <- app$get_results() %>% as.list()

expect_equal(names(results), c("MIQ"))

expect_equal(results[["MIQ"]][8][["num_items"]], number_items)

if (TRUE) {
  # Export results
  MIQ_ability_sem <<- results[["MIQ"]][["ability_sem"]]
  MDT_ability <<- results[["MIQ"]][["ability"]]

  print(paste("Standard error of measurement of MIQ", MIQ_ability_sem))
}

app$stop()

