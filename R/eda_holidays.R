#' Exploratory data analysis (EDA) for holiday datasets
#'
#' @param data A dataset from this package. This includes holidays_20XX_long,
#'             holidays_20XX_long_major_regions, holidays_20XX_long_switzerland,
#'             holidays_2020_to_2025_long, holidays_2020_to_2025_long_major_regions
#'             and holidays_2020_to_2025_long_switzerland. Not that XX is a
#'             placeholder for 20, 21, 22, 23, 24 or 25.
#'
#' @return An exploratory data analysis for the input dataset.
#' @import plotly
#' @export
#'
#' @examples
#' df <- data("holidays_2020_long")
#' df <- get(df)
#' eda_holidays(data=df)
#'
#'
#'
eda_holidays <- function(data) {


  # Only include relevant years
  df <- data


  # Plots for 'Plots' pane
  plot(x=c(1,2,3), y=c(1,2,3), main="1/2")
  plot(x=c(10,12), y=c(10,12), main="2/2")


  # Explanatory message
  message("")
  message("")
  message("")
  message("Following an overview of all variables as well as their range of values.")
  message("")
  message("")


  # Print column names + values that come up in those columns
  num_rows <- dim(df)[1]
  num_cols <- dim(df)[2]

  for (col in 1:num_cols) {

    if (is.character(df[,col])) {

      message(colnames(df)[col])
      message(toString(unique(df[,col])))
      message("")

    } else if (is.Date(df[,col]) || is.numeric(df[,col])) {

      message(colnames(df)[col])
      message(paste(range(df[,col])[1], range(df[,col])[2], sep=" ... "))
      message("")

    } else {

      message("Column type not assigned.")

    }

  }


  # Interactive heat map
  df.1 <- df

  # Add new column with primary key
  # This key is needed to plot the y-axis of the heatmap
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

  # Create heat map
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
