
repair_xpath <- function(){
  rvestScraper <- SteveAI::rvestScraper
  rvestScraper$`GP-CONSULT`$href <- "/html/body/div/div/div/div/div/div/div[4]/div/form/fieldset/div/div/a"
  save(rvestScraper, file = "SteveAI/data/scraper_rvest.RData")
}


# url <- "https://cloudmade.com/careers/"
# docs <- url %>% xml2::read_html()
#
# targetString <- "Mobile QA Engineer"
# tags <- html_nodes(docs, xpath = paste0("//*[contains(text(), '", targetString,"')]"))
# xp <- SteveAI:::getXPathByTag(tag = tags, text = targetString)
#
# targetString <- "Digital Product Manager"
# tags <- html_nodes(docs, xpath = paste0("//*[contains(text(), '", targetString,"')]"))
# xp2 <- SteveAI:::getXPathByTag(tag = tags, text = targetString)
#
# targetString <- "IT Recruiter"
# tags <- html_nodes(docs, xpath = paste0("//*[contains(text(), '", targetString,"')]"))
# xp3 <- SteveAI:::getXPathByTag(tag = tags, text = targetString)
# xp3
#
#
# docs %>% html_nodes(xpath = xp)
