# AUTO SCRAPES - xpath100iter
#"TEAMBANK";"https://www.mein-check-in.de/teambank/x/stellenangebote-ausbildung-praktika-trainees/index/cls/germany"
# "DZ_HYP";"https://vr.mein-check-in.de/dzhyp"

# DOUBLES?
# https://takeda.wd3.myworkdayjobs.com/External
# VR Karriere Doppelung?

# NON-Lytics
# https://r-biopharm.com/de/karriere/stellenangebote/

# VIELE JOBS
# candidate(MAN)
# https://employment.wellsfargo.com/psc/PSEA/APPLICANT_NW/HRMS/c/HRS_HRAM_FL.HRS_CG_SEARCH_FL.GBL?FOCUS=Applicant&
# https://www.amazon.jobs/en-gb/search?offset=0&result_limit=10&sort=relevant&distanceType=Mi&radius=24km&latitude=&longitude=&loc_group_id=&loc_query=&base_query=data%20scientist&city=&country=&region=&county=&query_options=&
# https://www.santander-karriere.de/de/beruns/karriere/stellenangebote_1/stellenangebote.html

# https://careers.delawarenorth.com/
# https://karriere.diakonie.de/stellenboerse/text/daten/umkreis/30/seite/1/#more-results
# https://karriere.dussmanngroup.com/alle-jobs/
# https://www.bertrandt.jobs/sap(bD1kZSZjPTEwMA==)/bc/bsp/kwp/bsp_eui_rd_uc/main.do?action=to_uc_search&sap-language=de&country=DE
# https://careers.bbva.com/europa/jobs-results/

# PERSONALBERATUNG
# https://pbschaffrath.de/jobs/
# https://brainpower.ipn-gruppe.com/home/
# https://www.bjc-its.de/jobsearch

# TECHNISCH SCHWIERIG
# https://angel.co/berlin/consulting-1/jobs
# candidate MAZARS (unsichere Verbidnung)
# https://careers.schaeffler.com/#
# "VKB";"https://karriere.vkb.de/vkb"
# "DAIMLER_PROTICS";"https://www.daimler.com/karriere/jobsuche/?searchString=Daimler+Protics&action=doSearch"
# "CENTERSHOP";"https://www.centershop.de/unser-unternehmen/karriere/"
# BWVG; https://www.wir-leben-genossenschaft.de/de/bwgv-jobboerse-52.htm

# ÖFFENTLICH MIT FRIST
# https://www.berlin.de/politik-verwaltung-buerger/stellenausschreibungen/
# https://www.berlin.de/karriereportal/stellen/jobportal/stellenangebote.html

# ZU WENIG JOBS:
# https://master.de/karriere/
# https://www.fakro.de/karriere-bei-fakro/stellenangebote/
# https://www.qubix.com/openpositions/india
# https://www.gms.info/karriere/jobs-bei-gms
# https://berlinerstadtwerke.de/ueber-uns/karriere/
# https://www.stadtwerke-bochum.de/privatkunden/unternehmen/karriere/jobangebot.html
# http://www.stadtwerke-flensburg.de/unternehmen/jobs-karriere/stellenangebote/?L=0
# https://www.stadtwerke-karlsruhe.de/swk/karriere/onlinebewerbung/fach-fuehrungskraefte.php
# https://swa-b.de/stellenangebote/
# https://www.stadtwerke-bayreuth.de/ueber-uns/unsere-stadtwerke-bayreuth/karriere-ausbildung/
# http://www.stwab.de/karriere
# https://www.stadtwerke-baden-baden.de/de/karriere/stellenangebote.php
# https://mangools.com/careers
# http://www.birkle-it.com/career
# https://www.hako.com/de_de/Unternehmen/Jobs_und_Karriere/Stellenangebote/Zentralbereiche.php
# https://www.vicampo.de/jobs/uxdesign
# https://www.mindpeak.ai/careers/
# https://simcog.de/de/jobs
# https://www.fiebig.com/unternehmen/jobs.html
# https://www.yamaha-motor.eu/de/de/unternehmen/stellenangebote/
# https://www.zi.de/das-zi/stellenangebote/
# https://jan-seiffert.de/stellenangebote/
# https://rocketloop.de/jobs/
# https://jobs.lever.co/moneyfarm?location=Frankfurt
# http://qimia.de/de/karriere/
# http://www.chi-deutschland.com/karriere.php
# https://www.ankordata.de/homepage/Jobs.action
# http://www.hengstenberg-gruppe.de/?page_id=291
# https://www.mercury-instruments.com/de-Mercury_Instruments_Mitarbeiter.html
# https://www.sparda-verband.jobs/stellensuche.php

