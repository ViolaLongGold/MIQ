main_test <- function(label,
                      image_dir,
                      num_items,
                      next_item.criterion,
                      next_item.estimator,
                      next_item.prior_dist = next_item.prior_dist,
                      next_item.prior_par = next_item.prior_par,
                      final_ability.estimator,
                      constrain_answers) {
  item_bank <- MIQ::MIQ_item_bank

  psychTestRCAT::adapt_test(
    label = label,
    item_bank = item_bank,
    show_item = show_item(image_dir),
    stopping_rule = psychTestRCAT::stopping_rule.num_items(n = num_items),
    opt = MIQ_options(next_item.criterion = next_item.criterion,
                      next_item.estimator = next_item.estimator,
                      next_item.prior_dist = next_item.prior_dist,
                      next_item.prior_par = next_item.prior_par,
                      final_ability.estimator = final_ability.estimator,
                      constrain_answers = constrain_answers,
                      item_bank = item_bank)
  )
}

show_item <- function(image_dir) {
  function(item, ...) {
    stopifnot(is(item, "item"), nrow(item) == 1L)

    item_number <- psychTestRCAT::get_item_number(item)
    num_items_in_test <- psychTestRCAT::get_num_items_in_test(item)
    item_bank <- MIQ::MIQ_item_bank

    MIQ_item(
      label = paste0("q", item_number),
      page_number = item_number,
      item_name = item_bank[item_bank$id == item_number, "name"],
      answer = item$answer,
      prompt = get_prompt(item_number, num_items_in_test),
      image_dir = image_dir,
      save_answer = TRUE,
      get_answer = NULL,
      on_complete = NULL,
      instruction_page = FALSE
    )
  }
}

get_prompt <- function(item_number, num_items_in_test) {
  shiny::div(
    shiny::h4(
      psychTestR::i18n(
        "PAGE_HEADER",
        sub = list(num_question = item_number,
                   test_length = if (is.null(num_items_in_test))
                     "?" else
                       num_items_in_test)),
      style = "text_align: center;"
    ),
    shiny::p(
      psychTestR::i18n("PROMPT"),
      style = "margin-left:20%; margin-right:20%; text-align:justify;")
    )
}
