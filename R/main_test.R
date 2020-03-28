get_eligible_first_items_MIQ <- function(){
  which(MIQ::MIQ_item_bank$type == "8" & MIQ::MIQ_item_bank$bit_flips == 4)
}


get_lures <- function(item_id){
  if(purrr::is_scalar_character(item_id)){
    return(MIQ::MIQ_lures_bank[MIQ::MIQ_lures_bank$item_id == item_id, ] %>% pull("lures"))
  }
  stop(printf("Invalid item id %s", item_id))
}

main_test <- function(label, audio_dir, img_dir, num_items,
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
    show_item = show_item(audio_dir, img_dir),
    stopping_rule = psychTestRCAT::stopping_rule.num_items(n = num_items),
    opt = MIQ_options(next_item.criterion = next_item.criterion,
                      next_item.estimator = next_item.estimator,
                      next_item.prior_dist = next_item.prior_dist,
                      next_item.prior_par = next_item.prior_par,
                      final_ability.estimator = final_ability.estimator,
                      constrain_answers = constrain_answers,
                      eligible_first_items = get_eligible_first_items_MIQ(),
                      item_bank = item_bank)
  )
}

show_item <- function(audio_dir, img_dir) {
  function(item, ...) {
    stopifnot(is(item, "item"), nrow(item) == 1L)
    item_number <- psychTestRCAT::get_item_number(item)
    num_items_in_test <- psychTestRCAT::get_num_items_in_test(item)

    MIQ_item(
      label = paste0("q", item_number),
      pattern = item$pattern,
      lures = get_lures(item$item_id),
      answer = item$answer,
      prompt = get_prompt(item_number, num_items_in_test),
      img_dir = img_dir,
      audio_dir = audio_dir,
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
      style  = "text_align:center"
    ),
    shiny::p(
      psychTestR::i18n("PROMPT"),
      style = "margin-left:20%;margin-right:20%;text-align:justify")
    )
}
