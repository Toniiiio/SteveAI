library(rvest)
load("/home/rstudio/SteveAI/scraper_rvest.RData")
source("/home/rstudio/sivis/rvestFunctions.R")
rvestScraping <- function(scraper){
  url <- scraper$url
  XPath <- scraper$XPath
  
  rvestOutRaw <- getRvestText(
    url = url, 
    XPath = XPath
  )
  
  rvestOut <- gsub(
    pattern = "\n|   |\tNew|\t", 
    replacement = "", 
    x = rvestOutRaw
  )
  
  rvestLink <- getRvestHref(
    url = url, 
    XPath = XPath
  )
  
  out <- data.frame(
    x = rvestLink,
    jobName = rvestOut,
    comp = name,
    date = Sys.Date(),
    location = "",
    eingestelltAm = "",
    bereich = ""
  )
  fileNameJobDesc = paste0("dataRvest/JobDescLinks_", name, "_", Sys.Date(), ".csv")
  write.csv2(x = out, file = fileNameJobDesc, row.names = FALSE)
}

print(Sys.time())
out <- list()
nr <- 1


durationFileName <- paste0("/home/rstudio/SteveAI/scrapeDuration_", Sys.Date(), ".csv")
for(nr in 1:length(rvestScraper)){
  start <- Sys.time()
  name <- names(rvestScraper)[nr]
  print(name)
  out[[name]] <- tryCatch(
    expr = rvestScraping(scraper = rvestScraper[[nr]]),
    error = function(e){
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
    row.names = FALSE,
    col.names = FALSE
  )
}

