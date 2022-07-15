## code to prepare `holidays_20XX_long_major_regions` dataset goes here


# Set working directory
#setwd("...")


# Import other package
# Adds 'PACKAGENAME' to Imports field in DESCRIPTION
#use_package("dplyr")
#use_package("ggplot2")


# Install packages
library(devtools)
library(dplyr)
library(ggplot2)
#install() # Note that you have to be in the /R directory of the package to install it
library(holidays)


# Load holidays functions
load_all()
document()
rm(list=ls(all=TRUE))


data("holidays_2020_dates")
#data("holidays_2025_dates")




# Load preprocessed datasets
# Note that the working directory must be set to /holidays
df.0 <- data(holidays_2020_to_2025_long)
df.0 <- get(df.0) # Fetch dataset


# Inspect dataset
str(df.0)


# Aggregate data
df.1 <- df.0 %>%
          group_by(Grossregion, Datum, Tag, Monat, Jahr, Jahreszeit, Wochentag) %>%
          summarise(Ferientag = sum(Ferientag),
                    Wochenende = sum(Wochenende),
                    Freier.Tag = sum(Freier.Tag))


# Convert grouped_df to df
df.1 <- as.data.frame(df.1)


# Visual check
lvls <- levels(as.factor(df.1$Grossregion))
lvls

df.plot <- df.1[df.1$Grossregion == lvls[6],]

plot <- ggplot(df.plot, aes(x=Datum, y=Freier.Tag)) +
  geom_line() +
  xlab("")
plot


# Store dataset
# Adds 'R' to Depends field in DESCRIPTION
# Saving dataset to 'data/...rda'
holidays_2020_long_major_regions <- df.1[df.1$Jahr == 2020,]
holidays_2021_long_major_regions <- df.1[df.1$Jahr == 2021,]
holidays_2022_long_major_regions <- df.1[df.1$Jahr == 2022,]
holidays_2023_long_major_regions <- df.1[df.1$Jahr == 2023,]
holidays_2024_long_major_regions <- df.1[df.1$Jahr == 2024,]
holidays_2025_long_major_regions <- df.1[df.1$Jahr == 2025,]
holidays_2020_to_2025_long_major_regions <- df.1

usethis::use_data(holidays_2020_long_major_regions,
                  holidays_2021_long_major_regions,
                  holidays_2022_long_major_regions,
                  holidays_2023_long_major_regions,
                  holidays_2024_long_major_regions,
                  holidays_2025_long_major_regions,
                  holidays_2020_to_2025_long_major_regions)


# Inspect data
# Load it into global environment
data("holidays_2020_long_major_regions")
data("holidays_2021_long_major_regions")
data("holidays_2022_long_major_regions")
data("holidays_2023_long_major_regions")
data("holidays_2024_long_major_regions")
data("holidays_2025_long_major_regions")
data("holidays_2020_to_2025_long_major_regions")


