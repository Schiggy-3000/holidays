#' Time series for holidays datasets
#'
#' @param data A dataset from this package. This includes holidays_20XX_long,
#'             holidays_20XX_long_major_regions, holidays_20XX_long_switzerland,
#'             holidays_2020_to_2025_long, holidays_2020_to_2025_long_major_regions
#'             and holidays_2020_to_2025_long_switzerland. Not that XX is a
#'             placeholder for 20, 21, 22, 23, 24 or 25.
#'
#' @return An interactive time series plot for the dataset that was passed into the function.
#'         Each region (e.g. a 'Kanton', 'Grossregion' or 'Land') is represented by a plotted line.
#'         The x-axis denotes dates whereas the number of holidays on a given date is shown on the y-axis.
#'         You can use the filter function at the top of the plot to display only the regions of your choice.
#' @import plotly crosstalk
#' @importFrom ggplot2 ggplot geom_line aes xlab ylab
#' @export
#'
#' @examples
#' df <- data("holidays_2020_long")
#' df <- get(df)
#' holidays_time_series(data=df)
#'
#'
#'
holidays_time_series <- function(data) {


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


  # Time series plot
  tx <- highlight_key(df.1, ~Primary.key, "Ort waehlen")
  gg <- ggplot(tx) +
          geom_line(aes(df.1$Datum, df.1$Ferientag, group=df.1$Primary.key)) +
          xlab("Datum") +
          ylab("Ferientag")

  suppressMessages( #  persistent=TRUE throws a message that is not relevant to the user
    select <- highlight(
      ggplotly(gg, tooltip="Kanton"),
      selectize=TRUE,               # Creates a search box that allows to select 'Kanton'
      persistent=TRUE,              # Clicking on multiple lines keeps them all selected
      on = "plotly_click",          # A click on a line selects it
      off = "plotly_doubleclick"))  # A doubleclick does not unselect a line


  # Plot time series
  bscols(select)

}
