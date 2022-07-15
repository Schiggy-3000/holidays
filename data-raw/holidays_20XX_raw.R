## code to prepare `holidays_20XX_raw.rda` dataset goes here


# Install package
library(devtools)
install() # Note that you have to be in the /R directory of the package to install it
library(holidays)


# Build datasets
year <- 2020
html <- fetch_html_element(year)
df_raw_2020 <- html_to_df(html)

year <- 2021
html <- fetch_html_element(year)
df_raw_2021 <- html_to_df(html)

year <- 2022
html <- fetch_html_element(year)
df_raw_2022 <- html_to_df(html)

year <- 2023
html <- fetch_html_element(year)
df_raw_2023 <- html_to_df(html)

year <- 2024
html <- fetch_html_element(year)
df_raw_2024 <- html_to_df(html)

year <- 2025
html <- fetch_html_element(year)
df_raw_2025 <- html_to_df(html)


# Store raw datasets in /data-raw
# This is the best place to put data that your functions need.
# While not accessible to users.
#setwd("...") # Set storage location
save(df_raw_2020, file="holidays_2020_raw.rda")
save(df_raw_2021, file="holidays_2021_raw.rda")
save(df_raw_2022, file="holidays_2022_raw.rda")
save(df_raw_2023, file="holidays_2023_raw.rda")
save(df_raw_2024, file="holidays_2024_raw.rda")
save(df_raw_2025, file="holidays_2025_raw.rda")


