dont_run <- function(){

  fetch_time <- DBI::dbGetQuery(
    conn = conn,
    statement = paste0("SELECT * FROM ", target_table_time)
  )

  fetch_jobid <- DBI::dbGetQuery(
    conn = conn,
    statement = paste0("SELECT * FROM ", target_table_job)
  )

}

