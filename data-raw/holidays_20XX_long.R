## code to prepare `holidays_20XX_long` dataset goes here


# Set working directory
#setwd("...")


# Import other package
# Adds 'PACKAGENAME' to Imports field in DESCRIPTION
#use_package("dplyr")


# Install packages
library(devtools)
library(dplyr)
#install() # Note that you have to be in the /R directory of the package to install it
library(holidays)


# Load holidays functions
load_all()
document()
rm(list=ls(all=TRUE))
#data("holidays_2020_dates")
#data("holidays_2025_dates")


# Load preprocessed datasets
# Note that the working directory must be set to /holidays
years <- c(2020, 2021, 2022, 2023, 2024, 2025)
file_name <- "./data-raw/holidays_2020_dates_as_strings.rda" # Don't change this to another year. We use 2020 as blueprint.
df <- load(file=file_name) # Store dataset name
df <- get(df) # Fetch dataset

# Setup new data frame
df.1 <- data.frame()
df.1 <- subset(df, select=c(1:2))

for (n in 1:length(years)) {

  file_name <- paste("./data-raw/holidays_", years[n], "_dates_as_strings.rda", sep="")
  df.0 <- load(file=file_name) # Store dataset name
  df.0 <- get(df.0) # Fetch dataset

  n_rows <- dim(df.0)[1]
  n_cols <- dim(df.0)[2]

  df.1[toString(years[n])] <- NA

  # Merge all 'Ferienxxx' columns into one column '20XX'
  for (row in 1:n_rows) {

    # Find row (=index) in df.1 where we have to insert values later
    Kanton <- df.0[row,1]
    Schule <- df.0[row,2]
    index <- which(df.1[,1] == Kanton & df.1[,2] == Schule)

    date_string <- ""

    for (col in 3:n_cols) {

      date_string <- paste(date_string, df.0[row,col], sep=", ")

    }

    # Remove leading ", "
    date_string_new <- str_replace_all(date_string, "^, ", "")

    # Write date_string to new df cell
    df.1[index,toString(years[n])] <- date_string_new

  }
}


# Replace NA with "-"
df.1.1 <- df.1
df.1.1[is.na(df.1.1)] <- "-"


# Setup new data frame
df.2 <- subset(df.1.1, select=c(1:2))
df.2["Tage"] <- NA

n_rows <- dim(df.1.1)[1]
n_cols <- dim(df.1.1)[2]

# Merge all '20XX' columns into one column 'Tage'
for (row in 1:n_rows) {

  date_string <- ""

  for (col in 3:n_cols) {

    date_string <- paste(date_string, df.1.1[row,col], sep=", ")

  }

  # Remove leading ", "
  date_string_new <- str_replace_all(date_string, "^, ", "")

  # Write date_string to new df cell
  df.2[row,3] <- date_string_new

}


# Create own row for each date in 'Tage' cell
df.3 <- data.frame()
for (row in 1:n_rows) {

  Kanton <- df.2[row,1]
  Schule <- df.2[row,2]
  Datum <- str_split(df.2[row,3], ",")

  for (d in 1:length(Datum[[1]])) {

    Holiday <- Datum[[1]][d]
    Holiday <- trimws(Holiday, which=c("both")) # Remove leading & trailing spaces

    new_row <- data.frame(Kanton=Kanton,
                          Schule=Schule,
                          Tag=Holiday)

    df.3 <- rbind(df.3, new_row)

  }
}


# Drop "-" entries
df.4 <- df.3[df.3$Tag != "-",]
check.1 <- df.3[df.3$Tag == "-",] # Check how many "-" there are
check.2 <- df.3[df.4$Tag == "-",] # Check whether all "-" were removed


# Setup new data frame (Helper data frame)
# Before: Aargau, Alle Schulen
# After: Aargau, Alle Schulen, "2020-01-01, 2020-01-02, ..., 2020-12-31"
df.5 <- subset(df.1, select=c(1:2))
dates <- vector(mode="character") # Initialize vector


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

df.5["Tage"] <- toString(dates)


# Setup new data frame (Helper data frame)
# Before: Aargau, Alle Schulen, "2020-01-01, 2020-01-02, ..., 2020-12-31"
# After: Aargau, Alle Schulen, "2020-01-01"
n_rows <- dim(df.5)[1]
n_cols <- dim(df.5)[2]

# Create own row for each date in "Tage" cell
df.6 <- data.frame()

