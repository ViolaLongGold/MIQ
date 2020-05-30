for (questionnaire in c("MIQ")) {
    item_bank_raw <- read.csv(paste0("data_raw/item_banks/", questionnaire, "_item_bank.csv"), sep = ";", stringsAsFactors = FALSE, header = TRUE)
    assign(paste0(questionnaire, "_item_bank"), item_bank_raw)
}

usethis::use_data(MIQ_item_bank, overwrite = TRUE)
