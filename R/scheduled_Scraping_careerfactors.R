rm(list = ls())
options(stringsAsFactors = FALSE)
library(rvest)
library(urltools)
library(glue)
load("/home/rstudio/SteveAI/scraper_CAREERFACTORS.RData")
# careerfactorURLS <- c(careerfactorURLS, "https://jobs.goodyear.com")
# names(careerfactorURLS)[length(careerfactorURLS)] <- "GOODYEAR"
# save(careerfactorURLS, file = "/home/rstudio/SteveAI/scraper_CAREERFACTORS.RData")
load("/home/rstudio/SteveAI/scraper_CAREERFACTORS_ItemsPerPage.RData")
# xitemsPerPage$PIRELLI <- 25
# save(xitemsPerPage, file = "/home/rstudio/SteveAI/scraper_CAREERFACTORS_ItemsPerPage.RData")
source("/home/rstudio/sivis/rvestFunctions.R")

html_text_na <- function(x, ...) {
  
  txt <- try(html_text(x, ...))
  if (inherits(txt, "try-error") |
      (length(txt)==0)) { return(NA) }
  return(txt)
  
}

print("Starting careerfactors")
setwd("/home/rstudio/SteveAI/")
nr <- 1
name <- "aib"
scrapeCareerfactors <- function(name){

  output = list()
  rvestOut = "NonEmptyInitVal"
  continueScraping <- TRUE
  existsAlready <- 0
  
  iterNr <- 1

  while(continueScraping){
    maxJobs <- 20000
    itemsPerPage <- xitemsPerPage[[name]]
    
    compDomain <- careerfactorURLS[[name]]
    url <- glue("{compDomain}/search/?q=&sortColumn=referencedate&sortDirection=desc&startrow={(iterNr - 1)*itemsPerPage}")
    
    xpathes <- data.frame(
      XPath = "/html/body/div/div/div/div/div/table/tbody/tr/td/span/a",
      locationXPath = "/html/body/div/div/div/div/div/table/tbody/tr/td/span[@class = 'jobLocation']",
      UntBereichXPath = "/html/body/div/div/div/div/div/table/tbody/tr/td/span[@class = 'jobDepartment']",
      sonstigeXPath = "/html/body/div/div/div/div/div/table/tbody/tr/td/span[@class = 'jobFacility']",
      seasonalXPath = "/html/body/div/div/div/div/div/table/tbody/tr/td/span[@class = 'jobShifttype']", 
      eingestelltAmXPath = "/html/body/div/div/div/div/div/table/tbody/tr/td/span[@class = 'jobDate']"
    )
    code <- read_html(x = url)
    dataRaw <- sapply(xpathes, function(xpath){
      html_nodes(x = code, xpath = xpath) %>% 
        html_text_na() %>%
        gsub(pattern = "\n|\t|  ", replacement = "")
    }) 
    linksRaw <- xpathes$XPath %>% html_nodes(x = code, xpath = .) %>% html_attr(name = "href") 
    links <- glue("{compDomain}{linksRaw}")
  
    if(sum(lengths((dataRaw))) & !all(is.na(dataRaw))){
      XPathOutput <- do.call(cbind, dataRaw)
      colnames(XPathOutput) <- gsub(pattern = "XPath", replacement = "jobName", colnames(XPathOutput))
      
      out <- cbind(
        data.frame(
          x = links,
          comp = name,
          date = Sys.Date()
        ), 
        XPathOutput
      )
      
      if(length(output)) existsAlready <- sum(sapply(output, FUN = identical, y = out))
      if(!existsAlready) output[[iterNr]] <- out
      
      amtScrapedJobsTotal <- length(unlist(lapply(output, "[[", "jobName")))
      amtScrapedJobsThisPage <- sum(lengths((dataRaw)))
      continueScraping <- amtScrapedJobsThisPage & amtScrapedJobsTotal < maxJobs
      
      if(existsAlready > 0) continueScraping <- FALSE
      
      iterNr <- iterNr + 1
    }else{
      continueScraping <- FALSE
    }
  }
  
  fileNameJobDesc = paste0("dataSUCCESSFACTORS/JobDescLinks_", name, "_", Sys.Date(), ".csv")
  writeToFile <- do.call(what = rbind, args = output)
  write.csv2(x = writeToFile[!duplicated(writeToFile), ], file = fileNameJobDesc, row.names = FALSE)
  print("DONE - SAVING NOW")
}


out <- list()
scraperNr <- 180
durationFileName <- paste0("/home/rstudio/SteveAI/scrapeDuration_", Sys.Date(), ".csv")
for(scraperNr in 1:length(careerfactorURLS)){
  start <- Sys.time()
  print(paste0("scraperNr: ", scraperNr))
  name <- names(careerfactorURLS)[scraperNr]
  print(name)
  out[[name]] <- tryCatch(
    expr = scrapeCareerfactors(name = name),
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




