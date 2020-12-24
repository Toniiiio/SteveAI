# elemsWithDates <- getElementWithDates(remDr)
# sapply(elemsWithDates, function(elem) elem$getElementText())
# xpathes <- lapply(elemsWithDates, getElementFullXPath)
# linkPathDates <- getElementFullXPath(elems[1], excludeAttribute = "href")
# locations = getElementWithEntities(remDr, "de", "LOC_B")

# ATKUELLER STAND:
# dd = remDr$findElements("xpath", "//*[contains(text(), 'Bestätigen')]")
# clickElement2(remDr, dd[2])

# ff = remDr$findElement("xpath", "//*[contains(text(), 'OK')]")
# ff$clickElement()

#
findJobNameXpath = function(xpathTxt = "(m/w", elemNr = 1, xpathStruct = "text", excludeAttribute = "href"){
  if(xpathStruct == "text") xpathFirst <- paste0("//*[contains(text(), '", xpathTxt,"')]")
  if(xpathStruct == "contains") xpathFirst <- paste0("//*[text()[contains(., '", xpathTxt,"')]]")
  if(xpathStruct == "contains..") xpathFirst <- paste0("//*[text()[contains(.., '", xpathTxt,"')]]")
  # elemsIframe <- remDr$findElements("xpath", "//iframe")
  # if(length(elemsIframe)) remDr$switchToFrame(elemsIframe[[1]])
  
  xpathCands <- remDr$findElements("xpath", xpathFirst)
  sum = 0
  while(!sum & elemNr <= length(xpathCands) & elemNr < 20){
    # lapply(elems, function(elem) elem$getElementText())
    # remDr$findElement("css", "html")$getElementText()
    jobXpath <- getElementFullXPathFast(xpathCands[elemNr], excludeAttribute = excludeAttribute)
    elems <- remDr$findElements("xpath", jobXpath$xpathAttribute)
    txts = unlist(sapply(elems, function(elem) elem$getElementText()))
    sum = sum(nchar(txts))
    elemNr <- elemNr + 1
    if(!sum) print(paste0("try next xpathAttr: ", elemNr))
  }
  
  # lapply(elems, function(elem) elem$getElementText())
  # todo: what is happening here?
  remDr$findElement("css", "html")$getElementText()
  jobXpath <- getElementFullXPath(elems[elemNr], excludeAttribute = excludeAttribute)
  # elems <- remDr$findElements("xpath", jobXpath$xpathAttribute)
  print(paste0("Amount elements: ", length(elems)))
  return(
    list(
      xpathAttr = jobXpath$xpathAttribute,
      xpath = jobXpath$xpath,
      elems = elems,
      len = length(elems),
      txts = txts
    )
  )
}

expr <- function(remDr = ""){
  remDr$open()
}
newDriver = function(remDr){
  tryCatch(
    expr = expr(remDr),
    error = function(e){
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
      return(remDr)
    }
  )
}


# to do: Union Investment - , "Alle" könnte auch andere dropdowns betreffen
ExpandAmtOffer2575 = function(elemNr = NULL, click = 2, itemNr = 1){
  amtDisplayJobs <- c("20", "25", "30", "40", "50", "50 pro Seite", "75", "100", "150", "200", "250", "Alle", "All", "Alle Einträge")
  xpathes <- paste0("//*/option[@value = '", amtDisplayJobs,"']")
  xpathes <- paste0("//mat-option[text() = '", amtDisplayJobs,"']")
  xpathes <- paste0("//*[text()[contains(., 100)]]")
  amtDisplay <- lapply(xpathes, function(xpath) remDr$findElements('xpath', xpath))
  lapply(amtDisplay[[1]], function(m) m$getElementTagName())
  idx = which(lengths(amtDisplay) > 0)
  if(length(idx)){
    if(is.null(elemNr)){
      elemNr <- max(idx)
      print(paste0("trying: ", amtDisplayJobs[elemNr]))
    }
    s <- amtDisplay[[elemNr]]
    if(click == 1) s[[itemNr]]$clickElement()
    if(click == 2) clickElement2(remDr, s[itemNr])
  }
}



