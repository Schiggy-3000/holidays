#' Dataset - Swiss school holidays for ML (Scope: country)
#'
#' Dataset in long format containing school holidays (1.- 9. grade) from the
#' years 2020 - 2025 aggregated to just one entity, Switzerland.
#'
#' @format Data frames with region, temporal, and holiday variables.
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
#'   \item{Ferientyp}{Indicates the type of holidays if it is a holiday, e.g. Sommerferien, Herbstferien.}
#' }
#' @source \url{https://www.schulferien.org/schweiz/ferien/}

#' @rdname holidays_20XX_long_switzerland
"holidays_2020_long_switzerland"

#' @rdname holidays_20XX_long_switzerland
"holidays_2021_long_switzerland"

#' @rdname holidays_20XX_long_switzerland
"holidays_2022_long_switzerland"

#' @rdname holidays_20XX_long_switzerland
"holidays_2023_long_switzerland"

#' @rdname holidays_20XX_long_switzerland
"holidays_2024_long_switzerland"

#' @rdname holidays_20XX_long_switzerland
"holidays_2025_long_switzerland"

