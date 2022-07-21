#' Reformats raw data frame into a clean data frame
#'
#' @param df A raw data frame.
#'
#' @return A clean data frame.
#' @import stringr
#'
#' @examples
#' year <- 2022
#' html <- fetch_html_element(year)
#' df_raw <- html_to_df(html)
#' df_clean <- clean_df(df_raw)
#' df_clean
#'
#'
#'
clean_df <- function(df) {

  # Setup
  n_rows <- dim(df)[1] # Number of rows
  n_cols <- dim(df)[2] # Number of columns

  # Remove last row from df (contains header again)
  df <- df[1:(n_rows-1),] # Copy all but last row
  n_rows <- dim(df)[1] # New number of rows

  # Loop through all cells of df and remove unnecessary characters
    for(col in 1:n_cols) {
      for(row in 1:n_rows) {

        temp <- df[row, col]
        temp <- str_replace_all(temp, "\n", "")     # Remove all \n
        temp <- str_replace_all(temp, "\\*", "")    # Remove all *
        temp <- trimws(temp, which=c("both"))       # Remove leading & trailing spaces
        temp <- str_replace(temp, "\\s{2,}", "_") # Replace multiple spaces with ' | '
        df[row, col] <- temp

      }
    }

  # Add new column for cantons and schools
  cantons <- df[,1]
  list_of_cantons <- rep(NA, n_rows)
  list_of_schools <- rep(NA, n_rows)

  for(n in 1:n_rows){

    tokens <- str_split(cantons[n], "_")  # Split string from first column (e.g. Aargau_Alle Schulen --> Aargau & Alle Schulen)
    tokens <- array(unlist(tokens),dim=c(1,2)) # Convert list to array (Easier to access elements)
    canton <- tokens[1]
    school <- tokens[2]

    list_of_cantons[n] <- canton
    list_of_schools[n] <- school

  }

  df["Kanton"] <- list_of_cantons
  df["Schule"] <- list_of_schools

  # Drop redundant column (first column)
  df <- subset(df, select=c(2:8))

  # Reorder columns
  df <- df[, c(6,7,1,2,3,4,5)]

  # Return cleaned df
  return(df)

}
