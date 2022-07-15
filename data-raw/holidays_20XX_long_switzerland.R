## code to prepare `holidays_20XX_long_switzerland` dataset goes here


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


# Add column and reorder columns
df.1 <- df.0
df.1["Land"] <- "Schweiz"
col_order <- c("Land",
               "Kanton",
               "Schule",
               "Grossregion",
               "Datum",
               "Tag",
               "Monat",
               "Jahr",
               "Jahreszeit",
               "Wochentag",
               "Ferientag",
               "Wochenende",
               "Freier.Tag")
df.1 <- df.1[, col_order]


# Aggregate data
df.2 <- df.1 %>%
  group_by(Land, Datum, Tag, Monat, Jahr, Jahreszeit, Wochentag) %>%
  summarise(Ferientag = sum(Ferientag),
            Wochenende = sum(Wochenende),
            Freier.Tag = sum(Freier.Tag))


# Convert grouped_df to df
df.2 <- as.data.frame(df.2)


# Visual check
df.plot <- df.2

plot <- ggplot(df.plot, aes(x=Datum, y=Freier.Tag)) +
  geom_line() +
  xlab("")
plot


# Store dataset
# Adds 'R' to Depends field in DESCRIPTION
# Saving dataset to 'data/...rda'
holidays_2020_long_switzerland <- df.2[df.2$Jahr == 2020,]
holidays_2021_long_switzerland <- df.2[df.2$Jahr == 2021,]
holidays_2022_long_switzerland <- df.2[df.2$Jahr == 2022,]
holidays_2023_long_switzerland <- df.2[df.2$Jahr == 2023,]
holidays_2024_long_switzerland <- df.2[df.2$Jahr == 2024,]
holidays_2025_long_switzerland <- df.2[df.2$Jahr == 2025,]
holidays_2020_to_2025_long_switzerland <- df.2

usethis::use_data(holidays_2020_long_switzerland,
                  holidays_2021_long_switzerland,
                  holidays_2022_long_switzerland,
                  holidays_2023_long_switzerland,
                  holidays_2024_long_switzerland,
                  holidays_2025_long_switzerland,
                  holidays_2020_to_2025_long_switzerland)


# Inspect data
# Load it into global environment
data("holidays_2020_long_switzerland")


