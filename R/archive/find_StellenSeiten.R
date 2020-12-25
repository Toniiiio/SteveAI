library(RSelenium)
portNr <- 25371
system(paste0("sudo -kS docker run -d -p ", portNr, 
              ":4444 selenium/standalone-firefox:2.53.0"),
       input = "Donthack1")
remDr <- remoteDriver(
  remoteServerAddr = "localhost",
  port = portNr,
  browserName = "firefox"
)
remDr$open()
remDr$setWindowSize(1900, 2200)


url = targetURL
PageLinks <- function(url){
  remDr$navigate(url)
  elems = remDr$findElements("xpath", "//a")
  links = lapply(elems, function(elem) elem$getElementAttribute("href"))
  # locations = lapply(elems, function(elem) elem$getElementLocation())
  # idx = lengths(sapply(links, grep, pattern = "union-investment.de")) > 0
  out <- unlist(links)
  if(is.null(out)) out <- ""
  return(out)
}

TryPageLinks = function(url){
  tryCatch(expr = PageLinks(url),
           error = function(e){
             print("error")
             return(url)
           }
  ) 
}
url = checkHrefs[searchIndex]
TryPageLinks(url)

# https://psi-hr.dvinci-hr.com/de/jobs

linkLevel[[2]] = unlist(lapply(url, pageLinks))

ddd = lapply(unique(linkLevel[[2]]), pageLinks)
pageLinks(url)

BaseURL <- function(url){
  splitters <- c(".com", ".de", ".at", ".net", ".fr")
  splitted <- sapply(splitters, x = url, strsplit)
  idx <- which(lengths(splitted) > 1)[1]
  baseURL <- splitted[as.numeric(idx)][[1]][1]
  return(paste0(baseURL, names(idx)))
}


# todo: ggf. base URL auf 
compName = "BASF"
targetURL = "https://www.datev.de/bms/cgi-bin/appl/selfservice.pl?action=startapp;job_pub_nr=9347367E-37B0-4FB1-B8F7-110DBD27296A;p=homepage"
targetURL = "https://mw-powerengineering.de/stellenangebote/einkaufsachbearbeiter-w-m/"
targetURL = "https://careers.bloomberg.com/job/detail/72499"
targetURL = "https://jobs.zalando.com/jobs/1487214-abteilungsleiter-m-w-textil/"
targetURL = "https://www.cofinpro.de/karriere/stellenanzeige/backend-entwickler-java/"
remDr$navigate(targetURL)

FindStellenSeite <- function(compName, targetURL){
  # baseUrl <- BaseURL(url)
  # googledURLStelle = google()
  # googledURLBase = google()
  hrefs = ""
  target = ""
  checkHrefs = targetURL #c(baseUrl, googledURLStelle, googledURLBase)
  depth = 1
  continue <- TRUE
  
  while(continue & depth < 6){
    exclude <- paste(c("xing.com", "linkedin.com", "facebook.com", "www.instagram", "kununu.com", "google.com", "twitter.com", "youtube.com", 
                       "impressum", "newsletter", "www.glassdoor", "presse", "pinterest.de", "@", "javascript:", "mailto:", "cookiebot.com",
                       ".png", ".jpg", ".jpeg"), collapse = "|")
    idx <- grep(exclude, checkHrefs, fixed = FALSE)
    if(length(idx)) checkHrefs <- checkHrefs[-idx]
    continueSearch <- TRUE
    searchIndex <- 1
    newHrefs <- list()
    while(searchIndex <= length(checkHrefs) & continueSearch){
      print(checkHrefs[searchIndex])
      newHrefs[[searchIndex]] <- TryPageLinks(checkHrefs[searchIndex])
      if(depth == 1) newHrefs[[searchIndex]] <- setdiff(newHrefs[[searchIndex]], targetURL)
      continueSearch <- !sum(newHrefs[[searchIndex]] %in% targetURL)
      searchIndex <- searchIndex + 1
    }

    if(!continueSearch){
      target = checkHrefs[searchIndex - 1]
      continue <- FALSE
    }else{
      checkHrefs <- setdiff(unique(unlist(newHrefs)), hrefs)
      hrefs <- unique(c(hrefs, checkHrefs))
      depth <- depth + 1
    }
  }
  return(target)
}
FindStellenSeite(compName, targetURL)





# Manual Results


# Ausgangpunkt: Connecticum. Beispiel: www.basf.com/jobs/research-scientists.html
# Startpunkte:
# Von eigener Seite: www.basf.com/jobs/stellenangebote/research-scientists.html
# Gegooglte Seite "basf stellenangebote": www.basf.com/jobs/ oder stepstone.de/Basf
# Gegooglte Seite "basf": www.basf.com/jobs/ oder stepstone.de/Basf
# Und Base Seite: www.basf.com/ oder generaljobportal.com/basfgehashed
# 
# Ziel: Stellenangebotsseite, ist die Seite, die auf die Zielseite verlinkt.
