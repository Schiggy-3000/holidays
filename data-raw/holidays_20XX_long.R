## code to prepare `holidays_20XX_long` dataset goes here

# Setup
setwd("C:/Users/Gabriel/Desktop/MScThesis/package/holidays")


# Install packages
library(devtools)
install() # Note that you have to be in the /R directory of the package to install it
library(holidays)


# Load holidays functions
load_all()
document()


# Load preprocessed datasets
# Note that the working directory must be set to /holidays
load(file="./data-raw/holidays_2020_dates_as_strings.rda")
df <- holidays_2020_dates_as_strings
n_rows <- dim(df)[1]
n_cols <- dim(df)[2]


# Setup new data frame
df_new <- subset(df, select=c(1:2))
df_new["Ferien"] <- NA


# Merge all 'Ferienxxx' columns into one column 'Ferien'
# "Sportferien", "Frühlingsferien", Sommerferien", "Herbstferien", "Wheinachtsferien" -> "Ferien
for (row in 1:n_rows) {

  date_string <- ""

  for (col in 3:n_cols) {

    date_string <- paste(date_string, df[row,col], sep=", ")

  }


  # Remove leading ", "
  date_string_new <- str_replace_all(date_string, "^, ", "")


  # Write date_string to df_new cell
  df_new[row,3] <- date_string_new

}


# THIS WORKS SOMEHOW
ds <- df_new[1,3]
ls <- str_split(ds, ", ")
ls[[1]][2] # Access individual elements of list






