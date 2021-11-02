#
# # See if there is data for day 1 and 3 but not for day2.
# which(rowSums(rr) == 2 & rr[, 2] == 0)
#
# comp_name <- "MASTERCARD"
#
# filter_comp <- function(data, comp_name){
#
#   rownames(data) %>%
#     strsplit(split = "__") %>%
#     sapply(FUN = "[", 2) %>%
#     magrittr::equals(comp_name) %>%
#     rr[., ]
#
# }
#
# filter_comp(rr, comp_name)



# 1. Check if for each data in table job_id is one equivilant in table time and vice versa.
# 2. See if there is data for day 1 and 3 but not for day2. Holes within "time rows".
# 3. If data for a company comes for a given day. There are n=10 jobs for that day.
#    - m=2 are unnknown so they are added to the job_id table.
#    - m=2 rows also have to be added for the time table.
#    - n=10 data points have to be updated in the time table.
# 4. check for validy of job names, e.g. "–__BUSCH" too short, maybe also check for too long
# 5. Check if database is too large or too many tables.

# 6. Check if too big differences in job counts.
#     a) 10 normal jobs could be replaced by 10 wrong values (Karriere, Team, etc.)
#      --> 10 to 10 would be 0. But it would be 10 old ones gone, 10 new ones.
#     b) check if company has high variance in job counts

# Check if for each data in table job_id is one equivilant in table time and vice versa.

run_checks <- function(date_today = Sys.Date()){

  library(DBI)
  library(magrittr)
  library(glue)
  setwd("~")
  db_name <- "rvest_scraper.db"
  db_exists <- file.exists(db_name)

  if(db_exists){
    target_table_job <- "RVEST_SINGLE_JOBS"
    target_table_time <- "RVEST_SINGLE_TIME"
    conn <- DBI::dbConnect(RSQLite::SQLite(), db_name)
  }



  # 5.
  found_tables <- DBI::dbListTables(conn)
  expect_tables <- c("RVEST_MULTI_JOBS",  "RVEST_MULTI_TIME",  "RVEST_SINGLE_JOBS", "RVEST_SINGLE_TIME")
  unknown_tables <- setdiff(found_tables, expect_tables)
  unknown_tables
  missing_tables <- setdiff(expect_tables, found_tables)
  missing_tables
  #dbExecute(conn = conn, statement = "DROP TABLE new_table2")



  sapply(glue("SELECT COUNT(*) FROM {found_tables}"),
         DBI::dbGetQuery, conn = conn)

  n_col <- sapply(glue("SELECT * FROM {found_tables} LIMIT 5"),
    FUN = function(statem){
      DBI::dbGetQuery(conn = conn, statement = statem) %>% dim %>% .[2]
  }) %>% setNames(nm = found_tables)

  file.size(db_name)
  lapply(glue("SELECT * FROM {dbListTables(conn)}"), FUN = function(statem){
    DBI::dbGetQuery(conn = conn, statement = statem)}) %>%
    object.size



  db_content <- lapply(glue("SELECT * FROM {dbListTables(conn)}"), FUN = function(statem){
    DBI::dbGetQuery(conn = conn, statement = statem)
  }) %>%
    setNames(nm = dbListTables(conn))


  # Recreate database and check size:

  db_name_tmp <- db_name %>%
    gsub(pattern = ".db", replacement = "_copy2_tmp.db")
  conn_tmp <- DBI::dbConnect(RSQLite::SQLite(), db_name_tmp)

  name <- names(db_content)[1]

  val <- db_content[[name]]

  for(name in names(db_content)){

    DBI::dbWriteTable(
      conn = conn_tmp,
      name = names(db_content)[1],
      value = db_content[[name]],
      overwrite = TRUE
    )

  }



  fetch_time <- DBI::dbGetQuery(
    conn = conn,
    statement = paste0("SELECT * FROM ", target_table_time),
    row.names = TRUE
  )
  head(fetch_time)

  fetch_jobid <- DBI::dbGetQuery(
    conn = conn,
    statement = paste0("SELECT * FROM ", target_table_job)
  )
  head(fetch_jobid)

  id_time <- rownames(fetch_time)
  id_jobid <- fetch_jobid$job_id

  setdiff(id_time, id_jobid)
  setdiff(id_jobid, id_time)


  id_jobid %>% {.[grepl(pattern = "PROSIEBENSAT1", x = .)]}

  # id_jobid %>% {.[grepl(pattern = "SALZGITTER", .)]}
  # id_time %>% {.[grepl(pattern = "SALZGITTER", .)]}


  # shortest names
  xx <- nchar(id_time)
  f <- order(xx, decreasing = FALSE) %>% head(n = 35)
  id_time[f]

  # longest names
  xx <- nchar(id_time)
  f <- order(xx, decreasing = TRUE) %>% head(n = 15)
  id_time[f]


  ff <- lapply(id_time, strsplit, split = "__")
  ff <- unlist(ff, recursive = FALSE)
  comps <- sapply(ff, "[", 2)

  rr <- fetch_time > 0
  idx_today <- which(colnames(fetch_time) == date_today %>% as.numeric() %>% toString)

  q <- comps[rr[, idx_today - 1]]
  counts <- table(q)
  q <- comps[rr[, idx_today]]
  counts2 <- table(q)

  dd <- merge(
    counts %>% data.frame,
    counts2 %>% data.frame,
    by = "q",
    all = TRUE
  )
  dd

  abs_diff <- diff <- abs(dd[, 3] - dd[, 2])
  rel_diff <- diff/dd[, 2]*100
  rel_diff
  abs_diff


  DBI::dbDisconnect(conn = conn)

}
run_checks()


