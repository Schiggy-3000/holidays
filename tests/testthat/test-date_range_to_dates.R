require("testthat")
require("stringr")

test_that("Conversion of date ranges to dates works", {

  html <- fetch_html_element(2020)
  df.raw <- html_to_df(html)
  df <- clean_df(df.raw)

  # Use two sample cells to convert their date range to date strings
  # Possible result A: '-' has to yield '-'
  # Possible result B: '06.04. - 17.04.' has to yield '2020-04-06, 2020-04-07, ..., 2020-04-08'
  dates.sport <- date_range_to_dates(df[1,"Sportferien"], 2020)
  dates.frueh <- date_range_to_dates(df[1,"Fruehlingsferien"], 2020)

  sport.1 <- str_detect(string=dates.sport, pattern="2020-.{2}-.{2}")
  sport.2 <- dates.sport == "-"
  check.sport <- sport.1 | sport.2

  frueh.1 <- str_detect(string=dates.frueh, pattern="2020-.{2}-.{2}")
  frueh.2 <- dates.frueh == "-"
  check.frueh <- frueh.1 | frueh.2

  actual <- c(check.sport, check.frueh)

  should <- c(TRUE, TRUE)
  result <- identical(actual, should)


  expect_equal(TRUE, result)
})
