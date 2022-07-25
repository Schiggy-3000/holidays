
# Set working directory
#setwd("...")
rm(list=ls(all=TRUE))



# Import other package
# Adds 'PACKAGENAME' to Imports field in DESCRIPTION
#use_package("dplyr")
#use_package("lubridate")
#use_package("tidyr")



# Install packages
library(devtools)
library(dplyr)
library(lubridate)
library(tidyr)
#install() # Note that you have to be in the /R directory of the package to install it
#library(holidays)



# Load preprocessed datasets
# Note that the working directory must be set to /holidays
df.2019 <- get(load("./data-raw/holidays_2019_dates_as_strings.rda"))
df.2020 <- get(load("./data-raw/holidays_2020_dates_as_strings.rda"))
df.2021 <- get(load("./data-raw/holidays_2021_dates_as_strings.rda"))
df.2022 <- get(load("./data-raw/holidays_2022_dates_as_strings.rda"))
df.2023 <- get(load("./data-raw/holidays_2023_dates_as_strings.rda"))
df.2024 <- get(load("./data-raw/holidays_2024_dates_as_strings.rda"))
df.2025 <- get(load("./data-raw/holidays_2025_dates_as_strings.rda"))


#### Step 1 ####
# Merge Xxxxxferien from all years into one column
# New df to merge Xxxxxferien (Skeleton)
df.1 <- data.frame()
df.1 <- subset(df.2020, select=c(1:2)) # Don't change this to another year. We use 2020 as blueprint.
df.1["Sportferien"]       <- NA
df.1["Fruehlingsfehrien"] <- NA
df.1["Sommerferien"]      <- NA
df.1["Herbstferien"]      <- NA
df.1["Weihnachtsferien"]  <- NA

# New df to merge Xxxxxferien (Values)
df.1.1 <- df.1
n_rows <- dim(df.1.1)[1]
n_cols <- dim(df.1.1)[2]

for (col in 3:n_cols) {

  for (row in 1:n_rows) {

    # Collect dates from Xxxxxferien in string
    date_string <- paste(df.2019[row, col],
                         df.2020[row, col],
                         df.2021[row, col],
                         df.2022[row, col],
                         df.2023[row, col],
                         df.2024[row, col],
                         df.2025[row, col],
                         sep=", ")

    # Replace NA with "-"
    date_string <- str_replace_all(date_string, "NA", "-")

    # Insert dates into df
    df.1.1[row, col] <- date_string

  }
}


#### Check 1.X ####
# Concatenate all dfs
df.check <- rbind(df.2019,
                  df.2020,
                  df.2021,
                  df.2022,
                  df.2023,
                  df.2024,
                  df.2025)

# Collect all Xxxxxferien dates in strings
before_sportferien       <- toString(df.check[,3])
before_fruehlingsferien  <- toString(df.check[,4])
before_sommerferien      <- toString(df.check[,5])
before_herbstferien      <- toString(df.check[,6])
before_winterferien      <- toString(df.check[,7])

after_sportferien       <- toString(df.1.1[,3])
after_fruehlingsferien  <- toString(df.1.1[,4])
after_sommerferien      <- toString(df.1.1[,5])
after_herbstferien      <- toString(df.1.1[,6])
after_winterferien      <- toString(df.1.1[,7])

# Check if a given year occurs equally often
year <- "2019"
n_before <- length(str_match_all(before_sportferien, year)[[1]])
n_after <- length(str_match_all(after_sportferien, year)[[1]])
check.1.1 <- n_before == n_after

n_before <- length(str_match_all(before_fruehlingsferien, year)[[1]])
n_after <- length(str_match_all(after_fruehlingsferien, year)[[1]])
check.1.2 <- n_before == n_after

n_before <- length(str_match_all(before_sommerferien, year)[[1]])
n_after <- length(str_match_all(after_sommerferien, year)[[1]])
check.1.3 <- n_before == n_after

