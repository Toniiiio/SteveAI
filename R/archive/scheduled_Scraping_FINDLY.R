library(glue)
library(magrittr)
library(httr)
library(jsonlite)
library(dplyr)

setwd("/home/rstudio/SteveAI/")
load("/home/rstudio/SteveAI/scraperFINDLY.RData")
source("/home/rstudio/sivis/rvestFunctions.R")


amtJobs <- 500
foundJobs <- TRUE
targetColumns <- c("title", "primary_city", "id", "entity_status", "language", "industry",  "ref", "description", "primary_category", 
                   "salary", "job_type", "travel", "level",  "relocation", "education", "years_experience", "open_positions", 
                   "department", "shift", "recruiter", "parent_category",  "store_id", "close_date", "open_date", "url", 
                   "seo_url", "importance",  "apply_rate")


dateToday <- Sys.Date()
ItemsPerPage <- 50
amtSecondsSleep <- 3
durationFileName <- paste0("/home/rstudio/SteveAI/scrapeDuration_", dateToday, ".csv")

name = "AMITA"
scrapeFINDLY <- function(name){
  print(name)
  fileNameJobDesc = paste0("dataFINDLY/JobDescLinks_FINDLY_", name, "_", dateToday, ".csv")
  if(!file.exists(fileNameJobDesc)){
    start <- Sys.time()
    compNr <- findlyScrapers[[name]]
    amtJobs <- 500
    foundJobs <- TRUE
    nr <- 1
    
    output <- list()
    startNr <- 1
    while(foundJobs){
      print(startNr)
      start <- (startNr - 1)*amtJobs
      url <- glue("https://jobsapi3-internal.findly.com/api/job?callback=jobsCallback&offset={start}&sortfield=compliment&sortorder=descending&Limit={amtJobs}&Organization={compNr}")
      json <- url %>%
        GET %>%
        content(type = "text", encoding = "UTF-8") %>%
        gsub(pattern = "jobsCallback[(]", replacement = "") %>%
        gsub(pattern = "})", replacement = "}") %>%
        fromJSON
      
      
      foundJobs <- length(json$queryResult) > 0
      if(foundJobs){
        output[[startNr]] <- json %$% queryResult %>% select(targetColumns)
      }
      startNr <- startNr + 1
    }
    dt <- do.call(rbind, output)

    write.csv2(
      x = dt, 
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

name <- names(findlyScrapers)[1]
for(name in names(findlyScrapers)){
  tryCatch(
    scrapeFINDLY(name = name),
    error = function(err){
      nr <<- nr + 1
      print(paste0("nr: ", nr))
      print(err)
      
      # write.table(
      #   x = data.frame(name = paste0(
      #     Sys.time(), ": Company: ", toBeScraped[nr],
      #     " Error1: ", err,
      #     " Error2: ", remDr$errorDetails()$localizedMessage)
      #   ), 
      #   file = errorfileName, 
      #   append = TRUE, 
      #   row.names = FALSE, 
      #   col.names = FALSE
      # )
    }
  )
  
  print(paste0("DONE - SAVING ", name))
}








