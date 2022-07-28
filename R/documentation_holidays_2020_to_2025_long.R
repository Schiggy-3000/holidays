#' Dataset - Swiss school holidays for ML (Scope: cantons, 2020 - 2025)
#'
#' A dataset in long format containing school holidays (1.- 9. grade) from the
#' years 2020 - 2025. This data was scraped in July 2022.
#'
#' @format A data frame with region, temporal, and holiday variables.
#' \describe{
#'   \item{Kanton}{Swiss cantons, e.g. Aargau, Bern.}
#'   \item{Schule}{The particular type of school, e.g. Alle Stufen, Gymnasium.}
#'   \item{Grossregion}{Major regions of Switzerland, e.g. Zentralschweiz, Ostschweiz.}
#'   \item{Datum}{Date in ISO 8601 format: YYYY-MM-DD.}
#'   \item{Tag}{Day of the month. A value in the range of 01 - 31.}
#'   \item{Monat}{Month of the year. A value in the range of 01 - 12.}
#'   \item{Jahr}{The year, e.g. 2020, 2021.}
#'   \item{Jahreszeit}{Season of the year, e.g. Fruehling, Sommer.}
#'   \item{Ferientag}{Binary value that captures whether the day is a holiday or not. 0: No holiday, 1: Holiday.}
#'   \item{Ferientyp}{Indicates the type of holidays if it is a holiday, e.g. Sommerferien, Herbstferien.}
#'   \item{Wochentag}{Day of the week, e.g. Montag, Dienstag.}
#'   \item{Wochenende}{Binary value that captures whether the day is a day on the weekend. 0: Mo - Fr, 1: Sa - Su.}
#' }
#' @source \url{https://www.schulferien.org/schweiz/ferien/}
"holidays_2020_to_2025_long"
