library(rvest)
library(urltools)
load("/home/rstudio/sivis/scraperRvestMultiPage.RData")
source("/home/rstudio/sivis/rvestFunctions.R")


setwd("/home/rstudio/SteveAI/")
nr <- 1
name <- "VNG"
scrapeRvestMPage <- function(name){
  
  scraper <- scraperRvestMultiPage[name]
  urlGen <- scraper[[1]]$urlGen
  XPath <- scraper[[1]]$XPath
  output = list()
  rvestOut = "NonEmptyInitVal"
  continueScraping <- TRUE
  existsAlready <- 0
  
  url <- urlGen(nr = 1)
  if(!is.null(scraper[[1]]$AmtJobsXPath)){
    maxIterRaw <- getRvestText(
      url = url, 
      XPath = scraper[[1]]$AmtJobsXPath
    )
    if(length(grep(pattern = "of", x = maxIterRaw))) maxIterRaw <- strsplit(x = maxIterRaw, split = " of ")[[1]][2]
    maxJobs <- as.numeric(maxIterRaw)
    if(!length(maxJobs)) maxJobs <- 50000
  }else{
    maxJobs <- 50000
  }
  
  iterNr <- 1

  while(continueScraping){
    print(continueScraping)
    url <- urlGen(nr = iterNr)
    code <- read_html(x = url)
    
    rvestOutLinkRaw <- getRvestHref(
      url = url, 
      XPath = XPath
    )
    
    if(!is.na(rvestOutLinkRaw[1])){
      rvestOutLink <- sapply(rvestOutLinkRaw, extractJobLink, baseUrl = url, USE.NAMES = FALSE)      
    }else{
      rvestOutLink <- rvestOutLinkRaw
    }

    outXPath <- list()
    nms <- names(scraper[[1]])
    idx <- grep(pattern = tolower("XPath"), tolower(nms))
    XPathesToScrape <- setdiff(nms[idx], "AmtJobsXPath")
    
    rvestOutRaw <- lapply(X = scraper[[1]][XPathesToScrape], FUN = getRvestTexts, code = code)
    
    if(sum(lengths((rvestOutRaw)))){
      XPathOutput <- do.call(cbind, rvestOutRaw)
      colnames(XPathOutput) <- gsub(pattern = "XPath", replacement = "jobName", colnames(XPathOutput))
      
      out <- cbind(
        data.frame(
          x = rvestOutLink,
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
  
  fileNameJobDesc = paste0("dataMultiRvest/JobDescLinks_", name, "_", Sys.Date(), ".csv")
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




