
dont_run <- function(){
  library(rvest)
  library(httr)
  library(magrittr)
  library(urltools)

  # system(
  #   paste0("sudo -kS docker rm -vf $(docker ps -a -q)"),
  #   input = "vistarundle1!!!"
  # )
  # system(
  #   paste0("sudo -S docker rmi -f $(docker images -a -q)"),
  #   input = "vistarundle1!!!"
  # )

  source("R/is_job_offer_page.R")
  source("R/handle_links.R")
  source("R/link_checker.R")
  load("data/comp_urls_indeed.RData")
  load("data/job_page_candidates_indeed.RData")
  urls <- unlist(comp_urls)

  source("R/rvestFunctions.R")

  pjs <<- webdriver::run_phantomjs()
  ses <<- webdriver::Session$new(port = pjs$port)


  w <- (sapply(indeed_results, typeof, USE.NAMES = FALSE) == "list") %>%
    unname %>%
    which

  w
  #201 find better xpath
  # 259 wrong turn to paypal
  # 262 find  (m / w/d)
  # 264: find better path?


  # button: 103
  # mehr anz: 106
  # 76, 79, 105, 106, 107,

  nr <- 1

  url <- urls[nr]
  url


  sd <- sapply(indeed_results, typeof)
  xxx <- which(sd == "list")

  # 13 problem?
  # 31 false positive?
  # 32 filters not set - need german locale?
  nr <- xxx[34]

  xx <- indeed_results[[nr]]
  #   xx <- indeed_results[[url]]
  xx$counts
  #xx$matches[[3]]
  xx$parsed_links$href
  xx$parsed_links$href[xx$winner]
  #xx$parsed_links$href[2]
  #xx$parsed_links$href[xx$winner] %>% browseURL()

  doc <- xx$doc %>% xml2::read_html()
  doc %>% SteveAI::showHtmlPage()
  target_text <- get_target_text(xx)
  # target_text <- "Kundenbetreuer (W/m/d)"
  target_text

  # doc %>% html_nodes(xpath = "//*[contains(text(), 'm/w/d')]") %>%
  #   html_text()

  #doc %>% SteveAI::showHtmlPage()
  xpath <- SteveAI::getXPathByText(text = target_text, doc = doc, add_class = TRUE, exact = TRUE)
  xpath


  source("R/configure_xpath.R")
  url <- xx$parsed_links$href[xx$winner]
  out <- configure_xpath(xpath, doc, ses, url)
  out

  required_len <- 13

  tags_pure <- out$tags_pure
  classes <- out$classes
  add_classes(required_len, out$tags_pure, out$classes, doc)
  out$require_js

  indeed_results[[nr]]$result <- "need_button"
  indeed_results[[nr]]$result <- "works incomplete xpath"
  indeed_results[[nr]]$result <- "works_multi_candidate"
  indeed_results[[nr]]$result <- "works_multi_candidate_wrong_doc"
  indeed_results[[nr]]$result <- "works"

  save(indeed_results, file = "data/job_page_candidates_indeed.RData")


  # doc %<>% gsub(pattern = "&", replacement = "&amp;", fixed = TRUE) %>%
  #   xml2::re
  # write_xml(doc, "doc.xml")
  # xml2::read_xml("doc.xml")

}

get_target_text <- function(xx){

  rr <- xx$matches[[xx$winner]] %>%
    {.[names(.) != "apply_button"]} %>%
    unname %>%
    unlist(recursive = TRUE)

  #weights <- c("m/w/d" = 5, "m/w" = 4, "vollzeit" = 0.1) # has to have the same lengths
  rr[names(rr) %in% c("m/w/d",  "w/m/d")] %<>% {as.numeric(.)*5}
  rr %>%
    {names(.)[which.max(.)]}
}


#(M / F / D)
# (m / f / d)
