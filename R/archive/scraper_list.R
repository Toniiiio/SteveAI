save(list = "scraper", file = "scraper.RData")
load("scraper.RData")

# scraper = list()


# url = "https://www.isr.de/jobs"
# remDr$navigate(url)
# xx <- remDr$findElements("xpath", "//iframe")
# lapply(xx, function(x) x$getElementAttribute("id"))
# jobNameXpathRaw = findJobNameXpath("(m/w", xpathStruct = "text")
# remDr$switchToFrame("easyXDM_default4374_provider")
# #contains.. / contains
# jobNameXpathRaw$xpathAttr
# jobNameXpathRaw$xpath
# jobNameXpath = 
# 
# print(paste0("Amount iframes: ", length(remDr$findElements("xpath", "//iframe"))))
# fd = remDr$findElements("xpath", "//button[contains(text(), 'Alle laden')]")
# remDr$findElement("xpath", "//body")$getElementText()
# tryCatch(ExpandAmtOffer2575(click = 1), error = function(e) print("25, 50, 75,... not successful"))
# tryCatch(ExpandAmtOffer2575(click = 2), error = function(e) print("25, 50, 75,... not successful"))
# 
#   
# nextPageLinkName = '2'
# nextPageLinkName = NULL
# xpath = paste0("//*[contains(text(), '", nextPageLinkName,"')]")
# xpath = paste0("//*[text() = ", nextPageLinkName,"]")
# elems = remDr$findElements("xpath", xpath)
# elems[[1]]$getElementAttribute("outerHTML")
# switchPageXpath = function(nextPageLinkName) paste0("//*[text() = ", nextPageLinkName,"]")
# results = scrapeData(jobNameXpath, switchPageXpath, nextPageLinkName, unidentical = TRUE)


scraper[["QIOPTIC"]] = list(
  url = "https://www.excelitascareers.com/de",
  func = function(){
    button = remDr$findElements("xpath", "//a[contains(text(), 'Weitere Stellenangebote anzeigen')]")
    clickElement2(remDr, button)
  },
  jobNameXpath = "//html//body//div//main//section//div//div//div//ul//li//div//h4[@class = 'panel-label job-title small-text panel-label--first-panel']",
  nextPageLinkName = NULL,
  switchPageXpath = function(nextPageLinkName) paste0("//button[contains(text(), ", nextPageLinkName,")]")
)


scraper[["BANKSAPI"]] = list(
  url = "https://banksapi.de/jobs/",
  jobNameXpath = "//html//body//div//section//div//div//div//div//table//tbody//tr//td//a",
  nextPageLinkName = NULL,
  switchPageXpath = function(nextPageLinkName) paste0("//*[text() = ", nextPageLinkName,"]")
)

scraper[["WIRECARD"]] = list(
  url = "https://www.wirecard.de/karriere/stellenangebote/",
  func = function(){
    frm = remDr$findElements("xpath", "//iframe")
    remDr$switchToFrame(frm[[1]])
  },
  jobNameXpath =  "//html//body//ul//li//div//a",
  nextPageLinkName = NULL,
  switchPageXpath = function(nextPageLinkName) paste0("//*[text() = ", nextPageLinkName,"]")
)

scraper[["FLIXBUS"]] = list(
  url = "https://jobs.flixmobility.com/job/list-of-jobs.aspx",
  jobNameXpath = "//html//body//div//div//div//div//div//form//div//div//div//div//div//ul//li//h3//a",
  nextPageLinkName = '2',
  switchPageXpath = function(nextPageLinkName) paste0("//*[text() = ", nextPageLinkName,"]")
)

scraper[["QIAGEN"]] = list(
  url = "https://careers.peopleclick.com/careerscp/client_qiagen/external/EN_US/search.do",
  func = function(){
    fd = remDr$findElements("xpath", "//input[@value = 'Search']")
    fd[[1]]$clickElement()
  },
  jobNameXpath = "//html//body//table//tbody//tr//td//table//tbody//tr//td//table//tbody//tr//td//div//div//div//form//table//tbody//tr//td[@class = 'pc-rtg-tableItem']//a",
  nextPageLinkName = "'>'",
  switchPageXpath = function(nextPageLinkName) paste0("//input[@value = ", nextPageLinkName,"]")
)

scraper[["SCHNEIDERLE"]] = list(
  url = "https://schneiderele.taleo.net/careersection/2/jobsearch.ftl?lang=de&keyword=&CATEGORY=-1&LOCATION=-1",
  jobNameXpath = "//html//body//div//div//div//div//div//div//div//ul//li//div//div//span//a",
  nextPageLinkName = '2',
  switchPageXpath = function(nextPageLinkName) paste0("//*[text() = ", nextPageLinkName,"]")
)

