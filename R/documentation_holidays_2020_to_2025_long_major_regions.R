#' Swiss school holidays (2020 - 2025)
#'
#' A dataset in long format containing school holidays (1.- 9. grade) from the years
#' 2020 - 2025 aggregated to major region in Switzerland (e.g. Zentralschweiz, Ostschweiz)
#'
#' @format A data frame with 15344 rows and 10 variables.
#' \describe{
#'   \item{Grossregion}{Major regions of Switzerland, e.g. Zentralschweiz, Ostschweiz.}
#'   \item{Datum}{Date in ISO 8601 format: YYYY-MM-DD.}
#'   \item{Tag}{Day of the month. A value in the range of 01 - 31.}
#'   \item{Monat}{Month of the year. A value in the range of 01 - 12.}
#'   \item{Jahr}{The year, e.g. 2020, 2021.}
#'   \item{Jahreszeit}{Season of the year, e.g. Fruehling, Sommer.}
#'   \item{Wochentag}{Day of the week, e.g. Montag, Dienstag.}
#'   \item{Ferientag}{Value that captures how many major regions have a holiday on that date.}
#'   \item{Wochenende}{Value that captures how many major regions have weekend on that date.}
#'   \item{Freier.Tag}{Value that captures how many major regions have a day off on that date.}
#' }
#' @source \url{https://www.schulferien.org/schweiz/ferien/}
"holidays_2020_to_2025_long_major_regions"
