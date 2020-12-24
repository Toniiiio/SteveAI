# library(RSelenium.extras)

# getElementAttributeValues(remDr, elem, excludeAttribute = "")
# getElementFullXPathfunction(elem, excludeAttribute = "")
# getElementWithDates(remDr)
# getElementWithEntities(remDr, spacyModel = "de", entityType = "LOC_B")
# clickElemen2(remDr, elem)
# displayScreenshot()
# mapContainerPort(portNr, password)


# library(RSelenium)
# portNr <- 14342
# system(paste0("sudo -kS docker run -d -p ", portNr, 
#               ":4444 selenium/standalone-firefox:2.53.0"),
#        input = "Donthack1")
# remDr <- remoteDriver(
#   remoteServerAddr = "localhost",
#   port = portNr,
#   browserName = "firefox"
# )
# remDr$open()
# remDr$navigate("https://www.r-project.org/")
# xpath <- "//div[@class = 'container page']//div[@class = 'row']//div"
# elems <- remDr$findElements("xpath", xpath)
# elem <- elems[1]

getElementAttributeValues <- function(remDr, elem, excludeAttribute = ""){
  jsCode <- "var attribs = {}; 
  for (idx = 0; idx < arguments[0].attributes.length; ++idx) { 
  attrib = arguments[0].attributes[idx]
  attribs[attrib.name] = attrib.value 
  };
  return attribs;"
  attributesRaw <- remDr$executeScript(jsCode, args = elem)
  attributes <- attributesRaw[setdiff(names(attributesRaw), excludeAttribute)]
  tagName <- elem[[1]]$getElementTagName()[[1]]  
  
  if(length(attributes)){
    xpathElementsRaw <- sapply(1:length(attributes), 
                               function(nr) paste0("@", names(attributes[nr]), " = '", attributes[[nr]], "'"))
    elementXPath <- paste0("//", tagName, "[", paste(xpathElementsRaw, collapse = " and "), "]")
  }else{
    elementXPath <- paste0("//", tagName, paste("", collapse = " and "))
  }
  output <- list(attribute = attributes, xpath = elementXPath)
  
  return(output)
}
# getElementAttributeValues(remDr, elem)

# elems <- elemsWithDates
getElementFullXPath <- function(elem, excludeAttribute = ""){
  finalTagName <- elem[[1]]$getElementTagName()
  finalTagXpath <- getElementAttributeValues(remDr, elem, excludeAttribute)$xpath
  tagNames <- list()
  xpathes <- list()
  continue <- TRUE
  nr <- 1
  while(continue){ #nr < 100
    elem <- elem[[1]]$findChildElements("xpath", ".//parent::*")  
    tagNames[[nr]] <- elem[[1]]$getElementTagName()
    xpathes[[nr]] <- getElementAttributeValues(remDr, elem, excludeAttribute)$xpath
    continue <- tagNames[[nr]] != "html"
    nr <- nr + 1
    # are there html pages without html tag? https://stackoverflow.com/questions/5641997/is-it-necessary-to-write-head-body-and-html-tags
  }
  
  list(xpath = paste(paste0(c(unlist(xpathes)[length(xpathes):1], finalTagXpath)) , collapse = ""),
       xpathAttribute = paste(paste0("//", c(unlist(tagNames)[length(tagNames):1], finalTagName)) , collapse = ""))
}

# getElementFullXPath(elems[10])

getElementFullXPathFast <- function(elem, excludeAttribute = ""){
  finalTagName <- elem[[1]]$getElementTagName()
  finalTagXpath <- getXPath(remDr, elem[[1]])

  list(xpath = finalTagXpath,
       xpathAttribute = finalTagXpath)
}



