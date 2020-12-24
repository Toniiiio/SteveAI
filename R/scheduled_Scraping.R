# Rossmann Treffer pro Seite auf 250
# Beiersdorf Treffer pro Seite auf 100

# todo see which are already scraped and skip those.

# 03.03.2019: upgedated scraper auhc richtig in in text output auf .txt
# - manchmal sind scrapes leer - lade die seite mit gleichen code zum dritten mal dann gehts - checken.
# Unexpected modal dialog alert -  https://stackoverflow.com/questions/30771067/selenium-webdriver-unexpected-modal-dialog-alert
# IDEALO reparieren - unable to access property name illegal - firefox issue switch to chrome?
# standort etc. mit scrapen
# workaround bei ABOUT YOU BEHEBEN
# Selenium message:Element belongs to a different frame than the current one - switch to its containing frame to use it
# APOBANK
# wenn switch to iframe richtig ist, dann auch im output zeigen, sherlock
# careerfactors kommt öfter vor
# breuninger + verfassung nachholen, DZBANK, ESA, FIDUCIA - zeigt jobbereich nicht an
# immowelt, special scrolling
# COMDIREKT, das heimliche DIV das sich einschleicht div class = hidden-sm hidden-md hidden-lg
# Scrapes gone wrong?
# EON?, PORSCHE?
# todo: extraDIV DOEHLER


# rename old log file - so that log data can be associated with respective date
file.rename(
  from = "/home/rstudio/SteveAI/scripts/scheduled_Scraping.log", 
  to = paste0("/home/rstudio/SteveAI/scripts/scheduled_Scraping", Sys.Date() - 1,".log")
)

# Cleaning up old docker files
system("docker rm $(docker ps -a)")
system(paste0("sudo -kS docker rm $(docker ps -a)"),
       input = "Donthack1")


start <- Sys.time()
# Deutsche Bahn, Rewe, Lidl
#system("sudo sync; echo 3 > /proc/sys/vm/drop_caches")
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


# echo 1 > /proc/sys/kernel/sysrq
# echo f > /proc/sysrq-trigger
# echo 0 > /proc/sys/kernel/sysrq

# write.table(paste0("Driver succesfully opened at: ", Sys.time()), logfileName, append = TRUE)
# write.table(x = data.frame(name = 1), file = logfileName, append = TRUE, row.names = FALSE, col.names = FALSE)
setwd("/home/rstudio/SteveAI")
source("scripts/RSelenium_Functions.R")
source("scripts/AutoJobScrapeFunctions.R")
load("scraper.RData")
load("/home/rstudio/SteveAI/switchPageCountUp.RData")
load("/home/rstudio/SteveAI/switchPageLoadMore.RData")

# system("sudo -kS echo 1 > /proc/sys/kernel/sysrq;echo f > /proc/sysrq-trigger;echo 0 > /proc/sys/kernel/sysrq",
#        input = "Donthack1")
# system('sudo -kS 1 > /proc/sys/kernel/sysrq',input= "Donthack1")