# RECHTLICH CHECKEN:
# > remDr$navigate('https://careers.adidas-group.com/jobs')
# > remDr$findElement('xpath', '//body')$getElementText()
# [[1]]
# [1] "Access Denied\nYou don't have permission to access \"http://careers.adidas-group.com/jobs\" on this server.\nReference #18.3d8f1402.1545847533.2f4d116e"

# # #### Does not stop at correct moment
# # remDr$navigate("http://www.google.de")
# # url = "https://www.gfk.com/de/karriere/jobsuche/"
# # remDr$navigate(url)
# # frm = remDr$findElements("xpath", "//iframe")
# # remDr$switchToFrame(frm[[1]])
# # fd = remDr$findElements("xpath", '//input[@value = "Search"]')
# # fd[[1]]$clickElement()
# # Sys.sleep(15)
# # frm = remDr$findElements("xpath", "//iframe")
# # remDr$switchToFrame(frm[[1]])
# # 
# # jobNameXpath = "//html//body//section//form//div//div//div//div//div//div//div//div//div//div//a//h3"
# # nextPageLinkName = "'Next'"
# # switchPageXpath = function(nextPageLinkName) paste0("//input[@value = ", nextPageLinkName,"]")
# # results = scrapeData(jobNameXpath, switchPageXpath, nextPageLinkName, unidentical = TRUE)
# # unlist(results)
# 
# # https://stackfuel.com/ueber-uns/
# # https://osigroup.jobs.net/en-US/search?keywords=&location=
# # remDr$navigate("https://www.altran.com/de/de/karriere/bewerben-sie-sich-jetzt/")
# # https://jobs.ebayinc.com/search-jobs/data%20scientist/403/1
# https://www.acardian.de/wir-suchen/

