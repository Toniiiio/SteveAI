library(rvest)

options(stringsAsFactors = FALSE)
setwd("/home/rstudio/SteveAI")
xx <- list.files("data")
nms = xx[grep(pattern = "Desc", x = xx)]
fileInfo = file.info(paste0("data/", nms))
filesToRead = nms[which(fileInfo$size > 3)]
load("JobDescriptions/filesAlreadyRead.RData")
source("/home/rstudio/sivis/rvestFunctions.R")
filesToRead = filesToRead[!(filesToRead %in% filesAlreadyRead)]
filesToRead[1]

data = list()
nr <- 1
for(nr in 1:length(filesToRead)){
  data[[nr]] = read.csv(paste0("data/", filesToRead[nr]))$x
  names(data[nr]) <- filesToRead[nr]
}
names(data) <- filesToRead
jobDescLinks = unlist(data)

# html = list()
load("JobDescriptions/jobDescr.RData")
alreadyScraped = names(html)
jobDescLinks <- unique(jobDescLinks[!(jobDescLinks %in% alreadyScraped)])
amountIterations <- length(jobDescLinks)
  


iter <- 1
for(iter in 1:ceiling(amountIterations / 50)){
  print(
    paste0("iter: ", iter)
  )
  alreadyScraped = names(html)
  jobDescLinks <- jobDescLinks[!(jobDescLinks %in% alreadyScraped)]
  nr = 1
  for(nr in 1:(min(50, length(jobDescLinks)))){ #length(jobDescLinks)
    print(nr)
    html[[jobDescLinks[nr]]] <- tryCatch(
      expr = getRvestHtmlSource(url = jobDescLinks[nr]), 
      error = function(error){
        paste0(
          print(error) 
        )
      } 
    )
  }
  save(html, file = "JobDescriptions/jobDescr.RData")
}