scraper[["METRO_AG"]] = list(
  url = "https://metro.taleo.net/careersection/2/jobsearch.ftl?lang=en",
  jobNameXpath = "//html//body//div//div//div//div//div//div//div//div//ul//li//div//div//span//a",
  nextPageLinkName = '2',
  switchPageXpath = function(nextPageLinkName) paste0("//*[text() = ", nextPageLinkName,"]")
)

scraper[["CELONIS"]] = list(
  url = "https://www.celonis.com/de/careers/jobs/#/",
  jobNameXpath = "//html//body//div//div//div//div//div//div//div//div//article//div//h2",
  nextPageLinkName = NULL,
  switchPageXpath = function(nextPageLinkName) paste0("//*[text() = ", nextPageLinkName,"]")
)

scraper[["CREDITPLUS"]] = list(
  url = "https://www.creditplus.de/ueber-creditplus/karriere/job-angebote/",
  jobNameXpath = "//html//body//div//div//main//div//div//div//div//div//div//a//p[@class = 'headline']",
  nextPageLinkName = NULL,
  switchPageXpath = function(nextPageLinkName) paste0("//*[text() = ", nextPageLinkName,"]")
)

scraper[["MEDIAMARKT_SATURN"]] = list(
  url = "https://media-saturn-jobs.dvinci.de/cgi-bin/appl/selfservice.pl",
  jobNameXpath = "//html//body//div//div//div//div//div//div//div//div//a//div//div//h4",
  func = function(){
    fd = remDr$findElements("xpath", "//a[text() = '100']")
    fd[[1]]$clickElement()
    
  },
  nextPageLinkName = '2',
  switchPageXpath = function(nextPageLinkName) paste0("//*[text() = ", nextPageLinkName,"]")
)

scraper[["ENBW"]] = list(
  url = "https://karriere.enbw.com/fachpositionen/?newms=hm",
  func = function(){
    fd = remDr$findElements("xpath", "//input[@value = 'Suchen']")
    fd[[1]]$clickElement()
  },
  jobNameXpath = "//html//body//div//div//div//div//div//table//tbody//tr//td//div//table//tbody//tr//td//a",
  nextPageLinkName = "'Weiter'",
  switchPageXpath = function(nextPageLinkName) paste0("//a[text() = ", nextPageLinkName,"]")
)


scraper[["CHECK24"]] = list(
  url = "https://jobs.check24.de/search/?search=&initial=true",
  jobNameXpath = "//html//body//div//div//main//section//div//section//a//div//article//h3",
  nextPageLinkName = NULL,
  switchPageXpath = function(nextPageLinkName) paste0("//*[text() = ", nextPageLinkName,"]")
)

scraper[["SCHNEIDERELE"]] = list(
  url = "https://schneiderele.taleo.net/careersection/2/jobsearch.ftl?lang=de&keyword=&CATEGORY=-1&LOCATION=-1",
  jobNameXpath = "//html//body//div//div//div//div//div//div//div//ul//li//div//div//span//a",
  nextPageLinkName = '2',
  switchPageXpath = function(nextPageLinkName) paste0("//*[text() = ", nextPageLinkName,"]")
)


# url = "https://karriere.vkb.de/vkb"
# remDr$navigate(url)
# print(paste0("Amount iframes: ", length(remDr$findElements("xpath", "//iframe"))))
# fd = remDr$findElements("xpath", "//button[contains(text(), 'Alle laden')]")
# remDr$findElement("xpath", "//body")$getElementText()
# tryCatch(ExpandAmtOffer2575(click = 1), error = function(e) print("25, 50, 75,... not successful"))
# tryCatch(ExpandAmtOffer2575(click = 2), error = function(e) print("25, 50, 75,... not successful"))
# contains.. / contains
# jobNameXpathRaw = findJobNameXpath("Ausbildung zum Fachinformatiker (m/w/d)", xpathStruct = "text")
# jobNameXpathRaw$xpathAttr
# jobNameXpathRaw$xpath
# jobNameXpath = "//html//body//nav//ul//li//ul//li//a//span"
#   
# nextPageLinkName = 'Weitere laden'
# xpath = paste0("//*[contains(text(), '", nextPageLinkName,"')]")
# xpath = paste0("//*[text() = '", nextPageLinkName,"']")
# elems = remDr$findElements("xpath", jobNameXpathRaw$xpathAttr)
# elems[[15]]$getElementAttribute("outerHTML")
# elems[[15]]$getElementText()
# switchPageXpath = function(nextPageLinkName) paste0("//*[text() = ", nextPageLinkName,"]")
# results = scrapeData(jobNameXpath, switchPageXpath, nextPageLinkName, unidentical = TRUE)
# 
# url = "https://karriere.vkb.de/vkb"
# 
# remDr$navigate(url)
# jobNameXpath =  "//html//body//nav//ul//li//ul//li//a"
# nextPageLinkName = NULL
# switchPageXpath = function(nextPageLinkName) paste0("//*[text() = ", nextPageLinkName,"]")
# results = scrapeData(jobNameXpath, switchPageXpath, nextPageLinkName, unidentical = TRUE)

