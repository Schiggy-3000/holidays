#' Holidays dataset variables overview
#'
#' @param data A dataset from this package. This includes holidays_20XX_long,
#'             holidays_20XX_long_major_regions, holidays_20XX_long_switzerland,
#'             holidays_2020_to_2025_long, holidays_2020_to_2025_long_major_regions
#'             and holidays_2020_to_2025_long_switzerland. Not that XX is a
#'             placeholder for 20, 21, 22, 23, 24 or 25.
#'
#' @return A console output that provides an overview of all variables of
#'         the dataset and unique values they contain.
#' @import lubridate
#' @export
#'
#' @examples
#' df <- data("holidays_2020_long")
#' df <- get(df)
#' holidays_describe(data=df)
#'
#'
#'
holidays_describe <- function(data) {



  #### Check dataset compatibility ####

  # Compare if colnames of input dataset match allowed datasets
  input <- colnames(data)
  cantons <- c("Kanton",
               "Schule",
               "Grossregion",
               "Datum",
               "Tag",
               "Monat",
               "Jahr",
               "Jahreszeit",
               "Ferientag",
               "Ferientyp",
               "Wochentag",
               "Wochenende")
  major_regions <- c("Grossregion",
                     "Datum",
                     "Tag",
                     "Monat",
                     "Jahr",
                     "Jahreszeit",
                     "Wochentag",
                     "Ferientag",
                     "Wochenende",
                     "Ferientyp")
  switzerland <- c("Land",
                   "Datum",
                   "Tag",
                   "Monat",
                   "Jahr",
                   "Jahreszeit",
                   "Wochentag",
                   "Ferientag",
                   "Wochenende",
                   "Ferientyp")

  a <- identical(input, cantons)
  b <- identical(input, major_regions)
  c <- identical(input, switzerland)

  if (a || b || c) {

    # No action required
    # Data frame seems to be from the package itselfe

  } else {

    # User used an own or customized dataset as input
    return(message("Own or customised datasets are not compatible with this function. Choose a dataset from this package. E.g. holidays_2020_long, holidays_2020_long_major_regions, or holidays_2020_long_switzerland. For more details, check the function documentation at ?holidays_describe."))

  }



  # Setup
  df <- data


  # Explanatory message
  cat("\n\n")
  cat("Following an overview of all variables as well as their unique values.")
  cat("\n\n\n")


  # Print column names + values that come up in those columns
  num_rows <- dim(df)[1]
  num_cols <- dim(df)[2]

  for (col in 1:num_cols) {

    if (is.character(df[,col])) {

      cat("$",
          colnames(df)[col],
          paste("(", toString(length(unique(df[,col]))), ")", sep=""),
          "\n")
      cat(toString(unique(df[,col])), "\n")
      cat("\n")

    } else if (is.Date(df[,col]) || is.numeric(df[,col])) {

      cat("$",
          colnames(df)[col],
          paste("(", toString(length(unique(df[,col]))), ")", sep=""),
          "\n")
      cat(paste(range(df[,col])[1], range(df[,col])[2], sep=" ... "), "\n")
      cat("\n")

    } else {

      cat("$", colnames(df)[col], "\n")
      cat("Column type not assigned.", "\n")
      cat("\n")

    }

  }
}
