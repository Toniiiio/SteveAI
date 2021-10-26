
check_rvest_Scraper <- function(){
  rvestScraper <- SteveAI::rvestScraper
  #names(rvestScraper)[4] <- "Union Investment"

  library(magrittr)

  missing_url <- lapply(SteveAI::rvestScraper, "[[", "url") %>%
    nchar %>%
    magrittr::is_greater_than(4) %>%
    magrittr::not() %>%
    which

  missing_url
  SteveAI::rvestScraper[missing_url]

  for(nr in seq(SteveAI::rvestScraper)){
    name <- names(SteveAI::rvestScraper)[nr] %>% tolower
    url <- SteveAI::rvestScraper[[nr]]$url %>% tolower

    if(length(url)){
      name_in_url <- agrepl(pattern = name, x = url) & nchar(url)
      if(!name_in_url){
        print(name)
        print(url)
        print("____________________________")
      }
    }
  }

  # rvestScraper$PROSIEBENSAT1 <- NULL
  # rvestScraper$`TEXAS-INSTRUMENTS` <- NULL
  # save(rvestScraper, file = "SteveAI/data/scraper_rvest.RData")
}
