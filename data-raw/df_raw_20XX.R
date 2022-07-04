## code to prepare `df_raw_20XX` dataset goes here


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


# Store raw datasets in R/sysdata.rda
# This is the best place to put data that your functions need.
# While not accessible to users.
setwd("C:/Users/Gabriel/Desktop/MScThesis/package/holidays/data-raw") # Set storage location
save(df_raw_2020, file="holidays_2020_raw.rda")
save(df_raw_2021, file="holidays_2021_raw.rda")
save(df_raw_2022, file="holidays_2022_raw.rda")
save(df_raw_2023, file="holidays_2023_raw.rda")
save(df_raw_2024, file="holidays_2024_raw.rda")
save(df_raw_2025, file="holidays_2025_raw.rda")