for (row in 1:n_rows) {

  Kanton <- df.5[row,1]
  Schule <- df.5[row,2]
  Datum <- str_split(df.5[row,3], ",")

  for (d in 1:length(Datum[[1]])) {

    Tag <- Datum[[1]][d]
    Tag <- trimws(Tag, which=c("both")) # Remove leading & trailing spaces

    new_row <- data.frame(Kanton=Kanton,
                          Schule=Schule,
                          Tag=Tag)

    df.6 <- rbind(df.6, new_row)

  }
}

check.3 <- df.6[df.6$Kanton == "Aargau",] # Check how many days there are for "Aargau" (365 or 366 * number of years)
check.4 <- df.6[df.6$Kanton == "Bern",] # Check how many days there are for "Aargau" (730 or 732 * number of years)


# Setup new data frame
# We join df.4 and df.6
# df.4: Kanton, Schule, Tag
# df.6: Kanton, Schule, Tag
# df.7: Kanton, Schule, Tag, Ferientag
# The resulting data frame contains 4 columns whereas...
# ... the third column contains dates
# ... the fourth column contains a '1' if the date is a school holiday

df.4.1 <- df.4
df.4.1["Ferientag"] <- 1 # Add a new column filled with '1'
df.7 <- merge(x=df.6, y=df.4.1, by=c("Kanton", "Schule", "Tag"), all.x=TRUE)
df.7[is.na(df.7)] <- 0  # Replace NA with 0


check.5 <- dim(df.6)[1] == dim(df.7)[1] # Since we left join the resulting df.7 can't be larger than df.6

# df.7 must contain less rows with 'Ferientag' == 1 than df.4.1
# This is given since df.4.1 contains school holidays from more than one year
# (Weihnachtsferien cross over to the next year)
# df.7 on the other hand disregards this carry over.
check.6 <- dim(df.7[df.7$Ferientag == 1,])[1] < dim(df.4.1)[1]

# We can verify that rows from df.4.1 were not carried over
# by examining the setdiff (check.7)
df_temp <- df.7[df.7$Ferientag == 1,]
check.7 <- df_only_4.1 <- setdiff(df.4.1, df_temp) # Only rows from year we did not include


# Add supplementary data
# 'Wochentag', 'Wochenende'
df.8 <- df.7
df.8["Wochentag"] <- NA
df.8["Wochenende"] <- NA

n_rows <- dim(df.8)[1]
n_cols <- dim(df.8)[2]

for (row in 1:n_rows) {

  date <- df.8[row, "Tag"]
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


# The ratio of weekends to weekday should be 2:5 which is 0.4
check.8 <- round(dim(df.8[df.8$Wochenend == 1,])[1] / dim(df.8[df.8$Wochenend == 0,])[1], digits=1)


# Add 'Jahreszeit'
df.8.1 <- df.8
df.8.1["Jahreszeit"] <- NA

n_rows <- dim(df.8.1)[1]
n_cols <- dim(df.8.1)[2]

for (row in 1:n_rows) {

  day <- as_date(df.8.1[row,3])
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


# Check if there is any 'Jahreszeit' that has no season assigned to it
check.9 <- df.8.1[is.na(df.8.1$Jahreszeit),]


# Distribute date column
# Before: '2020-01-01'
# After: '01', 'Januar', '2020'
df.9 <- df.8.1

names(df.9)[3] <- "Datum" # Rename column from 'Tag' to 'Datum'
df.9["Tag"] <- NA
df.9["Monat"] <- NA
df.9["Jahr"] <- NA

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
               "Wochentag",
               "Wochenende")
df.9 <- df.9[, col_order]


# Add major regions (e.g. Zentralschweiz, Ostschweiz, ...)
df.10 <- df.9
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


# Check if there is any 'Kanton' that has no 'Grossregion' assigned to it
check.10 <- df.10[is.na(df.10$Grossregion),]


# Add 'Freier Tag' (= Ferientag + Wochenende)
df.11 <- df.10
df.11["Freier.Tag"] <- NA

n_rows <- dim(df.11)[1]
n_cols <- dim(df.11)[2]

for (row in 1:n_rows) {

  Ferientag <- df.11[row,"Ferientag"]
  Wochenende <- df.11[row,"Wochenende"]

  if (Ferientag == 1 || Wochenende == 1) {

    df.11[row, "Freier.Tag"] <- 1

  } else {

    df.11[row, "Freier.Tag"] <- 0

  }
}


# Check if there are rows with NA values
check.11 <- dim(df.12[is.na(df.12),])[1] == 0


# Reorder column
col_order <- c("Kanton",
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
df.11 <- df.11[, col_order]


# Convert columns to correct format
df.12 <- df.11

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

  # Convert 'Freier Tag' from string to int
  num <- as.numeric(df.12[,"Freier.Tag"])
  df.12$Freier.Tag <- num

}


# Inspect column formats
str(df.12)


# Store dataset
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


