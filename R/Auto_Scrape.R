# todo: switch to iframe: IDNOW example
# strange switchtoxpath function
# autodetect - increase elements
# https://career5.successfactors.eu/
# APOBANK reparieren
# wenn empty list, dann wechsel auf iframe

# ld <- list.files()
# file.rename(ld[1:27], paste0("candidate_archive/", ld[1:27]))
library(RSelenium, lib.loc = "/home/rstudio/R/x86_64-pc-linux-gnu-library/3.5")
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


remove(list = setdiff(ls(), "remDr"))
# remDr$open()

setwd("/home/rstudio/SteveAI")
source("scripts/RSelenium_Functions.R")
source("scripts/AutoJobScrapeFunctions.R")
load("scraper.RData")

nr <- 1
for(nr in 1:50){
    print(c("nr: ", nr))
    scrapeFileName <- "scrape_candidates.txt"
    scrapeCands <- read.table(scrapeFileName, header = FALSE, stringsAsFactors = FALSE, sep = ";")
    
    url = scrapeCands[1, 2]
    compName = scrapeCands[1, 1]
    # compName <- gsub("[:]|///|[.]|/", "", compName)
    # compName <- abbreviate(compName, 20)
    # https://career.axelspringer.com/jobangebote/#
    
    # browseURL("http://www.internetstores.de/karriere.html")
    # "http://www.internetstores.de/karriere.html"
    # remDr$navigate("https://www.otto.de/unternehmen/jobs/jobboerse/?search=")
    # remDr$findElements("xpath", "//span[text() = 'Jobbörse']")[[1]]$clickElement()
    
    # url = "https://de.devoteamcareers.com/de/offene-stellen/?contractType=&jobProfile=&location=de&region=&keywords="
    # url = "https://arbeiten.dm-drogeriemarkt.com/dmd/Stellensuche_Z"
    
    
    # url = "https://www.mein-check-in.de/teambank/x/stellenangebote-ausbildung-praktika-trainees/index/cls/germany"
    
    
    # 
    # url = "https://career5.successfactors.eu/career?company=C0000159900P&career%5fns=job%5flisting%5fsummary&navBarLevel=JOB%5fSEARCH&_s.crb=LTXFswhOBF%2fMC65%2bZrT3c9eRNsI%3d"
    # compName = "HERAEUS"
    
    # url = "https://biontech.de/de/karriere/"
    # compName = "BIONTECH"
    
    
    
    
    remDr$navigate(url)
    tryCatch(ExpandAmtOffer2575(click = 1), error = function(e) print("25, 50, 75,... not successful"))
    tryCatch(ExpandAmtOffer2575(click = 2), error = function(e) print("25, 50, 75,... not successful"))
    
    # iframes = remDr$findElements('xpath', '//iframe')
    # remDr$switchToFrame(iframes[[1]])
    
    
    load("scraper.RData")
    output = list()
    
    extractNextPageLinks = lapply(scraper[1:170], function(scrp){
      list(
        xpath = scrp["switchPageXpath"]$switchPageXpath((scrp["nextPageLinkName"])),
        switchPageXpath = scrp["switchPageXpath"],
        nextPageLinkName = scrp["nextPageLinkName"]
      )
    })
    
    NextPageLinkNameCand <- function(){
      xpathes <- lapply(extractNextPageLinks, function(link) link$xpath)
      xPathInfos = extractNextPageLinks[!duplicated(xpathes)]
      
      FoundElems = lapply(unlist(unique(xpathes)), function(xpath){
        remDr$findElements("xpath", xpath)
      })
      
      unlist(unique(xpathes))[lengths(FoundElems) > 0]
      # nextPageXPathCandidates = FoundElems[lengths(FoundElems) > 0]
    }
    
    cands = NextPageLinkNameCand()
    winner = tail(cands, 1)
    links <- sapply(extractNextPageLinks, function(links) links$xpath == winner)
    if(sum(lengths(links))){
      winnerIdx = unname(which(links)[1])
      winnerLink = extractNextPageLinks[[winnerIdx]]
    }else{
      winnerLink <- list(
        xpath = "//a[contains(text(), 'NULL')]",
        switchPageXpath = "",
        nextPageLinkName = NULL
      )
    }
    
    # remDr$navigate("https://jobs.union-investment.de/Jobboerse/Stellenangebote")
    # text = "(m/w"; try("text")
    try <- function(text, xpathStruct = "text"){
      tryCatch(
        findJobNameXpath(xpathTxt = text, xpathStruct = xpathStruct),
        error = function(e){
          print(text)
          return(list())
        } 
      )
    }
    
    # xpath <- xpathAttrs[1]
    getJobNames <- function(xpath){
      elems <- remDr$findElements("xpath", xpath)
      unlist(sapply(elems, function(elem) elem$getElementText()))
    }
    
    AutoJobNameXPathes <- function(){
      candidates = c("(m/w", "(f/m", "(m/f", "(w/m", "Berater", "Consultant", "Manager", "Developer", "Data Scientist",
                     "Abteilungsleiter IT", "(Junior)")
      
      jobNameXpathRaws <- lapply(candidates, try, xpathStruct = "text")
      jobNameXpathCands <- jobNameXpathRaws[lengths(jobNameXpathRaws) > 0]
      xpathAttrs = unname(unlist(sapply(jobNameXpathCands, "[", "xpathAttr")))
      # todo make that cleaner
      if(!length(xpathAttrs)){
        iframes = remDr$findElements("xpath", "//iframe")
        if(length(iframes)){
          remDr$switchToFrame(iframes[[1]])
          jobNameXpathRaws <- lapply(candidates, try, xpathStruct = "text")
          jobNameXpathCands <- jobNameXpathRaws[lengths(jobNameXpathRaws) > 0]
          xpathAttrs = unname(unlist(sapply(jobNameXpathCands, "[", "xpathAttr")))
        }
      }
      
      xpathes = unname(unlist(sapply(jobNameXpathCands, "[", "xpath")))
      # todo: more efficient with uniques
      
      # todo: more intellifent algorithm to identify if text is a jobname?
      allJobNames = lapply(xpathAttrs, getJobNames)

      keep = sapply(allJobNames, function(names) sum(nchar(names)) > 0)
      
      if(length(keep)){
        jobNameXpathCands = jobNameXpathCands[keep]
      }else{
        jobNameXpathCands = list(list(
          xpath = "//a[contains(text(), 'NULL')]",
          switchPageXpath = "",
          nextPageLinkName = NULL,
          len = 0
        ))
      }

      
      xpathAttrsCounts <- table(xpathAttrs)
      
      jobNameXPath = names(which.max(xpathAttrsCounts))
      if(!is.null(jobNameXPath)){
        elems = remDr$findElements("xpath", jobNameXPath)
        jobNames <- unlist(sapply(elems, function(elem) elem$getElementText()))
      }else{
        jobNames = ""
      }
      
      xpathes <- list(xpathAttr = xpathAttrs, 
                      xpathes = xpathes, 
                      len = unlist(sapply(jobNameXpathCands, "[", "len")),
                      allJobNames = allJobNames
      )
      
      out = list(
        xpathes = xpathes,
        jobNameXPath = jobNameXPath,
        jobNames = jobNames
      )
      return(out)
    }
    
    # remDr$findElements("xpath", "//body")[[1]]$getElementText()
    # remDr$findElements("xpath", "//iframe")
    
    jobNameXPathAll = AutoJobNameXPathes()

    jobNameXpath = jobNameXPathAll$jobNameXPath
    nextPageLinkName = winnerLink[3]$nextPageLinkName[[1]]
    switchPageXpath = winnerLink[2]$switchPageXpath
    remDr$navigate(url)
      
    if(!is.null(jobNameXpath)){
      # iframes = remDr$findElements('xpath', '//iframe')
      # remDr$switchToFrame(iframes[[1]])
      results = scrapeData(jobNameXpath, switchPageXpath[[1]], nextPageLinkName, unidentical = TRUE)
      
      if(is.null(nextPageLinkName)) nextPageLinkName <- "NULL"
    }else{
      results <- ""
    }
    
    
    fileName <- paste0("candidate_", compName, ".R")
    fileConn<-file(fileName)
    
    Amtiframes <- remDr$findElements("xpath", "//iframe")
    
code <- paste0("
browseURL('", url, "')

fullxpath: ", paste(jobNameXPathAll$xpathes$xpathes, collapse = '\n'),
"
\n 
",
"Amount i-frames: ", length(Amtiframes), 
"\n",
paste0("remDr$navigate('", url, "')\n"),"
remDr$setWindowSize(1900, 2200)\n
screenshot <- remDr$screenshot(display = TRUE)\n
elem = remDr$findElement(\"xpath\", \"//*[text() = '']\")\n
getXPath(remDr, elem)\n
iframes = remDr$findElements('xpath', '//iframe')\n
remDr$switchToFrame(iframes[[1]])\n
remDr$findElement('xpath', '//body')$getElementText()\n
load('/home/rstudio/SteveAI/scraper.RData')
\n
scraper[['", compName, "']] = list(
url = '", url,"',
jobNameXpath = '", jobNameXpath, "',
nextPageLinkName = ",  nextPageLinkName, ",
switchPageXpath = ",  winnerLink[2][[1]], "
)
save(list = 'scraper',file = '/home/rstudio/SteveAI/scraper.RData')\n

", paste0("remDr$navigate('", url, "')\n"),
paste0("param = scraper[['", compName, "']] \n"),
paste0("if(length(param$func)) param$func(remDr)\n"),
paste0("results = scrapeData(param$jobNameXpath, param$switchPageXpath, param$nextPageLinkName)\n"),
paste0("results = scrapeData(param$jobNameXpath, param$switchPageXpath, NULL)\n\n"),

paste0("amount elements: ", length(unlist(results))),
"

", paste(unlist(results), collapse = "\n"))

  writeLines(code, fileConn)
  close(fileConn)
  # file.edit(fileName)
  # browseURL("https://banksapi.de/jobs/")

  saveData = data.frame(scrapeCands[-1, ])
  write.table(saveData, file = "scrape_candidates.txt", row.names = FALSE, col.names = FALSE, sep = ";")
  
}
  

