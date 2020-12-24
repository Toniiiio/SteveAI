library(httr)
library(rvest)
library(magrittr)
library(dplyr)
library(glue)
library(urltools)

setwd("/home/rstudio/SteveAI/")
load("/home/rstudio/SteveAI/scraperGET.RData")
source("/home/rstudio/sivis/rvestFunctions.R")

dateToday <- Sys.Date()
# ItemsPerPage <- 50
# amtSecondsSleep <- 3
durationFileName <- paste0("/home/rstudio/SteveAI/scrapeDuration_", dateToday, ".csv")

scrapeGET <- function(name){
  print(name)
  fileNameJobDesc = paste0("dataGET/JobDescLinks_GET_", name, "_", dateToday, ".csv")
  if(!file.exists(fileNameJobDesc)){
    start <- Sys.time()
    output <- list()
    result <- data.frame("NonEmptyValue")
    
    output <- list()
    res <- "InitWithValue"
    nr <- 1
    
    scraper <- scrapers[[name]]
    while(length(res)){
      Sys.sleep(3)
      print(nr)
      getURL <- scraper$urlGen(nr)
      
      res <- scheduledGET(url = getURL, targetKeys = scraper$targetKeys, base = scraper$base, baseFollow = scraper$baseFollow)$res
      output[[nr]] <- res
      nr <- nr + 1
      
    }
    tbl <- do.call(what = rbind, args = output)
    
    write.csv2(
      x = tbl, 
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

name <- names(scrapers) %>% tail(1)
for(name in names(scrapers)){
  print(name)
  tryCatch(
    scrapeGET(name = name),
    error = function(err){
      nr <<- nr + 1
      print(paste0("nr: ", nr))
      print(err)
      
      # write.table(
      #   x = data.frame(name = paste0(
      #     Sys.time(), ": Company: ", name
      #   )), 
      #   file = errorfileName, 
      #   append = TRUE, 
      #   row.names = FALSE, 
      #   col.names = FALSE
      # )
    }
  )
  
  print(paste0("DONE - SAVING ", name))
}

