dont_run <- function(){
  load("~/SteveAI/data/scraper_rvest.RData")

  rvestScraper0 <- rvestScraper



  for(nr in seq(rvestScraper0)){
    rvestScraper0[[nr]]$href <- rvestScraper3[[nr]]$href
  }


  rvestScraper <- rvestScraper0
  save(rvestScraper, file = "data/scraper_rvest.RData")

  names(rvestScraper[[1]])


  has_data <- sapply(rvestScraper, function(scrp) all(c("url", "jobNameXpath", "domain", "href") %in% names(scrp)))
  all(has_data)

}
