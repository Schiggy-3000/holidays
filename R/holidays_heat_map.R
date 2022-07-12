#' Heat map for holidays datasets
#'
#' @param data A dataset from this package. This includes holidays_20XX_long,
#'             holidays_20XX_long_major_regions, holidays_20XX_long_switzerland,
#'             holidays_2020_to_2025_long, holidays_2020_to_2025_long_major_regions
#'             and holidays_2020_to_2025_long_switzerland. Not that XX is a
#'             placeholder for 20, 21, 22, 23, 24 or 25.
#'
#' @return An interactive heat map plot for the dataset that was passed into the function.
#' @import plotly
#' @export
#'
#' @examples
#' df <- data("holidays_2020_long")
#' df <- get(df)
#' holidays_heat_map(data=df)
#'
#'
#'
holidays_heat_map <- function(data) {


  # Setup for plot
  df.1 <- data


  # Add new column with primary key
  # This key is needed to plot the y-axis of the plots
  # holidays_20XX_long:               primary.key -> 'Kanton' + 'Schule'
  # holidays_20XX_long_major_region:  primary.key -> 'Grossregion'
  # holidays_20XX_long_switzerland:   primary.key -> 'Land'
  if (is.character(df.1$Kanton)) {

    df.1$Primary.key <- with(df.1, paste0(Kanton, ", ", Schule))

  } else if (is.character(df.1$Grossregion)) {

    df.1$Primary.key <- df.1$Grossregion

  } else if (is.character(df.1$Land)) {

    df.1$Primary.key <- df.1$Land

  } else {

    print("Unknown dataset format")

  }


  # Heat map
  n <- length(unique(df.1$Primary.key))
  heatmap <- plot_ly() %>%
    add_trace(
      type = "heatmap",
      data = df.1,
      x = ~Datum,
      y = ~Primary.key,
      z = ~Ferientag,
      showscale = FALSE,
      colors = c("slategray1", "steelblue3"),
      hoverinfo = "text",
      text = ~paste("Datum:",
                    df.1$Datum,
                    "<br>Ort:",
                    df.1$Primary.key,
                    "<br>Ferientag:",
                    df.1$Ferientag)) %>%
    layout(
      xaxis = list(title=""),
      yaxis = list(title="", tickvals=0:n))


  # Plot heat map
  heatmap

}
