#' Dataset - Swiss school holidays for ML (Scope: major regions)
#'
#' Datasets in long format containing school holidays (1.- 9. grade) from the
#' years 2020 - 2025 aggregated to major region in Switzerland
#' (e.g. Zentralschweiz, Ostschweiz). This data was scraped in July 2022
#' from schulferien.org/schweiz/ferien/.
#'
#' @format Data frames with region, temporal, and holiday variables.
#' \describe{
#'   \item{Grossregion}{Major regions of Switzerland, e.g. Zentralschweiz, Ostschweiz.}
#'   \item{Datum}{Date in ISO 8601 format: YYYY-MM-DD.}
#'   \item{Tag}{Day of the month. A value in the range of 01 - 31.}
#'   \item{Monat}{Month of the year. A value in the range of 01 - 12.}
#'   \item{Jahr}{The year, e.g. 2020, 2021.}
#'   \item{Jahreszeit}{Season of the year, e.g. Fruehling, Sommer.}
#'   \item{Wochentag}{Day of the week, e.g. Montag, Dienstag.}
#'   \item{Ferientag}{Captures how many cantons from a given major region have a holiday on a particular date.
#'                    E.g. the major region 'Genferseeregion' has 3 cantons (Genf, Waadt, Wallis). 'Ferientag'
#'                    would therefore be a value from 0 - 3. Note, however, that Wallis counts twice since it
#'                    reports holidays for two different school systems (Oberwallis, Romand).
#'                    You can see how many school systems a canton has in holidays_20XX_dates (e.g. holidays_2020_dates).
#'                    As a result, 'Ferientag' is a number from 0 - 4.}
#'   \item{Wochenende}{Captures how many cantons from a given major region have weekend on a particular date.
#'                    E.g. the major region 'Genferseeregion' has 3 cantons (Genf, Waadt, Wallis). 'Wochenende
#'                    would therefore be a value from 0 - 3. Note, however, that Wallis counts twice since it
#'                    reports holidays for two different school systems (Oberwallis, Romand).
#'                    You can see how many school systems a canton has in holidays_20XX_dates (e.g. holidays_2020_dates).
#'                    As a result, 'Wochenende' is a number from 0 - 4.}
#'   \item{Ferientyp}{Indicates the type of holidays if it is a holiday, e.g. Sommerferien, Herbstferien.}
#' }
#' @source \url{https://www.schulferien.org/schweiz/ferien/}

#' @rdname holidays_20XX_long_major_regions
"holidays_2020_long_major_regions"

#' @rdname holidays_20XX_long_major_regions
"holidays_2021_long_major_regions"

#' @rdname holidays_20XX_long_major_regions
"holidays_2022_long_major_regions"

#' @rdname holidays_20XX_long_major_regions
"holidays_2023_long_major_regions"

#' @rdname holidays_20XX_long_major_regions
"holidays_2024_long_major_regions"

#' @rdname holidays_20XX_long_major_regions
"holidays_2025_long_major_regions"
