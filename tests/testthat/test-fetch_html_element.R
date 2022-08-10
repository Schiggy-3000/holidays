require("testthat")
require("xml2") # Converts xml_nodeset to list


test_that("fetching HTML table works", {

  html <- fetch_html_element(2020)
  html <- as_list(html) # Should be 1 list with 3 nodes
  node.1 <- html[[1]][1] # thead
  node.2 <- html[[1]][2] # tbody
  node.3 <- html[[1]][3] # tfoot

  html.tables <- length(html) # 1 list with 3 nodes
  html.nodes <- length(html[[1]]) # 3 nodes

  check.tables <- html.tables == 1 # Just one table with holiday data in it
  check.nodes <- html.nodes == 3 # thead, tbody, tfoot
  check.thead <- is.list(node.1$thead)
  check.tbody <- is.list(node.2$tbody)
  check.tfoot <- is.list(node.3$tfoot)

  actual <- c(check.tables, check.nodes, check.thead, check.tbody, check.tfoot)
  should <- c(TRUE, TRUE, TRUE, TRUE, TRUE)
  result <- identical(actual, should)

  expect_equal(TRUE, result)
})
