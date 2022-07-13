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
    group_by(Primary.key, Jahr) %>%
    summarise(Ferientag = sum(Ferientag),
              Wochenende = sum(Wochenende),
              Freier.Tag = sum(Freier.Tag))

  df.2 <- as.data.frame(df.2)


  gg <- ggplot(df.2, aes(fill=Jahr, y=Ferientag, x=Primary.key)) +
    geom_bar(position="dodge", stat="identity") +
    xlab("") +
    ylab("") +
    coord_flip() +
    theme_classic() +
    scale_fill_brewer(palette="PuBu")

  ggplotly(gg)

}
