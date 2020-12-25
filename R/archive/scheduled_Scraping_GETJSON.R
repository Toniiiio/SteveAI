# todo TUI und phoenix same provider or similar?

library(httr)
library(rvest)
library(magrittr)
library(dplyr)
library(urltools)
library(jsonlite)

setwd("/home/rstudio/SteveAI/")
source("/home/rstudio/sivis/rvestFunctions.R")
load("scraperJS.RData")
url <- "https://www.bmwgroup.jobs/content/grpw/websites/jobfinder.joblist.de.json"
ff <- url %>% GET %>% content %$% data
fff <- do.call(bind_rows, ff)
ff[5]
dateToday <- Sys.Date()
# ItemsPerPage <- 50
amtSecondsSleep <- 3
durationFileName <- paste0("/home/rstudio/SteveAI/scrapeDuration_", dateToday, ".csv")

jsScraper$ryanair$targetColumns <- c("id", "full_title", "state", "department", "url", "application_url", 
                                     "created_at", "description", "requirements", "benefits", "search_location", 
                                     "short_description", "employment_type", "industry", "function", 
                                     "experience", "education")
jsScraper$phoenix$targetColumns <- c("id", "language", "position", "jobPublicationURL", "startDate", "endDate", "tasks")
save(jsScraper, file = "scraperJS.RData")
name <- "ryanair"
name <- "phoenix"

scrapeGETJSON <- function(name){
  print(name)
  scraper <- jsScraper[[name]]
  fileNameJobDesc = paste0("dataJSON/JobDescLinks_GETJSON_", name, "_", dateToday, ".csv")
  if(!file.exists(fileNameJobDesc)){
    start <- Sys.time()
    
    jsonTextRaw <- GET(url = scraper$jsUrl) %>% content(as = "text", encoding = "UTF-8")
    jobDataAll <- jsonTextRaw %>% gsub(pattern = scraper$toReplace, replacement = "") %>% fromJSON 
    jobData <- jobDataAll[names(jobDataAll) %in% scraper$targetColumns]

    write.csv2(
      x = jobData, 
      file = fileNameJobDesc, 
      row.names = FALSE
    )
    
    end <- Sys.time()
    scrapeDuration <- as.numeric(end - start)
    
    write.table(
      data.frame(
        name = name,
        duration = scrapeDuration
      ),
      file = durationFileName, 
      append = TRUE, 
      col.names = FALSE,
      row.names = FALSE
    )
  }
}


nr <- 1
for(name in names(jsScraper)){
  print(name)
  tryCatch(
    scrapeGETJSON(name = name),
    error = function(err){
      nr <<- nr + 1
      print(paste0("nr: ", nr))
      print(err)
    }
  )
  
  print(paste0("DONE - SAVING ", name))
}

