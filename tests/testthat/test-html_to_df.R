require("testthat")

test_that("Conversion to data frame works", {

  html <- fetch_html_element(2020) # Fetch HTML table from schulferien.org
  df <- html_to_df(html) # Convert it to a data frame
  holiday_types <- c("Var.1", # Expected column names
                     "Sportferien",
                     "Fruehlingsferien",
                     "Sommerferien",
                     "Herbstferien",
                     "Weihnachtsferien")
  names <- colnames(df)

  check.names <- identical(names, holiday_types)
  check.cols <- ncol(df) == 6 # Canton and five different holiday types
  check.rows <- nrow(df) > 1 # Data from at least one canton+school combination

  actual <- c(check.names, check.cols, check.rows)
  should <- c(TRUE, TRUE, TRUE)
  result <- identical(actual, should)

  expect_equal(TRUE, result)
})
