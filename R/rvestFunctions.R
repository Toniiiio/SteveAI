isHtmlDoc <- function(elem){
  all(names(elem) %in% c("node", "doc"))
}

getHTML <- function(getURL, targetString){
  xx <- httr::GET(getURL)
  response <- content(xx)
  m <- str_count(string = response, pattern = "<.*>")
  if(length(m) > 1){
    docs <- lapply(response[m > 0], read_html)
  }else{
    docs <- response
  }

  if(isHtmlDoc((response))){
    docs <- response
    tags <- list(html_nodes(docs, xpath = paste0("//*[contains(text(), '", targetString,"')]")))
  }else{
    m2 <- lapply(docs, html_nodes, xpath = paste0("//*[contains(text(), '", targetString,"')]"))
    tags <- m2[lengths(m2) > 0]
    docs <- docs[lengths(m2) > 0]
  }

  list(
    xpath = sapply(tags, getXPathByTag, text = targetString, exact = FALSE),
    docs = docs
  )
}

# text <- txts[2]
getXPathByText <- function(text, doc, add_class = FALSE, exact = FALSE, attr = NULL, byIndex = FALSE, onlyTags = FALSE, clean_up = TRUE, to_exclude = "option"){

  if(is.character(doc)){

    warning("doc is of type character - trying to convert to xml doc with xml2::read_html")
    doc %<>% xml2::read_html()

  }

  text %<>% tolower %>% gsub(pattern = " ", replacement = "")
  text %<>% gsub(pattern = "\n|\r", replacement = "")
  xpath <- paste0("//*[text()[contains(translate(., 'ABCDEFGHIJKLMNOPQRSTUVWXYZ ', 'abcdefghijklmnopqrstuvwxyz'), '", text, "')]]")
  tag <- doc %>% html_nodes(xpath = xpath)
  tag
  tbl <- tag %>% html_name() %>% table(.)
  winner <- names(tbl) %in% to_exclude %>% magrittr::not() %>% tbl[.] %>% {names(.)[which.max(.)]}

  tag <- tag[which(html_name(tag) == winner)[1]]

  tagName <- ""
  tags <- c()

  if(length(tag) > 1){
    tagNames <- sapply(tag, html_name)
    match <- which(tagNames != "script")
    if(!length(match)) match <- 1
    tag <- tag[match[1]]
  }else if(length(tag) == 0){
    message(glue::glue("Did not find an xpath element that matches target Text: {text}!"))
    return(NULL)
  }


  while(!grepl(x = tagName, pattern = "html")){
    tagName <- tag %>% html_name
    if(add_class){
      class <- tag %>% html_attr(name = "class")
      class <- ifelse(is.na(class), yes =  "", no = glue::glue('[@class="{class}"]'))
      tagName <- glue::glue("{tagName}{class}")
    }
    tags <- c(tags, tagName)
    tag <- tag %>% html_nodes(xpath = "..")
  }

  if(onlyTags){
    return(tags %>% unique)
  }

  xpath <- paste(c("", tags[length(tags):1]), collapse = "/")
  xpath

}


scrapeGetHtml <- function(getUrl, res){
  htmlDoc <- getURL %>% GET %>% content
  subsetBy <- names(res$xpath)
  if(!is.null(subsetBy)) htmlDoc <- htmlDoc %$% get(subsetBy) %>% read_html
  texts <- htmlDoc %>% html_nodes(xpath = unname(res$xpath)) %>% html_text

  list(
    texts = texts
  )
}


extractJobLink <- function(hrefAttrText, baseUrl){
  firstHrefPart <- strsplit(hrefAttrText, ";")[[1]][1]
  hasJavascript <- grep(pattern = "javascript:", x = firstHrefPart)
  if(length(hasJavascript)){
    extractedRaw <- str_extract(
      string = firstHrefPart,
      pattern = "\\(([^)]+)\\)"
    )
    firstHrefPart <- gsub(pattern = "\\(|\\)|'", replacement = "", x = extractedRaw)
  }
  match <- substr(firstHrefPart, 1, 4) == "http"
  if(sum(match) / length(match) < 1){
    dom <- domain(baseUrl) # scraper[[compName]]$url
    url <- paste0("https://", dom,  firstHrefPart)
  }else{
    url <- firstHrefPart
  }
  return(url)
}



getXPath <- function(url, text, exact = FALSE){
  tagName <- ""
  tags <- c()
  if(exact){
    xpath <- paste0("//*[text() = '", text,"']")
  }else{
    xpath <- paste0("//*[contains(text(), '", text,"')]")
  }
  tag <- read_html(url) %>% html_nodes(xpath = xpath)
  if(!length(tag)){
    print("Element not in source!")
    return()
  }
  while(tagName != "html"){
    tag <- tag[1] %>% html_nodes(xpath = "..")
    tagName <- tag %>% html_name()
    tags <- c(tags, tagName)
  }

  xpath <- paste(c("", tags[length(tags):1]), collapse ="/")
  xpath
}


getXPathByTag <- function(tag, text, exact = FALSE){
  tagName <- ""
  tags <- c()

  if(!length(tag)){
    xpath = ""
  }else{
    if(length(tag) > 1){
      tagNames <- sapply(tag, html_name)
      match <- which(tagNames != "script")
      if(!length(match)) match <- 1
      tag <- tag[match[1]]
    }
    while(tagName != "html"){
      tagName <- tag %>% html_name()
      tags <- c(tags, tagName)
      tag <- tag %>% html_nodes(xpath = "..")
    }

    xpath <- paste(c("", tags[length(tags):1]), collapse ="/")
  }
  xpath
}


