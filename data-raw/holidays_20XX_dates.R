## code to prepare `holidays_20XX_dates` dataset goes here


# Set working directory
#setwd("...")


# Install package
library(devtools)
install() # Note that you have to be in the /R directory of the package to install it
library(holidays)


# Build datasets
year <- 2020
html <- fetch_html_element(year)
df_raw_2020 <- html_to_df(html)
holidays_2020_dates <- clean_df(df_raw_2020)

year <- 2021
html <- fetch_html_element(year)
df_raw_2021 <- html_to_df(html)
holidays_2021_dates <- clean_df(df_raw_2021)

year <- 2022
html <- fetch_html_element(year)
df_raw_2022 <- html_to_df(html)
holidays_2022_dates <- clean_df(df_raw_2022)

year <- 2023
html <- fetch_html_element(year)
df_raw_2023 <- html_to_df(html)
holidays_2023_dates <- clean_df(df_raw_2023)

year <- 2024
html <- fetch_html_element(year)
df_raw_2024 <- html_to_df(html)
holidays_2024_dates <- clean_df(df_raw_2024)

year <- 2025
html <- fetch_html_element(year)
df_raw_2025 <- html_to_df(html)
holidays_2025_dates <- clean_df(df_raw_2025)


# Store clean datasets
# Adds 'R' to Depends field in DESCRIPTION
# Saving df_clean_... to 'data/df_clean_....rda'
usethis::use_data(holidays_2020_dates,
                  holidays_2021_dates,
                  holidays_2022_dates,
                  holidays_2023_dates,
                  holidays_2024_dates,
                  holidays_2025_dates)


# Inspect data
# Load it into global environment
data("holidays_as_dates_2020")
