
scrape_indeed <- function(){
  url <- "https://de.indeed.com/cmp/_cs/cmpauto?returncmppageurls=1&q=a&caret=1&n=50"

  data <- url %>% httr::GET() %>% httr::content() %>% jsonlite::fromJSON()
  data


  urls <- paste0("https://de.indeed.com", data$overviewUrl,"/about")


  exclude <- paste(c("youtube", "facebook", "kununu", "instagram", "linkedin", "xing"), collapse = "|")
  xx <- function(url, exclude){
    doc <- url %>% read_html()

    links_raw <- html_nodes(x = doc, xpath = "//*[text() = 'Links']") %>%
      html_nodes(xpath = "..//a") %>%
      html_attr(name = "href")

    links <- (not(sapply(links_raw, grepl, pattern = exclude)) &
                substring(links_raw, first = 1, last = 1) != "/") %>%
      {names(.[.])}

    return(links)

  }

  comp_urls <- lapply(urls, xx, exclude = exclude)
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
