info_page <- function(id, style = "text-align:justify; margin-left:20%;margin-right:20%") {
  #messagef("Info page called with id %s and text %s", id, psychTestR::i18n(id, html = FALSE))
  psychTestR::one_button_page(shiny::div(psychTestR::i18n(id, html = TRUE), style = style),
                              button_text = psychTestR::i18n("CONTINUE"))
}

instructions <- function(img_dir) {
  c(
    psychTestR::code_block(function(state, ...) {
      psychTestR::set_local("do_intro", TRUE, state)
    }),
    info_page("INTRO1"),
    info_page("INTRO2"),
    #psychTestR::one_button_page(shiny::div(psychTestR::i18n("INSTRUCTIONS", html = TRUE),
    #                                       style = "text-align:justify; margin-left:20%;margin-right:20%"),
    #                            button_text = psychTestR::i18n("CONTINUE")),
    psychTestR::while_loop(
      test = function(state, ...) psychTestR::get_local("do_intro", state),
      logic = c(
        practice(img_dir)
        #ask_repeat()
      )),
    psychTestR::one_button_page(psychTestR::i18n("INTRO_MAIN"),
                                button_text = psychTestR::i18n("CONTINUE"))
  )
}
