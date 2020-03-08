pacman::p_load('showtext') # If you're on a newish Mac, you'll need XQuartz installed.
font_add_google("Open Sans", "opensans")
font <- "opensans"
showtext_auto()

gristify <- function() {
  
  ggplot2::theme(
    
    # Text
    plot.title = ggplot2::element_text(
      family = font,
      size = 20,
      face = "bold",
      color = "#222222"
    ),
    plot.title.position = "plot",
    plot.subtitle = ggplot2::element_text(
      family = font,
      size = 18,
      margin = ggplot2::margin(3, 0, 20, 0)
    ),
    plot.caption = ggplot2::element_text(
      family = font,
      size = 9,
      hjust = 0,
      color = "#666666"
    ),
    plot.caption.position = "plot",
    
    # Legend
    legend.position = "top",
    legend.text.align = 0,
    legend.background = ggplot2::element_blank(),
    legend.title = ggplot2::element_blank(),
    legend.key = ggplot2::element_blank(),
    legend.text = ggplot2::element_text(
      family = font,
      size = 14,
      color = "#666666"
    ),
    
    # Axes
    axis.title = ggplot2::element_blank(),
    axis.text = ggplot2::element_text(
      family = font,
      size = 14,
      color = "#666666"
    ),
    axis.text.x = ggplot2::element_text(margin = ggplot2::margin(5, b = 10)),
    axis.ticks.x = ggplot2::element_line(size = 0.25,
                                         color = "#222222"),
    axis.line.x = ggplot2::element_line(color = "#222222"),
    axis.ticks.y = ggplot2::element_blank(),
    axis.line.y = ggplot2::element_blank(),
    
    # Gridlines
    panel.grid.minor = ggplot2::element_blank(),
    panel.grid.major.y = ggplot2::element_line(color = "#F7F7F7"),
    panel.grid.major.x = ggplot2::element_blank(),
    
    # Background
    panel.background = ggplot2::element_blank(),
    
    # Strip background (facet-wrapped plots)
    strip.background = ggplot2::element_rect(fill = "white"),
    strip.text = ggplot2::element_text(size  = 22,  hjust = 0),
    
    # Margins
    plot.margin = unit(c(.2, .2, .2, .2), "in")
    
  )
}