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

# powershell
# docker ps -aq | foreach {docker rm $_}




source("R/is_job_offer_page.R")
source("R/handle_links.R")
source("R/link_checker.R")
load("data/comp_urls_indeed.RData")
load("data/job_page_candidates_indeed.RData")
urls <- unlist(comp_urls)
ses <<- start_phantom()

# if(!exists("indeed_reuslts")){
#   indeed_results <- list()
# }


#remDr <- start_selenium(port = 4457)

names(indeed_results) %>% .[length(.)] %>%
  magrittr::equals(urls) %>% which

# 275 --> repaired doc

# 20 fails
# 3 let selenium stop
# https://www.accenture.com/us-en/careers/jobsearch weird html with only script but with data
# but https://www.accenture.com/us-en/careers/explore-careers/area-of-interest/consulting-careers works
# 21 fails
# 22 fails
# 41 ses fails
# 42 weird

nr <- 48
for(nr in seq(urls)[47:3672]){
  url <- urls[nr]
  url
  indeed_results[[url]] <- tryCatch(
    find_job_page(url, ses, use_phantom = TRUE),
    error = function(e){
      print("Call to find_job_page failed with:")
      print(e)
      return("")
    }
  )
   save(indeed_results, file = "data/job_page_candidates_indeed.RData")
}

#paypal, facebook, instagram, youtube, cookiebot.com

# [1] "https://birdieco.de/barista-m-w-d-minijob-werksstudent-tagesgastronomie/#respond"
#
# Selenium message:Unable to locate element: {"method":"xpath","selector":"/html"}


#Hier finden Sie unsere Jobangebote
# link: careerfactors
#
# 1] "https://www.adiro.eu/jobs/"
# [1] "https://www.adiro.eu/"
# [1] "https://www.adiro.eu/jobs/"

nr <- 51
url <- urls[[nr]]
url
indeed_results[[url]]


# which(indeed_results %>% sapply(typeof) == "list")
