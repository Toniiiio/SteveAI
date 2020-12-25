library(httr)
library(rvest)
library(magrittr)
library(urltools)
library(dplyr)

setwd("/home/rstudio/SteveAI/")
load("/home/rstudio/SteveAI/scraperGoogle.RData")
source("/home/rstudio/sivis/rvestFunctions.R")

dateToday <- Sys.Date()
# ItemsPerPage <- 50
amtSecondsSleep <- 3
durationFileName <- paste0("/home/rstudio/SteveAI/scrapeDuration_", dateToday, ".csv")
targetColumns <- c("datePosted", "description", "hiringOrganization.department.name", "identifier.name", 
                   "identifier.value", "jobLocation.address.addressLocality", "title", "url", "employmentType")

output <- list()


scrapeGETGOOGLE <- function(name){
  print(name)
  fileNameJobDesc = paste0("dataGOOGLE/JobDescLinks_GETGOOGLE_", name, "_", dateToday, ".csv")
  if(!file.exists(fileNameJobDesc)){
    start <- Sys.time()
    output <- list()
    result <- data.frame("NonEmptyValue")
    
    output <- list()
    jobData <- "InitWithValue"
    nr <- 1
    
    getURL <- paste0("https://hire.withgoogle.com/v2/api/t/", name, "/public/jobs/")
    GETContent <- getURL %>% GET %>% content
    GETContentFlat <- lapply(GETContent, unlist)
    jobDataAll <- do.call(what = bind_rows, args = GETContentFlat)
    jobData <- jobDataAll %>% select(one_of(targetColumns))

    write.csv2(
      x = jobData,
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

name <- "businessinsidercom"
name <- compNames[1]
nr <- 1
for(name in compNames){
  print(name)
  tryCatch(
    scrapeGETGOOGLE(name = name),
    error = function(err){
      nr <<- nr + 1
      print(paste0("nr: ", nr))
      print(err)
    }
  )
  
  print(paste0("DONE - SAVING ", name))
}