scraper[["ASM_SMT_GERMANY"]] = list(
  url = "http://www.asm-smt.com/de/asm-career/jobs/europe",
  jobNameXpath = "//html//body//form//div//div//div//div//div//div//div//div//div//div//div//div//table//tbody//tr//td[@class = 'dms_tb_liste_titel']",
  nextPageLinkName = NULL,
  switchPageXpath = function(nextPageLinkName) paste0("//*[text() = ", nextPageLinkName,"]")
)

scraper[["ASM_SMT_EUROPE"]] = list(
  url = "http://www.asm-smt.com/de/asm-career/jobs/germany",
  jobNameXpath = "//html//body//form//div//div//div//div//div//div//div//div//div//div//div//div//table//tbody//tr//td[@class = 'dms_tb_liste_titel']",
  nextPageLinkName = NULL,
  switchPageXpath = function(nextPageLinkName) paste0("//*[text() = ", nextPageLinkName,"]")
)

scraper[["CYNORA"]] = list(
  url = "https://www.cynora.com/de/karriere/stellenangebote/professionals/",
  jobNameXpath = "//html[@webdriver = 'true' and @lang = 'de' and @amp = '' and @class = 'js']//body[@id = 'page-78']//div[@class = 'wrapper']//div[@class = 'main']//div[@class = 'container']//div[@class = 'frame frame-default frame-type-text frame-layout-0' and @id = 'c822']//p//a",
  nextPageLinkName = '2',
  switchPageXpath = function(nextPageLinkName) paste0("//*[text() = ", nextPageLinkName,"]")
)

scraper[["CRIF_BUERGEL"]] = list(
  url = "https://www.crifbuergel.de/de/ueber-uns/karriere",
  jobNameXpath = "//html//body//div//div//div//div//div//div//div//div//div//article//header//h2",
  nextPageLinkName = '2',
  switchPageXpath = function(nextPageLinkName) paste0("//*[text() = ", nextPageLinkName,"]")
)

scraper[["SENACOR"]] = list(
  url = "https://jobs.senacor.com/jobs",
  jobNameXpath = "//html//body//div//div//div//div//div//div//div//div//div//div//a//div//div//h3",
  nextPageLinkName = "'Nächste'",
  switchPageXpath = function(nextPageLinkName) paste0("//*[contains(text(), ", nextPageLinkName,")]")
)

scraper[["CEWE"]] = list(
  url = "https://company.cewe.de/de/karriere/stellenboerse.html",
  jobNameXpath = "//html//body//div//section//div//div//div//div//div//div//div//table//tbody//tr//td//a",
  nextPageLinkName = '2',
  switchPageXpath = function(nextPageLinkName) paste0("//*[text() = ", nextPageLinkName,"]")
)

scraper[["FRAUNHOFER"]] = list(
  url = "https://recruiting.fraunhofer.de/Jobs/1?lang=ger&Reset=G",
  jobNameXpath = "//html//body//div//div//div//div//table//tbody//tr//td//div//span//a",
  nextPageLinkName = "'nächste'",
  switchPageXpath = function(nextPageLinkName) paste0("//i[@title = ", nextPageLinkName,"]")
)


# todo: option value 50 does not work
# tryCatch(ExpandAmtOffer2575(elemNr = 5, itemNr = 3, click = 2), error = function(e) print("25, 50, 75,... not successful"))
scraper[["SAINT_GOBAIN"]] = list(
  url = "https://www.saint-gobain.de/karriere/stellenangebote-bei-saint-gobain",
  jobNameXpath = "//html//body//div//main//div//div//div//div//div//div//div//div//div//div//div//div//div//div//section//section//h3//a",
  nextPageLinkName = '2',
  switchPageXpath = function(nextPageLinkName) paste0("//*[text() = ", nextPageLinkName,"]")
)

