#' Converts html table element to df
#'
#' @param table The html table element you wish to convert.
#'
#' @return A data frame.
#' @import rvest
#' @export
#'
#' @examples
#' year <- 2022
#' html <- fetch_html_element(year)
#' df <- html_to_df(html)
#' df
#'
#'
#'
html_to_df <- function(table) {

  # Convert html table to df
  tb <- html_table(table,
                   header = TRUE,
                   trim = TRUE,
                   na.strings = "NA",
                   convert = TRUE)
  df <- as.data.frame(tb)

  # Replace non-ASCII character
  names(df)[3] <- "Fruehlingsferien"

  # Return df
  return(df)

}
