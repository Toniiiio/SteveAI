dont_run <- function(){

  setwd("~")
  source("SteveAI/R/jobLinks.R")
  # 1. read all job data
  # 2. Filter all that have links
  # 3. Filter for the ones that arent scraped yet.
  # 4. Group by company to identify the format and what to remove from the job desc page.

  db_name <- "rvest_scraper.db"
  target_table_job <- "RVEST_SINGLE_JOBS"
  conn <- DBI::dbConnect(RSQLite::SQLite(), db_name)

  data <- DBI::dbGetQuery(
    conn = conn,
    statement = glue("SELECT * FROM {target_table_job}")
  )

  keep <- which(is.na(data$links))

  length(keep)

  comp_nr <- 3
  with_links <- data[keep, ]
  all_comps <- with_links$comp %>% unique
  with_links$links

  data$comp %>% unique


  names(rvestScraper) %>% sort

  comp_name <- "FIDA"
  comp_name <- "CLOUDMADE"
  comp_name <- "KLETT"
  comp_name <- comps[5]
  find_neighbours <- function(comp_name){
    comp <- SteveAI::rvestScraper[[comp_name]]
    doc <- comp$url %>% read_html

    nodes <- doc %>% html_nodes(xpath = comp$jobNameXpath)

    job_desc_id <- "Das bringen Sie mit"
    contains_txt <- paste0("../..//*[self::a or contains(text(),'", job_desc_id, "')]")
    search_links <- c("..//a", "../..//a", "../../..//a", "../../../..//a", contains_txt)

    a_nodes <- lapply(search_links, function(xp) html_nodes(x = nodes, xpath = xp))

    print(length(nodes))
    print(lengths(a_nodes))

    # quotient <- lengths(a_nodes) / length(nodes)
    # is_multiple <- quotient > 1 & quotient%%1==0
    # xps <- paste0(search_links [is_multiple], "[", 1:quotient[is_multiple], "]")
    #
    # a_nodes <- lapply(xps, function(xp) html_nodes(x = nodes, xpath = xp))
    # lapply(a_nodes, html_text)

    idx <- which(length(nodes) == lengths(a_nodes))[1]
    search_links[idx]
  }

  comps <- with_links$comp %>% unique

  for(comp_name in comps){
    find_neighbours(comp_name)
    print("___________________________")
  }


  find_neighbours("cloudmade")

  comp$url %>% browseURL()

  library(magrittr)
  library(xml2)
  library(rvest)
  url <- "https://www.connext.de/connext/karriere/stellenangebote.aspx"
  doc <- url %>% xml2::read_html()
  txt <- "Software-Architekt (m/w/d)"
  xp <- getXPathByText(text = txt, doc = doc)

  xp <- "/html/body/form/div/div/div/div/span[1]"
  nodes <- doc %>% html_nodes(xpath = xp)

  job_desc_id <- "Das bringen Sie mit"
  contains_txt <- paste0("../..//*[self::a or contains(text(),'", job_desc_id, "')]")
  search_links <- c("..//a", "../..//a", "../../..//a", contains_txt)

  a_nodes <- lapply(search_links, function(xp) html_nodes(x = nodes, xpath = xp))

  print(length(nodes))
  print(lengths(a_nodes))


}
