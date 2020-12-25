library(httr)
library(rvest)
library(magrittr)
library(dplyr)
library(glue)
library(urltools)

setwd("/home/rstudio/SteveAI/")
tmpUrls <- tmpUrls[setdiff(names(tmpUrls), "fmcna")]
source("/home/rstudio/sivis/rvestFunctions.R")

dateToday <- Sys.Date()
# ItemsPerPage <- 50
# amtSecondsSleep <- 3
durationFileName <- paste0("/home/rstudio/SteveAI/scrapeDuration_", dateToday, ".csv")

baseUrl <- tmpUrls[1]
name <- "fmcna"


scrapers <- list()
scrapers$CVS <- list(
  url = "https://sfapi.azure-api.net/cloudjobs/odata/Search?api-version=1.0",
  genBody = function(nr){
    amtJobs <- 100
    list(FilterOnly = "false", ClientId = 14319L, SiteId = 23L, 
         JobQuery = structure(list(), .Names = character(0)), sid = "b5071543-a620-4803-9727-bc66064380ae", 
         uid = "ece336d2-4a16-442f-a70c-853b4c7ab08d", PageSize = amtJobs,
         Offset = (nr - 1)*amtJobs, JobFields = "UrlJobTitle,JobId,JobTitle,DisplayJobId,LongTextField2,MediumTextField1,LongTextField1")
  }
)

scrapers$VOVONIA <- list(
  url = "https://karriere.vonovia.de/api/sitecore/jobportal/search",
  genBody = function(nr){
    amtJobs <- 100
    list(Location = "", LocationLatitude = "", LocationLongitude = "", Radius = "", Seniority = "", Term = "", 
         Workspace = "", entriesCount = amtJobs, entriesStart = amtJobs*(nr - 1), 
         jobDetailLinkTargetItemId = "1a9b0279-2cff-4b37-aa8b-dc94548b2035", sortBy = "job_date")
  }
)


nr <- 1



name <- "VOVONIA"
name <- "CVS" ##geht nur bis 50*100 - gibt aber mehr seiten wenn man sich bis seite 50 durchklickt.
scrapePOST <- function(name){
  print(name)
  fileNameJobDesc = paste0("data/JobDescLinks_TMP_", name, "_", dateToday, ".csv")
  if(!file.exists(fileNameJobDesc)){
    start <- Sys.time()
    output <- list()
    nr <- 100
    
    while(length(unlist(cont)) > 6){
      Sys.sleep(0)
      print(nr)
      response <- POST(
        url = scrapers[[name]]$url, 
        encode = "json", 
        body = scrapers[[name]]$genBody(nr)
      )
      
      cont <- unlist(content(response), recursive = FALSE)
      if(length(unlist(cont)) > 6){
        output[[nr]] <- res 
      }
      
      res <- do.call(what = rbind, args = cont)

      nr <- nr + 1
    }
    
    result <- do.call(rbind, output)
    
    write.csv2(
      x = result, 
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
for(name in names(tmpUrls)){
  print(name)
  tryCatch(
    scrapeTMP(name = name),
    error = function(err){
      nr <<- nr + 1
      print(paste0("nr: ", nr))
      print(err)
    }
  )
  
  print(paste0("DONE - SAVING ", name))
}