scrapeData = function(jobNameXpath, switchPageXpath, nextPageLinkName, unidentical = TRUE,
                      clicker = "click", maxIter = 100, switchPageCountUp = switchPageCountUp,
                      switchPageLoadMore = switchPageLoadMore, location = param$location, 
                      bereich = param$bereich, eingestelltAm = param$eingestelltAm){
  if(is.null(maxIter)) maxIter = 100
  if(is.null(unidentical)) unidentical = TRUE
  jobResults = list()
  jobDescriptions = list()
  locationResults <- list()
  bereichResults <- list()
  eingestelltAmResults <- list()
  
  pageNr = 1
  previousResult = ""
  click <- function(clickElem) clickElem$clickElement()
  
  # only one page?
  if(!length(nextPageLinkName)){
    resultElems <- remDr$findElements("xpath", jobNameXpath)
    jobResults = unlist(lapply(resultElems, function(resultElem) resultElem$getElementText()))
    jobDescriptions = unlist(lapply(resultElems, function(resultElem) resultElem$getElementAttribute("href")))
    

    if(!is.null(location)){
      resultElems <- remDr$findElements("xpath", location)
      locationResults = unlist(lapply(resultElems, function(resultElem) resultElem$getElementText()))
    }else{
      locationResults = ""
    }

    if(!is.null(bereich)){
      resultElems <- remDr$findElements("xpath", bereich)
      bereichResults = unlist(lapply(resultElems, function(resultElem) resultElem$getElementText()))
    }else{
      bereichResults = ""
    }
    
    if(!is.null(eingestelltAm)){
      resultElems <- remDr$findElements("xpath", eingestelltAm)
      eingestelltAmResults = unlist(lapply(resultElems, function(resultElem) resultElem$getElementText()))
    }else{
      eingestelltAmResults = ""
    }
    
  }else if(nextPageLinkName %in% switchPageCountUp){
    continue = TRUE
    while(continue & pageNr < maxIter){
      elemsClickpageNr <- remDr$findElements("xpath", switchPageXpath(nextPageLinkName))
      elemsIter <- remDr$findElements("xpath", jobNameXpath)
      jobResults[[pageNr]] = lapply(elemsIter, function(elem) elem$getElementText())
      jobDescriptions[[pageNr]] = lapply(elemsIter, function(elem) elem$getElementAttribute("href"))
      
      if(!is.null(location)){
        resultElems <- remDr$findElements("xpath", location)
        locationResults[[pageNr]] = unlist(lapply(resultElems, function(resultElem) resultElem$getElementText()))
      }else{
        locationResults = ""
      }
      
      bereichResults <- NULL
      if(!is.null(bereich)){
        resultElems <- remDr$findElements("xpath", bereich)
        bereichResults[[pageNr]] = unlist(lapply(resultElems, function(resultElem) resultElem$getElementText()))
      }else{
        bereichResults = ""
      }
      
      eingestelltAmResults <- NULL
      if(!is.null(eingestelltAm)){
        resultElems <- remDr$findElements("xpath", eingestelltAm)
        eingestelltAmResults[[pageNr]] = unlist(lapply(resultElems, function(resultElem) resultElem$getElementText()))
      }else{
        eingestelltAmResults = ""
      }
      
      continue = length(elemsClickpageNr) > 0 
      if(unidentical) continue = continue & !identical(previousResult, jobResults[[pageNr]])
      previousResult <- jobResults[[pageNr]]
      if(continue){
        # elemsClickpageNr[[1]]$getElementText()
        tryCatch(click(elemsClickpageNr[[1]]), error = function(e){
          print("switch to click2")
          clickElement2(remDr, elemsClickpageNr[1])
        }) 
      } 
      Sys.sleep(3)
      print(pageNr)
      pageNr = pageNr + 1
      if(suppressWarnings(!is.na(as.numeric(gsub("'", "", nextPageLinkName))))){
        nextPageLinkName = as.numeric(gsub("'", "", nextPageLinkName))
        nextPageLinkName = nextPageLinkName + 1
        nextPageLinkName = as.character(nextPageLinkName)  #paste0("'", nextPageLinkName + 1, "'")
      }
    }
  }else if(nextPageLinkName %in% switchPageLoadMore){
    elems <- 0
    amtElems = 0
    
    while(length(elems) != amtElems){
      if(clicker == "submit"){
        nextPage <- remDr$findElements("xpath", switchPageXpath(nextPageLinkName))
        nextPage[[1]]$submitElement()
      }else if(clicker == "click"){
        nextPage <- remDr$findElements("xpath", switchPageXpath(nextPageLinkName))
        if(length(nextPage)){
          tryCatch(click(nextPage[[1]]), error = function(e){
            print("switch to click2")
            clickElement2(remDr, nextPage)
          })
        }else{
          print("no link to click")
        }
      }      
      Sys.sleep(3)
      amtElems = length(elems)
      print(amtElems)
      elems <- remDr$findElements("xpath", jobNameXpath)
    }
    resultElems <- remDr$findElements("xpath", jobNameXpath)
    jobResults = unlist(lapply(resultElems, function(resultElem) resultElem$getElementText()))
    jobDescriptions = unlist(lapply(resultElems, function(resultElem) resultElem$getElementAttribute("href")))

    if(!is.null(location)){
      resultElems <- remDr$findElements("xpath", location)
      locationResults = unlist(lapply(resultElems, function(resultElem) resultElem$getElementText()))
    }else{
      locationResults = ""
    }

    if(!is.null(bereich)){
      resultElems <- remDr$findElements("xpath", bereich)
      bereichResults = unlist(lapply(resultElems, function(resultElem) resultElem$getElementText()))
    }else{
      bereichResults = ""
    }

    if(!is.null(eingestelltAm)){
      resultElems <- remDr$findElements("xpath", eingestelltAm)
      eingestelltAmResults = unlist(lapply(resultElems, function(resultElem) resultElem$getElementText()))
    }else{
      eingestelltAmResults <- ""
    }
    
        
  }else{
    print("Dont have the link name included....please add it!")
  }
  
  return(
    list(
      jobResults = jobResults,
      jobDescriptions = jobDescriptions,
      location = locationResults,
      eingestelltAm = eingestelltAmResults,
      bereich = bereichResults
    )
  )
}


