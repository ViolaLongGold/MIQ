MIQ_dict_raw <- readRDS("data_raw/MIQ_dict.RDS")
names(MIQ_dict_raw) <- c("key", "DE", "EN")
MIQ_dict_raw <- MIQ_dict_raw[,c("key", "EN", "DE")]
MIQ_dict <- psychTestR::i18n_dict$new(MIQ_dict_raw)
usethis::use_data(MIQ_dict, overwrite = TRUE)
