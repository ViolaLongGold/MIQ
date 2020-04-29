training_answers  <- c(8, 3)

practice <- function() {
  unlist(lapply(1:2, practice_and_feedback_pages))
}

practice_and_feedback_pages <- function(page_number) {
  list(
    practice_page(page_number),
    psychTestR::reactive_page(function(answer, ...) {
      practice_feedback_page(page_number, answer)
    })
  )
}

practice_page <- function(page_number) {
  MIQ_item(label = sprintf("training%s", page_number),
           page_number = page_number,
           item_name = paste0("x", page_number),
           answer = training_answers[page_number],
           prompt = psychTestR::i18n(sprintf("PRACTICE%d", page_number), html = TRUE),
           subprompt = psychTestR::i18n("PRACTICE_SUBPROMPT", html = TRUE),
           image_dir = image_dir,
           save_answer = FALSE,
           instruction_page = FALSE)
}

practice_feedback_page <- function(page_number, answer) {
  label <- sprintf("training%d", page_number)
  correctness_text <- if (answer == training_answers[page_number]) {
      psychTestR::i18n("CORRECT")
    } else {
      psychTestR::i18n("INCORRECT")
    }
  prompt <- paste(psychTestR::i18n(sprintf("PRACTICE_FEEDBACK%d", page_number), html = TRUE), correctness_text)
  practice_feedback_page_with_img(label, prompt, page_number, training_answers[page_number], image_dir)
}