# # Personalvermittlung:
# # https://www.phaidoninternational.com/jobs/?sortdir=desc&opt=2529%2C2529%2C974&pagesize=12&sortby=CurrentCountry
# 
# # screenshot
# # https://corporate.xing.com/de/karriere/
# 
# # Alle 307 auf einer seite?
# # url = "https://www.jobs.mahle.com/germany/de/jobs/"
# # remDr$navigate(url)
# # print(paste0("Amount iframes: ", length(remDr$findElements("xpath", "//iframe"))))
# # fd = remDr$findElements("xpath", "//button[contains(text(), 'Alle laden')]")
# # remDr$findElement("xpath", "//body")$getElementText()
# # tryCatch(ExpandAmtOffer2575(click = 1), error = function(e) print("25, 50, 75,... not successful"))
# # tryCatch(ExpandAmtOffer2575(click = 2), error = function(e) print("25, 50, 75,... not successful"))
# # jobNameXpathRaw = findJobNameXpath("(m/w)", xpathStruct = "text")
# # jobNameXpathRaw$xpathAttr
# # jobNameXpathRaw$xpath
# # jobNameXpath = 
# #   
# #   nextPageLinkName = "'pagerElement pager-next'"
# # xpath = paste0("//*[@class = '", nextPageLinkName,"']")
# # elems = remDr$findElements("xpath", xpath)
# # elems[[1]]$getElementAttribute("outerHTML")
# # switchPageXpath = function(nextPageLinkName) paste0("//*[@class = ", nextPageLinkName,"]")
# # results = scrapeData(jobNameXpath, switchPageXpath, nextPageLinkName, unidentical = TRUE)
# 
# # https://www.rexx-systems.com/jobs/stellenangebote.html
# # https://clinstat.eu/careers/
# # http://www.vbg.de/DE/Header/3_Karriere/3_Stellenboerse/Data_Scientist_VLRS_Dezember_2018/Stellenanzeige_Data_Scientist_node.html
# # https://eygbl.referrals.selectminds.com/experienced-opportunities/jobs/search/42159915
# # https://timbertec.de/karriere/
# # https://www.dilax.com/de/dilax-group/karriere/
# # https://www.deval.org/de/stellenausschreibungen.html
# # https://careers.amplifon.com/deutschland/amplifon-karriereboerse?activateCookieConfirm=true&scroll=true
# 
# 
# # In jeder Iteration frame neu finden?!!
# url = "https://karriere.apobank.de/Stellenportal.html"
# remDr$navigate(url)
# frame = remDr$findElement("xpath", "//iframe")
# remDr$switchToFrame(frame)
# jobNameXpath = "//html//body//div//div//div//div//div//div//div[@class = 'itemlist_jobtitle']//a"
# nextPageLinkName = "2"
# switchPageXpath = function(nextPageLinkName) paste0("//*[text() = ", nextPageLinkName,"]")
# results = scrapeData(jobNameXpath, switchPageXpath, nextPageLinkName, unidentical = TRUE)
# 
# 
# # https://karriere.akka.eu/accueil.aspx?LCID=1031
# 
# # find on each site 1581 elements
# # url = "https://www.bertrandt.jobs/sap(bD1kZSZjPTEwMA==)/bc/bsp/kwp/bsp_eui_rd_uc/main.do?action=to_uc_search&sap-language=de&country=DE"
# # remDr$navigate(url)
# # jobNameXpath = "//html//body//div//div//div//div//div//div//div//div//div//div//div//div//table//tbody//tr//td[@class = 'data_title']/div/span//a"
# # nextPageLinkName = 'Weitere laden'
# # xpath = paste0("//*[contains(text(), '", nextPageLinkName,"')]")
# # xpath = paste0("//*[text() = '", nextPageLinkName,"']")
# # elems = remDr$findElements("xpath", jobNameXpath)
# # lapply(elems[100:110], function(elem) elem$getElementText())
# # elems[[1]]$getElementAttribute("outerHTML")
# # switchPageXpath = function(nextPageLinkName) paste0("//*[text() = ", nextPageLinkName,"]")
# # results = scrapeData(jobNameXpath, switchPageXpath, nextPageLinkName, unidentical = TRUE)
# 
# 
# 
# # https://www.ecb.europa.eu/careers/vacancies/html/index.en.html
# # https://berenberg.taleo.net/careersection/ber_deu/moresearch.ftl?lang=de&portal=101430233
# # https://www.radeberger-gruppe.de/de/karriere/aktuelle-stellenangebote
# # https://www.metzler.com/de/metzler/karriere/stellenangebote
# # https://www.bafin.de/DE/DieBaFin/ArbeitenBaFin/Stellenangebote/stellenangebote_node.html
# # https://www.the-linde-group.com/de/karriere/jobs-bei-linde/index.html > für jedes Land einzeln
# 
# # nextpagelink hard to find
# url = "https://globalcareers-goldmansachs.icims.com/jobs/search?ss=1&searchRelation=keyword_all"
# remDr$navigate(url)
# frm = remDr$findElement("xpath", "//iframe")
# remDr$switchToFrame(frm)
# remDr$findElement("xpath", "//body")$getElementText()
# jobNameXpath = "//html//body//div//ul//li//div//a//span[2]"
# nextPageLinkName = '2'
# xpath <- paste0("//body//div//div//div//div//a[text()[contains(., ", nextPageLinkName,")] and //span]")
# # xpath <- paste0("//*[text() = '", nextPageLinkName,"']")
# elems <- remDr$findElements("xpath", xpath)
# lapply(elems, function(elem) elem$getElementText())
# switchPageXpath = function(nextPageLinkName) paste0("//body//div//div//div//div//a[text()[contains(., ", nextPageLinkName,")] and //span]")
# results = scrapeData(jobNameXpath, switchPageXpath, nextPageLinkName, unidentical = TRUE)
# 
# #fd = remDr$findElements("xpath", "//button[contains(text(), 'Alle laden')]")
# tryCatch(ExpandAmtOffer2575(click = 1), error = function(e) print("25, 50, 75,... not successful"))
# tryCatch(ExpandAmtOffer2575(click = 2), error = function(e) print("25, 50, 75,... not successful"))
# 
# fileName <- paste0("_", Sys.Date(), ".csv")
# write.csv(x = unlist(results), file = fileName)
# write.table(paste0(" succesfully scraped at: ", Sys.time()), logfileName, append = TRUE)
# 
# 
# 
# # To DO: Hängt sich bei Load more auf.
# # BOSCH
# url <- "https://www.bosch.de/karriere/jobs/"
# remDr$navigate(url)
# amtJobs = remDr$findElements("xpath", "//span[@class = 'M-JobSearchFilter__resultsLabel']")[[1]]$getElementText()[[1]]
# amt <- ceiling((as.numeric(strsplit(amtJobs, " ")[[1]][1]) - 9)/9)
# for(nr in 1:amt){
#   fd = remDr$findElements("xpath", "//span[contains(text(), 'Weitere laden')]")
#   clickElement2(remDr, fd)
#   print(nr)
#   Sys.sleep(0.2)
# }
# jobNameXpath = "//html//body//main//div//div//m-job-search-results-group-dynamic//div//div//a-job-panel-dynamic//div//div//h3"
# nextPageLinkName <- NULL
# switchPageXpath <- function(nextPageLinkName) paste0("//span[text() = ", nextPageLinkName,"]")
# results = scrapeData(jobNameXpath, switchPageXpath, nextPageLinkName, unidentical = TRUE)
# 
# fileName <- paste0("Thyssen_", Sys.Date(), ".csv")
# write.csv(x = unlist(results), file = fileName)
# write.table(paste0("Thyssen succesfully scraped at: ", Sys.time()), logfileName, append = TRUE)
# 
# 
# # # SAP
# # url <- "https://jobs.sap.com/search/?q=&locationsearch=&locale=de_DE"
# # remDr$navigate(url)
# # 
# # fd = remDr$findElements("xpath", "//button[contains(text(), 'Alle laden')]")
# # remDr$findElement("xpath", "//body")$getElementText()
# # # contains.. / text
# # jobNameXpath = findJobNameXpath("IT Project Manager (f/m)", xpathStruct = "text")
# # jobNameXpath = "//html//body//div//div//div//div//form//div//div//table//tbody//tr//td//a[@class = 'jobTitle-link']"
# # nextPageLinkName <- "2"
# # switchPageXpath <- function(nextPageLinkName) paste0("//a[text() = ", nextPageLinkName,"]")
# # results = scrapeData(jobNameXpath, switchPageXpath, nextPageLinkName, unidentical = TRUE)
# # 
# # fileName <- paste0("Thyssen_", Sys.Date(), ".csv")
# # write.csv(x = unlist(results), file = fileName)
# # write.table(paste0("Thyssen succesfully scraped at: ", Sys.time()), logfileName, append = TRUE)
# 
# 
# # Backlog:
# # https://jobs.siemens-info.com/jobs?page=1
# 
# # read.csv("manualLog_2018-12-06.csv")
# # read.csv("Lufthansa_2018-12-03.csv")
# 
# # Oetker - click input does not work.
# # url <- "https://www.oetker.de/karriere/jobs-bewerbungen/internationale-stellenboerse.html"
# # remDr$navigate(url)
# # nextPageLinkName <- "'Mehr Jobs laden'"
# # # jobNameXpath = findJobNameXpath("Personalreferent (m/w)")
# # # jobNameXpath$xpathAttr
# # jobNameXpath = "//html//body//div//div//div//div//div//div//div//div//div//form//table//tbody//tr//td//a"
# # switchPageXpath <- function(nextPageLinkName) paste0("//input[contains(@value, ", nextPageLinkName,")]")
# # results = scrapeData(jobNameXpath, switchPageXpath, nextPageLinkName, unidentical = TRUE,
# #                      clicker = "submit")
# # 
# # fileName <- paste0("Karstadt_", Sys.Date(), ".csv")
# # write.csv(x = unlist(results), file = fileName)
# # write.table(paste0("Karstadt succesfully scraped at: ", Sys.time()), logfileName, append = TRUE)
# 
# 
# ### can find element - but cant get element text
# # url <- "https://jobs.jpmorganchase.com/ListJobs/All"
# # remDr$navigate(url)
# # remDr$findElement("xpath", "//body")$getElementText()
# # #contains.. / contains
# # jobNameXpathRaw = findJobNameXpath("Associate - Treasury Product Strategy", xpathStruct = "text")
# # jobNameXpathRaw$xpathAttr
# # jobNameXpathRaw$xpath
# # jobNameXpath = "//html//body//section//div//div//div//table//tbody//tr//td[@class = 'st-val coloriginaljobtitle']//a"
# # dd <- remDr$findElements("xpath", jobNameXpathRaw$xpath)
# # sapply(dd, function(d) d$getElementText())
# # 
# # nextPageLinkName <- '2'
# # switchPageXpath <- function(nextPageLinkName) paste0("//a[text() = ", nextPageLinkName,"]")
# # results = scrapeData(jobNameXpath, switchPageXpath, nextPageLinkName, unidentical = TRUE)
# # 
# # 
# # fileName <- paste0("_", Sys.Date(), ".csv")
# # write.csv(x = unlist(results), file = fileName)
# # write.table(paste0(" succesfully scraped at: ", Sys.time()), logfileName, append = TRUE)
# 
# 
# # http://careers.bankofamerica.com/
# 
# 
# 
# 
# # Munich Re # todo - es werden keine Jobs angezeigt
# # url <- "https://www.munichre.com/de/career/jobs-and-applications/current-job-openings/index.html"
# # remDr$navigate(url)
# # ddd <- remDr$findElements("xpath", "//body")
# # ddd[[1]]$getElementText()
# # dd <- remDr$findElements("xpath", "//*[contains(text(), 'Bestätigen')]")
# # clickElement2(remDr, dd)  
# # # jobNameXpath = findJobNameXpath("HR Associate Intern")
# # jobNameXpath = "//html//body//div//div//div//div//div//div//div//div//div//table//tbody//tr//td//a//span[@data-bo-text = 'row.titel']"
# # nextPageLinkName <- "2"
# # tryCatch(ExpandAmtOffer2575(1), error = function(e) print("25, 50, 75,... not successful"))
# # switchPageXpath <- function(nextPageLinkName) paste0("//button[text() = ", nextPageLinkName,"]")
# # results = scrapeData(jobNameXpath, switchPageXpath, nextPageLinkName)
# # 
# # fileName <- paste0("Deka_", Sys.Date(), ".csv")
# # write.csv(x = unlist(results), file = fileName)
# # write.table(paste0("Deka succesfully scraped at: ", Sys.time()), logfileName, append = TRUE)
# 
# 
# 
# 
# # url <- "https://www.daimler.com/karriere/jobsuche/?searchString=&action=doSearch"
# # remDr$navigate(url)
# # jobNameXpath = "//html//body//section//div//div//div//div//div//table//tbody//tr//td[@class = 'td-job-title']//div[@class = 'jobs-offer-description']//a"
# # nextPageLinkName <- NULL
# # switchPageXpath <- function(nextPageLinkName) paste0("//a[text() = '", nextPageLinkName,"']")
# # elem  <- remDr$findElements("xpath", "//a[contains(text(), 'alle Treffer anzeigen')]")
# # clickElement2(remDr, elem)
# # webElem <- remDr$findElement("css", "body")
# # for(nr in 1:40){
# #   webElem$sendKeysToElement(list(key = "down_arrow"))  
# # }
# # 
# # results = scrapeData(jobNameXpath, switchPageXpath, nextPageLinkName)
# # 
# # fileName <- paste0("Rossmann_", Sys.Date(), ".csv")
# # write.csv(x = unlist(results), file = fileName)
# # write.table(paste0("Rossmann succesfully scraped at: ", Sys.time()), logfileName, append = TRUE)
# 
# 
# # TODO: BIld anzeigen lassen:
# # url <- "https://karriere.aok.de/stellenangebote/"
# # remDr$navigate(url)
# 
# 
# 
# 
# # Netto to do ids anpassen
# # url <- "https://karriere.fuer-echte-kaufleute.de/jobagent_aldi/search/jobs.aspx?goResult=1&Einstiegsbereich=-1&Plz=-1"
# # url <- "https://www.netto-online.de/karriere/Stellenangebote.chtm?ref=60806-at102186_a158242_m12_p2743_cDE&affmt=0&affmn=0"
# # remDr$navigate(url)
# # jobNameXpath = "//html//body//div//div//div//section//section//div//div//div//section//div//div//div//div//div//div//div//a"
# # jobNameXpath$xpathAttr
# # nextPageLinkName <- NULL
# # switchPageXpath <- function(nextPageLinkName) paste0("//a[contains(text(), '", nextPageLinkName,"')]")
# # results = scrapeData(jobNameXpath, switchPageXpath, nextPageLinkName)
# # 
# # fileName <- paste0("Rewe_", Sys.Date(), ".csv")
# # write.csv(x = unlist(results), file = fileName)
# # write.table(paste0("Rewe succesfully scraped at: ", Sys.time()), logfileName, append = TRUE)
# 
# 
# # jobNameXpath = findJobNameXpath("Verkäufer(in) für den Getränkemarkt")
# 
# # read.csv("manualLog_2018-12-08.csv")
# 
# # https://careers.bpglobal.com/TGnewUI/Search/Home/Home?partnerid=25078&siteid=5076#keyWordSearch=&locationSearch=
# # https://www.shell.de/careers/experienced-professionals/job-search.html#7528=&filter1=&filter2=&siteId=5798&siteLocaleId=&7529=&48372=&49283=&57800=&7530=&48337=
# # https://www.karstadt-karriere.de/stellenmarkt
# 
# 
# # cant even get element text. very long xpath for 
# # url <- "https://www.heidelbergcement.com/de/stellenangebote"
# # remDr$navigate(url)
# # print(paste0("Amount iframes: ", length(remDr$findElements("xpath", "//iframe"))))
# # remDr$findElement("xpath", "//body")$getElementText()
# 
