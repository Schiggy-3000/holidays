#' Swiss school holidays (2021)
#'
#' A dataset in long format containing school holidays (1.- 9. grade) from the year 2021
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
#'   \item{Ferientag}{Captures how many cantons have a holiday on a given date.
#'                    This number can be higher than the number of cantons in Switzerland (26).
#'                    This is due to the fact that certain cantons report holidays for
#'                    multiple school systems. E.g. Wallis counts twice since it
#'                    reports holidays for two different school systems (Oberwallis, Romand).
#'                    You can see how many school systems a canton has in holidays_20XX_dates
#'                    (e.g. holidays_2020_dates).}
#'   \item{Wochenende}{Captures how many cantons have weekend on a given date.
#'                    This number can be higher than the number of cantons in Switzerland (26).
#'                    This is due to the fact that certain cantons report holidays for
#'                    multiple school systems. E.g. Wallis counts twice since it
#'                    reports holidays for two different school systems (Oberwallis, Romand).
#'                    You can see how many school systems a canton has in holidays_20XX_dates
#'                    (e.g. holidays_2020_dates).}
#'   \item{Freier.Tag}{Captures how many cantons have a day off on a given date.
#'                    This number can be higher than the number of cantons in Switzerland (26).
#'                    This is due to the fact that certain cantons report holidays for
#'                    multiple school systems. E.g. Wallis counts twice since it
#'                    reports holidays for two different school systems (Oberwallis, Romand).
#'                    You can see how many school systems a canton has in holidays_20XX_dates
#'                    (e.g. holidays_2020_dates).}
#' }
#' @source \url{https://www.schulferien.org/schweiz/ferien/}
"holidays_2021_long_switzerland"
