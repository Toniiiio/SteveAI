library(httr)
library(rvest)
library(urltools)
library(dplyr)

setwd("/home/rstudio/SteveAI/")
load("/home/rstudio/SteveAI/scraperLEVER.RData")
source("/home/rstudio/sivis/rvestFunctions.R")

dateToday <- Sys.Date()
# ItemsPerPage <- 50
amtSecondsSleep <- 3
durationFileName <- paste0("/home/rstudio/SteveAI/scrapeDuration_", dateToday, ".csv")
targetColumns <- c("categories.commitment", "categories.location", "categories.team", "createdAt", "descriptionPlain",  "id", "text", "hostedUrl")

# url <- "https://api.lever.co/v0/postings/quora"
# xx <- url %>% GET %>% content
# temp <- lapply(tempx$jobs, unlist)
# ff <- do.call(what = bind_rows, args = temp)
name <- "returntocorp"
scrapeGETLEVER <- function(name){
  print(name)
  fileNameJobDesc = paste0("dataLEVER/JobDescLinks_GETLEVER_", name, "_", dateToday, ".csv")
  if(!file.exists(fileNameJobDesc)){
    start <- Sys.time()
    output <- list()
    result <- data.frame("NonEmptyValue")
    
    urlGen <- function(nr){
      paste0("https://api.lever.co/v0/postings/", name)
    }
    
    output <- list()
    jobData <- "InitWithValue"
    
    
    getURL <- urlGen(nr)
    GETContent <- getURL %>% GET %>% content 
    GETContentFlat <- lapply(GETContent, unlist)
    if(!sum(names(GETContentFlat) == c("ok", "error"))){
      jobData <- do.call(what = bind_rows, args = GETContentFlat)
      jobData %>% select(one_of(targetColumns))
      
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
    }else{
      print("no data")
    }
  }
}

nr <- 1
name <- "wonder" #compNames[1]
for(name in compNames){
  print(name)
  tryCatch(
    scrapeGETLEVER(name = name),
    error = function(err){
      nr <<- nr + 1
      print(paste0("nr: ", nr))
      print(err)
    }
  )
  
  print(paste0("DONE - SAVING ", name))
}

