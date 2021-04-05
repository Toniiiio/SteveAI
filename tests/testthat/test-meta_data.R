test_that("meta data complete", {
  has_data <- sapply(rvestScraper, function(scrp) all(c("url", "jobNameXpath", "domain", "href") %in% names(scrp)))
  expect_equal(all(has_data), TRUE)
})

