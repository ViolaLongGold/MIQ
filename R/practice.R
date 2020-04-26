training_answers  <- c(3, 1, 4, -1)

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

make_practice_page <-  function(page_number, image_dir) {
  psychTestR::reactive_page(function(answer, ...) {
    printf("[make_practice_page] Answer: %s, page_number: %d, correct: %d", answer, page_number, training_answers[page_number])
    correct <- "INCORRECT"
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
           answer = training_answers[page_number],
           prompt = prompt,
           subprompt = subprompt,
           image_dir = image_dir,
           save_answer = FALSE,
           instruction_page = FALSE)
}

practice <- function(image_dir) {
  lapply(1:2, make_practice_page, image_dir) %>% unlist()
}
