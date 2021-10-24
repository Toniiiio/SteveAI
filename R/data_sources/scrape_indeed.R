# library(magrittr)
# library(xml2)
# library(rvest)
#
# x <- letters
# y <- letters
# d1 <- expand.grid(x = x, y = y, z = y, z1 = y, z2 = y, stringsAsFactors = FALSE)
#
# strs <- apply(d1, 1, function(row) row %>% c %>% paste0(collapse = ""))
# save(strs, file = "../strs.RData")



get_comp_urls <- function(str){
  url <- paste0("https://de.indeed.com/cmp/_cs/cmpauto?returncmppageurls=1&q=", str,"&caret=1&n=50")
  data <- url %>% httr::GET() %>% httr::content() %>% jsonlite::fromJSON()

  urls <- paste0("https://de.indeed.com", data$overviewUrl,"/about")
  urls
}

# urls <- rep(NA, length(strs))
# for(nr in seq(strs)){
#   print(nr)
#   urls[nr] <- get_comp_urls(strs[nr])
#   save(urls, file = "../urls.RData")
#   Sys.sleep(3)
# }
# urls[1:5]
#
#
# urls <- setdiff(unique(urls),  "https://de.indeed.com/about")


exclude <- paste(c("youtube", "facebook", "kununu", "instagram", "linkedin", "xing"), collapse = "|")
xx <- function(url, exclude){
  doc <- url %>% read_html()
  #url %>% browseURL()

  links_raw <- html_nodes(x = doc, xpath = "//*[text() = 'Links']") %>%
    html_nodes(xpath = "..//a") %>%
    html_attr(name = "href")

  links <- (not(sapply(links_raw, grepl, pattern = exclude)) &
              substring(links_raw, first = 1, last = 1) != "/") %>%
    {names(.[.])}

  if(is.null(links)) links <- ""

  return(links)

}


# comp_urls <- rep(NA, length(strs))
# nr <- 2
# urls[1:2]
# #seq(urls)
# for(nr in 1:3){
#   print(nr)
#   comp_urls[2] <- xx(url = urls[nr], exclude = exclude)
#   save(comp_urls, file = "../comp_urls.RData")
# }



scrape_indeed <- function(url){


  comp_urls
  save(comp_urls, file = "comp_urls.RData")
  load("comp_urls.RData")
  job_sites_indeed <- urls %>% gsub(pattern = "/about", replacement = "/jobs")

  # start with substring /

  url <- "https://de.indeed.com/cmp/Allianz/jobs"
  url <- job_sites_indeed[6]
  xp <- "//*[@data-testid='jobTitle']"

  doc <- url %>% read_html()
  job_titles <- html_nodes(x = doc, xpath = xp) %>%
    html_text()
  job_titles

  xp <- "//div/a/div/div/h3"
  url <- "https://www.asklepios.com/beruf/stellenangebote-und-bewerbung/alle-stellenangebote/"

  doc <- url %>% read_html()
  job_titles2 <- html_nodes(x = doc, xpath = xp) %>%
    html_text()
  job_titles2


  unique(job_titles2) %in% unique(job_titles)

}
