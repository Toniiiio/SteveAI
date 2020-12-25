library(httr)
library(rvest)
library(urltools)

setwd("/home/rstudio/SteveAI/")
load("/home/rstudio/SteveAI/scraperWORKDAY.RData")
source("/home/rstudio/sivis/rvestFunctions.R")

urls$RollsRoyceProf <- "https://rollsroyce.wd3.myworkdayjobs.com/professional"

save(urls, file = "/home/rstudio/SteveAI/WORKDAYData.RData")

dateToday <- Sys.Date()
ItemsPerPage <- 50
amtSecondsSleep <- 3
durationFileName <- paste0("/home/rstudio/SteveAI/scrapeDuration_", dateToday, ".csv")

scrapeWorkD <- function(name){
  print(name)
  fileNameJobDesc = paste0("data/JobDescLinks_WORKDAYS_", name, "_", dateToday, ".csv")
  if(!file.exists(fileNameJobDesc)){
    start <- Sys.time()
    baseUrl <- urls[name]
    output <- list()
    result <- data.frame("NonEmptyValue")
    nr <- 1
    
    while(nrow(result)){
      print(nr)
      url <- urlGenWorkDays(baseUrl = baseUrl, nr = nr)
      
      result <- scrapeWorkDays(url)
      output[[nr]] <- result
      Sys.sleep(amtSecondsSleep)
      nr <- nr + 1
    }
    dt <- do.call(what = rbind, args = output)
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

name <- names(urls)[1]
for(name in names(urls)){
  tryCatch(
    scrapeWorkD(name = name),
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

