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

    item_bank <- MIQ::MIQ_item_bank
    item_number <- psychTestRCAT::get_item_number(item)
    item_name <- item_bank[item_bank$id == item_number, "name"]
    num_items <- psychTestRCAT::get_num_items_in_test(item)

    MIQ_item(
      label = paste0("q", item_number, "_", item_name),
      page_number = item_number,
      item_name = item_bank[item_bank$id == item_number, "name"],
      answer = item$answer,
      prompt = get_prompt(item_number, num_items),
      image_dir = image_dir,
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
