item_bank <- readRDS("data_raw/MIQ_item_bank.RDS")
item_bank$item_id <- sprintf("%s-%s", item_bank$pattern, item_bank$bit_flips)

item_bank <- item_bank %>% distinct(item_id, .keep_all = T)
item_bank$length.cat <- NULL
item_bank$item_no <- NULL
item_bank$training <- NULL
item_bank$sample <- NULL
item_bank$K9.rescaled <- NULL
MIQ_item_bank <- as.data.frame(item_bank)

stopifnot(is.numeric(item_bank$answer))
usethis::use_data(MIQ_item_bank, overwrite = TRUE)
