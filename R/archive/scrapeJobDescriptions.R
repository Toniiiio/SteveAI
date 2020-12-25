# Freecell 4775407
library(RSelenium)
portNr = 20000 + as.numeric(Sys.Date()) + sample(1:10000, 1)
system(paste0("sudo -kS docker run -d -p ", portNr,
              ":4444 selenium/standalone-firefox:2.53.0"),
       input = "Donthack1")
remDr <<- remoteDriver(
  remoteServerAddr = "localhost",
  port = portNr,
  browserName = "firefox"
)
Sys.sleep(2)
remDr$open()

# 
options(stringsAsFactors = FALSE)
setwd("/home/rstudio/SteveAI")
xx <- list.files("data")
nms = xx[grep(pattern = "Desc", x = xx)]
fileInfo = file.info(paste0("data/", nms))
filesToRead = nms[which(fileInfo$size > 3)]
load("JobDescriptions/filesAlreadyRead.RData")
filesToRead = filesToRead[!(filesToRead %in% filesAlreadyRead)]

if(length(filesToRead)){
  data = list()
  for(nr in 1:length(filesToRead)){
    data[[nr]] = read.csv(paste0("data/", filesToRead[nr]))$x
  }
  jobDescLinks = unlist(data)
  
  # html = list()
  load("JobDescriptions/jobDescr.RData")
  alreadyScraped = names(html)
  jobDescLinks <- jobDescLinks[!(jobDescLinks %in% alreadyScraped)]
  amountIterations <- length(jobDescLinks)
  
  for(iter in 300:ceiling(amountIterations / 50)){
    print(
      paste0("iter: ", iter)
    )
    alreadyScraped = names(html)
    jobDescLinks <- jobDescLinks[!(jobDescLinks %in% alreadyScraped)]
    nr = 1
    for(nr in 1:(min(50, length(jobDescLinks)))){ #length(jobDescLinks)
      print(nr)
      getPageText <- function(link){
        remDr$navigate(link)
        remDr$findElement("xpath", "//html")$getElementText()[[1]]
      }
      jobDescLinks[nr]
      html[[jobDescLinks[nr]]] <- tryCatch(
        expr = getPageText(jobDescLinks[nr]), 
        error = function(error) print(error)
      )
    }
    save(html, file = "JobDescriptions/jobDescr.RData")
  }
  
  
  # filesAlreadyRead = c(filesAlreadyRead, filesToRead)
  save(filesAlreadyRead, file = "JobDescriptions/filesAlreadyRead.RData")
}





# Identification on browser side + Test definition. 
# Automated testing - Scheduling on client / R side. 



remDr$navigate("https://www.daimler.com/karriere/jobsuche/")
remDr$screenshot(TRUE)

elem = remDr$findElement("xpath", "/*[text() = 'Schließen']")
