#' Swiss school holidays (2023)
#'
#' A dataset in long format containing school holidays (1.- 9. grade) from the year 2023
#' aggregated to just one entity, Switzerland.
#'
#' @format A data frame with 365 rows and 10 variables.
#' \describe{
#'   \item{Land}{Switzerland.}
#'   \item{Datum}{Date in ISO 8601 format: YYYY-MM-DD.}
#'   \item{Tag}{Day of the month. A value in the range of 01 - 31.}
#'   \item{Monat}{Month of the year. A value in the range of 01 - 12.}
#'   \item{Jahr}{The year, e.g. 2020, 2021.}
#'   \item{Jahreszeit}{Season of the year, e.g. Fruehling, Sommer.}
#'   \item{Wochentag}{Day of the week, e.g. Montag, Dienstag.}
#'   \item{Ferientag}{Value that captures how many cantons have a holiday on that date.}
#'   \item{Wochenende}{Value that captures how many cantons have weekend on that date.}
#'   \item{Freier.Tag}{Value that captures how many cantons have a day off on that date.}
#' }
#' @source \url{https://www.schulferien.org/schweiz/ferien/}
"holidays_2023_long_switzerland"
