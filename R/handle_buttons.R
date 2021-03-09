

urls <- c("https://www.amazon.jobs",
"https://www.bankpower.de/stellenboerse/aktuelle-jobangebote/",
"https://global.abb/group/en/careers",
"https://karriere.aldi-sued.de/jobsuche",
"https://absolut-personal.de/jobs/",
"https://bbrauncareers-bbraun.icims.com/jobs/intro?hashed=-435686691&mobile=false&width=908&height=500&bga=true&needsRedirect=false&jan1offset=60&jun1offset=120",
"https://careers.amplifon.com/en",
"https://job-search.astrazeneca.de/",
"https://atlastitan.de/karriere/",
"https://jobs.atsautomation.com/?locale=de_DE",
"https://www.avjs-gruppe.de/",
"https://careers.bcg.com/discover",
"https://jobs.beeline-group.com/",
"https://www.bt.com/careers",
"https://careers.cevalogistics.com/DACH/?locale=de_DE",
"https://worldwidecareers-bruker.icims.com/jobs/intro?hashed=-435767630&mobile=false&width=940&height=500&bga=true&needsRedirect=false&jan1offset=60&jun1offset=120"
)


url <- "https://jobs.beeline-group.com/"
url <- urls[16]
url <- urls[5]
url
url <- urls[16]
for(url in urls){
  print("---------------")
  print(url)
  ses$go(url = url)
  # ses$getUrl()
  #ses$takeScreenshot()
  ses$getUrl()
  browseURL(ses$getUrl())
  doc <- ses$findElement(xpath = "/*")
  print(doc$getAttribute("innerHTML") %>% nchar)
  xp1 <- "//input //*[contains(text(), 'job')]"
  xp1 <- "//*[contains(text(), 'job')]"
  buttons <- ses$findElements(xpath = xp1)
  print(length(buttons))
  for(nr in seq(buttons)){
    tryCatch(buttons[[nr]]$click(), error = function(e) message(e))
  }
  ses$takeScreenshot()
  print(ses$findElement(xpath = "/*")$getAttribute("innerHTML") %>% nchar)
  print(ses$getUrl())
}

url <- "https://atlastitan.de/karriere/"
doc <- url %>% read_html()

ses$go(url = url)
xp <- "//*[(self::button or self::input)]"
xp <- "//*[contains(text(), 'Jobs')]"
xx <- ses$findElements(xpath = xp)
xx
doc %>% html_nodes(xpath = xp) %>% html_text()


xp <- "//*[(self::button or self::input)] .//parent::*//*[contains(text(), 'Jobs Anzeigen')]" #https://atlastitan.de/karriere/




xx <- ses$findElements(xpath = xp)

for(nr in seq(xx)){
  print(xx[[nr]]$getName())
  print(xx[[nr]]$getText())
}

xx[[1]]$getAttribute(name = "class")
xx[[2]]$getAttribute(name = "class")
doc %>% (xpath = xp)

ses$takeScreenshot()
url %>% browseURL()
x <- ses$findElement(xpath = "//iframe")
ses$
x$getAttribute("innerHTML") %>% cat



html <- "<button>Jobsuche cool</button>"
doc <- html %>% read_html
doc %>% html_nodes(xpath = xp1)

xp1 <- "//button[.//*[contains(text(), 'Ergebnisse anzeigen')]]"
xp1 <- "//button[.//*[contains(text(), 'Find your job')]]"
xp1 <- "//button[.//*[contains(text(), 'Jobsuche')]]"
xp1 <- "//button" # text: Stellenportal
xp1 <- "//button[text() = 'search']" # -->doesnt show
xp1 <- "//button[.//*[text() = 'Suchen']]"
xp1 <- "//button[text() = 'Suchen' or .//*[text() = 'Suchen']]"
xp1 <- "//button[.//*[text() = 'Jobs Anzeigen']]"
xp1 <- "//input[@value = 'Stellen suchen']" # ? does not work?
xp1 <- "//button[.//*[text() = 'Suchen']]"
xp1 <- "//button" # 11 cookies?
xp1 <- "//button[.//*[contains(text(), 'Search')] or contains(text(), 'Search')]"
xp1 <- "//button[contains(text(), 'Search')]"
xp1 <- "//button[text() = 'Search']"
xp1 <- "//input[@value = 'Stellen suchen']"
xp1 <- "//input[@value = 'Stellenangebote suchen']"
xp1 <- "//input[@value = 'Search']" # has iframe

buttons <- ses$findElements(xpath = xp1)
for(nr in seq(buttons)){
  tryCatch(buttons[[nr]]$click(), error = function(e) message(e))
}
ses$takeScreenshot()
ses$getUrl()
ses$getUrl() %>% browseURL()
url


generate_button_xpath <- function(){
  texts <- c('Ergebnisse anzeigen', 'Find your job', 'Jobsuche', 'search', 'Jobs Anzeigen', 'Stellen suchen', 'Search', 'Stellenangebote suchen', 'Jobs anzeigen', 'finden', 'Find a job')
  tagnames_raw <- c("button", "input")
  tagnames <- paste0("(", paste0("self::", tagnames_raw, collapse = " or "), ")")

  xp_text <- paste0(paste(paste0(".//parent::*//*[contains(text(), '", texts,"')]"), collapse = " or "))
  paste0("//*", "[", tagnames, " and (", xp_text, ")]")
}

"//input[contains(@value,'Stellen') or contains(@title,'Stellen')]" #https://jobs.beeline-group.com/


xp1 <- generate_button_xpath()
xp1

pjs <- webdriver::run_phantomjs()
ses <<- webdriver::Session$new(port = pjs$port)
# ses$
#   xx <- ses$getWindow()
# ses <- xx$setSize(3000, 2000)
# ses$initialize(id = )
#
#
#
pjs <- webdriver::run_phantomjs()
ses <<- webdriver::Session$new(port = pjs$port)

url <- "https://global.abb/group/en/careers"
ses$go(url = url)
#
button <- ses$findElements(xpath = xp1)
button[[1]]$click()
ses$takeScreenshot()


xp1 <- "//*[(self::button or self::input) and (.//parent::*//*[contains(text(), 'Ergebnisse anzeigen')])]"

