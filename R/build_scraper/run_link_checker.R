
dont_run <- function(){
  library(rvest)
  library(httr)
  library(magrittr)
  library(glue)
  library(urltools)
  library(SteveAI)
  source("SteveAI/R/is_job_offer_page.R")
  source("R/is_job_offer_page.R")

  source("SteveAI/R/handle_links.R")
  source("R/handle_links.R")

  source("SteveAI/R/link_checker.R")
  source("R/build_scraper/link_checker.R")
  source('R/build_scraper/target_text.R')

  beep <- function(n = 2){
    for(i in seq(n)){
      system("rundll32 user32.dll,MessageBeep -1")
      Sys.sleep(.5)
    }
  }

  pjs <<- webdriver::run_phantomjs()
  ses <<- webdriver::Session$new(port = pjs$port)

  # scrape searcher does not move forward:
  #rvestScraper$APLANT$domain <- "https://www.sunbeltrentals.co.uk/"

  comp_name <- "DEUTSCHE-BANK"
  url <- "http://www.lidl.de"  #rvestScraper[[comp_name]]$domain
  url
  url %>% browseURL()
  xx <- find_job_page(url, ses = ses, pjs = pjs)
  beep()


  xx$matches
  xx$all_docs[[9]] %>% showHtmlPage()
  winner_url <- xx$parsed_links$href[xx$winner]
  winner_url
  winner_url %>% ec
  paste0(winner_url, "#:~:text=", url_encode(xx$candidate_meta[[4]][1])) %>% browseURL()
  xx$candidate_meta
  xx$candidate_meta %>% names

  xx$parsed_links$href

  rvestScraper[[comp_name]]$url <- winner_url
  rvestScraper[[comp_name]]$multi_page <- FALSE
  rvestScraper[[comp_name]]$jobNameXpath <-  "/html/body/main/div/div/div/div/a/div/div/h5"
  # save(rvestScraper, file = "data/scraper_rvest.RData")

}


save(rvestScraper, file = "scraper_rvest.RData")

#todo:
# wrong links: IDEALO


# # works
# url <- "http://www.blutspendezentren.de"
# url <- "https://byterunner.de/"
#
# #error
# url <- "http://www.bytedance.com"
#
# # komische reihenfolge klappt aber
# url <- "http://www.aap.de"
#
# url <- "http://www.abb.de"
#
# url <- "http://www.ab-events.de"
#
# url <- "http://www.saturn.de"
# url<- "https://www.saturn.de/webapp/wcs/stores/servlet/multichannelalljobsoverview"
#
# url <- "http://www.mediamarkt.de"
#
# # javascript
# url <- "http://www.cewe.de"
# # javascript
# url <- "http://www.linde.de/"
# # javascript
# url <- "http://www.staples.de/"
#
# url <- "http://www.milram.de/"
#
# #works - but incomplete xpath
# url <- "http://www.makita.de/"
#
# # cant even find manuelly
# url <- "http://www.milka.de/"
#
# #javascript
# url <- "http://www.oetker.de/"
# url <- "https://www.lenovo.com"
#
# #javascript
# url <- "https://www.ravensburger.com"
# xpath <- "//*[@alt = 'search for jobs']"
#
# # error in htm2text
# url <- "https://www.loreal.com/"
#
# # works - candidate for additional candidates
# url <- "https://www.zdf.de/"
#
# #javascript
# url <- "https://www.ard.de/"
#
# #javascript
# url <- "https://www.accobrands.com/"
#
# # url <- "https://www.holsten.de"
#



# html error - look deeper here
url <- "https://www.lufthansa.de/"

url <- "https://www.stabilo.com"

#works
url <- "https://www.penny.de"

# shitty seite - a la indeed
url <- "https://www.netflix.com"

# biegt zu linkedin ab
url <- "https://www.ibm.com"

# works with selenium
url <- "https://www.airbnb.com"

# search button
url <- "https://www.microsoft.com"

# xx <- find_job_page(url, remDr, TRUE)

# xx <- find_job_page(url)
# #
# xx$counts
# xx$parsed_links$href
# xx$parsed_links$href[xx$winner]
# xx$parsed_links$href[xx$winner] %>% browseURL()

# professionals
# opportunities
# career opportunities
# explore career opportunities

#
#
#
# txts <- c('search for jobs', 'stellenanzeigen')
# xpath <- paste0("//*[contains(@alt, '", txts,"')]") %>% paste(collapse = " or ")
# url %>% read_html() %>% html_nodes(xpath = xpath)
#
#
#
# ww <- xx$matches[xx$winner] %>% unlist(recursive = FALSE) %>% sapply(names)
# ww
#
# doc <- xx$parsed_links$href[xx$winner] %>% xml2::read_html()
# doc %>% SteveAI::showHtmlPage()
# ww <- SteveAI::getXPathByText(text = "Offene", doc = doc, add_class = TRUE)
# html_nodes(x = doc, xpath = ww) %>% html_text()
#
#
#
# Job finden >
#
#
#
# doc <- "https://www.dmk.de/wir-als-arbeitgeber/" %>% read_html
# tags <- doc %>% html_nodes(xpath = "//*[self::a or self::button or self::input]")
#
# tags %>% html_name()
# which(tags %>% html_name() == "input")
# which(tags %>% html_name() == "button")
# which(!is.na(tags %>% html_attr(name = "value")))
#
# txt <- tags %>% html_text()
# val <- tags %>% html_attr(name = "value") %>% ifelse(is.na(.), "", .)
# cont <- paste0(txt, val)
#
#
#
#
#
