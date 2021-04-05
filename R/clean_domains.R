clean_domains <- function(){
  library(urltools)
  library(httr)
  library(magrittr)
  load(file.path("~", "scraper_rvest.RData"))
  urls <- sapply(rvestScraper, "[", "url")
  domains <- sapply(urls, function(url) tryCatch(domain(url), error = function(e) ""))
  domains <- paste0("https://", domains)
  conts <- rep(NA, length(domains))
  #which(conts != "200")
  for(nr in seq(rvestScraper)){
    print(nr)
    conts[nr] <- tryCatch(httr::GET(domains[nr]) %>% httr::status_code(), error = function(e) "")
  }

  domains[which(conts != "200")] <- c(
    "https://www.idealo.de/",
    "https://www.dz-privatbank.com/dzpb/",
    "",
    "https://www.americantower.com/",
    "",
    "https://www.brenntag.com/corporate/de/"
  )

  for(nr in seq(rvestScraper)){
    rvestScraper[[nr]]$domain <- domains[nr]
  }
  save(rvestScraper, file = "data/scraper_rvest.RData")
  save(rvestScraper, file = "../scraper_rvest.RData")
}
