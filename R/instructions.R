info_page <- function(id, style = "text-align: center; margin-left: 10%; margin-right: 10%; margin-bottom: 20px;") {
  psychTestR::one_button_page(shiny::div(psychTestR::i18n(id, html = TRUE), style = style),
                              button_text = psychTestR::i18n("CONTINUE"))
}

instructions <- function(image_dir) {
  c(
    psychTestR::code_block(function(state, ...) {
      psychTestR::set_local("do_intro", TRUE, state)
    }),
    info_page("INTRO1"),
    info_page("INTRO2"),
    practice(),
    psychTestR::one_button_page(
      psychTestR::i18n("INTRO_MAIN"),
      button_text = psychTestR::i18n("CONTINUE")
    )
  )
}
