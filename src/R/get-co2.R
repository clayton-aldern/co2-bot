pacman::p_load('tidyverse')
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
t <- "Carbon dioxide today"
t_s <-
  expression(paste("Atmospheric ", CO[2], ", parts per million"))
c <-
  paste0(
    "Source: NOAA | Location: Mauna Loa | Graphic + Bot: Clayton Aldern (@compatibilism) | ",
    gsub(" 0", " ", format(Sys.Date(), format = "%B %d, %Y"))
  )

# make the chart
twitter_card <- ggplot(monthly, aes(x = Date, y = co2)) +
  geom_point(
    size = 2.5,
    shape = 1,
    stroke = 1,
    color = "#cccccc",
    alpha = 0.66
  ) +
  geom_line(aes(y = smoothed),
            size = 1.1,
            color = "#ff9999",
            lineend = "round") +
  geom_point(
    data = daily,
    aes(x = Date, y = day),
    size = 3,
    shape = 16,
    stroke = 1,
    color = "#ffcc99"
  ) +
  labs(title = t,
       subtitle = t_s,
       caption = c) +
  
  geom_label(
    aes(
      x = daily[1,]$Date - (365 * 1.8),
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
    family = font_text,
    size = 4
  ) +
  geom_curve(
    aes(
      x = daily[1,]$Date - (365 * 0.70),
      y = daily[1,]$day - 14.5,
      xend = daily[1,]$Date,
      yend = daily[1,]$day - 1
    ),
    colour = "#ffcc99",
    size = 0.75,
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
    family = font_text,
    size = 4
  ) +
  geom_curve(
    aes(
      x = daily[2,]$Date - (365 * 2),
      y = daily[2,]$day + 1.25,
      xend = daily[2,]$Date - 60,
      yend = daily[2,]$day + 0.4
    ),
    colour = "#ffcc99",
    size = 0.75,
    curvature = -0.2,
    lineend = "round",
    arrow = arrow(length = unit(0.03, "npc"))
  ) +
  
  scale_x_date(date_breaks = "years", date_labels = "%Y") +
  
  gristify()

# export
fig_name <- paste0('/co2-', Sys.Date(), '.png')
fn <- paste0(getwd(), fig_dir, fig_name)
ggplot2::ggsave(
  twitter_card,
  filename = fn,
  width = (w / s),
  height = (h / s),
  bg = "white",
  limitsize = FALSE
)