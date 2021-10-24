dont_run <- function(){

  library(magrittr)
  library(RSQLite)
  db_name <- "rvest_scraper.db"
  target_table_job <- "RVEST_SINGLE_JOBS"
  target_table_time <- "RVEST_SINGLE_TIME"
  conn <- DBI::dbConnect(RSQLite::SQLite(), db_name)

  fetch_time <- DBI::dbGetQuery(
    conn = conn,
    statement = paste0("SELECT * FROM ", target_table_time)
  )
  fetch_time %>% head

  fetch_jobid <- DBI::dbGetQuery(
    conn = conn,
    statement = paste0("SELECT * FROM ", target_table_job)
  )
  fetch_jobid %>% head

}