n_before <- length(str_match_all(before_herbstferien, year)[[1]])
n_after <- length(str_match_all(after_herbstferien, year)[[1]])
check.1.4 <- n_before == n_after

n_before <- length(str_match_all(before_winterferien, year)[[1]])
n_after <- length(str_match_all(after_winterferien, year)[[1]])
check.1.5 <- n_before == n_after



#### Step 2 ####
# Distribute dates to their own row
# New df (Skeleton)
df.2 <- data.frame(Kanton=character(),
                   Schule=character(),
                   Datum=character(),
                   Ferientyp=character(),
                   stringsAsFactors=FALSE)

n_rows <- dim(df.1.1)[1]
n_cols <- dim(df.1.1)[2]

for (col in 3:n_cols) {

  ferientyp <- colnames(df.1.1)[col]

  for (row in 1:n_rows) {

    kanton <- df.1.1[row, 1]
    schule <- df.1.1[row, 2]
    dates <- str_split(df.1.1[row, col], ",")

    for (d in 1:length(dates[[1]])) {

      # Remove leading & trailing spaces from date
      date <- trimws(dates[[1]][d], which=c("both"))

      # Add row to df
      df.2[nrow(df.2)+1,] <- c(kanton, schule, date, ferientyp)

    }
  }
}


#### Check 2.X ####
# Check if the no. of holidays in a given holiday (e.g. Sportferien) stayed the same

# Concatenate holidays from 'Xxxxxferien' (e.g. Sportferien)
ferien <- "Sportferien"
n_rows <- dim(df.1.1)[1]
n_cols <- dim(df.1.1)[2]
tage <- ""

for (row in 1:n_rows) {

  tage <- paste(tage, df.1.1[row, ferien], sep=", ")

}

# Trim leading ', '
first <- 2
last <- nchar(tage)
tage <- substr(tage, start=first, stop=last)

# Count number of dates (in string) before
tage_before <- length(str_split(tage, ", ")[[1]])

# Count number of dates (rows) after
tage_after <- nrow(df.2[df.2$Ferientyp == ferien,])

# Check if the no. of holidays stayed the same
check.2.1 <- tage_before == tage_after



# Check if the no. of holidays in a given holiday (e.g. Sportferien)
# for a 'Kanton' + 'Schule' stayed the same

ferien <- "Sommerferien"
kanton <- "Obwalden"
schule <- "Volksschule"

# Select row with 'Kanton' + 'Schule' combination
df.check <- df.1.1[df.1.1$Kanton == kanton & df.1.1$Schule == schule,]
tage <- df.check[1, ferien]

# Count number of dates (in string) before
tage_before <- length(str_split(tage, ", ")[[1]])

# Count number of dates (rows) after
tage_after <- nrow(df.2[df.2$Kanton == kanton & df.2$Schule == schule &df.2$Ferientyp == ferien,])

# Check if the no. of holidays stayed the same
check.2.2 <- tage_before == tage_after



#### Step 3 ####
# Drop "-" entries
df.3 <- df.2[df.2$Datum != "-",]


#### Check 3.X ####
# Check if correct number of missing values were dropped
rows_removed <- nrow(df.2[df.2$Datum == "-",])
rows_before <- nrow(df.2)
rows_after <- nrow(df.3)
check.3.1 <- rows_after == rows_before - rows_removed



#### Step 4 ####

# Setup helper df
# Add a column to all 'Kanton' + 'Schule' combination with all dates from 2019-01-01 ... 2025-12-31
# Before: Aargau, Alle Schulen
# After: Aargau, Alle Schulen, "2020-01-01, 2020-01-02, ..., 2020-12-31"
df.4 <- subset(df.1, select=c(1:2))
dates <- vector(mode="character") # Initialize vector
years <- c(2019, 2020, 2021, 2022, 2023, 2024, 2025)

start_date <- paste(years[1], "-01-01", sep="") # Set start date of the year: 2020-01-01
start_date <- date(start_date) # Convert to date
end_date <- paste(years[length(years)]+1, "-01-01", sep="") # Set end date: 2021-01-01
end_date <- date(end_date) # Convert to date

