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

if(!exists("indeed_reuslts")){
  indeed_results <- list()
}

remDr <- start_selenium(port = 4445)

names(indeed_results) %>% .[length(.)] %>%
  magrittr::equals(urls) %>% which

# 275 --> repaired doc

nr <- 1
for(nr in seq(urls)[1:3672]){
  url <- urls[nr]
  indeed_results[[url]] <- tryCatch(
    find_job_page(url, remDr, TRUE),
    error = function(e){
      remDr <- tryCatch(start_selenium (port = 5512 + nr), error = function(e) return(""))
      return("")
    }
  )
  save(indeed_results, file = "data/job_page_candidates_indeed.RData")
}

#paypal, facebook, instagram, youtube

# [1] "https://birdieco.de/barista-m-w-d-minijob-werksstudent-tagesgastronomie/#respond"
#
# Selenium message:Unable to locate element: {"method":"xpath","selector":"/html"}


#Hier finden Sie unsere Jobangebote
# link: careerfactors


# which(indeed_results %>% sapply(typeof) == "list")
