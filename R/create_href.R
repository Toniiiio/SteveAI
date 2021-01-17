library(xml2)
library(rvest)

xpath_href <- rep(NA, length(SteveAI::rvestScraper))

nr <- 40
for(nr in seq(SteveAI::rvestScraper)){
  print(nr)
  comp <- SteveAI::rvestScraper[[nr]]
  doc <- tryCatch(comp$url %>% xml2::read_html(), error = function(e) "<html>")
  if(identical(doc, "<html>")) next
  doc %>% SteveAI::showHtmlPage()

  elems <- doc %>% rvest::html_nodes(xpath = comp$jobNameXpath)
  if(!length(elems)) next

  cont_search_link <- TRUE

  while(cont_search_link){
    href <- elems %>% html_attr(name = "href")
    tag_name <- elems %>% html_name()
    cont_search_link <- (all(is.na(href)) | all(tag_name == "html")) & length(elems)
    if(cont_search_link)  elems %<>% html_nodes(xpath = "..")
  }

  has_href <- !all(is.na(href))
  if(has_href){
    xpath_href[nr] <- SteveAI::getXPathByTag(elems[1])
  }

}

save(xpath_href, file = "xpath_href.RData")


rvestScraper <- SteveAI::rvestScraper
rvestScraper$href <- xpath_href

save(rvestScraper, file = "SteveAI/data/scraper_rvest.RData")
