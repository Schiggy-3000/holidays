# Converts date range to individual dates
#
# @param cell A date range. E.g. "21.02. - 01.03.". As this function is
#             meant for processing holiday data, those date ranges most
#             likely stem from data frame cells (E.g. holidays_2020_dates).
# @param year The year from which the dates are from.
#
# @return A string where all individual dates are concatenated. Note that
#         while input date ranges must be in dd.mm. format, the output uses yyyy-mm-dd.
#' @import lubridate stringr
#
# @examples
# # Load dataset
#
# data(holidays_2020_dates)
# data(holidays_2025_dates)
#
#
# # Grab different formats of date string
#
# case_1 <- holidays_2020_dates[1,3]  # "-"
# case_2 <- holidays_2020_dates[3,3]  # "21.02. - 01.03."
# case_3 <- holidays_2020_dates[5,4]  # "04.04. - 19.04.+22.05."
# case_4 <- holidays_2020_dates[7,4]  # "25.03.+04.04. - 18.04.+22.05. - 23.05."
# case_5 <- holidays_2020_dates[13,4] # "02.04. - 19.04.+04.05.+22.05."
# case_6 <- holidays_2020_dates[30,4] # 30.03. - 13.04.+21.05. - 01.06."
# case_7 <- holidays_2020_dates[18,7] # "07.12.+19.12. - 03.01."
# case_8 <- holidays_2025_dates[6,5]  # "07.07."
# case_9 <- holidays_2025_dates[24,5] # "09.06.+19.06.+05.07. - 17.08."
#
#
# # Resulting date strings
#
# date_range_to_dates(case_1, 2020) # "-"
# date_range_to_dates(case_2, 2020) # "2020-02-21, 2020-02-22, ..., 2020-03-01"
# # ...
# date_range_to_dates(case_9, 2020) # "2020-06-09, 2020-06-19, ..., 2020-08-17"
#
#
#
date_range_to_dates <- function(cell, year){


  # Split date string at +
  # E.g. "04.04. - 19.04.+22.05." becomes "04.04. - 19.04." & "22.05."
  tokens <- str_split(cell, "\\+")
  tokens <- unlist(tokens) # Convert list to vector
  dates <- vector(mode="character") # Initialize vector


  # Iterate over all tokens and return date ranges as dates
  # E.g. "-" becomes ["-"]
  # E.g. "22.05." becomes ["22.05."]
  # E.g. "21.02. - 23.02." becomes  ["21.02.", "22.02.", "23.02."]
  for(token in tokens) {


    # There are 3 unique types of tokens that result from splitting at +
    # case 1: -
    # case 2: 22.05.
    # case 3: 22.05. - 23.05.


    # Handle cases
    if (token == "-") {

      start_date <- "-"
      end_date <- "-"
      dates <- append(dates, start_date)
      break

    } else if (str_detect(token, "^[0-9]+\\.[0-9]+\\.$")) {

      start_date <- token
      end_date <- token

    } else if (str_detect(token, "^[0-9]+\\.[0-9]+\\. -")) {

      # If token is of the form "01.01. - 01.02." we split it at - again
      atoms <- str_split(token, "-")
      atoms <- unlist(atoms) # Convert list to vector

      # Remove leading & trailing spaces (e.g. "01.01. " is now "01.01.")
      atoms_clean <- vector(mode="character") # Initialize vector
      for(atom in atoms) {

        temp <- trimws(atom, which=c("both"))
        atoms_clean[atom] <- temp

      }

      start_date <- atoms_clean[1]
      end_date <- atoms_clean[2]
    }


    # Add year to start_date
    start_date <- paste(start_date, year, sep="")


    # Add year to end_date
    # If end_date is in January, then we do year+1
    # E.g. 15.12. becomes 15.12.2021
    # E.g. 15.01. becomes 15.01.2022
    if (str_detect(end_date, "^[0-9]+\\.01+\\.$")) {
      end_date <- paste(end_date, year+1, sep="")
    } else {
      end_date <- paste(end_date, year, sep="")
    }


    # Convert start_date to POSIXct
    d <- str_split(start_date, "\\.")
    d <- unlist(d) # Convert list to vector
    start_date <- make_datetime(day=as.integer(d[1]), month=as.integer(d[2]), year=as.integer(d[3])) # start_date as type 'POSIXct'
    start_date <- date(start_date) # start_date as type 'date'


    # Convert end_date to POSIXct
    d <- str_split(end_date, "\\.")
    d <- unlist(d) # Convert list to vector
    end_date <- make_datetime(day=as.integer(d[1]), month=as.integer(d[2]), year=as.integer(d[3])) # end_date as type 'POSIXct'
    end_date <- date(end_date) # end_date as type 'date'


    # Collect days from start_date to end_date in a vector
    temp <- start_date
    repeat{

      # Add dates to vector
      dates <- append(dates, toString(temp)) # temp as string since it would be converted to milliseconds otherwise
      temp <- temp + days(1) # Add 1 day to date

      # Break loop when start_date (=temp) is larger than end_date
      if(temp > end_date){
        break
      }
    }
  }

  # Return all dates
  # Convert to string since it is easier to write it into a single cell of a data frame that way
  return(toString(dates))

}
