
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
library(lubridate)
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
               "Ferientag",
               "Ferientyp",
               "Wochentag",
               "Wochenende")
df.1 <- df.1[, col_order]


# Aggregate data
df.2 <- df.1 %>%
  group_by(Land, Datum, Tag, Monat, Jahr, Jahreszeit, Wochentag) %>%
  summarise(Ferientag = sum(Ferientag),
            Wochenende = sum(Wochenende),
            Ferientyp = max(Ferientyp)) # max("-", "Sommerferien") yields "Sommerferien"


# Convert grouped_df to df
df.2 <- as.data.frame(df.2)


# Checks after mutation

# Check for duplicates
# For this, compare number of unique rows to total number of rows
check.1 <- nrow(unique(df.2)) == nrow(df.2)

# Check if there are NAs
check.2 <- nrow(df.2[is.na(df.2),]) == 0

# Check if there is 1 Land
check.3 <- length(levels(as.factor(df.2$Land))) == 1

# Check if the number of rows is correct
# Every date from 2019-01-01 ... 2026-01-01 should come up exactly once
start_date <- date("2019-01-01") # Convert to date
end_date <- date("2026-01-01") # Convert to date
days_total <- as.integer(difftime(end_date, start_date, units="days")) # Calculates the number of dates between dates
check.4 <- nrow(df.2) == days_total

# Check if only 0 or 36 come up in 'Wochenende'
wochenend_values_ist <- unique(df.2$Wochenende)
wochenend_values_soll <- c(0, 36)
check.5 <- identical(wochenend_values_ist, wochenend_values_soll)


# Visual check

# Plot different Jahr/Monat combinations to check the data
df.plot <- df.2[df.2$Jahr == 2020 & df.1$Monat == "01",]
plot <- ggplot(df.plot, aes(x=Datum, y=Wochenende)) +
  geom_line() +
  scale_x_date(date_breaks = "days") +
  scale_y_continuous(breaks=c(6, 16, 26, 36, 46)) +
  theme(axis.text.x = element_text(angle=90, vjust=0.5, hjust=1)) +
  xlab("")
plot


# Check variable types
str(df.2)


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