temp <- start_date
repeat{

  # Add dates to vector
  dates <- append(dates, toString(temp)) # temp as string since it would be converted to milliseconds otherwise
  temp <- temp + days(1) # Add 1 day to date

  # Break loop when start_date (=temp) is larger than end_date
  if(temp == end_date){
    break
  }
}

df.4["Datum"] <- toString(dates)


#### Check 4.X ####
# Check if correct number of dates were added

days_added <- length(dates) # Number of dates that were added
days_total <- as.integer(difftime(end_date, start_date, units="days")) # Calculates the number of dates between dates
check.4.1 <- days_added == days_total



#### Step 5 ####

# Setup helper df
# Distribute dates to their own row
# Before: Aargau, Alle Schulen, "2019-01-01, 2020-01-02, ..., 2025-12-31"
# After: Aargau, Alle Schulen, "2019-01-01"
n_rows <- dim(df.4)[1]
n_cols <- dim(df.4)[2]
df.5 <- data.frame()

for (row in 1:n_rows) {

  Kanton <- df.4[row,1]
  Schule <- df.4[row,2]
  Datum <- str_split(df.4[row,3], ",")

  for (d in 1:length(Datum[[1]])) {

    Tag <- Datum[[1]][d]
    Tag <- trimws(Tag, which=c("both")) # Remove leading & trailing spaces

    new_row <- data.frame(Kanton=Kanton,
                          Schule=Schule,
                          Datum=Tag)

    df.5 <- rbind(df.5, new_row)

  }
}


#### Check 5.X ####
# Check whether dates were distributed to their own cell correctly
# by counting the number of rows
rows_expected <- nrow(df.4) * days_total
rows_actual <- nrow(df.5)
check.5.1 <- rows_expected == rows_actual



#### Step 6 ####

# Setup helper df
# Join df.3 and df.5
# df.3: Kanton, Schule, Datum, Ferientyp
# df.5: Kanton, Schule, Datum
# df.6: Kanton, Schule, Datum, Ferientyp, Ferientag

# The resulting data frame contains 5 columns whereas...
# ... the third column contains dates
# ... the fourth column contains the type of holidays (e.g. 'Sommerferien')
# ... the fifth column contains a '1' if the date is a school holiday

# Add a new column filled with '1'
df.3.1 <- df.3
df.3.1["Ferientag"] <- 1

# Left outer join
df.6 <- merge(x=df.5, y=df.3.1, by=c("Kanton", "Schule", "Datum"), all.x=TRUE)

# Replace NA is column 'Ferientag' with 0 and with '-' in column 'Ferientyp'
df.6 <- df.6 %>% replace_na(list(Ferientag=0, Ferientyp="-"))


#### Check 6.X ####

# Check whether all holiday were carried over properly
# Number of holidays in 2026
indexe <- with(df.3.1, grepl("2026", Datum)) # Find all rows that contain '2026' in 'Datum' column
ferientage_2026 <- nrow(df.3.1[indexe,])

# Number of holidays before and after mutation
ferientage_before <- nrow(df.3)
ferientage_after <- nrow(df.6[df.6$Ferientag == 1,])

# We don't carry days from 2026 over into our df
# Therefore we have to account for them
check.6.1 <- ferientage_before == ferientage_after + ferientage_2026

# Since we left outer join, the number of rows has to still be the same
check.6.2 <- nrow(df.6) == nrow(df.5)



#### Step 7 ####

# Add supplementary data
# 'Wochentag', 'Wochenende', 'Jahreszeit'
df.8 <- df.6
df.8["Wochentag"] <- NA
df.8["Wochenende"] <- NA

n_rows <- dim(df.8)[1]
n_cols <- dim(df.8)[2]

