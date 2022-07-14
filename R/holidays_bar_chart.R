#' Bar chart for holidays datasets
#'
#' @param data A dataset from this package. This includes holidays_20XX_long,
#'             holidays_20XX_long_major_regions, holidays_20XX_long_switzerland,
#'             holidays_2020_to_2025_long, holidays_2020_to_2025_long_major_regions
#'             and holidays_2020_to_2025_long_switzerland. Not that XX is a
#'             placeholder for 20, 21, 22, 23, 24 or 25.
#' @return An interactive bar plot for the dataset that was passed into the function.
#'         Each bar represents the number of holidays in a year for a given region.
#' @importFrom ggplot2 ggplot geom_bar aes xlab ylab coord_flip theme_classic scale_fill_brewer
#' @importFrom rlang .data
#' @export
#'
#' @examples
#' df <- data("holidays_2020_to_2025_long_major_regions")
#' df <- get(df)
#' holidays_bar_chart(data=df)
#'
#'
#'
holidays_bar_chart <- function(data) {


  # Setup for plot
  df.1 <- data


  # Add new column with primary key
  # This key is needed to plot the y-axis of the plots
  # holidays_20XX_long:               primary.key -> 'Kanton' + 'Schule'
  # holidays_20XX_long_major_region:  primary.key -> 'Grossregion'
  # holidays_20XX_long_switzerland:   primary.key -> 'Land'
  if (is.character(df.1$Kanton)) {

    df.1$Primary.key <- with(df.1, paste0(Kanton, ", ", Schule))

  } else if (is.character(df.1$Grossregion)) {

    df.1$Primary.key <- df.1$Grossregion

  } else if (is.character(df.1$Land)) {

    df.1$Primary.key <- df.1$Land

  } else {

    print("Unknown dataset format")

  }


  # Aggregate data
  df.2 <- df.1 %>%
    group_by(.data$Primary.key, .data$Jahr) %>% # .data is needed to avoid "no visible binding for global variable" note
    summarise(Ferientag = sum(.data$Ferientag),
              Wochenende = sum(.data$Wochenende),
              Freier.Tag = sum(.data$Freier.Tag))

  df.2 <- as.data.frame(df.2)


  gg <- ggplot() +
    geom_bar(aes(fill=df.2$Jahr, y=df.2$Ferientag, x=df.2$Primary.key),
             position="dodge", stat="identity") +
    xlab("") +
    ylab("Ferientage") +
    coord_flip() +
    theme_classic() +
    scale_fill_brewer(palette="PuBu", name="") # Remove legend title

  ggplotly(gg)

}
