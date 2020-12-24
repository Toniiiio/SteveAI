library(httr)
library(magrittr)
library(rvest)
library(jsonlite)
library(dplyr)
library(urltools)

setwd("/home/rstudio/SteveAI/")
load("/home/rstudio/SteveAI/scraperGREENHOUSE.RData")
source("/home/rstudio/sivis/rvestFunctions.R")
dateToday <- Sys.Date()
amtSecondsSleep <- 3
varNames <- c("absolute_url", "education", "internal_job_id", "location", 
              "metadata", "id", "updated_at", "requisition_id", "title")
durationFileName <- paste0("/home/rstudio/SteveAI/scrapeDuration_", dateToday, ".csv")

output <- list()
nr <- 74
amtComps <- length(compNames) - 1
for(listNr in 1:amtComps){
  print(listNr)
  name <- compNames[listNr]
  getUrl <- paste0("https://boards-api.greenhouse.io/v1/boards/", name, "/jobs")
  output[[listNr]] <- getUrl %>% GET %>% content
  
  fileNameJobDesc = paste0("dataGreenhouse/JobDescLinks_GREENHOUSE_", name, "_", dateToday, ".csv")
  temp <- output[[listNr]]$jobs
  if(is.null(temp)){
    output[[listNr]] <- NULL
  }else{
    temp <- lapply(temp, unlist)
    for(elemNr in 1:length(temp)){
      temp[[elemNr]][sapply(temp[[elemNr]], length) == 0] <- ""      
    }
    dt <- do.call(what = bind_rows, args = temp)
    
    write.csv2(
      x = dt, 
      file = fileNameJobDesc, 
      row.names = FALSE
    )
  Sys.sleep(amtSecondsSleep)
  }
}
