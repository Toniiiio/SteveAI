
matches_job_name_db <- function(doc, html_text, db_name = "rvest_scraper.db", target_table_job = "RVEST_SINGLE_JOBS"){
  # check if document contains already scraped job titles

  conn <- DBI::dbConnect(RSQLite::SQLite(), db_name)

  data <- DBI::dbGetQuery(
    statement = glue::glue("SELECT * FROM {target_table_job}"),
    conn = conn
  )

  job_names <- unique(data$jobName)

  texts <- approx_match_strings(target_strings = job_names, html_text = html_text)
  return(table(texts))

  # xpathes <- sapply(txts, SteveAI::getXPathByText, doc = doc) %>%
  #   unique %>%
  #   unlist
  #
  # if(!length(xpathes)){
  #   return(0)
  # }
  #
  # amt_xpath_matches <- sapply(
  #   X = xpathes,
  #   function(xpath) html_nodes(x = doc, xpath = xpath) %>% length
  # )
  #
  # amt_jobs_matched <- txts %>% length

  # xpath match is not accurate: xpath like /div/a/h4 can match more than just the job links
  #is_job_site <- amt_jobs_matched
    #any(amt_xpath_matches %in% c(5, 10, 15, 20, 50, 100)) |

}

has_apply_button <- function(doc){
  doc %>%
    html_nodes(xpath = "//a[translate(text(), 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz')  = 'apply']") %>%
    length
}

match_strings <- function(target_strings, html_text){
  has_target_strings <- !nchar(target_strings) %>% sum
  if(has_target_strings) return(FALSE)

  sapply(tolower(target_strings), stringr::str_count, string = tolower(html_text)) %>%
    {.[. > 0]}

}

# todo: Multiple matches
# target_strings <- "as"
# html_text <- "as d as"
approx_match_strings <- function(target_strings, html_text){

  has_targets <- nchar(target_strings) %>% sum
  if(!has_targets) return(character())

  matches <- sapply(
    target_strings,
    FUN = aregexec,
    text = html_text,
    fixed = TRUE
  )


  idx <- which(matches != -1)
  txts <- sapply(matches[idx], regmatches, x = html_text) %>% unlist
  txts

}


has_indeed_jobs <- function(job_titles, html_text){
  if(!nchar(job_titles)) return(FALSE)
  sapply(job_titles, grepl, x = html_text) %>%
    {names(.[.])}
}

has_add_indicators <- function(html_text){
  indicators <- c("m/w/x", "m/f/d", "w/m/d", "m/w/d", "stelle anzeigen", "vollzeit", "vollzeit/teilzeit", "treffer pro seite", "(Junior) ", "(Senior) ")
  indicator_match <- sapply(indicators,stringr::str_count, string = tolower(html_text))
  indicator_match %>% sum
}

target_indicator_count <- function(job_titles, doc){

  if(!nchar(doc[1])) return(FALSE)

  html_text <- tryCatch(doc %>% as.character %>% htm2txt::htm2txt(),
                        error = function(e){
                          message(e)
                          warning(e)
                          return("")
                        })

  indicators <- c("m/w/x", "m/f/d", "f/m/d", "w/m/d", "m/w/d", "stelle anzeigen", "vollzeit", "vollzeit/teilzeit", "treffer pro seite", "(Junior) ", "(Senior) ")
  add_indicators <- match_strings(target_strings = indicators, html_text = html_text)
  indeed_jobs <- approx_match_strings(target_strings = job_titles, html_text = html_text)
  apply_button <- has_apply_button(doc)
  job_name_db <- matches_job_name_db(doc = doc, html_text = html_text, db_name = "rvest_scraper.db", target_table_job = "RVEST_SINGLE_JOBS")

  list(
    add_indicators = add_indicators,
    indeed_jobs = indeed_jobs,
    apply_button = apply_button,
    job_name_db = job_name_db
  )

}
