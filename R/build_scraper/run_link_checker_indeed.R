dont_run <- function(){

  library(rvest)
  library(httr)
  library(magrittr)
  library(urltools)

  # system(
  #   paste0("sudo -kS docker rm -vf $(docker ps -a -q)"),
  #   input = ""
  # )
  # system(
  #   paste0("sudo -S docker rmi -f $(docker images -a -q)"),
  #   input = ""
  # )

  # powershell
  # docker ps -aq | foreach {docker rm $_}




  source("R/is_job_offer_page.R")
  source("R/handle_links.R")
  source("R/link_checker.R")
  source("R/target_text.R")
  # load("data/comp_urls_indeed.RData")
  # load("data/job_page_candidates_indeed.RData")
  load("data/wiki_indeed.RData")
  # urls <- unlist(comp_urls)
  load("wiki_urls.RData")
  urls <- wiki_urls[-(1:2)] %>% unlist %>% unname %>% unique

  #ses <<- start_phantom()


  # if(!exists("indeed_reuslts")){
  #   wiki_results2 <- list()
  # }


  pjs <<- webdriver::run_phantomjs()
  ses <<- webdriver::Session$new(port = pjs$port)

  urls %>% grepl(pattern = "sturbucks") %>% which
  url <- "https://www.Xxx.com/"
  url <- "https://karriere.bayer.de/de/"
  nr <- 3
  for(nr in seq(urls)[2:100]){
    url <- urls[nr]
    url
    wiki_results2[[url]] <- tryCatch(
      find_job_page(url, ses, use_phantom = TRUE),
      error = function(e){
        pjs <<- webdriver::run_phantomjs()
        ses <<- webdriver::Session$new(port = pjs$port)
        print("Call to find_job_page failed with:")
        print(e)
        return("")
      }
    )
    save(wiki_results2, file = "data/wiki_indeed.RData")
  }


  nr <- 58
  url <- urls[[nr]]
  url
  indeed_results[[url]]


  # which(indeed_results %>% sapply(typeof) == "list")

}

# wiki_results2[[url]]$counts
# wiki_results2[[url]]$parsed_links$href
