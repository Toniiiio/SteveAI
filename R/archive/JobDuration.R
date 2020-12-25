setwd("/home/rstudio/SteveAI/data")
fileNamesRaw <- list.files()
fileNames = fileNamesRaw[-grep(pattern = "JobDescLinks_", fileNamesRaw)]
compNames <- unique(sapply(strsplit(fileNames, "_201"), "[", 1 ))


positionList <- list()

# compNr <- 9
for(compNr in 1:length(compNames)){
  print(compNr)
  idxs <- grep(compNames[compNr], fileNames)
  jobDatas <- list()  
  
  # fileName <- fileNames[idxs][2]
  for(fileName in fileNames[idxs]){
    splitted <- strsplit(fileName, "_")[[1]]
    dates <- splitted[length(splitted)]
    idx <- length(jobDatas) + 1
    if(!is.na(fileName) & file.size(fileName) > 10){
      jobDatas[[idx]] <-  read.csv2(fileName, sep = ",", stringsAsFactors = FALSE)[, 2]
      names(jobDatas)[idx] <- gsub(".csv", "", dates)
    }
  }
  
  positions <- list()
  
  # nr <- 1
  keep <- sapply(jobDatas, function(data) sum(is.na(data))) == 0
  jobDatas <- jobDatas[keep]
  if(length(jobDatas)){
    for(nr in 1:length(jobDatas)){
      jobData <- jobDatas[[nr]]
      date <- names(jobDatas[nr])
      newJobs <- setdiff(jobData, names(positions))
      existingJobs <- intersect(names(positions), jobData)
      lst <- as.list(rep(date, length(newJobs)))
      names(lst) <- newJobs
      positions <- c(positions, lst)
      for(jobName in existingJobs){
        positions[[jobName]] <- c(positions[[jobName]], date)  
      }
    }
    positionList[[compNr]] <- positions
    names(positionList)[compNr] <- compNames[compNr]
  }
}

#### SCRAPED JOBS PER DAY

# positionList
# sort(lengths(positionList), decreasing = TRUE)
dd <- unlist(positionList)
amtJobsPerDay <- sort(table(dd))

table(dd)
barplot(table(dd))

names(positionList)
lengths(positionList)
ff <- names(positionList)
# ff
# 

load("../SteveAI/scraper.RData")
# 
# 
names(scraper)[which(nchar(names(positionList)) == 0)]
scraper[which(nchar(names(positionList)) == 0)]
# 
# /html/body/div/div/main/div/div/div/div/div/div/a/p
# 
# 
# data <- read.csv2("../SteveAI/data/CREDITPLUS_2019-06-05.csv", sep = ",",
#                   stringsAsFactors = FALSE)
# data$x
