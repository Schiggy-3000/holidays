
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
          summarise(Ferientag=sum(Ferientag),
                    Wochenende=sum(Wochenende),
                    Ferientyp=max(Ferientyp)) # max("-", "Sommerferien") yields "Sommerferien"

# Convert grouped_df to df
df.1 <- as.data.frame(df.1)


# Checks after mutation

# Check for duplicates
# For this, compare number of unique rows to total number of rows
check.1 <- nrow(unique(df.1)) == nrow(df.1)

# Check if there are NAs
check.2 <- nrow(df.1[is.na(df.1),]) == 0

# Check if there are 7 Grossregionen
check.3 <- length(levels(as.factor(df.1$Grossregion))) == 7

# Check if all 'Kanton' + 'Schule' combinations were distributed across Grossregionen
# For this, we count the number of 'Kanton' + 'Schule' combinations
# and compare this count to the sum of 'Kanton' + 'Schule' combinations of all Grossregionen
kanton_schule_combinations <- unique(df.0[, 1:2])
kanton_schule_combinations_pro_grossregion <- unique(df.0[, 1:3]) %>% count(Grossregion)
check.4 <- nrow(kanton_schule_combinations) == sum(kanton_schule_combinations_pro_grossregion$n)

# Check if counts in column 'Wochenende' are correct
temp <- unique(kanton_schule_combinations_pro_grossregion$n)
wochenende_counts_before <- sort(as.integer(append(temp, 0))) # Append 0. This comes up when there is no weekend
wochenende_counts_after <- sort(as.integer(unique(df.1$Wochenende)))
check.5 <- identical(wochenende_counts_before, wochenende_counts_after)



# Visual check

# See what Grossregionen are available and
# the number of 'Kanton' + 'Schule' combination per Grossregion
View(kanton_schule_combinations_pro_grossregion)

# Plot different Grossregion/Jahr/Monat combinations to check the data
df.plot <- df.1[df.1$Grossregion == "Nordwestschweiz" & df.1$Jahr == 2020 & df.1$Monat == "01",]
plot <- ggplot(df.plot, aes(x=Datum, y=Wochenende)) +
  geom_line() +
  scale_x_date(date_breaks = "days") +
  scale_y_continuous(breaks=c(0:12)) +
  theme(axis.text.x = element_text(angle=90, vjust=0.5, hjust=1)) +
  xlab("")
plot


# Check variable types
str(df.1)


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


