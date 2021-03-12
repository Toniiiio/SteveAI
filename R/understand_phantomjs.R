#
# library(webdriver)
# library(magrittr)
#
# start_phantom <- function(){
#   pjs <- webdriver::run_phantomjs()
#   webdriver::Session$new(port = pjs$port)
# }
#
# pjs <- webdriver::run_phantomjs()
# pjs
# ses <- webdriver::Session$new(port = pjs$port)
#
#
# ses <- start_phantom()
# ses$getUrl()
# ses$go("https://www.jobs.abbott/us/en")
#
# doc <- ses$findElement(xpath = "/*")$getAttribute(name = "innerHTML")
# doc
#
# elem <- ses$findElement(xpath = "//button[*[contains(text(), 'Jobs')]]")
# elem$click()
# ses$takeScreenshot()
#
#
# pjs <- webdriver::run_phantomjs()
# ses <- webdriver::Session$new(port = pjs$port)
# ses$getUrl()
#
#
#
#
# all_doc <- "https://career.centogene.com/de" %>% read_html
# htm2txt::htm2txt(as.character(all_doc))
#
# session_getUrl <- function(self, private) {
#
#   "!DEBUG session_getUrl"
#   response <- private$makeRequest(
#     "GET CURRENT URL"
#   )
#
#   response$value
# }
#
#
# makeRequest = function(endpoint, data = NULL, params = NULL,
#                        headers = NULL)
#   session_makeRequest(self, private, endpoint, data, params, headers)
# )
#
#
#
# endpoint = "GET CURRENT URL"
#
# session_makeRequest <- function(self, private, endpoint, data, params,
#                                 headers) {
#
#   "!DEBUG session_makeRequest `endpoint`"
#   headers <- update(default_headers, as.character(headers))
#
#   ep <- parse_endpoint(endpoint, private, params)
#
#   url <- paste0(
#     "http://",
#     private$host,
#     ":",
#     private$port,
#     ep$endpoint
#   )
#
#
#
# 127.0.0.1:6138/session/:15408/url
