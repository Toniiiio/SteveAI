#
# setwd("~")
# db_name <- "rvest_scraper.db"
# db_exists <- file.exists(db_name)
# target_table_time <- "RVEST_SINGLE_TIME"
# conn <- DBI::dbConnect(RSQLite::SQLite(), db_name)
#


# xxxxx this destroys row names

# fetch_time <- DBI::dbGetQuery(
#   conn = conn,
#   statement = paste0("SELECT * FROM ", target_table_time),
#   row.names = TRUE
# )
#
# xx <- rownames(fetch_time) %>% {grepl(pattern = "http", .)}
# which(xx)
#
# fdd <- gsub(
#   pattern = "__.*__",
#   replacement = "__",
#   x = rownames(fetch_time)[which(xx)],
#   perl = TRUE
# )
#
# fdd %in% rownames(fetch_time)
# row_idx <- sapply(fdd, function(fd) which(fd == rownames(fetch_time)), USE.NAMES = FALSE)
# col_idx <- which(colnames(fetch_time) == "18638")
# fetch_time[row_idx, col_idx] <- 1
# fetch_time[which(xx), ] <- 0
#
#
# DBI::dbWriteTable(
#   conn = conn,
#   name = target_table_time,
#   value = fetch_time,
#   overwrite = TRUE
# )
#
#
#
#
#
#
#
#
#
# db_name <- "rvest_scraper.db"
# db_exists <- file.exists(db_name)
# target_table_jobs <- "RVEST_SINGLE_JOBS"
# conn <- DBI::dbConnect(RSQLite::SQLite(), db_name)
#
# fetch_job <- DBI::dbGetQuery(
#   conn = conn,
#   statement = paste0("SELECT * FROM ", target_table_jobs)
# )
#
#
# rr <- fetch_job$job_id %>% {grepl(pattern = "http", .)}
# rrr <- fetch_job[-which(rr), ]
#
# DBI::dbWriteTable(
#   conn = conn,
#   name = target_table_jobs,
#   value = rrr,
#   overwrite = TRUE
# )
#
#
#
#
#
#
#
#