getElementWithDates <- function(remDr){
  bodyTextRaw <- remDr$findElement("css", "body")$getElementText()
  bodyText <- gsub("\n", " ", bodyTextRaw)
  bodyTextSplit <- strsplit(bodyText, " ")[[1]]
  regex <- "^(?:(?:31(\\/|-|\\.)(?:0?[13578]|1[02]))\\1|(?:(?:29|30)(\\/|-|\\.)(?:0?[1,3-9]|1[0-2])\\2))(?:(?:1[6-9]|[2-9]\\d)?\\d{2})$|^(?:29(\\/|-|\\.)0?2\\3(?:(?:(?:1[6-9]|[2-9]\\d)?(?:0[48]|[2468][048]|[13579][26])|(?:(?:16|[2468][048]|[3579][26])00))))$|^(?:0?[1-9]|1\\d|2[0-8])(\\/|-|\\.)(?:(?:0?[1-9])|(?:1[0-2]))\\4(?:(?:1[6-9]|[2-9]\\d)?\\d{2})$"
  isDate = grepl(regex, bodyTextSplit)
  datesTxt <- unique(bodyTextSplit[isDate])
  dateElemsRaw <- lapply(datesTxt, function(dateTxt) remDr$findElements("xpath", 
                                                                        paste0("//*[contains(text(),'", dateTxt,"')]")))
  dateElems <- unlist(dateElemsRaw, recursive = FALSE)
  return(dateElems)
}



getElementWithEntities <- function(remDr, spacyModel = "de", entityType = "LOC_B"){
  bodyTextRaw <- remDr$findElement("css", "body")$getElementText()
  bodyText <- gsub("\n", " ", bodyTextRaw)
  bodyTextSplit <- strsplit(bodyText, " ")[[1]]
  
  library(spacyr)
  spacy_initialize(spacyModel)
  parsedtxt <- spacy_parse(bodyTextSplit)
  docIds <- parsedtxt[parsedtxt$entity == entityType, ]$doc_id
  idx <- as.numeric(sapply(docIds, function(docId) strsplit(docId, "text")[[1]][2]))
  entityWords <- unique(bodyTextSplit[idx])
  result <- list()
  for(word in entityWords){
    result[[word]] <- remDr$findElements("xpath", paste0("//*[contains(text(), '", word ,"')]"))
  }
  return(result)
}

clickElement2 <- function(remDr, elem){
  remDr$executeScript("arguments[0].click();", args = elem[1])  
}

displayScreenshot  <- function(remDr, elem){
  
}

getXPath <- function(remDr = remDr, elem){
  outRaw1 = remDr$executeScript(
    script = "
    gPt = function(c){
    /*if(c.id!==''){
    return'id(\"'+c.id+'\")'
    }*/
    if(c===document.body){
    return c.tagName
    }
    var a=0;
    var e=c.parentNode.childNodes;
    for(var b=0;b<e.length;b++){
    var d=e[b];
    if(d===c){
    return gPt(c.parentNode)+'/'+c.tagName+'['+(a+1)+']'
    }
    if(d.nodeType===1&&d.tagName===c.tagName){
    a++
    }
    }
    };
    return gPt(arguments[0]).toLowerCase();
    ",
    args = list(elem)
  )
  outRaw2 <- gsub("[[]\\d[]]|", "", outRaw1)
  out <- gsub("/", "//", outRaw2)
  out <- paste0("//", out)
  return(out)
}

# getXPath(remDr, elem = data[[3]])


mapContainerPort = function(portNr, password){
  system(paste0("sudo -kS docker run -d -p ", portNr, 
                ":4444 selenium/standalone-firefox:2.53.0"),
         input = password)  
}


# url <- "https://de.devoteamcareers.com/de/offene-stellen/"
downloadToLocal <- function(url, includeFiles = FALSE){
  add <- ifelse(includeFiles, "-p -k -e robots=off ", "")
  cmd <- paste0("wget ", add, url)
  system(cmd)  
}

removeCssClassElement <- function(elems, className, replacement = ""){
  # elems = remDr$findElements("xpath", "//div[contains(@class, 'collapsed')]")
  sapply(elems, function(elem){
    currentClass <- elem$getElementAttribute("class")
    elem$setElementAttribute("class", gsub(className, replacement, currentClass))
  })
}


addCssClassElement <- function(elems, addClass = ""){
  # elems = remDr$findElements("xpath", "//div[contains(@class, 'collapsed')]")
  sapply(elems, function(elem){
    currentClass <- elem$getElementAttribute("class")
    elem$setElementAttribute("class", paste(currentClass, addClass))
  })
}


### Find difference after button is clicked  
# remDr$navigate("https://www.wirecard.com/de/unternehmen/karriere")
# xx = remDr$getPageSource()
# 
# elems = remDr$findElements("xpath", "//*[contains(@class, 'collapse')]")
# addCssClassElement(elems, addClass = "show")
# xx2 = remDr$getPageSource()

