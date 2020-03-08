#!/usr/bin/env Rscript
# co2-bot 0.1
# author: Clayton Aldern

pacman::p_load('rtweet')
source(paste0(getwd(), "/src/R/get-co2.R"))

tweet <- "Testing out a bot here... \1F4C8"
img <- fn

post_tweet(status = tweet,
           media = img)