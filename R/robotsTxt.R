library(robotstxt)

RobotsTxt <- function(urls){
  allowed <- rep(0, length(urls))
  start <- Sys.time()
  for(nr in 1:length(urls)){
    allowed[nr] <- tryCatch(
      paths_allowed(urls[nr]),
      error = function(e) return(NA)
    )
  }
  return(allowed)
}

load("SteveAI/scraper.RData")
urls <- unlist(unname(sapply(scraper,"[", "url")))
allowed <- RobotsTxt(urls)
IgnoreIdx <- allowed == 0 & !is.na(allowed)
scraper <- scraper[!IgnoreIdx]

