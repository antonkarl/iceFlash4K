library(tidyverse)
library(readr)
library(knitr)
library(reticulate)


## set working space
setwd("templates/pdf")

## load data

## en
base.df <- read_tsv("../data/list_4k_en.tsv") %>%
  mutate(across(everything(), ~replace_na(., ""))) %>%
  mutate(across(everything(), ~gsub("%", "\\%", ., fixed = T))) %>%
  rename(manual = manual_en) #%>% head(1200) #%>%


# ## pl
# base.df <- read_tsv("../data/list_4k_pl.tsv") %>%
#   mutate(across(everything(), ~replace_na(., ""))) %>%
#   mutate(across(everything(), ~gsub("%", "\\%", ., fixed = T))) %>%
#   rename(manual = manual_pl) #%>% head(1200) #%>%


## knitr loop

for (tier in unique(base.df$tier)) {
  knit2pdf("flashcard_new.rnw", output=paste("flash_", tier, ".tex", sep = ""), compiler = 'xelatex')
}



# # ## make Anki decks
py_run_file("scripts/gen_deck_en_new.py")
# py_run_file("scripts/gen_deck_pl_new.py")


