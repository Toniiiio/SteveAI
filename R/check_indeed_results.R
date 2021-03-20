# retry https://jobs.ernstings-family.com/persis/main?fn=bm.ausschreibungsuebersicht&cfg_kbez=Internet&__nav=0
dont_run <- function(){
  library(rvest)
  library(httr)
  library(magrittr)
  library(urltools)

  #load(file = "data/job_page_candidates_indeed.RData")
  load("data/wiki_indeed.RData")
  source("R/configure_xpath.R")

  indeed_results2 <- wiki_results2
  #nr <- 13
  xx <- which(lengths(indeed_results2) == 7)

  nrr <- xx[nr]
  nr
  out <- indeed_results2[[nrr]]

  out$candidate_meta
  out$parsed_links$href[out$winner]
  #out$doc %>% SteveAI::showHtmlPage()
  nr <- nr + 1

  out$parsed_links$href
  out$candidate_meta


  out$parsed_links$href[out$winner] %>% browseURL()

  #out$candidate_meta$target_text <- "SOFTWARE ENGINEER"
  out$parsed_links$href
  out$counts
  required_len <- 9

  tags_pure <- out$candidate_meta$tags_pure
  classes <- out$candidate_meta$classes
  doc <- out$doc %>% xml2::read_html()
  add_classes(required_len, out$candidate_meta$tags_pure, out$candidate_meta$classes, doc)
  out$candidate_meta$require_js

}

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
  source("R/target_text.R")
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
  # 35
  # 38
  # 42,43 wrong doc parsed?
  # 47 retrain: "Assistant Center Manager", "Quality Specialist"
  # 48 myworkdayjobs
  # 55 weird geturl behavior
  # 62 shitty
  # 64 should work now
  # 68 taleo wrong locale?
  #69 murks seite
  # 72 - senior probleme
  # 74 myworkdays
  # 75 doesnt show
  nr <- xxx[[1]]

  parsing_results <- indeed_results[[nr]]
  #   parsing_results <- indeed_results[[url]]
  parsing_results$counts
  #parsing_results$matches[[3]]
  parsing_results$parsed_links$href
  parsing_results$parsed_links$href[parsing_results$winner]
  #parsing_results$parsed_links$href[2]
  #parsing_results$parsed_links$href[parsing_results$winner] %>% browseURL()


  out <- extract_target_text(parsing_results)
  out$candidate_meta$target_text
  out$candidate_meta

  parsing_results$all_docs[parsing_results$winner] %>% SteveAI::showHtmlPage()
  #parsing_results$parsed_links$href[parsing_results$winner] %>% browseURL()

  required_len <- 4

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