for (row in 1:n_rows) {

  date <- df.8[row, "Datum"]
  weekday <- wday(date)

  day <- case_when(weekday == 1 ~ "Sonntag",
                   weekday == 2 ~ "Montag",
                   weekday == 3 ~ "Dienstag",
                   weekday == 4 ~ "Mittwoch",
                   weekday == 5 ~ "Donnerstag",
                   weekday == 6 ~ "Freitag",
                   weekday == 7 ~ "Samstag"
  )

  df.8[row, "Wochentag"] <- day


  if (weekday == 1 || weekday == 7) {

    df.8[row, "Wochenende"] <- 1

  } else {

    df.8[row, "Wochenende"] <- 0

  }
}


# Add 'Jahreszeit'
df.8.1 <- df.8
df.8.1["Jahreszeit"] <- NA

n_rows <- dim(df.8.1)[1]
n_cols <- dim(df.8.1)[2]

for (row in 1:n_rows) {

  day <- as_date(df.8.1[row, "Datum"])
  a <- as_date(paste(year(day), "03", "20", sep="-"))
  b <- as_date(paste(year(day), "06", "21", sep="-"))
  c <- as_date(paste(year(day), "09", "22", sep="-"))
  d <- as_date(paste(year(day), "12", "21", sep="-"))
  e <- as_date(paste(year(day), "12", "31", sep="-"))


  if (day < a) {

    df.8.1[row, "Jahreszeit"] <- "Winter" # 1. Jan - 19. Mar

  } else if (day < b) {

    df.8.1[row, "Jahreszeit"] <- "Frühling" # 20. Mar - 20. Juni

  } else if (day < c) {

    df.8.1[row, "Jahreszeit"] <- "Sommer" # 21. Juni - 21. Sep

  } else if (day < d) {

    df.8.1[row, "Jahreszeit"] <- "Herbst" # 22. Sep - 20. Dez

  } else if (day <= e){

    df.8.1[row, "Jahreszeit"] <- "Winter" # 21. Dez - 31. Dez

  } else {

    print(NA) # In case the year does not match

  }

}


#### Check 7.X ####

# The ratio of weekends to weekday should be 2:5 which is 0.4
check.7.1 <- round(dim(df.8[df.8$Wochenend == 1,])[1] / dim(df.8[df.8$Wochenend == 0,])[1], digits=1) == 0.4

# Check if there is any 'Jahreszeit' that has no season assigned to it
check.7.2 <- nrow(df.8.1[is.na(df.8.1$Jahreszeit),]) == 0



#### Step 8 ####

# Distribute date column
# Before: '2020-01-01'
# After: '2020-01-01', '01', 'Januar', '2020'
df.9 <- df.8.1
df.9["Tag"]   <- NA
df.9["Monat"] <- NA
df.9["Jahr"]  <- NA

n_rows <- dim(df.9)[1]
n_cols <- dim(df.9)[2]

for (row in 1:n_rows) {

  # Split column value at '-'
  # This  yields 'Tag', 'Monat' und 'Jahr' seperately
  atoms <- str_split(df.9[row,3], "-")

  df.9[row,"Tag"] <- atoms[[1]][3]
  df.9[row,"Monat"] <- atoms[[1]][2]
  df.9[row,"Jahr"] <- atoms[[1]][1]

}

# Drop redundant column, reorder column
col_order <- c("Kanton",
               "Schule",
               "Datum",
               "Tag",
               "Monat",
               "Jahr",
               "Jahreszeit",
               "Ferientag",
               "Ferientyp",
               "Wochentag",
               "Wochenende")
df.9.1 <- df.9[, col_order]


#### Check 8.X ####

# No checks here



#### Step 9 ####

# Add major regions (e.g. Zentralschweiz, Ostschweiz, ...)
df.10 <- df.9.1
df.10["Grossregion"] <- NA

n_rows <- dim(df.10)[1]
n_cols <- dim(df.10)[2]

