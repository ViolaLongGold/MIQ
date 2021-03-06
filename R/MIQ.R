#' MIQ
#'
#' This function defines a MIQ module for incorporation into a
#' psychTestR timeline.
#' Use this function if you want to include MIQ in a battery of other tests, or
#' if you want to add custom psychTestR pages to your test timeline.
#' For demoing the MIQ, consider using \code{\link{MIQ_demo}()}.
#' For a standalone implementation of the MIQ, consider using
#' \code{\link{MIQ_standalone}()}.
#' @param label (Character scalar) Label to give the MIQ results in the output file.
#' @param num_items (Integer scalar) Number of items in the test.
#' @param with_welcome (Logical scalar) Whether to display a welcome page.
#' Defaults to TRUE
#' @param take_training (Logical scalar) Whether to include the training phase.
#' Defaults to FALSE.
#' @param feedback_page (Function) Defines a feedback page function for displaying
#' the results to the participant at the end of the test. Defaults to NULL.
#' Possible feedback page functions include \code{"feedback_with_score()"}, and
#' \code{"feedback_with_graph()"}.
#' @param with_finish (Logical scalar) Whether to display a finish page.
#' Defaults to FALSE
#' @param next_item.criterion (Character scalar)
#' Criterion for selecting successive items in the adaptive test.
#' See the \code{criterion} argument in \code{\link[catR]{nextItem}} for possible values.
#' Defaults to \code{"MFI"}.
#' @param next_item.estimator (Character scalar)
#' Ability estimation method used for selecting successive items in the adaptive test.
#' See the \code{method} argument in \code{\link[catR]{thetaEst}} for possible values.
#' \code{"BM"}, Bayes modal,
#' corresponds to the setting used in the original MPT paper.
#' \code{"WL"}, weighted likelihood,
#' corresponds to the default setting used in versions <= 0.2.0 of this package.
#' @param next_item.prior_dist (Character scalar)
#' The type of prior distribution to use when calculating ability estimates
#' for item selection.
#' Ignored if \code{next_item.estimator} is not a Bayesian method.
#' Defaults to \code{"norm"} for a normal distribution.
#' See the \code{priorDist} argument in \code{\link[catR]{thetaEst}} for possible values.
#' @param next_item.prior_par (Numeric vector, length 2)
#' Parameters for the prior distribution;
#' see the \code{priorPar} argument in \code{\link[catR]{thetaEst}} for details.
#' Ignored if \code{next_item.estimator} is not a Bayesian method.
#' The default is \code{c(0, 1)}.
#' @param final_ability.estimator
#' Estimation method used for the final ability estimate.
#' See the \code{method} argument in \code{\link[catR]{thetaEst}} for possible values.
#' The default is \code{"WL"}, weighted likelihood.
#' #' If a Bayesian method is chosen, its prior distribution will be defined
#' by the \code{next_item.prior_dist} and \code{next_item.prior_par} arguments.
#' @param constrain_answers (Logical scalar)
#' If \code{TRUE}, then item selection will be constrained so that the
#' correct answers are distributed as evenly as possible over the course of the test.
#' We recommend leaving this option disabled.
#' @param eligible_first_items (Character scalar)
#' (NULL or integerish vector) If not NULL, lists the eligible items for the first item
#' in the test, where each item is identified by its 1-indexed row number in item_bank
#' (see adapt_test). For example, c(2, 3, 4) means that the first item will be drawn
#' from rows 2, 3, 4 of the item bank). Default is \code{c(3)} (the third item).
#' @param dict (i18n_dict) The psychTestR dictionary used for internationalisation.
#' @export
MIQ <- function(label = "MIQ",
                num_items = 5,
                with_welcome = TRUE,
                take_training = FALSE,
                feedback_page = NULL,
                with_finish = FALSE,
                next_item.criterion = "MFI",
                next_item.estimator = "BM",
                next_item.prior_dist = "norm",
                next_item.prior_par = c(0, 1),
                final_ability.estimator = "WL",
                constrain_answers = FALSE,
                eligible_first_items = c(3),
                dict = MIQ::MIQ_dict) {

  stopifnot(purrr::is_scalar_character(label),
            purrr::is_scalar_integer(num_items) || purrr::is_scalar_double(num_items),
            purrr::is_scalar_logical(take_training),
            psychTestR::is.timeline(feedback_page) ||
              is.list(feedback_page) ||
              psychTestR::is.test_element(feedback_page) ||
              is.null(feedback_page))

  shiny::addResourcePath("www_MIQ", system.file("www", package = "MIQ"))

  psychTestR::join(
    if (with_welcome) welcome_page(),
    if (take_training) psychTestR::new_timeline(instructions(), dict = dict),
    psychTestR::new_timeline(
      main_test(label = label,
                num_items = num_items,
                next_item.criterion = next_item.criterion,
                next_item.estimator = next_item.estimator,
                next_item.prior_dist = next_item.prior_dist,
                next_item.prior_par = next_item.prior_par,
                final_ability.estimator = final_ability.estimator,
                constrain_answers = constrain_answers,
                eligible_first_items = eligible_first_items),
      dict = dict),
    if (with_finish)
      psychTestR::new_timeline(
        psychTestR::one_button_page(
          body = psychTestR::i18n("CONGRATULATIONS"),
          button_text = psychTestR::i18n("CONTINUE")
        ), dict = dict),

    feedback_page
  )
}
