#' Title
#'
#' @param x String to be split
#' @param split Character at which to split
#'
#' @return Returns a list
#' @export
#'
#' @examples
#' x <- "alfa,bravo,charlie,delta"
#' strsplit1(x, split = ",")
strsplit1 <- function(x, split) {

  strsplit(x, split = split)[[1]]

  }
