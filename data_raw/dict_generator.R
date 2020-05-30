for (questionnaire in c("MIQ")) {
  dict_raw <- read.csv(paste0("data_raw/dicts/", questionnaire, "_dict.csv"), sep = ";", stringsAsFactors = FALSE, header = TRUE)
  general_dict_raw <- read.csv("data_raw/dicts/GENERAL_dict.csv", sep = ";", stringsAsFactors = FALSE, header = TRUE)
  assign(paste0(questionnaire, "_dict"), psychTestR::i18n_dict$new(dplyr::bind_rows(dict_raw, general_dict_raw)))
}

usethis::use_data(MIQ_dict, overwrite = TRUE)