for (row in 1:n_rows) {

  Kanton <- df.10[row, "Kanton"]

  region <- case_when(Kanton == "Aargau" ~ "Zentralschweiz",
                      Kanton == "Appenzell Ausserrhoden" ~ "Ostschweiz",
                      Kanton == "Appenzell Innerrhoden" ~ "Ostschweiz",
                      Kanton == "Basel-Land" ~ "Nordwestschweiz",
                      Kanton == "Basel-Stadt" ~ "Nordwestschweiz",
                      Kanton == "Bern" ~ "Mittelland",
                      Kanton == "Freiburg" ~ "Mittelland",
                      Kanton == "Genf" ~ "Genferseeregion",
                      Kanton == "Glarus" ~ "Ostschweiz",
                      Kanton == "Graubünden" ~ "Ostschweiz",
                      Kanton == "Jura" ~ "Mittelland",
                      Kanton == "Luzern" ~ "Zentralschweiz",
                      Kanton == "Neuenburg" ~ "Mittelland",
                      Kanton == "Nidwalden" ~ "Zentralschweiz",
                      Kanton == "Obwalden" ~ "Zentralschweiz",
                      Kanton == "Sankt Gallen" ~ "Ostschweiz",
                      Kanton == "Schaffhausen" ~ "Ostschweiz",
                      Kanton == "Schwyz" ~ "Zentralschweiz",
                      Kanton == "Solothurn" ~ "Mittelland",
                      Kanton == "Tessin" ~ "Tessin",
                      Kanton == "Thurgau" ~ "Ostschweiz",
                      Kanton == "Uri" ~ "Zentralschweiz",
                      Kanton == "Waadt" ~ "Genferseeregion",
                      Kanton == "Wallis" ~ "Genferseeregion",
                      Kanton == "Zürich" ~ "Zürich",
                      Kanton == "Zug" ~ "Zentralschweiz"
  )

  df.10[row, "Grossregion"] <- region

}

# Reorder column
col_order <- c("Kanton",
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
df.10.1 <- df.10[, col_order]


#### Check 9.X ####

# Check if there is any 'Kanton' that has no 'Grossregion' assigned to it
check.9 <- nrow(df.10.1[is.na(df.10.1$Grossregion),]) == 0



#### Step 10 ####

# Convert columns to correct format
df.12 <- df.10.1

n_rows <- dim(df.12)[1]
n_cols <- dim(df.12)[2]

for (row in 1:n_rows) {

  # Convert 'Datum' from string to date
  date_iso <- as_date(df.12[,"Datum"])
  df.12$`Datum` <- date_iso

  # Convert 'Ferientag' from string to int
  num <- as.numeric(df.12[,"Ferientag"])
  df.12$Ferientag <- num

  # Convert 'Wochenende' from string to int
  num <- as.numeric(df.12[,"Wochenende"])
  df.12$Wochenende <- num

}


#### Check 10.X ####

# Inspect column formats
str(df.12)



#### Store dataset ####
# Adds 'R' to Depends field in DESCRIPTION
# Saving dataset to 'data/...rda'
holidays_2020_long <- df.12[df.12$Jahr == 2020,]
holidays_2021_long <- df.12[df.12$Jahr == 2021,]
holidays_2022_long <- df.12[df.12$Jahr == 2022,]
holidays_2023_long <- df.12[df.12$Jahr == 2023,]
holidays_2024_long <- df.12[df.12$Jahr == 2024,]
holidays_2025_long <- df.12[df.12$Jahr == 2025,]
holidays_2020_to_2025_long <- df.12

usethis::use_data(holidays_2020_long,
                  holidays_2021_long,
                  holidays_2022_long,
                  holidays_2023_long,
                  holidays_2024_long,
                  holidays_2025_long,
                  holidays_2020_to_2025_long)


# Inspect data
# Load it into global environment
data("holidays_2020_long")
data("holidays_2021_long")
data("holidays_2022_long")
data("holidays_2023_long")
data("holidays_2024_long")
data("holidays_2025_long")
data("holidays_2020_to_2025_long")


