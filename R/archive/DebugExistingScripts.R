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

remDr$navigate("https://www.wirecard.com/de/unternehmen/karriere")
elems = remDr$findElements("xpath", "//*[contains(@class, 'collapse')]")
addCssClassElement(elems, addClass = "show")
elems = remDr$findElements("xpath", "/html/body/section/div/div/div/div/div/div/div/div/a/div/div[1]")
sapply(elems, function(elem) elem$getElementText())
elems = remDr$findElements("xpath", "/html/body/section/div/div/div/div/div/div/div/div/a/div/div[2]")
sapply(elems, function(elem) elem$getElementText())





remDr$navigate("https://www.wirecard.com/de/unternehmen/karriere")


scraper[[3]]$func = function(remDr){
  elems = remDr$findElements("xpath", "//*[contains(@class, 'collapse')]")
  addCssClassElement(elems, addClass = "show")
}
scraper[[3]]$jobNameXpath = "/html/body/section/div/div/div/div/div/div/div/div/a/div/div[1]"
scraper[[3]]$eingestelltAm = "/html/body/section/div/div/div/div/div/div/div/div/a/div/div[2]"
save(scraper, file = "/home/rstudio/SteveAI/scraper_backup.RData")

load("/home/rstudio/SteveAI/scraper_backup.RData")