# # }else if(sum(lengths(sapply(c(2, "'backfor'", "'b_pagination__link'", "'sc-bmyXtO jVmCmP sc-dnqmqq gBBUEN'", "' Next > '", "'mehr Jobs laden'", "'right'", "'b_linkarrow b_linkarrow--right bJS_pagebrowser_next'", "'paginationArrow sapIcon'","'backfor-more'", "'Zur nächsten Seite'", "'Nächste Seite'", "tablenav_top_nextlink_66856", "'Next >'", "'›'", "'icon itnav_next'",
# #                               "nächste Seite", "'View Next'", "'halflings halflings-menu-right'", "'>'", "'fa fa-angle-right'", "'»'", "2", "'2'", "'pagerElement pager-next'",
# #                               "'Nächste'", "'Next Page'", "'icon-double-arrow-r'", "'nächste'", "'next'", "'Weiter'", "'Nächste 100'", "'Load more'",
# #                               "'Next'", "''"), grep, x = nextPageLinkName)))){
# }else if(sum(lengths(sapply(c(2, "'backfor'", "'b_pagination__link'", "'sc-bmyXtO jVmCmP sc-dnqmqq gBBUEN'", "' Next > '", "'mehr Jobs laden'", "'right'", "'b_linkarrow b_linkarrow--right bJS_pagebrowser_next'", "'paginationArrow sapIcon'","'backfor-more'", "'Zur nächsten Seite'", "'Nächste Seite'", "tablenav_top_nextlink_66856", "'Next >'", "'›'", "'icon itnav_next'",
#                               "nächste Seite", "'View Next'", "'halflings halflings-menu-right'", "'>'", "'fa fa-angle-right'", "'»'", "2", "'2'", "'pagerElement pager-next'",
#                               "'Nächste'", "'Next Page'", "'icon-double-arrow-r'", "'nächste'", "'next'", "'Weiter'", "'Nächste 100'", "'Load more'",
#                               "'Next'", "''"), grep, x = nextPageLinkName)))){
#   continue = TRUE
#   while(continue & pageNr < maxIter){
#     # elemsClickpageNr <- remDr$findElements("xpath", nextPageLinkName)
