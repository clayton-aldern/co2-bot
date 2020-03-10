#!/usr/bin/env Rscript
# co2-bot 0.1
# author: Clayton Aldern

pacman::p_load('rtweet','textclean')
source(paste0(getwd(), "/src/R/get-co2.R"))
attempted = FALSE

# Check to see if we have the most recent data.
# We want the bot to run every morning, so we should have data through yesterday.
if (as.character(daily$Date[nrow(daily)]) != Sys.Date() - 1) {
  
  stop(
    "You don't have the most recent data data.
    Check the NOAA .txt at ftp://aftp.cmdl.noaa.gov/products/trends/co2/co2_trend_gl.txt"
  )
  
  tweet <-
    paste0(
      "Good morning! ☕️
Yesterday's global average atmospheric CO2 reading was ",
      daily$day[1],
      " ppm. 🌏
Last year at this time, it was ",
      daily$day[2],
      " ppm. 📈"
    )
  img <- fn
  
  post_tweet(status = tweet,
             media = img)
  attempted = TRUE
}

if (attempted) {
  entry = textclean::replace_emoji(tweet)
  media = img
} else {
  entry = "error"
  media = "error"
}

line <- paste(Sys.time(), entry, media, sep = "\t")
write(line,
      file = paste0(getwd(), logs_dir, "/tweets.log"),
      append = TRUE)