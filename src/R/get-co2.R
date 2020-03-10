pacman::p_load('tidyverse')
source(paste0(getwd(), "/src/R/config.R"))
source(paste0(getwd(), "/src/R/gristify.R"))

# get data
d <-
  readLines("ftp://aftp.cmdl.noaa.gov/products/trends/co2/co2_trend_gl.txt")

# clean
header <- which(d == "# year month   day    cycle    trend")
d <-
  d[header + 1:length(d)] %>% trimws() %>% data.frame()
d <-
  data.frame(d[rowSums(is.na(d)) != ncol(d),])
d <- d %>%
  separate(
    colnames(d),
    c("year", "month", "day", "cycle", "trend"),
    sep = "[ ]{3,}",
    convert = TRUE
  )

# select the last 10 years
n_years <- 10
n <- round(n_years * 365.25)
d <- d %>% tail(n)
d$Date <-
  d %>% with(paste(year, month, day, sep = "-")) %>%
  as.Date("%Y-%m-%d")

# pull out individual dates to highlight
daily <- d[c(nrow(d), nrow(d) - 366),]

# downsample daily data to monthly averages
monthly <- list(d$cycle, d$trend) %>%
  aggregate(list(format(d$Date, "%Y-%m")), mean)
colnames(monthly) <- c('Date', 'cycle', 'trend')
monthly$Date <- paste0(monthly$Date, "-15") %>% as.Date()

# params for chart
w <- 700
h <- 600
s <- 100
t <- "Carbon dioxide: current global average"
t_s <-
  expression(paste("Atmospheric ", CO[2], ", parts per million"))
c <-
  paste0(
    "Source: NOAA/ESRL | Graphic + Bot: Clayton Aldern (@compatibilism) | Generated: ",
    gsub(" 0", " ", format(Sys.Date(), format = "%B %d, %Y"))
  )

# make the chart
card <- monthly %>% ggplot(aes(x = Date, y = cycle)) +
  geom_point(
    size = 2.5,
    shape = 1,
    stroke = 1,
    color = styles$pts
  ) +
  geom_line(aes(y = trend),
            size = 1.1,
            color = styles$ln,
            lineend = "round") +
  geom_point(
    data = daily,
    aes(x = Date, y = cycle),
    size = styles$shapesize,
    shape = styles$shape,
    stroke = 1,
    color = styles$highlight
  ) +
  labs(title = t,
       subtitle = t_s,
       caption = c) +
  
  geom_label(
    aes(
      x = daily[1, ]$Date - (365 * 1.8),
      y = daily[1, ]$cycle - 18,
      label = paste0("Yesterday:\n", sprintf("%.2f", round(daily$cycle[1],2)), " ppm"),
      fontface = 3
    ),
    hjust = 0,
    vjust = 0,
    lineheight = 1,
    colour = "#666666",
    #fill = "white",
    label.size = NA,
    family = styles$font_text,
    size = 4
  ) +
  geom_curve(
    aes(
      x = daily[1, ]$Date - (365 * 0.70),
      y = daily[1, ]$cycle - 14.5,
      xend = daily[1, ]$Date,
      yend = daily[1, ]$cycle - 1
    ),
    colour = styles$highlight,
    size = 0.75,
    curvature = 0.2,
    lineend = "round",
    arrow = arrow(length = unit(0.03, "npc"))
  ) +
  
  geom_label(
    aes(
      x = daily[2, ]$Date - (365 * 3.9),
      y = daily[2, ]$cycle,
      label = paste0("One year ago:\n", sprintf("%.2f", round(daily$cycle[2],2)), " ppm"),
      fontface = 3
    ),
    hjust = 0,
    vjust = 0,
    lineheight = 1,
    colour = "#666666",
    #fill = "white",
    label.size = NA,
    family = styles$font_text,
    size = 4
  ) +
  geom_curve(
    aes(
      x = daily[2, ]$Date - (365 * 2),
      y = daily[2, ]$cycle + 1.25,
      xend = daily[2, ]$Date - 60,
      yend = daily[2, ]$cycle + 0.4
    ),
    colour = styles$highlight,
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
  card,
  filename = fn,
  width = (w / s),
  height = (h / s),
  bg = "white",
  limitsize = FALSE
)