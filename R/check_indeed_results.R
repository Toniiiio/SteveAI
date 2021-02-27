
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

  w <- (sapply(indeed_results, typeof, USE.NAMES = FALSE) == "list") %>%
    unname %>%
    which

  w
  #201 find better xpath
  # 259 wrong turn to paypal
  # 262 find  (m / w/d)
  # 264: find better path?
  nr <- 3

  xx <- indeed_results[[nr]]
  xx$all_docs[1]
  xx$counts
  xx$parsed_links$href
  xx$parsed_links$href[xx$winner]
  xx$parsed_links$href[xx$winner] %>% browseURL()

  doc <- xx$doc %>% xml2::read_html()
  target_text <- xx$matches[xx$winner] %>%
    lapply(unname) %>%
    unlist(recursive = TRUE) %>%
    {names(.)[which.max(as.numeric(.))]}
  target_text

  doc %>% html_nodes(xpath = "//*[contains(text(), 'm/w/d')]") %>%
    html_text()

  doc %>% SteveAI::showHtmlPage()
  xpath <- getXPathByText(text = target_text, doc = doc, add_class = TRUE, )
  xpath
  html_nodes(x = doc, xpath = xpath) %>% html_text()

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

#(M / F / D)
# (m / f / d)