scraper[["THALES"]] = list(
  url = "https://jobs.thalesgroup.com/search-jobs",
  jobNameXpath = "//html//body//div//main//section//div//div//section//section//ul//li//a//h2",
  nextPageLinkName = "'next'",
  switchPageXpath = function(nextPageLinkName) paste0("//a[@class = ", nextPageLinkName,"]")
)

scraper[["BFFT"]] = list(
  url = "https://www.bfft.de/jobs-stellen/stellenangebote/",
  jobNameXpath = "//html//body//div//div//section//div//div//div//div//div//div//h2//a",
  nextPageLinkName = NULL,
  switchPageXpath = function(nextPageLinkName) paste0("//*[text() = ", nextPageLinkName,"]")
)
scraper[["HILTI"]] = list(
  url = "https://careers.hilti.de/de-de/search/jobs?f%5B0%5D=sm_field_country%3ADE",
  jobNameXpath = "//html//body//div//div//div//div//section//article//h3//a",
  nextPageLinkName = '2',
  switchPageXpath = function(nextPageLinkName) paste0("//*[text() = ", nextPageLinkName,"]")
)

scraper[["EFSAUTO"]] = list(
  url = "https://www.efs-auto.com/karriere/stellenangebote/",
  jobNameXpath = "//html//body//div//div//div//div//div//div//div//div//div//div//table//tbody//tr//td//a",
  nextPageLinkName = NULL,
  switchPageXpath = function(nextPageLinkName) paste0("//*[text() = ", nextPageLinkName,"]")
)

scraper[["4FLOW"]] = list(
  url = "https://www.4flow.de/karriere/jobportal.html?no_cache=1",
  jobNameXpath = "//html//body//div//main//div//div//div//table//tbody//tr//td[@class = 'odd title' or @class = 'even title']//a",
  nextPageLinkName = NULL,
  switchPageXpath = function(nextPageLinkName) paste0("//*[text() = ", nextPageLinkName,"]")
)


scraper[["DEVOTEAM"]] = list(
  url = "https://de.devoteamcareers.com/de/offene-stellen/",
  jobNameXpath = "//html//body//div//section//a//div//div//h3",
  nextPageLinkName = '2',
  switchPageXpath = function(nextPageLinkName) paste0("//*[text() = ", nextPageLinkName,"]")
)

# PROSIEBENSAT! - sehr schnell
scraper[["PROSIEBENSAT1"]] = list(
  url = "https://www.prosiebensat1-jobs.com/stellenangebote.html",
  jobNameXpath = "//html//body//div//div//div//div//div//div//ul//li//div//div//div//a",
  nextPageLinkName = '2',
  switchPageXpath = function(nextPageLinkName) paste0("//a[text() = ", nextPageLinkName,"]")
)  

# UNION INVESTMENT! - sehr schnell
scraper[["PROSIEBENSAT1"]] = list(
  url = "https://jobs.union-investment.de/Jobboerse/Stellenangebote",
  func = tryCatch(ExpandAmtOffer2575(click = 1), error = function(e) print("25, 50, 75,... not successful")),
  jobNameXpath = "//html//body//div//form//div//div//div//div//div//table//tbody//tr//td[@class = 'hidden-xs']//a",
  nextPageLinkName = NULL,
  switchPageXpath = function(nextPageLinkName) paste0("//a[text() = ", nextPageLinkName,"]")
)

# ALNATURA - schnell
scraper[["ALNATURA"]] <- list(
  url = "https://alnaturagmbh-portal.rexx-recruitment.com/stellenangebote.html",
  jobNameXpath = "//html//body//div//div//div//div//div//div//div//table//tbody//tr//td//a",
  nextPageLinkName <- '2',
  switchPageXpath = function(nextPageLinkName) paste0("//a[text() = ", nextPageLinkName,"]")
)

# BAYER - sehr schnell
scraper[["BAYER"]] = list(
  url = "https://karriere.bayer.de/de/job-search",
  jobNameXpath = "//html//body//div//div//div//section//div//div//div//table//tbody//tr//td//a",
  nextPageLinkName = NULL,
  switchPageXpath = function(nextPageLinkName) paste0("//a[contains(text(), '", nextPageLinkName,"')]")
)

# Deka  - sehr schnell
scraper[["DEKA"]] = list(
  url = "https://www.deka.de/deka-gruppe/karriere/jobboerse",
  jobNameXpath = "//html//body//div//div//div//div//div//div//div//div//div//table//tbody//tr//td//a//span[@data-bo-text = 'row.titel']",
  nextPageLinkName = "2",
  func = function(remDr){tryCatch(ExpandAmtOffer2575(1), error = function(e) print("25, 50, 75,... not successful"))},
  switchPageXpath = function(nextPageLinkName) paste0("//button[text() = ", nextPageLinkName,"]")
)

