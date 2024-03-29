% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/holidays_bar_chart.R
\name{holidays_bar_chart}
\alias{holidays_bar_chart}
\title{Bar chart for holidays datasets}
\usage{
holidays_bar_chart(
  data,
  normalize = FALSE,
  holidaytype = c("Sportferien", "Fruehlingsferien", "Sommerferien", "Herbstferien",
    "Weihnachtsferien")
)
}
\arguments{
\item{data}{A dataset from this package. This includes holidays_20XX_long,
holidays_20XX_long_major_regions, holidays_20XX_long_switzerland,
holidays_2020_to_2025_long, holidays_2020_to_2025_long_major_regions,
and holidays_2020_to_2025_long_switzerland. Not that XX is a
placeholder for 20, 21, 22, 23, 24 or 25.}

\item{normalize}{Can be set to TRUE or FALSE. If set to TRUE, values for 'Ferientag'
are normalized. This is useful for e.g. holidays_20XX_long_major_regions.
Since not all major regions have the same number of members (e.g. Zentralschweiz: 9,
Genferseeregion: 4). Normalizing the data can make the bar chart more meaningful.}

\item{holidaytype}{The type of holidays you want the plot for. Possible values are:
Sportferien, Fruehlingsferien, Sommerferien, Herbstferien, and Weihnachtsferien.
You can also chose multiple values at once: holidaytype=c("Sommerferien", "Herbstferien").
If you don't pass any value here, all types are included.}
}
\value{
An interactive bar plot for the dataset that was passed into the function.
Each bar represents the number of holidays in a year for a given region.
}
\description{
Bar chart for holidays datasets
}
\examples{
df <- data("holidays_2020_to_2025_long_major_regions")
df <- get(df)
holidays_bar_chart(data=df, normalize=TRUE, holidaytype=c("Sommerferien", "Herbstferien"))



}