# 
# # scrapingJobs(name)
# # name = toBeScraped[nr]
# scrapingJobs = function(name){
#   tryCatch(
#     expr = remDr$navigate("http://www.google.de"),
#     error = function(e){
#       portNr = 20000 + as.numeric(Sys.Date()) + sample(1:10000, 1)
#       system(paste0("sudo -kS docker run -d -p ", portNr,
#                     ":4444 selenium/standalone-firefox:2.53.0"),
#              input = "Donthack1")
#       remDr <<- remoteDriver(
#         remoteServerAddr = "localhost",
#         port = portNr,
#         browserName = "firefox"
#       )
#       Sys.sleep(2)
#       remDr$open()
#       Sys.sleep(2)
#     }
#   )
#   param = scraper[[name]]
#   remDr$navigate(param$url)
#   remDr$setWindowSize(2900, 3200)
#   if(length(param$func)) param$func(remDr)
#   results = scrapeData(jobNameXpath = param$jobNameXpath, switchPageXpath = param$switchPageXpath, nextPageLinkName = param$nextPageLinkName, 
#                        maxIter = param$maxIter, unidentical = param$unidentical, switchPageCountUp = switchPageCountUp,
#                        switchPageLoadMore = switchPageLoadMore, location = param$location, bereich = param$bereich, eingestelltAm = param$eingestelltAm)
#   
#   write.table(x = data.frame(name = name), file = logfileName, append = TRUE, row.names = FALSE, col.names = FALSE)
#   fileName = paste0("data/", name, "_", Sys.Date(), ".csv")
#   write.csv(x = unlist(results$jobResults), file = fileName)
#   
#   jobDesc <- unlist(results$jobDescriptions)
#   if(!is.null(jobDesc)){
#     fileNameJobDesc = paste0("data/JobDescLinks_", name, "_", Sys.Date(), ".csv")
#     out <- data.frame(
#       x = unlist(results$jobDescriptions),
#       jobName = unlist(results$jobResults),
#       comp = name,
#       date = Sys.Date(),
#       location = results$location,
#       eingestelltAm = results$eingestelltAm,
#       bereich = results$bereich
#     )
#     write.csv2(x = out, file = fileNameJobDesc, row.names = FALSE)
#   }
# }
# 
# # https://www.boerse-stuttgart.de/de/unternehmen/karriere/boerse-stuttgart-als-arbeitgeber/
# # https://www.otto-lse.com/careers/stellenangebote/
# # https://www.otto.de/unternehmen/jobs/jobboerse/?search=
# 
# 
# logfileName = paste0("manualLog_", Sys.Date() - 1, "-copy.csv")
# errorfileName = paste0("errorLog_", Sys.Date() - 1, "-copy.csv")
# if(!file.exists(logfileName)) logfileName = paste0("manualLog_", Sys.Date(), ".csv")
# if(!file.exists(errorfileName)) errorfileName = paste0("errorLog_", Sys.Date(), ".csv")
# 
# toBeScraped <- ""
# nr <- 1
# # save(list = 'scraper',file = '/home/rstudio/SteveAI/scraper.RData')
# 
# n <- length(scraper) + 10
# durationFileName <- paste0("/home/rstudio/SteveAI/scrapeDuration_", Sys.Date(), ".csv")
# 
# while(length(toBeScraped) > 0 & nr < n + 10 ){
#   if(!file.exists(logfileName)) write.table(paste0("Script started at: ", Sys.time()), logfileName, append = TRUE)
#   alreadyScraped = read.csv2(logfileName, stringsAsFactors = FALSE)
#   toBeScraped <- setdiff(names(scraper), alreadyScraped[, 1])
#   name <- toBeScraped[nr]
#   print(name)
#   start <- Sys.time()
#   
#   tryCatch(
#     scrapingJobs(toBeScraped[nr]),
#     error = function(err){
#       nr <<- nr + 1
#       print(paste0("nr: ", nr))
#       print(err)
#       
#             
#       write.table(
#         x = data.frame(name = paste0(
#           Sys.time(), ": Company: ", toBeScraped[nr],
#           " Error1: ", err,
#           " Error2: ", remDr$errorDetails()$localizedMessage)
#         ), 
#         file = errorfileName, 
#         append = TRUE, 
#         row.names = FALSE, 
#         col.names = FALSE
#       )
#     }
#   )
#   end <- Sys.time()
#   scrapeDuration <- as.numeric(end - start)
#   
#   if(!is.na(name)){
#     write.table(
#       data.frame(name = name, duration = scrapeDuration),
#       file = durationFileName, 
#       append = TRUE, 
#       row.names = FALSE,
#       col.names = FALSE
#     )
#   }
# }
# end <- Sys.time()
# 
# 
# system("docker rm $(docker ps -a)")

tryCatch(
  source("/home/rstudio/SteveAI/scripts/scheduled_Scraping_rvest.R"),
  error = function(e) print("FAILED rvest")
)
tryCatch(
  source("/home/rstudio/SteveAI/scripts/scheduled_Scraping_rvestMultiPage.R"),
  error = function(e) print("FAILED rvest multi page")
)

print("starting workdays.")
tryCatch(
  source("/home/rstudio/SteveAI/scripts/scheduled_Scraping_workdays.R"),
  error = function(e) print("FAILED workdays")
)

print("starting get.")
tryCatch(
  source("/home/rstudio/SteveAI/scripts/scheduled_Scraping_GET.R"),
  error = function(e) print("FAILED GET")
)

print("starting getgoogle.")
tryCatch(
  source("/home/rstudio/SteveAI/scripts/scheduled_Scraping_GETGOOGLE.R"),
  error = function(e) print("FAILED GET GOOGLE")
)

print("starting getlever.")
tryCatch(
  source("/home/rstudio/SteveAI/scripts/scheduled_Scraping_GETLEVER.R"),
  error = function(e) print("FAILED GET LEVER")
)

print("starting getjibe.")
tryCatch(
  source("/home/rstudio/SteveAI/scripts/scheduled_Scraping_GETJIBE.R"),
  error = function(e) print("FAILED JIBE")
)

print("starting getgreenhouse.")
tryCatch(
  source("/home/rstudio/SteveAI/scripts/scheduled_Scraping_GETGREENHOUSE.R"),
  error = function(e) print("FAILED GREENHOUSE")
)

print("starting getsjon.")
tryCatch(
  source("/home/rstudio/SteveAI/scripts/scheduled_Scraping_GETJSON.R"),
  error = function(e) print("FAILED JSON")
)

print("starting tmp.")
tryCatch(
  source("/home/rstudio/SteveAI/scripts/scheduled_Scraping_TMP.R"),
  error = function(e) print("FAILED TMP")
)

print("starting findly.")
tryCatch(
  source("/home/rstudio/SteveAI/scripts/scheduled_Scraping_FINDLY.R"),
  error = function(e) print("FAILED FINDLY")
)

print("starting careerfactors.")
tryCatch(
  source("/home/rstudio/SteveAI/scripts/scheduled_Scraping_careerfactors.R"),
  error = function(e) print("FAILED careerfactors")
)

print("starting create data structure.")
tryCatch(
  source("/home/rstudio/DataStructure/createDataStructure.R"),
  error = function(e) print("FAILED create data structure")
)


tryCatch(
  source("/home/rstudio/SteveAI/scripts/scrapeJobDescriptionsRVest.R"),
  error = function(e) print("FAILED scrapeJobDescriptionsRVest")
)