# LINDT - schnell
scraper[["LINDT"]] <- list(
  url = "https://recruitingapp-1619.umantis.com/Jobs/1",
  jobNameXpath = "//html//body//div//div//div//div//table//tbody//tr//td//div//span//a",
  nextPageLinkName = "'icon itnav_next'",
  switchPageXpath = function(nextPageLinkName) paste0("//i[@class = ", nextPageLinkName,"]")
)


# IQVIA - mittel?
scraper[["IQVIA"]] = list(
  url = "https://jobs.iqvia.com/en-US/search?keywords=&location=",
  nextPageLinkName = '2',
  jobNameXpath = "//html//body//section//div//div//div//div//div//div//div//table//tbody//tr//td//a",
  switchPageXpath = function(nextPageLinkName) paste0("//a[contains(text(), '", nextPageLinkName,"')]")
)

# Barclays - schnell
scraper[["BARCLAYS"]] <- list(
  url = "https://barclays.taleo.net/careersection/2/moresearch.ftl?lang=en_GB",
  jobNameXpath = "//html//body//div//div//form//div//div//div//div//div//div//table//tbody//tr//td//div//div//table//tbody//tr//td//div//div//div//div//h3//span//a",
  nextPageLinkName = "'Next'",
  switchPageXpath = function(nextPageLinkName) paste0("//a[text() = ", nextPageLinkName,"]"),
  func = function(remDr){
    tryCatch(ExpandAmtOffer2575(click = 1), error = function(e) print("25, 50, 75,... not successful"))
  }
)


# CreditSuisse - mittel
scraper[["CREDIT_SUISSE"]] <- list(
  url = "https://tas-creditsuisse.taleo.net/careersection/external_advsearch/moresearch.ftl?lang=de",
  jobNameXpath = "//html//body//div//form//div//div//div//div//div//div//table//tbody//tr//td//div//div//table//tbody//tr//td//div//div//div//div//h3//span//a",
  nextPageLinkName = "'Zur nächsten Seite'",
  switchPageXpath = function(nextPageLinkName) paste0("//a[@title = ", nextPageLinkName,"]")
)


# Lego #todo: ohne die class sorting1 gibt es datum + ort - mittel 3-4min
scraper[["LEGO"]] = list(
  url = "https://www.lego.com/de-de/careers/search-jobs/",
  jobNameXpath = "//html//body//div//div//div//div//div//div//section//div//div//div//table//tbody//tr//td[@class='sorting_1']//a",
  nextPageLinkName = "2",
  switchPageXpath = function(nextPageLinkName) paste0("//a[text() = '", nextPageLinkName,"']"),
  func = function(remDr){tryCatch(ExpandAmtOffer2575(), error = function(e) print("25, 50, 75,... not successful"))}
)


# Karstadt # todo func
scraper[["KARSTADT"]] = list(
  url = "https://www.karstadt-karriere.de/stellenmarkt",
  jobNameXpath = "//html//body//div//div//div//div//table//tbody//tr//td//div//span//a",
  nextPageLinkName = "tablenav_top_nextlink_66856",
  switchPageXpath = function(nextPageLinkName) paste0("//a[@id = '", nextPageLinkName,"']"),
  func = function(remDr){
    elemsIframe = remDr$findElements("xpath", "//iframe")
    if(length(elemsIframe)) remDr$switchToFrame(elemsIframe[[1]])
  }
)


# Telekom
scraper[["TELEKOM"]] = list(
  url = "https://telekom.jobs/karriere?SearchParam%5Bkeyword%5D%5B%5D=&SearchParam%5Blocation%5D%5B%5D=Deutschland",
  jobNameXpath = "//html//body//div//div//div//div//table//tbody//tr//td[@class = 'job']//div//span//a",
  nextPageLinkName = "2",
  switchPageXpath = function(nextPageLinkName) paste0("//a[text() = '", nextPageLinkName,"']"),
  func = function(remDr){tryCatch(ExpandAmtOffer2575(click = 2), error = function(e) print("25, 50, 75,... not successful"))}
)




