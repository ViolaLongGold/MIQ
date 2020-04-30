welcome_page <- function() {
  psychTestR::new_timeline(
    psychTestR::one_button_page(
      body = psychTestR::i18n("WELCOME"),
      button_text = psychTestR::i18n("CONTINUE")
    ), dict = MIQ::MIQ_dict)
}
