
matches_job_name_db <- function(doc, db_name = "rvest_scraper.db", target_table_job = "RVEST_SINGLE_JOBS"){
  # check if document contains already scraped job titles

  conn <- DBI::dbConnect(RSQLite::SQLite(), db_name)

  data <- DBI::dbGetQuery(
    statement = glue::glue("SELECT * FROM {target_table_job}"),
    conn = conn
  )

  job_names <- unique(data$jobName)
  text <- doc %>%
    as.character() %>%
    htm2txt::htm2txt()

  matches <- sapply(
    job_names,
    FUN = aregexec,
    text = text,
    fixed = TRUE
  )

  idx <- which(matches != -1)
  txts <- sapply(matches[idx], regmatches, x = text) %>% unlist

  xpathes <- sapply(txts, SteveAI::getXPathByText, doc = doc) %>%
    unique %>%
    unlist

  if(!length(xpathes)){
    return(0)
  }

  amt_xpath_matches <- sapply(
    X = xpathes,
    function(xpath) html_nodes(x = doc, xpath = xpath) %>% length
  )

  amt_jobs_matched <- txts %>% length

  # xpath match is not accurate: xpath like /div/a/h4 can match more than just the job links
  #is_job_site <- amt_jobs_matched
    #any(amt_xpath_matches %in% c(5, 10, 15, 20, 50, 100)) |

  return(amt_jobs_matched)

}

has_apply_button <- function(doc){
  doc %>%
    html_nodes(xpath = "//a[translate(text(), 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz')  = 'apply']") %>%
    length
}

has_indeed_jobs <- function(job_titles, html_text){
  if(!nchar(job_titles)) return(FALSE)
  sapply(job_titles, grepl, x = html_text) %>%
    sum
}

has_add_indicators <- function(html_text){
  indicators <- c("m/w/x", "m/f/d", "w/m/d", "m/w/d", "stelle anzeigen", "vollzeit", "vollzeit/teilzeit", "treffer pro seite", "(Junior) ", "(Senior) ")
  indicator_match <- sapply(indicators,stringr::str_count, string = tolower(html_text))
  indicator_match %>% sum
}

target_indicator_count <- function(job_titles, doc){

  if(!nchar(doc)) return(FALSE)

  html_text <- doc %>%
    as.character %>%
    htm2txt::htm2txt()

  count <- has_apply_button(doc) +
    has_indeed_jobs(job_titles = job_titles, html_text = html_text) +
    has_add_indicators(html_text) +
    matches_job_name_db(doc, db_name = "rvest_scraper.db", target_table_job = "RVEST_SINGLE_JOBS")

  return(count)

}
