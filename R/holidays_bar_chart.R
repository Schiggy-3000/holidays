#' Bar chart for holidays datasets
#'
#' @param data A dataset from this package. This includes holidays_20XX_long,
#'             holidays_20XX_long_major_regions, holidays_20XX_long_switzerland,
#'             holidays_2020_to_2025_long, holidays_2020_to_2025_long_major_regions,
#'             and holidays_2020_to_2025_long_switzerland. Not that XX is a
#'             placeholder for 20, 21, 22, 23, 24 or 25.
#' @param holidaytype The type of holidays you want the plot for. Possible values are:
#'                    Sportferien, Fruehlingsferien, Sommerferien, Herbstferien, and Weihnachtsferien.
#'                    If you don't pass any value here, all types are included.
#' @return An interactive bar plot for the dataset that was passed into the function.
#'         Each bar represents the number of holidays in a year for a given region.
#' @import plotly
#' @export
#'
#' @examples
#' df <- data("holidays_2020_to_2025_long_major_regions")
#' df <- get(df)
#' holidays_bar_chart(data=df, holidaytype=c("Sommerferien", "Herbstferien"))
#'
#'
#'
holidays_bar_chart <- function(data, holidaytype=c("Sportferien", "Fruehlingsferien", "Sommerferien", "Herbstferien", "Weihnachtsferien")) {


  #### Step 0 - Setup ####
  df.1 <- data
  holiday <- holidaytype



  #### Step 1 - Subset data ####

  # Set 'Ferientag' to 0 for all holidays that were not selected by the user.
  df.temp_a <- df.1[df.1$Ferientyp %in% holiday,]
  df.temp_b <- df.1[!(df.1$Ferientyp %in% holiday),]
  df.temp_b$Ferientag <- 0

  # Concatenate dfs
  df.2 <- rbind(df.temp_a, df.temp_b)



  #### Step 2 - Add primary key ####

  # Add new column with primary key
  # This key is needed to plot the y-axis of the plots
  # holidays_20XX_long:               primary.key -> 'Kanton' + 'Schule'
  # holidays_20XX_long_major_region:  primary.key -> 'Grossregion'
  # holidays_20XX_long_switzerland:   primary.key -> 'Land'
  df.3 <- df.2

  if (is.character(df.3$Kanton)) {

    df.3$Primary.key <- with(df.3, paste0(Kanton, ", ", Schule))

  } else if (is.character(df.3$Grossregion)) {

    df.3$Primary.key <- df.3$Grossregion

  } else if (is.character(df.3$Land)) {

    df.3$Primary.key <- df.3$Land

  } else {

    print("Unknown dataset format")

  }



  #### Step 3 - Aggregate data ####

  df.4 <- df.3 %>%
    group_by(Primary.key, Jahr) %>%
    summarise(Ferientag = sum(Ferientag))

  df.4 <- as.data.frame(df.4)



  #### Step 4 - Plot data ####
  df.plot <- df.4
  n <- length(unique(df.plot$Primary.key)) # Needed that all Primary.keys are displayed

  plot_ly() %>%
    add_trace(
      data=df.plot,
      x=df.plot$Ferientag,
      y=df.plot$Primary.key,
      color=~factor(df.plot$Jahr, ordered=TRUE),
      colors="RdYlBu",
      type="bar",
      hoverinfo = "text",
      text=~paste("Datum:",
                  df.plot$Jahr,
                  "<br>Ort:",
                  df.plot$Primary.key,
                  "<br>Ferientag:",
                  df.plot$Ferientag)) %>%
    layout(
      showlegend=TRUE,
      xaxis=list(title="Ferientage", showgrid=FALSE),
      yaxis=list(title="", showgrid=FALSE, tickvals=0:n))

}
