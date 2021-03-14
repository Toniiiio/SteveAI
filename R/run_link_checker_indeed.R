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

  # powershell
  # docker ps -aq | foreach {docker rm $_}




  source("R/is_job_offer_page.R")
  source("R/handle_links.R")
  source("R/link_checker.R")
  source("R/target_text.R")
  load("data/comp_urls_indeed.RData")
  load("data/job_page_candidates_indeed.RData")
  urls <- unlist(comp_urls)
  #ses <<- start_phantom()


  # if(!exists("indeed_reuslts")){
  #   indeed_results2 <- list()
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

  d <- urls %>% grepl(pattern = "axa") %>% which
  d
  d %>% urls[.]

  pjs <<- webdriver::run_phantomjs()
  ses <<- webdriver::Session$new(port = pjs$port)

  # element not visible 415, 416

  #424: Error
  #429: MyWorkdayjobs
  # 431: no jobs or doesnt find?

  url <- "https://www.wirpflegen.de/"
  nr <- 575
  for(nr in seq(urls)[585:3672]){
    url <- urls[nr]
    url
    indeed_results2[[url]] <- tryCatch(
      find_job_page(url, ses, use_phantom = TRUE),
      error = function(e){
        print("Call to find_job_page failed with:")
        print(e)
        return("")
      }
    )
    save(indeed_results2, file = "data/job_page_candidates_indeed.RData")
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

  nr <- 58
  url <- urls[[nr]]
  url
  indeed_results[[url]]


  # which(indeed_results %>% sapply(typeof) == "list")


  # [1] "https://www.irishjobs.ie/myprofile/saved-jobs"
  # [1] "https://www.irishjobs.ie/Jobs/IT"
  # [1] "https://www.irishjobs.ie/All-Jobs"
  # [1] "https://www.irishjobs.ie/All-Jobs?Recruiter=Agency"
  # [1] "https://www.irishjobs.ie/Jobs/Retail-General-Manager-Job-8563065.aspx"

}

