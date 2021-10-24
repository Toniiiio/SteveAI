dont_run <- function(){
  xp <- '//tr/td[2]/a'
  url <- "https://en.wikipedia.org/wiki/List_of_S%26P_500_companies"

  doc <- url %>% xml2::read_html()
  #doc %>% SteveAI::showHtmlPage()
  links <- doc %>% html_nodes(xpath = xp) %>% html_attr(name = "href") %>% paste0("https://en.wikipedia.org", .)

  wiki_urls <- list(NA, length(links))
  link <- links[2]
  which(link == links)
  #:length(links)
  for(link in links[1:374]){
    print(link)
    doc <- link %>% read_html
    wiki_urls[[link]] <- doc %>% html_nodes(xpath = "//*[contains(text(), 'Website')]") %>%
      html_nodes(xpath = "../td/span/a") %>% html_attr(name = "href")
    save(wiki_urls, file = "wiki_urls.RData")
  }
}
