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
  item_name <- paste0("x", page_number)
  button_text_key <- if (page_number == 1) { "NEXT_PRACTICE_ITEM" } else { "CONTINUE_TO_MAIN" }

  ui <- shiny::div(
    shiny::div(prompt, style = "font-weight: bold;"),
    shiny::tags$img(src = paste0(image_dir, sprintf("/%s/m_%s.png", item_name, item_name)), style = "margin-top: 10px; width: 468px;"),
    shiny::div(shiny::tags$img(src = paste0(image_dir, sprintf("/%s/r%d_%s.png", item_name, training_answers[page_number], item_name)), style = "margin-bottom: 15px; margin-top: 10px; width: 106px; height: 73px;")),
    shiny::p(psychTestR::trigger_button("next", psychTestR::i18n(button_text_key)))
  )

  psychTestR::page(ui = ui, label = label)
}
