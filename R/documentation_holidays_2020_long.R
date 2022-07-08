#' Swiss school holidays (2020)
#'
#' A dataset in long format containing school holidays (1.- 9. grade) from the year 2020.
#'
#' @format A data frame with 13176 rows and 12 variables.
#' \describe{
#'   \item{Kanton}{Swiss cantons, e.g. Aargau, Bern.}
#'   \item{Schule}{The particular type of school, e.g. Alle Stufen, Gymnasium.}
#'   \item{Grossregion}{Major regions of Switzerland, e.g. Zentralschweiz, Ostschweiz.}
#'   \item{Datum}{Date in ISO 8601 format: YYYY-MM-DD.}
#'   \item{Tag}{Day of the month. A value in the range of 01 - 31.}
#'   \item{Monat}{Month of the year. A value in the range of 01 - 12.}
#'   \item{Jahr}{The year, e.g. 2020, 2021.}
#'   \item{Jahreszeit}{Season of the year, e.g. Fruehling, Sommer.}
#'   \item{Wochentag}{Day of the week, e.g. Montag, Dienstag.}
#'   \item{Ferientag}{Binary value that captures whether the day is a holiday or not. 0: No holiday, 1: Holiday.}
#'   \item{Wochenende}{Binary value that captures whether the day is a day on the weekend. 0: Mo - Fr, 1: Sa - Su.}
#'   \item{Freier.Tag}{Binary value that captures whether the day is a holiday and/or a day on the weekend. 0: Default, 1: Holiday/Weekend.}
#' }
#' @source \url{https://www.schulferien.org/schweiz/ferien/}
"holidays_2020_long"
