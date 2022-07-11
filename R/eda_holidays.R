#' Exploratory data analysis (EDA) for holiday datasets
#'
#' @param data A dataset from this package. This includes holidays_20XX_long,
#'             holidays_20XX_long_major_regions, holidays_20XX_long_switzerland,
#'             holidays_2020_to_2025_long, holidays_2020_to_2025_long_major_regions
#'             and holidays_2020_to_2025_long_switzerland. Not that XX is a
#'             placeholder for 20, 21, 22, 23, 24 or 25.
#' @param years The years for which you want the EDA to be executed for.
#'              E.g. if you chose dataset holidays_2020_long, set years=2020.
#'              Similarly, if you chose holidays_2020_to_2025_long, you can
#'              set multiple years=c(2020,2021,2025).
#'
#' @return An exploratory data analysis for the input dataset.
#' @export
#'
#' @examples
#' df <- data("holidays_2020_dates")
#' df <- get(df)
#' y <- c(2020, 2021, 2025)
#' eda_holidays(data=df, years=y)
#'
#'
#'
eda_holidays <- function(data, years) {


  # Setup
  df <- data
  y <- years


  # Plots for 'Plots' pane
  plot(x=c(1,2,3), y=c(1,2,3), main="1/2")
  plot(x=c(10,12), y=c(10,12), main="2/2")


  # Explanatory message
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

      message("")
      message(colnames(df)[col])
      message(toString(unique(df[,col])))
      message("")

    } else if (is.Date(df[,col]) || is.numeric(df[,col])) {

      message("")
      message(colnames(df)[col])
      message(paste(range(df[,col])[1], range(df[,col])[2], sep=" ... "))
      message("")

    } else {

      message("Column type not assigned.")

    }

  }

}
