library(tidyverse)
library(readr)
library(knitr)
library(reticulate)
#library(ipa)


## set working space
setwd("demo/pdf")

## load data

# ## en
# base.df <- read_tsv("../../output_v2/list_4k_en.tsv",
#                     col_types = cols(ÞF = col_character(),
#                                     ÞGF = col_character(),
#                                     EF = col_character())) %>%
#   mutate_if(is.character, replace_na, "") %>%
#   mutate(across(7:9, ~gsub("%", "\\%", ., fixed = T))) %>%
#   rename(manual = manual_en) #%>% head(1200) #%>%
# 
#   # mutate(across(everything(), ~replace_na(., ""))) %>%
#   # mutate(across(everything(), ~gsub("NA", "", ., fixed = T))) %>%
#   # mutate(across(everything(), ~gsub("%", "\\%", ., fixed = T))) %>%
#   # rename(manual = manual_en) #%>% head(200) #%>%


# # ## pl
# base.df <- read_tsv("../../output_v2/list_4k_pl.tsv",
#                     col_types = cols(ÞF = col_character(),
#                                      ÞGF = col_character(),
#                                      EF = col_character())) %>%
#   mutate_if(is.character, replace_na, "") %>%
#   mutate(across(7:9, ~gsub("%", "\\%", ., fixed = T))) %>%
#   rename(manual = manual_pl) #%>% head(200) #%>%
  
# ## zh
# base.df <- read_tsv("../../output_v2/list_4k_zh.tsv",
#                     col_types = cols(ÞF = col_character(),
#                                      ÞGF = col_character(),
#                                      EF = col_character())) %>%
#   mutate_if(is.character, replace_na, "") %>%
#   mutate(across(7:9, ~gsub("%", "\\%", ., fixed = T))) %>%
#   rename(manual = manual_zh) #%>% head(200) #%>%


## ukr
base.df <- read_csv("../../output_v2/list_4k_ukr.csv",
                    col_types = cols(ÞF = col_character(),
                                     ÞGF = col_character(),
                                     EF = col_character())) %>%
  mutate_if(is.character, replace_na, "") %>%
  mutate(across(7:9, ~gsub("%", "\\%", ., fixed = T))) %>% 
  rename(manual = manual_ukr) #%>% head(1200) #%>%



## knitr loop

for (tier in unique(base.df$tier)) {
  knit2pdf("flashcard_new_ukr.rnw", output=paste("ukr/flash_", tier, ".tex", sep = ""), compiler = 'xelatex')
}


## change back to flashcard dir
setwd("~/Maltaekni/flashcards")

# # ## make Anki decks
# py_run_file("demo/gen_deck_en_new.py")
# py_run_file("demo/gen_deck_pl_new.py")
# py_run_file("demo/gen_deck_zh_new.py")


