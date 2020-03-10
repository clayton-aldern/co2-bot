# Carbot Dioxide
Hello! **Carbot Dioxide** is an R bot that pulls the most recent global atmospheric CO2 concentration average from [NOAA](https://www.esrl.noaa.gov/gmd/ccgg/trends/gl_trend.html), generates a `ggplot2` chart with the data, and tweets it out. The main file is `tweet-it.R`. Thanks to the BBC for [inspiration](https://twitter.com/bbcelection) (especially [Alison Benjamin](https://twitter.com/hey_benjamin) and [Wes Stephenson](https://twitter.com/WesStephenson)!).

To store credentials for the `rtweet` package, follow the instructions [here](https://rtweet.info/articles/auth.html). You'll also need the development version of `ggplot2`:

```
devtools::install_github("tidyverse/ggplot2")
```

The production bot runs on an EC2 instance, but you could also schedule it to run in the terminal with `crontab` and `Rscript`, e.g.:

```
crontab -e
30 8 * * * /path/to/Rscript /path/to/tweet-it.R  # to run the bot at 8:30am every day
```

![example chart](https://github.com/clayton-aldern/co2-bot/blob/master/figures/co2-2020-03-10.png)
