library(httr)
library(rvest)
library(magrittr)
library(dplyr)
library(glue)
library(urltools)


setwd("/home/rstudio/SteveAI/")
load("/home/rstudio/SteveAI/scraperTMP.RData")
tmpUrls <- tmpUrls[setdiff(names(tmpUrls), "fmcna")]
source("/home/rstudio/sivis/rvestFunctions.R")


# tmpUrls <- c(tmpUrls, "https://jobs.carnival.com")
# names(tmpUrls)[length(tmpUrls)] <- "carnival"
# save(tmpUrls, file = "/home/rstudio/SteveAI/scraperTMP.RData")

dateToday <- Sys.Date()
# ItemsPerPage <- 50
# amtSecondsSleep <- 3
durationFileName <- paste0("/home/rstudio/SteveAI/scrapeDuration_", dateToday, ".csv")

baseUrl <- tmpUrls[1]
name <- "bd"

scrapeTMP <- function(name){
  print(name)
  fileNameJobDesc = paste0("dataTMP/JobDescLinks_TMP_", name, "_", dateToday, ".csv")
  if(!file.exists(fileNameJobDesc)){
    start <- Sys.time()

    locationXPath <- "/html/body/section/section/ul/li/a/span[@class = 'job-location'][1]"
    jobIdXPath <- "/html/body/section/section/ul/li/a/span[@class = 'job-id'][1]"
    XPath <- "/html/body/section/section/ul/li/a/h2"
    linkXPath <- "/html/body/section/section/ul/li/a"
    jobNames <- c("Init", "Val", "Non", "Empty")
    nr <- 1
    amtJobs <- 10000
    output <- list()
    
    while(length(jobNames) > 1){
      print(nr)
      getURL <- glue(tmpUrls[[name]], "/search-jobs/results?ActiveFacetID=0&CurrentPage=", nr,"&RecordsPerPage={amtJobs}&Distance=50&RadiusUnitType=0&Keywords=&Location=&Latitude=&Longitude=&ShowRadius=False&CustomFacetName=&FacetTerm=&FacetType=0&SearchResultsModuleName=Search+Results&SearchFiltersModuleName=Search+Filters&SortCriteria=0&SortDirection=0&SearchType=5&CategoryFacetTerm=&CategoryFacetType=&LocationFacetTerm=&LocationFacetType=&KeywordType=&LocationType=&LocationPath=&OrganizationIds=&PostalCode=&fc=&fl=&fcf=&afc=&afl=&afcf=")
      htmlDoc <- getURL %>% GET %>% content
      htmlDoc <- htmlDoc %$% results %>% read_html
      jobNames <- htmlDoc %>% html_nodes(xpath = XPath) %>% html_text 
      locations <- htmlDoc %>% html_nodes(xpath = locationXPath) %>% html_text 
      links <- htmlDoc %>% html_nodes(xpath = linkXPath) %>% html_attr("href") %>% paste0(baseUrl, .)
      ids <- htmlDoc %>% html_nodes(xpath = jobIdXPath) %>% html_text 
      if(!length(jobNames)) jobNames = ""
      if(!length(locations)) locations = ""
      if(!length(links)) links = ""
      if(!length(ids)) ids = ""
      
      if(length(jobNames)){
        output[[nr]] <- data.frame(
          jobNames = jobNames,
          locations = locations,
          links = links,
          ids = ids
        ) 
      }
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