#  Basf - todo
scraper[["BASF"]] = list(
  url = "https://www.basf.com/de/company/career/jobs.html",
  remDr$navigate(url),
  func = function(remDr){
    webElem = remDr$findElement("css", "body")
    webElem$sendKeysToElement(list(key = "end"))
    webElem$sendKeysToElement(list(key = "end"))
  },
  jobNameXpath = "//html//body//div//div//div//div//div//div//div//div//div//a//div//div[@class = 'jobCategoryResultGridRows bold-text']",
  nextPageLinkName = "'Zeige mehr'",
  switchPageXpath = function(nextPageLinkName) paste0("//a[text() = ", nextPageLinkName,"]")
)

# RWE - sehr schnell

scraper[["RWE"]] = list(
  url = "https://jobs.innogy.com/RWE/search/?createNewAlert=false&q=&optionsFacetsDD_location=",
  jobNameXpath = "//html//body//div//div//div//div//div//table//tbody//tr//td//span[@class = 'jobTitle hidden-phone']//a[@class = 'jobTitle-link']",
  nextPageLinkName = "2",
  switchPageXpath = function(nextPageLinkName) paste0("//a[text() = ", nextPageLinkName,"]")
)


#  Thyssen - sehr schnell
scraper[["THYSSEN"]] = list(
  url = "https://karriere.thyssenkrupp.com/de/jobs/",
  remDr$navigate(url),
  jobNameXpath = "//html//body//div//div//div//div//form//div//div//table//tbody//tr//td//a",
  nextPageLinkName = NULL,
  switchPageXpath = function(nextPageLinkName) paste0("//a[text() = ", nextPageLinkName,"]")
)

# Ing Diba  - click2 - schnell
scraper[["ING_DIBA"]] <- list(
  url = "https://www.ing.jobs/Global/Careers/Job-opportunities.htm",
  jobNameXpath = "//html//body//div//div//section//article//div//div//div//div//div//div//h3//a",
  nextPageLinkName = "'next'",
  switchPageXpath = function(nextPageLinkName) paste0("//a[text() = ", nextPageLinkName,"]")
)



# Bundesbank - sehr schnell
scraper[["BUNDESBANK"]] <- list(
  url = "https://www.bundesbank.de/de/bundesbank/karriere/jobboerse",
  func = function(remDr){
    tryCatch(ExpandAmtOffer2575(click = 1), error = function(e) print("25, 50, 75,... not successful"))
  },
  jobNameXpath = "//html//body//div//div//div//div//div//main//div//div//div//ul//li//div//div//div//div//div",
  nextPageLinkName = 2,
  switchPageXpath = function(nextPageLinkName) paste0("//a[text() = ", nextPageLinkName,"]")
)



scraper[["SCHWARZ"]] = list(
  url = "https://jobs.schwarz/search/?createNewAlert=false&q=",
  jobNameXpath = "//html//body//div//div//div//div//div//table//tbody//tr//td//span//a[@class = 'jobTitle-link']",
  nextPageLinkName = '2',
  switchPageXpath = function(nextPageLinkName) paste0("//*[text() = ", nextPageLinkName,"]")
)

# SwissRe - mittel 3-4min
scraper[["SWISSRE"]] <- list(
  url = "https://careers.swissre.com/search/?createNewAlert=false&q=&locationsearch=&optionsFacetsDD_shifttype=&optionsFacetsDD_customfield2=&optionsFacetsDD_location=",
  jobNameXpath = "//html//body//div//div//div//div//div//table//tbody//tr[@class = 'data-row clickable']//td[@headers = 'hdrTitle' and @class = 'colTitle']//span[@class = 'jobTitle hidden-phone']//a[@class = 'jobTitle-link']",
  nextPageLinkName = 2,
  switchPageXpath = function(nextPageLinkName) paste0("//a[text() = ", nextPageLinkName,"]")
)

# RUV - eher länger
scraper[["RUV"]] <- list(
  url = "https://www.ruv.de/karriere/jobsuche/Aktuelle_Jobangebote",
  jobNameXpath = "//html//body//div//div//div//div//div//div//h3//a",
  nextPageLinkName = "'Mehr laden'",
  switchPageXpath = function(nextPageLinkName) paste0("//a[text() = ", nextPageLinkName,"]")
)


