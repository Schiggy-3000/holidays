#' Fetches html table containing holiday data from website
#'
#' @param year The year you want the data from.
#'
#' @return An html table element.
#' @import polite rvest
#' @export
#'
#' @examples
#' year <- 2022
#' html <- fetch_html_element(year)
#' html
#'
#'
fetch_html_element <- function(year) {

  # Documentation of bow() function:
  # https://cran.r-project.org/web/packages/polite/polite.pdf

  page_url <- paste("https://www.schulferien.org/schweiz/ferien/", year, "/", sep="")
  session <- bow(url=page_url,
                 user_agent="Polite R package - https://github.com/dmi3kno/polite",
                 delay=5,
                 force=TRUE)
  page_html <- scrape(bow=session)

  # Extract table
  table <- page_html %>%  html_elements("table")
  table

}
