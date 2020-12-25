# TOP EMPLOYER: https://www.top-employers.com/de-DE/top-employers-weltweit/?country=Germany

start <- Sys.time()
# Deutsche Bahn, Rewe, Lidl
#system("sudo sync; echo 3 > /proc/sys/vm/drop_caches")
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

remDr$navigate("https://www.top-employers.com/de-DE/top-employers-weltweit/?country=Germany")
xx <- remDr$findElements("xpath", "//*[text() = '1 & 1 Versatel GmbH']")

getXPath(remDr, xx[[1]])
webElem <- remDr$findElement("css", "body")
webElem$sendKeysToElement(list(key = "end"))
xx <- remDr$findElements("xpath", "//body//div//ul//li//a//div//h3")
names <- vapply(xx, function(elem) elem$getElementText()[[1]], FUN.VALUE = character(1))