# Allianz
# scraper[["ALLIANZ"]] <- list(
#   url = "https://jobs.allianz.com/sap/bc/bsp/sap/zhcmx_erc_ui_ex/desktop.html?sap-language=de&freeText=&location=32760000#/SEARCH/RESULTS",
#   jobNameXpath = "//html//body//section//div//div//div//div//div//section//div//div//div//div//section//div//ul//li[@class = 'listItem jobListItem']//div[@class = 'details']//div[@class = 'title']",
#   nextPageLinkName = NULL,
#   switchPageXpath = function(nextPageLinkName) paste0("//a[text() = ", nextPageLinkName,"]"),
#   func = function(remDr){
#     amtJobs = remDr$findElements("xpath", "//*[text()[contains(., 'Jobs found')]]")[[1]]$getElementText()[[1]]
#     amt = ceiling((as.numeric(strsplit(amtJobs, " ")[[1]][1]) - 20)/20)
#     for(nr in 1:amt){
#       webElem = remDr$findElement("css", "body")
#       webElem$sendKeysToElement(list(key = "end"))
#       Sys.sleep(0.5)
#     }
#   }
# )

# Metro
scraper[["METRO"]] <- list(
  url = "https://metro-jobs.dvinci.de/cgi-bin/appl/selfservice.pl?layout=2;css_loc_nr=75A468B0-53B9-4734-9326-C8F813F2F950;geo_coordinate_obj.geo_coordinate_country=DE;lang=de",
  func = function(remDr){
    remDr$findElement("xpath", "//a[text() = 100]")$clickElement()
  },
  jobNameXpath = "//html//body//div//div//div//div//div//div//div//div//a//div//div//h4",
  nextPageLinkName = "2",
  switchPageXpath = function(nextPageLinkName) paste0("//a[text() = ", nextPageLinkName,"]")
)


# Zalando
scraper[["ZALANDO"]] <- list(
  url = "https://jobs.zalando.com/de/?gh_src=4n3gxh1&search=",
  jobNameXpath = "//html//body//div//div//div//section//div//ul//li//a//div//div//div//span[@class = 'card--job-result__title']",
  nextPageLinkName = "2",
  switchPageXpath = function(nextPageLinkName) paste0("//li[text() = ", nextPageLinkName,"]")
)


# Boehringer
scraper[["BOEHRINGER"]] <- list(
  url = "https://tas-boehringer.taleo.net/careersection/global+template+career+section+28external29/jobsearch.ftl?lang=de",
  jobNameXpath = "//html//body//div//div//div//div//div//div//div//div//div//table//tbody//tr//th//div//div//span//a",
  nextPageLinkName = "2",
  switchPageXpath = function(nextPageLinkName) paste0("//a[text() = ", nextPageLinkName,"]")
)

scraper[["AIRBUS"]] = list(
  url = "http://company.airbus.com/careers/jobs-and-applications/search-for-vacancies.html",
  jobNameXpath = "//html//body//main//div//article//section//div//ul//li//div//a//div//h2",
  nextPageLinkName = "'Show more results'",
  switchPageXpath = function(nextPageLinkName) paste0("//*[text() = ", nextPageLinkName, "]")
)


# Vattenfall  # TODO: Expand all
scraper[["VATTENFALL"]] <- list(
  url = "https://corporate.vattenfall.de/karriere/jobs/stellensuche/",
  func = function(remDr){
    tryCatch(ExpandAmtOffer2575(click = 1), error = function(e) print("25, 50, 75,... not successful"))
  },
  jobNameXpath =  "//html//body//form//section//div//article//div//div//table//tbody//tr//td//a",
  nextPageLinkName = "2",
  switchPageXpath = function(nextPageLinkName) paste0("//a[text() = ", nextPageLinkName,"]")
)


# EON - click2
scraper[["EON"]] <- list(
  url = "https://www.eon.com/de/ueber-uns/karriere/stellenangebote.html",
  jobNameXpath = "//html//body//section//div//div//div//div//div//div//div//div//div//div//a//article//main//h4",
  nextPageLinkName = "'Next'",
  switchPageXpath = function(nextPageLinkName) paste0("//span[text() = ", nextPageLinkName,"]")
)


# OBI
scraper[["OBI"]] <- list(
  url = "https://my-career.obi.com/?",
  jobNameXpath =  "//html//body//div//main//section//div//div//div//table//tbody//tr//td[@class = 'job']//a//span",
  nextPageLinkName = "2",
  switchPageXpath = function(nextPageLinkName) paste0("//a[text() = ", nextPageLinkName,"]"),
  func = function(remDr){
    tryCatch(ExpandAmtOffer2575(click = 1), error = function(e) print("25, 50, 75,... not successful"))
  }
)



