# add_http <- function(url, comp_data){
#
#   domain <- urltools::domain(comp_data$url)
#   domain_short <- gsub(domain, pattern = "www.", replacement = "")
#   # requirement: "https://www.clark.de/de/jobs?gh_jid=4924568002" + "boards.greenhouse.io"
#   is_sub_url <- (!grepl(domain_short, url)  & !grepl(pattern = "[.]de|[.]com|[.]net", url, perl = TRUE)) |
#     substring(url, first = 1, last = 1) == "/"
#
#   if(is_sub_url){
#     url <- paste0(
#       "https://",
#       domain,
#       "/",
#       url
#     )
#   }
#
#   # todo: very dirty
#   # reason: https://www.cofinpro.de//karriere/stellenanzeige/manager-mit-schwerpunkt-foerderbanken leads to an error
#   url <- gsub(x = url, pattern = "//", replacement = "/", fixed = TRUE)
#   url <- gsub(x = url, pattern = "http:/", replacement = "http://", fixed = TRUE)
#   gsub(x = url, pattern = "https:/", replacement = "https://", fixed = TRUE)
#
# }
#
# link_to_article <- function(links){
#
#   read_html_txt <- function(url){
#     tryCatch(htm2txt::gettxt(url), error = function(e){
#       warning(paste0(url, "fails with", e))
#       return("ERROR")
#     })
#   }
#
#   job_descs_raw <- lapply(links, read_html_txt)
#   job_descs <- job_descs_raw[!duplicated(job_descs_raw) & job_descs_raw != "ERROR"]
#   if(length(job_descs) < 2){
#     warning("Not enough article found can not exclude header and footer.")
#     return(job_descs_raw)
#   }
#
#   iter <- min(20, length(job_descs)) - 1
#   end_of_starts <- rep(NA, iter - 1)
#   nr <- 200
#   for(nr in 2:(iter + 1)){
#     end_of_starts[nr - 1] <- findEnd(text1 = job_descs[[1]], text2 = job_descs[[nr]], reverse = FALSE)
#   }
#   end_of_start <- min(end_of_starts)
#
#   iter <- min(20, length(job_descs)) - 1
#   start_of_endings <- rep(NA, iter - 1)
#   for(nr in 2:(iter + 1)){
#     start_of_endings[nr - 1] <- findEnd(text1 = job_descs[[1]], text2 = job_descs[[nr]], reverse = TRUE)[1]
#   }
#   start_of_ending <- max(start_of_endings)
#
#   cut_start <- substring(job_descs[[1]], 1, end_of_start)
#   cut_end <- substring(job_descs[[1]], start_of_ending[1], nchar(job_descs[[1]]))
#
#   job_descs_out <- rep(NA, length(job_descs_raw))
#   nr <- 199
#   for(nr in seq(job_descs_raw)){
#     print(nr)
#     job_descs_out[nr] <- extract_article(text_raw = job_descs_raw[nr], cut1 = cut_start, cut2 = cut_end)
#   }
#
#   return(job_descs_out)
#
# }
#
#
#
# library(glue)
# library(magrittr)
# library(rvest)
#
# scrape_job_descs <- function(){
#
#   setwd("~")
#   source("SteveAI/R/jobLinks.R")
#   # 1. read all job data
#   # 2. Filter all that have links
#   # 3. Filter for the ones that arent scraped yet.
#   # 4. Group by company to identify the format and what to remove from the job desc page.
#
#   db_name <- "rvest_scraper.db"
#   target_table_job <- "RVEST_SINGLE_JOBS"
#   conn <- DBI::dbConnect(RSQLite::SQLite(), db_name)
#
#
#   data <- DBI::dbGetQuery(
#     conn = conn,
#     statement = glue("SELECT * FROM {target_table_job}")
#   )
#
#   keep <- which(!is.na(data$links))
#
#   length(keep)
#
#   comp_nr <- 3
#   with_links <- data[keep, ]
#   all_comps <- with_links$comp %>% unique
#
#   all_job_descs <- vector("list", length(all_comps))
#
#   #seq(all_comps)
#   # 10 -> error, 15
#   # todo: cofinpro - cut after WEITERE JOBANZEIGEN
#
#   comp_nr <- 9
#   for(comp_nr in 10:32){
#
#     comp_name <- all_comps[comp_nr]
#     print(comp_name)
#     comp_data <- SteveAI::rvestScraper[[comp_name]]
#     doc <- comp_data$url %>% read_html()
#     links <- doc %>%
#       html_nodes(xpath = comp_data$href) %>%
#       html_attr(name = "href")
#
#     links <- sapply(links, add_http, comp_data = comp_data, USE.NAMES = FALSE)
#     job_descs <- link_to_article(links)
#
#     all_job_descs[[comp_nr]] <- data.frame(
#       links = links,
#       job_descs = job_descs,
#       date = Sys.Date()
#     )
#     save(all_job_descs, file = "~/all_job_descs.RData")
#   }
#
# }
#
#
# #load("~/all_job_descs.RData")
# #26
#
# all_job_descs[[9]]$links[1]
# all_job_descs[[9]]$job_descs[6] %>% cat
# #3
# #7
# #9
# #10
