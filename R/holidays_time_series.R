#' Time series for holidays datasets
#'
#' @param data A dataset from this package. This includes holidays_20XX_long,
#'             holidays_20XX_long_major_regions, holidays_20XX_long_switzerland,
#'             holidays_2020_to_2025_long, holidays_2020_to_2025_long_major_regions
#'             and holidays_2020_to_2025_long_switzerland. Not that XX is a
#'             placeholder for 20, 21, 22, 23, 24 or 25.
#' @param normalize Can be set to TRUE or FALSE. If set to TRUE, values for 'Ferientag'
#'                  are normalized. This is useful for e.g. holidays_20XX_long_major_regions.
#'                  Since not all major regions have the same number of members (e.g. Zentralschweiz: 9,
#'                  Genferseeregion: 4). Normalizing the data can make the time series more meaningful.
#' @param holidaytype The type of holidays you want the plot for. Possible values are:
#'                    Sportferien, Fruehlingsferien, Sommerferien, Herbstferien, and Weihnachtsferien.
#'                    You can also chose multiple values at once: holidaytype=c("Sommerferien", "Herbstferien").
#'                    If you don't pass any value here, all types are included.
#'
#' @return An interactive time series plot for the dataset that was passed into the function.
#'         Each region (e.g. a 'Kanton', 'Grossregion' or 'Land') is represented by a plotted line.
#'         The x-axis denotes dates whereas the number of holidays on a given date is shown on the y-axis.
#'         You can use the filter function at the top of the plot to display only the regions of your choice.
#' @import plotly RColorBrewer
#' @importFrom rlang .data
#' @importFrom grDevices colorRampPalette
#' @export
#'
#' @examples
#' df <- data("holidays_2020_to_2025_long")
#' df <- get(df)
#' holidays_time_series(data=df, normalize=TRUE, holidaytype=c("Sommerferien", "Herbstferien"))
#'
#'
#'
holidays_time_series <- function(data, normalize=FALSE, holidaytype=c("Sportferien", "Fruehlingsferien", "Sommerferien", "Herbstferien", "Weihnachtsferien")) {



  #### Check dataset compatibility ####

  # Compare if colnames of input dataset match allowed datasets
  input <- colnames(data)
  cantons <- c("Kanton",
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
  major_regions <- c("Grossregion",
                     "Datum",
                     "Tag",
                     "Monat",
                     "Jahr",
                     "Jahreszeit",
                     "Wochentag",
                     "Ferientag",
                     "Wochenende",
                     "Ferientyp")
  switzerland <- c("Land",
                   "Datum",
                   "Tag",
                   "Monat",
                   "Jahr",
                   "Jahreszeit",
                   "Wochentag",
                   "Ferientag",
                   "Wochenende",
                   "Ferientyp")

  a <- identical(input, cantons)
  b <- identical(input, major_regions)
  c <- identical(input, switzerland)

  if (a || b || c) {

    # No action required
    # Data frame seems to be from the package itselfe

  } else {

    # User used an own or customized dataset as input
    return(message("Own or customised datasets are not compatible with this function. Choose a dataset from this package. E.g. holidays_2020_long, holidays_2020_long_major_regions, or holidays_2020_long_switzerland. For more details, check the function documentation at ?holidays_time_series."))

  }


  #### Step 0 - Setup ####
  df.1 <- data
  norm <- normalize
  holiday <- holidaytype



  #### Step 1 - Normalize data ####
  df.2 <- df.1

  if (norm && is.character(df.2$Kanton)) {

    # Handles non-aggregated datasets (e.g. holidays_2020_long)
    # We don't have to do anything here since 'Ferientag'
    # is already a binary value.

  } else if (norm && is.character(df.2$Land)) {

    # Handles datasets aggregated to country (e.g. holidays_2020_long_switzerland)

    # Find maximum value of 'Ferientag' per 'Grossregion'
    # Since all regions have weekends, we can use this metric
    # to find the maximum possible value
    max_value <- max(df.2$Wochenende)

    # Normalize 'Ferientag' column
    n_row <- nrow(df.2)

    for (row in 1:n_row) {

      df.2[row, "Ferientag"] <- round(df.2[row, "Ferientag"] / max_value, 2)

    }

  } else if (norm && is.character(df.2$Grossregion)) {

    # Handles datasets aggregated to major regions (e.g. holidays_2020_long_major_regions)

    # Find maximum value of 'Ferientag' per 'Grossregion'
    # Since all regions have weekends, we can use this metric
    # to find the maximum possible value
    # The .data$ is needed as check() would recognize those variables as
    # undefined global variables
    max_values <- df.2 %>%
      group_by(.data$Grossregion) %>%
      summarise(group_max = max(.data$Wochenende))
    max_values <- as.data.frame(max_values)

    max_genf <- max_values[max_values$Grossregion == "Genferseeregion", "group_max"]
    max_mitt <- max_values[max_values$Grossregion == "Mittelland", "group_max"]
    max_nord <- max_values[max_values$Grossregion == "Nordwestschweiz", "group_max"]
    max_osts <- max_values[max_values$Grossregion == "Ostschweiz", "group_max"]
    max_tess <- max_values[max_values$Grossregion == "Tessin", "group_max"]
    max_zent <- max_values[max_values$Grossregion == "Zentralschweiz", "group_max"]
    max_zuer <- max_values[max_values$Grossregion == "Z\u00FCrich", "group_max"] # ue written in Unicode Character (Hexadecimal)

    # Normalize 'Ferientag' column
    n_row <- nrow(df.2)

    for (row in 1:n_row) {

      region <- df.2[row, "Grossregion"]
      normalized_value <- case_when(region == "Genferseeregion" ~ round(df.2[row, "Ferientag"] / max_genf, 2),
                                    region == "Mittelland" ~ round(df.2[row, "Ferientag"] / max_mitt, 2),
                                    region == "Nordwestschweiz" ~ round(df.2[row, "Ferientag"] / max_nord, 2),
                                    region == "Ostschweiz" ~ round(df.2[row, "Ferientag"] / max_osts, 2),
                                    region == "Tessin" ~ round(df.2[row, "Ferientag"] / max_tess, 2),
                                    region == "Zentralschweiz" ~ round(df.2[row, "Ferientag"] / max_zent, 2),
                                    region == "Z\u00FCrich" ~ round(df.2[row, "Ferientag"] / max_zuer, 2)) # ue written in Unicode Character (Hexadecimal)
      df.2[row, "Ferientag"] <- normalized_value
    }
  }



  #### Step 2 - Subset data ####
  df.3 <- df.2

  # Set 'Ferientag' to 0 for all holidays that were not selected by the user.
  df.temp_a <- df.2[df.2$Ferientyp %in% holiday,]
  df.temp_b <- df.2[!(df.2$Ferientyp %in% holiday),]
  df.temp_b$Ferientag <- 0

  # Concatenate dfs
  df.3 <- rbind(df.temp_a, df.temp_b)



  #### Step 3 - Add primary key ####

  # Add new column with primary key
  # This key is needed to plot the y-axis of the plots
  # holidays_20XX_long:               primary.key -> 'Kanton' + 'Schule'
  # holidays_20XX_long_major_region:  primary.key -> 'Grossregion'
  # holidays_20XX_long_switzerland:   primary.key -> 'Land'
  df.4 <- df.3

  if (is.character(df.4$Kanton)) {

    df.4$Primary.key <- with(df.4, paste0(Kanton, ", ", Schule))

  } else if (is.character(df.4$Grossregion)) {

    df.4$Primary.key <- df.4$Grossregion

  } else if (is.character(df.4$Land)) {

    df.4$Primary.key <- df.4$Land

  } else {

    print("Unknown dataset format")

  }



  #### Step 4 - Sort data ####

  # Plotly's time series plot needs dates in order to plot them properly
  # The .data$ is needed as check() would recognize those variables as
  # undefined global variables
  df.5 <- df.4 %>% arrange(.data$Datum)



  #### Step 5 - Plot data ####
  df.plot <- df.5

  plot_ly() %>%
    add_trace(
      data=df.plot,
      x=df.plot$Datum,
      y=df.plot$Ferientag,
      color=df.plot$Primary.key,
      colors=colorRampPalette(brewer.pal(11,"RdYlGn"))(50), # The 'RdYlGn' color palette has only 11 colors. We expand it to 50.
      type="scatter",
      mode="lines",
      hoverinfo = "text",
      text=~paste("Datum:",
                  df.plot$Datum,
                  "<br>Ort:",
                  df.plot$Primary.key,
                  "<br>Ferientage:",
                  df.plot$Ferientag)) %>%
    layout(
      xaxis=list(title="", showgrid=FALSE),
      yaxis=list(title="", showgrid=FALSE))

}
