trigger_img_button <- function (inputId, img_src, width, height, margin = height / 10){
  inputId <- htmltools::htmlEscape(inputId, attribute = TRUE)
  style <- sprintf("width: %dpx; height: %dpx; margin: %dpx; background: url('%s'); background-size: %dpx %dpx; background-position: center center;", width, height, 4, img_src, width, height)
  shiny::actionButton(inputId = inputId,
                      label = "",
                      style = style,
                      icon = NULL,
                      onclick = "trigger_button(this.id);")
}

media_js <- list(
  media_not_played = "var media_played = false;",
  media_played = "media_played = true;",
  play_media = "document.getElementById('media').play();",
  show_media   = paste0("if (!media_played) ",
                        "{document.getElementById('media')",
                        ".style.visibility='inherit'};"),
  hide_media   = paste0("if (media_played) ",
                          "{document.getElementById('media')",
                          ".style.visibility='hidden'};"),
  show_media_btn = paste0("if (!media_played) ",
                          "{document.getElementById('btn_play_media')",
                          ".style.visibility='inherit'};"),
  hide_media_btn = paste0("document.getElementById('btn_play_media')",
                          ".style.visibility='hidden';"),
  show_responses = "document.getElementById('response_ui').style.visibility = 'inherit';"
)

#media_mobile_play_button <- shiny::tags$button(
#  shiny::tags$strong(psychTestR::i18n("CLICK_HERE_TO_PLAY")),
#  id = "btn_play_media",
#  style = "visibility: visible;height: 50px",
#  onclick = media_js$play_media
#)

media_mobile_play_button <- shiny::tags$p(
  shiny::tags$button(shiny::tags$span("\u25B6"),
                     type = "button",
                     id = "btn_play_media",
                     style = "visibility: hidden",
                     onclick = media_js$play_media)
)
get_audio_ui <- function(url,
                         type = tools::file_ext(url),
                         autoplay = TRUE,
                         width = 0,
                         wait = TRUE,
                         loop = FALSE) {
  stopifnot(purrr::is_scalar_character(url),
            purrr::is_scalar_character(type),
            purrr::is_scalar_logical(wait),
            purrr::is_scalar_logical(loop))
  src    <- shiny::tags$source(src = url, type = paste0("audio/", type))
  script <- shiny::tags$script(shiny::HTML(media_js$media_not_played))
  audio  <- shiny::tags$audio(
    script,
    src,
    id = "media",
    preload = "auto",
    autoplay = if(autoplay) "autoplay",
    width = width,
    loop = if (loop) "loop",
    oncanplaythrough = media_js$show_media_btn,
    onplay = paste0(media_js$media_played, media_js$hide_media_btn),
    #onended = if (wait) paste0(media_js$show_responses, media_js$hide_media) else "null",
    onended = if (wait) media_js$show_responses else "null"
  )
  shiny::tags$div(audio, media_mobile_play_button)
}

get_audio_element <- function(url,
                              type = tools::file_ext(url),
                              wait = F,
                              autoplay = FALSE,
                              width = 200,
                              height = 50,
                              id = "media") {
  stopifnot(purrr::is_scalar_character(url),
            purrr::is_scalar_character(type)
            )
  src    <- shiny::tags$source(src = url, type = paste0("audio/", type))
  script <- shiny::tags$script(shiny::HTML(media_js$media_not_played))
  audio  <- shiny::tags$audio(
    src,
    script,
    id = id,
    preload = "auto",
    controls = "controls",
    controlslist = "nodownload noremoteplayback",
    autoplay = if(autoplay) "autoplay",
    width = width,
    height = height,
    onplay = paste0(media_js$media_played, media_js$hide_media),
    onended = if (wait) paste0(media_js$show_responses, media_js$hide_media) else "null"
  )
  audio
}

NAFC_page_with_img <- function(label,
                               prompt,
                               subprompt,
                               page_number,
                               item_name,
                               image_dir,
                               choices,
                               save_answer = TRUE,
                               get_answer = NULL,
                               hide_response_ui = FALSE,
                               response_ui_id = "response_ui",
                               on_complete = NULL,
                               admin_ui = NULL) {
  stopifnot(purrr::is_scalar_character(label))
  audio_ui <- get_audio_ui("audio_url", wait = T, loop = F)
  style <- NULL
  if (hide_response_ui) style <- "visibility:hidden"
  ui <- shiny::div(
    shiny::div(prompt, style = "font-weight: bold;"),
    tagify(subprompt),
    shiny::tags$img(src = paste0(image_dir, sprintf("/%s/m_%s.png", item_name, item_name)), style = "margin-top: 10px;"),
    shiny::div(choices, style = style, id = response_ui_id)
    )
  if (is.null(get_answer)) {
    get_answer <- function(input, ...) as.numeric(gsub("answer", "", input$last_btn_pressed))
  }
  validate <- function(answer, ...) !is.null(answer)
  psychTestR::page(ui = ui, label = label, get_answer = get_answer, save_answer = save_answer,
       validate = validate, on_complete = on_complete, final = FALSE,
       admin_ui = admin_ui)
}

get_answer_button <- function(page_number,
                              item_name,
                              image_number,
                              image_dir,
                              width = 130,
                              height = 91,
                              index){

  img_src <- file.path(image_dir, sprintf("/%s/r%d_%s.png", item_name, image_number, item_name))
  # printf("get_answer_button img_src: %s", img_src)
  trigger_img_button(inputId = sprintf("answer%d", index),
                     img_src = img_src,
                     width = width,
                     height = height,
                     margin = height / 10)
}

get_answer_block<-function(page_number,
                           item_name,
                           image_numbers,
                           image_dir,
                           width = 550,
                           height = 100,
                           ncols = 4,
                           ...) {
  n <- length(image_numbers)
  rows <- list()
  for (i in seq_len(n)) {
    #width_factor <- nchar(image_numbers[i]) / 8
    button <- get_answer_button(page_number, item_name, image_numbers[i], width = 130, height = 91, index = i, image_dir = image_dir)
    rows[[i]] <- button
  }

  ret <- list()
  nrows <- floor(n / ncols)
  for (i in seq_len(nrows)) {
    ret[[i]] <- shiny::div(rows[(i - 1) * ncols + (1:ncols)])
  }
  ret
}

MIQ_item <- function(label,
                     page_number,
                     item_name,
                     answer,
                     prompt = "",
                     subprompt = "",
                     image_dir = "",
                     save_answer = TRUE,
                     get_answer = NULL,
                     on_complete = NULL,
                     instruction_page = FALSE,
                     block_size = 4) {

  page_prompt <- shiny::div(prompt)
  page_subprompt <- shiny::div(subprompt)
  # printf("MIQ item_called for page_number %d and item_name %s", page_number, item_name)

  image_numbers <- c(1, 2, 3, 4, 5, 6, 7, 8)

  if(!instruction_page){
    choices <- get_answer_block(page_number, item_name, image_numbers, image_dir = image_dir)

    NAFC_page_with_img(label = label,
                       prompt = page_prompt,
                       subprompt = page_subprompt,
                       page_number = page_number,
                       item_name = item_name,
                       image_dir = image_dir,
                       choices = choices,
                       save_answer = save_answer,
                       get_answer = get_answer,
                       on_complete = NULL)
  } else {
    psychTestR::one_button_page(page_prompt, button_text = "add stuff")
  }
}