# UBS - todo: does it take 1800 or 36000 results, take only from last iteration - Selenium message:Unexpected modal dialog (text: A script on this page may be busy,
scraper[["UBS"]] <- list(
  url = "https://jobs.ubs.com/TGnewUI/Search/Home/HomeWithPreLoad?partnerid=25008&siteid=5012&PageType=searchResults&SearchType=linkquery&LinkID=3138#keyWordSearch=&locationSearch=",
  jobNameXpath = "//html//body//div//div//div//div//div//div//div//div//div//div//div//ul//li//div//label//span[@ng-repeat = 'oQ in job.Questions']",
  nextPageLinkName = "'Next >'",
  switchPageXpath = function(nextPageLinkName) paste0("//a[text() = ", nextPageLinkName,"]")
)




# deutsche börse
scraper[["DEUTSCHE_BÖRSE"]] <- list(
  url = "https://career.deutsche-boerse.com/go/Absolventen/1397101/?q=&sortColumn=referencedate&sortDirection=desc",
  jobNameXpath = "//html//body//div//div//div//div//div//div//table//tbody//tr//td//span//a[@class = 'jobTitle-link']",
  nextPageLinkName = '2',
  switchPageXpath = function(nextPageLinkName) paste0("//a[text() = ", nextPageLinkName,"]")
)

# Beiersdorf
scraper[["BEIERSDORF"]] <- list(
  url = "https://www.beiersdorf.de/karriere/jobsuche/jobsuche",
  jobNameXpath = "//html//body//form//section//div//div//div//div//div//div//table//tbody//tr//td//a//span",
  nextPageLinkName = '2',
  switchPageXpath = function(nextPageLinkName) paste0("//a[text() = ", nextPageLinkName,"]"),
  func = function(remDr){
    tryCatch(ExpandAmtOffer2575(click = 1), error = function(e) print("25, 50, 75,... not successful"))
  }
)

# Rossmann - mittel - lang? 30 Seiten?
scraper[["ROSSMANN"]] = list(
  url = "https://www.jobs.rossmann.de/?search_criterion_keyword=&search_criterion_distance=25",
  jobNameXpath = "//html//body//div//div//form//div//div//div//div//table//tbody//tr//td//a//span",
  nextPageLinkName = "2",
  func = function(remDr){
    tryCatch(ExpandAmtOffer2575(), error = function(e) print("25, 50, 75,... not successful"))
  },
  switchPageXpath = function(nextPageLinkName) paste0("//a[text() = '", nextPageLinkName,"']")
)

#  Edeka - todo expandamtoffer anpassen auf 20. der click geht net fkt umschreiben
scraper[["EDEKA"]] = list(
  url = "http://www.edeka-verbund.de/Unternehmen/de/karriere/edeka_stellenboerse/stellen_filter_suche.jsp",
  jobNameXpath = "//html//body//div//div//div//main//div//div//div//div//ul//li//div//div//a//strong",
  nextPageLinkName = "2",
  file = tryCatch(ExpandAmtOffer2575(1), error = function(e) print("25, 50, 75,... not successful")),
  switchPageXpath = function(nextPageLinkName) paste0("//a[text() = '", nextPageLinkName,"']")
)

# Porsche
scraper[["PORSCHE"]] = list(
  url = "https://jobs.porsche.com/index.php?ac=search_result",
  jobNameXpath = "//html//body//div//main//form//section//div//div//div//div//div//table//tbody//tr//td//a//span",
  nextPageLinkName = "2",
  switchPageXpath = function(nextPageLinkName) paste0("//a[contains(text(), '", nextPageLinkName,"')]"),
  func = function(remDr){
    tryCatch(ExpandAmtOffer2575(), error = function(e) print("25, 50, 75,... not successful"))
  }
)


# Rewe - lange?
scraper[["REWE"]] = list(
  url = "https://karriere.rewe-group.com/search/?q=&department=REWE&utm_source=careersite&#search-wrapper",
  jobNameXpath = "//html//body//div//div//div//div//div//table//tbody//tr//td//span//a",
  nextPageLinkName = "2",
  switchPageXpath = function(nextPageLinkName) paste0("//a[contains(text(), '", nextPageLinkName,"')]")
)

# # LIDL - 1,5std?
# scraper[["LIDL"]] = list(
#   url = "https://jobs.lidl.de/de/stellensuche.htm",
#   jobNameXpath = "//html[@lang = 'de' and @webdriver = 'true']//body[@class = 'tJobSearch']//main//div[@id = 'react-container']//div[@class = 'jobSearchResults jobSearchResults_noLeaflet ']//div[@class = 'jobSearchResults-wrapper']//div[@class = 'resultContainer-body']//a[@class = 'jobResult']//h6[@class = 'jobTitle']",
#   nextPageLinkName = "2",
#   switchPageXpath = function(nextPageLinkName) paste0("//a[contains(text(), '", nextPageLinkName,"')]")
# )