getScrapeInfo <- function(browserOutputRaw){
  splitted <- strsplit(
    x = browserOutputRaw,
    split = ";"
  )[[1]]

  browserOutput <- list(
    url = splitted[1],
    clickType = splitted[2],
    expectedOutput = strsplit(splitted[3], split = "~~~")[[1]],
    XPath = splitted[4],
    XPathBlank = gsub(
      pattern = "[[]\\d+[]]",
      replacement = "",
      x = splitted[4]
    )
  )
  browserOutput
}

getRvestText <- function(url, XPath){
  read_html(x = url) %>%
    html_nodes(xpath = XPath) %>%
    html_text()
}

getRvestHtmlSource <- function(url){
  textRaw <- read_html(x = url) %>% html_nodes(xpath = "//*[not(*) and not(self::script)]") %>% html_text()
  text <- paste(textRaw, collapse = "\n")
  text
}


getRvestHref <- function(url, XPath){
  read_html(x = url) %>%
    html_nodes(xpath = XPath) %>%
    html_attr(name = "href")
}


rvestScraping <- function(nr){
  url <- scraper[[nr]]$url
  XPath <- scraper[[nr]]$jobNameXpath

  rvestOutRaw <- getRvestText(
    url = url,
    XPath = XPath
  )

  rvestOut <- gsub(
    pattern = "\n",
    replacement = "",
    x = rvestOutRaw
  )

  rvestOut
}

urlGenWorkDays <- function(baseUrl, nr){
  middlePart <- nr - 2
  if(middlePart == -1) middlePart <- "fs"
  paste0(
    baseUrl, "/", middlePart,
    "/searchPagination/318c8bb6f553100021d223d9780d30be/", (nr - 1)*ItemsPerPage
  )
}


scrapeWorkDays <- function(url){
  GETResult <- GET(url = url)
  subset <- content(GETResult)$body$children[[1]]$children[[1]]$listItems
  maxIter = length(subset)

  jobTitle <- c()
  location <- c()
  id <- c()
  eingestelltAm <- c()

  for(nr in 1:maxIter){
    jobTitle[nr] <- subset[[nr]]$title$instances[[1]]$text
    location[nr] <- subset[[nr]]$subtitles[[1]]$instances[[1]]$text
    id[nr] <- subset[[nr]]$subtitles[[2]]$instances[[1]]$text
    eingestelltAm[nr] <- subset[[nr]]$subtitles[[3]]$instances[[1]]$text
  }


  data.frame(
    jobTitle = jobTitle,
    location = location,
    id = id,
    eingestelltAm = eingestelltAm
  )
}


scheduledGET <- function(url, targetKeys, base, baseFollow = NULL){
  if(is.null(base)){
    stop("Parameter base, provided to scheduledGET(), is NULL - please provide a valid subset value.")
  }

  getRes <- GET(url = url)
  if(getRes$status_code != 200) return(NULL)
  contentGET <- content(getRes)
  contentGETFlat <- unlist(contentGET)
  if(is.null(contentGETFlat)) return(NULL)
  splitNames <- names(contentGETFlat) %>% strsplit(split = "[.]")
  lastKeys <- sapply(X = splitNames, FUN = tail, n = 1)

  # todo;do i neeed two of these functions?
  baseElems <- subsetByStr2(contentGET, base)
  if(!length(baseElems)) return(NULL)
  targetKey <- targetKeys[[1]]
  texts <- lapply(targetKeys, function(targetKey){
    baseElem <- baseElems[[1]]
    raw <- sapply(baseElems, function(baseElem){
      if(!is.null(baseFollow)){
        baseElem <- subsetByStr3(lstRaw = baseElem, arr = baseFollow)
      }
      subsetByStr3(lstRaw = baseElem, arr = targetKey)
    }, USE.NAMES = FALSE)
    raw2 <- sapply(raw, paste, collapse = " | ") %>% unname
    if(!length(raw2)) return(raw2)
    df <- data.frame(raw2, stringsAsFactors = FALSE)
    df <- setNames(df, paste(targetKey, collapse = "|"))
    df
  })

  res <- do.call(what = cbind, texts)
  colnames(res) <- targetKeys
  rownames(res) <- NULL

  list(
    res = res,
    base = base,
    targetKeys = targetKeys
  )
}


subsetByStr2 <- function(lstRaw, arr){
  lst <- lstRaw
  nr <- 1
  for(nr in 1:length(arr)){
    lst <-  lst[[arr[nr]]]
  }
  lst
}

subsetByStr3 <- function(lstRaw, arr){
  lst <- lstRaw
  nr <- 1
  for(nr in 1:length(arr)){
    lst <-  lst[[arr[nr]]]
    if(!length(lst)) return("") # missing element return empty string
    if(is.null(names(lst))) lst <- lst[[1]]
  }
  lst
}




showHtmlPage <- function(doc){
  tmp <- tempfile(fileext = ".html")
  doc %>% toString %>% writeLines(con = tmp)
  tmp %>% browseURL(browser = rstudioapi::viewer)
}

