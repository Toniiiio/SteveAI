library(magrittr)
url <- "https://google.de/"

x1 <- httr::GET(url) %>%
  httr::content() %>%
  as.character %>%
  htm2txt::htm2txt()

x2 <- htm2txt::gettxt(url, encoding = "UTF-8")

url <- "https://vbg.de/"
x <- paste(readLines(url, warn = FALSE, encoding = "UTF-8"), sep = '', collapse = ' ')


xml2::read_html(url)
x1 <- httr::GET(url) %>%
  httr::content() %>%
  as.character %>%
  htm2txt::htm2txt()



library(RSelenium)

remoteServerAddr = "localhost"
port = 4452
browserName = "firefox"
path = "/wd/hub"
version = ""
platform = "ANY"
javascript = TRUE
nativeEvents = TRUE
extraCapabilities = list()
serverURL <<- paste0("http://", remoteServerAddr, ":", port, path)

serverOpts <- list(
  desiredCapabilities =
    list(
      browserName = browserName,
      version = version,
      javascriptEnabled = javascript,
      platform = platform,
      nativeEvents = nativeEvents
    )
)

queryRD = function(ipAddr, method = "GET", qdata = NULL) {
  "A method to communicate with the remote server implementing the
          JSON wire protocol."
  getUC.params <-
    list(url = ipAddr, verb = method, body = qdata, encode = "json")
  res <- tryCatch(
    do.call(httr::VERB, getUC.params),
    error = function(e) e
  )
  if (inherits(res, "response")) {
    resContent <- httr::content(res, simplifyVector = FALSE)
    checkStatus(resContent)
  } else {
    checkError(res)
  }
}

if (length(extraCapabilities) > 0) {
  serverOpts$desiredCapabilities <-
    c(
      serverOpts$desiredCapabilities,
      extraCapabilities
    )
}
qpath <- sprintf("%s/session", serverURL)
ipAddr = qpath
method = "POST"
qdata = serverOpts
queryRD(ipAddr = qpath, method = "POST", qdata = serverOpts)
