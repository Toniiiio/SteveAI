library(httr)
library(rvest)
library(magrittr)
library(dplyr)
library(urltools)

setwd("/home/rstudio/SteveAI/")
load("/home/rstudio/SteveAI/scraperJIBE.RData")
# save(compNames, file = "/home/rstudio/SteveAI/scraperJIBE.RData")
source("/home/rstudio/sivis/rvestFunctions.R")

# https://careers.compassgroupcareers.com/api/jobs?page=2&internal=false&userId=580208b1-144b-4054-a158-4fdc9f6031d9&sessionId=9cd61729-ccff-4a6e-a564-5d535e3c27a3&deviceId=2953492370&domain=compassgroup.jibeapply.com

dateToday <- Sys.Date()
# ItemsPerPage <- 50
amtSecondsSleep <- 3
durationFileName <- paste0("/home/rstudio/SteveAI/scrapeDuration_", dateToday, ".csv")
targetColumns <- c("data.req_id", "data.title", "data.city", "data.state", 
                   "data.country", "data.categories.name", "data.apply_url", "data.meta_data.googlejobs.jobHash", 
                   "data.meta_data.googlejobs.derivedInfo.locations.postalAddress.addressLines", 
                   "data.meta_data.googlejobs.derivedInfo.locations.postalAddress.locality", 
                   "data.meta_data.googlejobs.jobSummary", "data.meta_data.canonical_url", 
                   "data.meta_data.last_mod", "data.meta_data.gdpr", "data.create_date", 
                   "data.category", "data.update_date"
)

scrapeGETJIBE <- function(name){
  print(name)
  fileNameJobDesc = paste0("dataJIBE/JobDescLinks_GET_", name, "_", dateToday, ".csv")
  if(!file.exists(fileNameJobDesc)){
    start <- Sys.time()
    output <- list()
    result <- data.frame("NonEmptyValue")
    
    urlGen <- function(nr){
      paste0("https://", name, ".jibeapply.com/api/jobs?page=", nr, "&limit=100")
    }
    
    output <- list()
    jobData <- "InitWithValue"
    nr <- 1
    
    while(length(jobData)){
      print(nr)
      getURL <- urlGen(nr)
      
      GETContent <- getURL %>% GET %>% content %$% jobs
      GETContentFlat <- lapply(GETContent, unlist)
      jobData <- do.call(what = bind_rows, args = GETContentFlat)
      jobData <- jobData %>% select(one_of(targetColumns))
      
      output[[nr]] <- jobData
      nr <- nr + 1
    }
    tbl <- do.call(what = bind_rows, args = output)
    
    write.csv2(
      x = tbl, 
      file = fileNameJobDesc, 
      row.names = FALSE
    )
    
    
    end <- Sys.time()
    scrapeDuration <- as.numeric(end - start)
    
    Sys.sleep(amtSecondsSleep)
    
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

name <- compNames[2]
nr <- 1
for(name in compNames){
  print(name)
  tryCatch(
    scrapeGETJIBE(name = name),
    error = function(err){
      nr <<- nr + 1
      print(paste0("nr: ", nr))
      print(err)
    }
  )
  
  print(paste0("DONE - SAVING ", name))
}

