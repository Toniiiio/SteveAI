# Open Todo:
# rvestOutLinkRaw <- getRvestHref(

library(httr)
library(magrittr)
library(dplyr)
library(rvest)
library(stringr)
library(glue)
library(urltools)

setwd("/home/rstudio/SteveAI/")
load("/home/rstudio/SteveAI/scraperGET.RData")
source("/home/rstudio/sivis/rvestFunctions.R")

dateToday <- Sys.Date()
# ItemsPerPage <- 50
# amtSecondsSleep <- 3
durationFileName <- paste0("/home/rstudio/SteveAI/scrapeDuration_", dateToday, ".csv")

# urlGen <- function(nr){
#   limit = 50
#   offset <- paste0("/ads-offset/", (nr - 1)*limit)
#   if(nr == 1) offset = ""
#   paste0("https://karriere.aldi-sued.de/jobsuche", offset,"/ads-limit/", limit,"/?type=json&tx_typoscriptrendering%5Bcontext%5D=%7B%22record%22%3A%22tt_content_108%22%2C%22path%22%3A%22tt_content.list.20.uialdisuedjobs_ads%22%7D&cHash=de0ebcd99ff5486424ea9fcb032748ba")  
# }
# urlGen(1)
# 
# 
# scraper <- list(
#   urlGen = urlGen,
#   subsetBy = "result",
#   XPath = "/html/body/table/tbody/tr/td/a",
#   locationXPath = "/html/body/table/tbody/tr/td[2]",
#   vollzeitXPath = "/html/body/table/tbody/tr/td[3]",
#   startXPath = "/html/body/table/tbody/tr/td[4]"
# )
# name <- "ALDI-SUED"

setwd("/home/rstudio/SteveAI/")
nr <- 1
scrapeGETHTML <- function(name){
  urlGen <- scraper$urlGen
  XPath <- scraper$XPath
  output = list()
  rvestOut = "NonEmptyInitVal"
  continueScraping <- TRUE
  existsAlready <- 0
  maxJobs = 90000
  
  iterNr <- 1
  while(continueScraping){
    print(continueScraping)
    getURL <- urlGen(nr = iterNr)

    code <- getURL %>% GET %>% content %$% get(scraper$subsetBy) %>% read_html
    
    outXPath <- list()
    nms <- names(scraper)
    idx <- grep(pattern = tolower("XPath"), tolower(nms))
    XPathesToScrape <- setdiff(nms[idx], "AmtJobsXPath")
    
    rvestOutRaw <- lapply(X = scraper[XPathesToScrape], FUN = getRvestTexts, code = code)
    
    if(sum(lengths((rvestOutRaw)))){
      XPathOutput <- do.call(bind_cols, rvestOutRaw)
      colnames(XPathOutput) <- gsub(pattern = "XPath", replacement = "jobName", colnames(XPathOutput))
      
      out <- cbind(
        data.frame(
          comp = name,
          date = Sys.Date()
        ), 
        XPathOutput
      )
      
      print(iterNr)
      if(length(output)) existsAlready <- sum(sapply(output, FUN = identical, y = out))
      output[[iterNr]] <- out
      
      amtScrapedJobsTotal <- length(unlist(lapply(output, "[[", "jobName")))
      amtScrapedJobsThisPage <- sum(lengths((rvestOutRaw)))
      continueScraping <- amtScrapedJobsThisPage & amtScrapedJobsTotal < maxJobs
      
      if(existsAlready > 0) continueScraping <- FALSE
      
      iterNr <- iterNr + 1
    }else{
      continueScraping <- FALSE
    }
    
    if(name == "FACEBOOK" & iterNr == 28) break
  }
  
  fileNameJobDesc = paste0("data/JobDescLinks_", name, "_", Sys.Date(), ".csv")
  write.csv2(x = do.call(what = rbind, args = output), file = fileNameJobDesc, row.names = FALSE)
  print("DONE - SAVING NOW")
}


out <- list()
scraperNr <- 36
durationFileName <- paste0("/home/rstudio/SteveAI/scrapeDuration_", Sys.Date(), ".csv")
for(scraperNr in 1:length(scraperRvestMultiPage)){
  start <- Sys.time()
  print(paste0("scraperNr: ", scraperNr))
  name <- names(scraperRvestMultiPage)[scraperNr]
  print(name)
  out[[name]] <- tryCatch(
    expr = scrapeRvestMPage(name = name),
    error = function(e){  
      print("error")
      print(nr)
      print(name)
      print(e)
    } 
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





