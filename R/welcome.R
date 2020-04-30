welcome_page <- function() {
  psychTestR::new_timeline(
    psychTestR::one_button_page(
      body = shiny::h3(psychTestR::i18n("WELCOME"), style = "margin-bottom: 35px;"),
      button_text = psychTestR::i18n("CONTINUE")
    ), dict = MIQ::MIQ_dict)
}
