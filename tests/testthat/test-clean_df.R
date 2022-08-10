require("testthat")
require("stringr")

test_that("Removal of unwanted characters works", {

  html <- fetch_html_element(2020) # Fetch HTML table from schulferien.org
  df.raw <- html_to_df(html) # Convert it to a data frame
  df <- clean_df(df.raw) # Remove unwanted characters

  cols <- ncol(df)
  names <- colnames(df)
  holiday_types <- c("Kanton", # Expected column names
                     "Schule",
                     "Sportferien",
                     "Fruehlingsferien",
                     "Sommerferien",
                     "Herbstferien",
                     "Weihnachtsferien")

  asterisk.canton <- str_detect(string=df$Kanton, pattern="\\*", negate=TRUE) # Search for * in canton column
  asterisk.school <- str_detect(string=df$Schule, pattern="\\*", negate=TRUE)
  asterisk.f.1 <- str_detect(string=df$Sportferien, pattern="\\*", negate=TRUE)
  asterisk.f.2 <- str_detect(string=df$Fruehlingsferien, pattern="\\*", negate=TRUE)
  asterisk.f.3 <- str_detect(string=df$Sommerferien, pattern="\\*", negate=TRUE)
  asterisk.f.4 <- str_detect(string=df$Herbstferien, pattern="\\*", negate=TRUE)
  asterisk.f.5 <- str_detect(string=df$Weihnachtsferien, pattern="\\*", negate=TRUE)


  check.asterisk.canton <- all(asterisk.canton) # Returns false if any asterisk is left in canton column
  check.asterisk.school <- all(asterisk.school)
  check.asterisk.f.1 <- all(asterisk.f.1)
  check.asterisk.f.2 <- all(asterisk.f.2)
  check.asterisk.f.3 <- all(asterisk.f.3)
  check.asterisk.f.4 <- all(asterisk.f.4)
  check.asterisk.f.5 <- all(asterisk.f.5)
  check.names <- identical(names, holiday_types) #  Kanton, Schule, and 5 holiday types
  check.cols <- cols == 7 # Kanton, Schule, and 5 holiday types

  actual <- c(check.asterisk.canton,
              check.asterisk.school,
              check.asterisk.f.1,
              check.asterisk.f.2,
              check.asterisk.f.3,
              check.asterisk.f.4,
              check.asterisk.f.5,
              check.names,
              check.cols)
  should <- c(TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE)
  result <- identical(actual, should)

  expect_equal(TRUE, result)
})
