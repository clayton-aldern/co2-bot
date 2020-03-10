# Carbot Dioxide
A R/Twitter bot that pulls the most recent global atmospheric CO2 concentration average from [NOAA](https://www.esrl.noaa.gov/gmd/ccgg/trends/gl_trend.html), makes a chart, and tweets it out.

To store credentials for the `rtweet` package, follow the instructions [here](https://rtweet.info/articles/auth.html).

The production bot runs on an EC2 instance, but you could also schedule it to run in the terminal with `crontab` and `Rscript`.

![example chart](https://github.com/clayton-aldern/co2-bot/blob/master/figures/co2-2020-03-09.png)
