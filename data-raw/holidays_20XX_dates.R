
# Set working directory
#setwd("...")



# Install package
library(devtools)
install() # Note that you have to be in the /R directory of the package to install it
library(holidays)



# Setup dataset blueprint
# Don't change the year. We use 2020 as blueprint.
year <- 2020
html <- fetch_html_element(year)
df_raw_2020 <- html_to_df(html)
holidays_2020_dates <- clean_df(df_raw_2020)
df.blueprint <- subset(holidays_2019_dates, select=c(1:2))



# Build datasets
year <- 2019
html <- fetch_html_element(year)
df_raw_2019 <- html_to_df(html)
holidays_2019_dates <- clean_df(df_raw_2019)
holidays_2019_dates <- merge(x=df.blueprint,
                             y=holidays_2019_dates,
                             by=c("Kanton", "Schule"),
                             all.x=TRUE) # Left outer join
holidays_2019_dates[is.na(holidays_2019_dates)] <- "-" # Replace NA with '-'

year <- 2020
html <- fetch_html_element(year)
df_raw_2020 <- html_to_df(html)
holidays_2020_dates <- clean_df(df_raw_2020)
holidays_2020_dates <- merge(x=df.blueprint,
                             y=holidays_2020_dates,
                             by=c("Kanton", "Schule"),
                             all.x=TRUE) # Left outer join
holidays_2020_dates[is.na(holidays_2020_dates)] <- "-" # Replace NA with '-'

year <- 2021
html <- fetch_html_element(year)
df_raw_2021 <- html_to_df(html)
holidays_2021_dates <- clean_df(df_raw_2021)
holidays_2021_dates <- merge(x=df.blueprint,
                             y=holidays_2021_dates,
                             by=c("Kanton", "Schule"),
                             all.x=TRUE) # Left outer join
holidays_2021_dates[is.na(holidays_2021_dates)] <- "-" # Replace NA with '-'

year <- 2022
html <- fetch_html_element(year)
df_raw_2022 <- html_to_df(html)
holidays_2022_dates <- clean_df(df_raw_2022)
holidays_2022_dates <- merge(x=df.blueprint,
                             y=holidays_2022_dates,
                             by=c("Kanton", "Schule"),
                             all.x=TRUE) # Left outer join
holidays_2022_dates[is.na(holidays_2022_dates)] <- "-" # Replace NA with '-'

year <- 2023
html <- fetch_html_element(year)
df_raw_2023 <- html_to_df(html)
holidays_2023_dates <- clean_df(df_raw_2023)
holidays_2023_dates <- merge(x=df.blueprint,
                             y=holidays_2023_dates,
                             by=c("Kanton", "Schule"),
                             all.x=TRUE) # Left outer join
holidays_2023_dates[is.na(holidays_2023_dates)] <- "-" # Replace NA with '-'

year <- 2024
html <- fetch_html_element(year)
df_raw_2024 <- html_to_df(html)
holidays_2024_dates <- clean_df(df_raw_2024)
holidays_2024_dates <- merge(x=df.blueprint,
                             y=holidays_2024_dates,
                             by=c("Kanton", "Schule"),
                             all.x=TRUE) # Left outer join
holidays_2024_dates[is.na(holidays_2024_dates)] <- "-" # Replace NA with '-'

year <- 2025
html <- fetch_html_element(year)
df_raw_2025 <- html_to_df(html)
holidays_2025_dates <- clean_df(df_raw_2025)
holidays_2025_dates <- merge(x=df.blueprint,
                             y=holidays_2025_dates,
                             by=c("Kanton", "Schule"),
                             all.x=TRUE) # Left outer join
holidays_2025_dates[is.na(holidays_2025_dates)] <- "-" # Replace NA with '-'


# Store clean datasets
# Adds 'R' to Depends field in DESCRIPTION
# Saving df_clean_... to 'data/df_clean_....rda'
usethis::use_data(holidays_2019_dates,
                  holidays_2020_dates,
                  holidays_2021_dates,
                  holidays_2022_dates,
                  holidays_2023_dates,
                  holidays_2024_dates,
                  holidays_2025_dates)


# Inspect data
# Load it into global environment
data("holidays_2020_dates")
