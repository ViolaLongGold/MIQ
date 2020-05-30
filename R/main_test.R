main_test <- function(label,
                      num_items,
                      next_item.criterion,
                      next_item.estimator,
                      next_item.prior_dist,
                      next_item.prior_par,
                      final_ability.estimator,
                      constrain_answers,
                      eligible_first_items) {
  item_bank <- MIQ::MIQ_item_bank

  psychTestRCAT::adapt_test(
    label = label,
    item_bank = item_bank,
    show_item = show_item(),
    stopping_rule = psychTestRCAT::stopping_rule.num_items(n = num_items),
    opt = MIQ_options(next_item.criterion = next_item.criterion,
                      next_item.estimator = next_item.estimator,
                      next_item.prior_dist = next_item.prior_dist,
                      next_item.prior_par = next_item.prior_par,
                      final_ability.estimator = final_ability.estimator,
                      constrain_answers = constrain_answers,
                      eligible_first_items = eligible_first_items,
                      item_bank = item_bank)
  )
}

show_item <- function() {
  function(item, ...) {
    stopifnot(is(item, "item"), nrow(item) == 1L)

    item_bank <- MIQ::MIQ_item_bank
    item_number <- psychTestRCAT::get_item_number(item)
    item_name <- item_bank[item_bank$id == item$id, "name"]
    num_items <- psychTestRCAT::get_num_items_in_test(item)
    # messagef("Showing item %s (correct: %d)", item_name, item$answer)

    MIQ_item(
      label = paste0("q", item_number),
      page_number = item_number,
      item_name = item_bank[item_bank$id == item$id, "name"],
      answer = item$answer,
      prompt = get_prompt(item_number, num_items),
      save_answer = TRUE,
      get_answer = NULL,
      on_complete = NULL,
      instruction_page = FALSE
    )
  }
}

get_prompt <- function(item_number, num_items) {
  shiny::div(
    paste(psychTestR::i18n(
      "PAGE_HEADER",
      sub = list(num_question = item_number,
                 num_items = if (is.null(num_items))
                   "?" else
                     num_items)), paste0("(", item_number, "/", num_items, ")")),
    shiny::p(
      psychTestR::i18n("PROMPT"),
      style = "font-weight: normal;"),
    style = "text-align: center; margin-bottom: 20px;"
  )
}
