pacman::p_load('tidyverse', 'magick', 'ggimage')
source(paste0(getwd(), "/src/R/config.R"))
source(paste0(getwd(), "/src/R/gristify.R"))

monthly <-
  read.csv(url(
    "https://www.esrl.noaa.gov/gmd/webdata/ccgg/trends/co2_mlo_mm.csv"
  ))
daily <-
  read.csv(url(
    "https://www.esrl.noaa.gov/gmd/webdata/ccgg/trends/co2_mlo_weekly.csv"
  ))

# Check to see if we have the most recent data.
# We want the bot to run every morning, so we should have data through yesterday.
if (as.character(daily$Date[nrow(daily)]) != Sys.Date() - 1) {
  stop(
    "You don't have the most recent data.
    Check the NOAA csv at https://www.esrl.noaa.gov/gmd/webdata/ccgg/trends/co2_mlo_weekly.csv"
  )
}

monthly$smoothed <-
  predict(loess(trend ~ as.numeric(Date), monthly, span = .05))

n_years <- 10
n <- n_years * 12
monthly <- tail(monthly, n)
monthly$Date <- as.Date(monthly$Date)

daily <- daily[c(nrow(daily), nrow(daily) - 365), ]
daily$Date <- as.Date(daily$Date)

# params for chart
w <- 700
h <- 600
s <- 100
font <- "Open Sans"
t <-
  paste0("Carbon dioxide concentration: ", gsub(" 0", " ", format(Sys.Date(), format =
                                                                    "%B %d, %Y")))
t_s <-
  expression(paste("Atmospheric ", CO[2], ", parts per million"))
c <- "Source: NOAA"

# make the chart
twitter_card <- ggplot(monthly, aes(x = Date, y = co2)) +
  geom_point(
    size = 2.5,
    shape = 1,
    stroke = 1,
    color = "#C3C3C3"
  ) +
  geom_line(aes(y = smoothed),
            size = 1.1,
            color = "#FF7700",
            lineend = "round") +
  geom_point(
    data = daily,
    aes(x = Date, y = day),
    size = 2.5,
    shape = 1,
    stroke = 1,
    color = "#0f9bff"
  ) +
  labs(title = t,
       subtitle = t_s,
       caption = c) +
  
  geom_label(
    aes(
      x = daily[1,]$Date - (365 * 2.1),
      y = daily[1,]$day - 17,
      label = paste0("Today:\n", daily[1,]$day, " ppm"),
      fontface = 3
    ),
    hjust = 0,
    vjust = 0,
    lineheight = 1,
    colour = "#666666",
    #fill = "white",
    label.size = NA,
    family = "Open Sans",
    size = 4
  ) +
  geom_curve(
    aes(
      x = daily[1,]$Date - 365,
      y = daily[1,]$day - 15,
      xend = daily[1,]$Date,
      yend = daily[1,]$day - 1
    ),
    colour = "#0f9bff",
    size = 0.5,
    curvature = 0.2,
    lineend = "round",
    arrow = arrow(length = unit(0.03, "npc"))
  ) +
  
  geom_label(
    aes(
      x = daily[2,]$Date - (365 * 3.9),
      y = daily[2,]$day,
      label = paste0("One year ago:\n", daily[2,]$day, " ppm"),
      fontface = 3
    ),
    hjust = 0,
    vjust = 0,
    lineheight = 1,
    colour = "#666666",
    #fill = "white",
    label.size = NA,
    family = "Open Sans",
    size = 4
  ) +
  geom_curve(
    aes(
      x = daily[2,]$Date - (365 * 2),
      y = daily[2,]$day + 1.25,
      xend = daily[2,]$Date - 60,
      yend = daily[2,]$day + 0.4
    ),
    colour = "#0f9bff",
    size = 0.5,
    curvature = -0.2,
    lineend = "round",
    arrow = arrow(length = unit(0.03, "npc"))
  ) +
  
  gristify()

# twitter_card

# export
ggplot2::ggsave(
  twitter_card,
  filename = paste0(getwd(), fig_dir, '/chart.png'),
  width = (w / s),
  height = (h / s),
  bg = "white",
  limitsize = FALSE
)