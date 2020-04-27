training_answers  <- c(8, 3)

ask_repeat <- function(prompt) {
  psychTestR::NAFC_page(
    label = "ask_repeat",
    prompt = prompt,
    choices = c("go_back", "continue"),
    labels = lapply(c("GOBACK", "CONTINUE"), psychTestR::i18n),
    save_answer = FALSE,
    arrange_vertically = FALSE,
    on_complete = function(state, answer, ...) {
      psychTestR::set_local("do_intro", identical(answer, "go_back"), state)
    }
  )
}

practice_feedback_page <-  function(page_number, correct_answer_number, image_dir) {
  # TODO
  psychTestR::conditional(function(state, ...) get_local("correct_answer", state) == training_answers[page_number],
    feedback_page_with_img(sprintf("training%d", page_number), paste(psychTestR::i18n(sprintf("PRACTICE_FEEDBACK%d", page_number), html = TRUE), "Correct!"), page_number, correct_answer_number, image_dir)
  )
  # conditional(function(state, ...) get_local("correct_answer", state) != training_answers[page_number],
  #   feedback_page_with_img(sprintf("training%d", page_number), paste(psychTestR::i18n(sprintf("PRACTICE_FEEDBACK%d", page_number), html = TRUE), "Incorrect!"), page_number, correct_answer_number, image_dir)
  # )
}

practice_page <-  function(page_number, image_dir) {
  psychTestR::reactive_page(function(answer, ...) {
    printf("[practice_page] Answer: %s, page_number: %d, correct: %d", answer, page_number, training_answers[page_number])
    correct <- "INCORRECT"
    printf("answer: %s", answer)
    print(training_answers[page_number - 1])
    if (page_number > 1 &&  answer == training_answers[page_number - 1]) correct <- "CORRECT"
    feedback <- psychTestR::i18n(correct)
    get_practice_page(page_number, feedback, image_dir)
  })
}

get_practice_page <- function(page_number, feedback, image_dir){
  key <- sprintf("PRACTICE%d", page_number)
  prompt <- psychTestR::i18n(key, html = TRUE, sub = list(feedback = feedback))
  subprompt <- psychTestR::i18n("PRACTICE_SUBPROMPT", html = TRUE, sub = list(feedback = feedback))
  printf("[get_practice_page] page_number; %d, key: %s, feedback: %s", page_number, key, feedback)

  MIQ_item(label = sprintf("training%s", page_number),
           page_number = page_number,
           item_name = paste0("x", page_number),
           answer = training_answers[page_number],
           prompt = prompt,
           subprompt = subprompt,
           image_dir = image_dir,
           save_answer = FALSE,
           instruction_page = FALSE)
}

practice <- function(image_dir) {
  lapply(1:2, practice_page, image_dir) %>% unlist()
}
