## code to prepare `holidays_20XX_dates_as_strings` dataset goes here


# Set working directory
#setwd("...")


# Install packages
library(devtools)
install() # Note that you have to be in the /R directory of the package to install it
library(holidays)


# Load datasets
data("holidays_2020_dates")
data("holidays_2021_dates")
data("holidays_2022_dates")
data("holidays_2023_dates")
data("holidays_2024_dates")
data("holidays_2025_dates")


# Build dataset
# You have to change the year (e.g. 2020) in 4 locations to build
# A dataset for another year. They are market with 'YEAR'
year <- 2020 # YEAR
df <- holidays_2020_dates # YEAR
n_rows <- dim(df)[1]
n_cols <- dim(df)[2]


# Iterate over columns
for (col in 3:n_cols) {

  # Iterate over rows
  for (row in 1:n_rows) {

    current_cell <- df[row,col]
    dates <- date_range_to_dates(cell=current_cell, year=year)
    df[row,col] <- dates

  }

}


# Store dataset
setwd("./data-raw") # Set storage location
holidays_2020_dates_as_strings <- df # YEAR
file_name <- paste("holidays_", year, "_dates_as_strings.rda", sep="")
save(holidays_2020_dates_as_strings, file=file_name) # YEAR


