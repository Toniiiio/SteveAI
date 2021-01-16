### Doku: Database management

# I will have to add
# - new columns (for each new date) with default value of 0 -> once
# - new rows for each new job with default value of 0  --> multiple times
#
#
# That way it is ensured, that
# - new jobs have value of 0 for previous days
# - old jobs have value of 0 for the new date
#
# Then,
# - add 1 to all jobs that are on current day

### To learn:
# - write use cases and examples for tests or additions or implementations
# - if remove: can i safely remove this?

### Error database:
# Error: Error: cannot allocate vector of size 1.6 Gb
# Source: DBI::dbGetQuery(conn = conn, statement = paste0("SELECT * FROM ", target_table_job))
# Solution:

# Error: log is empty in msg: 2020-05-27T19-35-36___13816___(shell)___ERROR___
# Source: NULL element in glue
# Solution: Remove that NULL element. and test for NULL: lapply(lapply(SteveAI::rvestScraper, "[[", "url"), is.null) %>% unlist %>% which.

# Error: Fehler: near ".1": column names with .1 not accepted in database
# Source: sqlite database does not accept . in name. is created by duplicated columns
# Solution: Remove the duplicate column

# Error:
# error that is logged without proper meta data (comp_name) and error
# even if error handling is properly wrapped in try catch log. if the error handling scrape_log_error(.)
# has error in it.
# Solution: Fix it.

which01 <- function(x, arr.ind = FALSE, useNames = TRUE, one = TRUE){
  if(one) x <- !x
  which(x = !x, arr.ind = FALSE, useNames = TRUE)
}


write_To_DB <- function(db_name, target_table_job, target_table_time, conn, out, target_name, url, logger_name) {

  amtItems <- apply(out, 2, nchar)

  # todo: dirty
  if(is.null(dim(amtItems))) amtItems <- matrix(amtItems, nrow = 1)
  with_data <- amtItems %>%
    apply(MARGIN = 2, FUN = sum) %>%
    which01() %>%
    out[, .]

  job_id <- with_data[not(names(with_data) %in% c("links", "date"))] %>%
    apply(MARGIN = 1, FUN = paste, collapse = "__")

  out <- cbind(job_id, with_data)

  conn <- DBI::dbConnect(RSQLite::SQLite(), db_name)
  data_to_store <- out[!is.null(out)] # todo: can i safely remove this?  & lengths(out) > 1 --> counter example: what if i have only one row to add.
  # data_to_store <- out %>% do.call(what = "rbind")


  # todo: more special characters?
  # chinese characters --> cant save as native encoding
  data_to_store$job_id %<>%
    trimws %>%
    gsub(pattern = "||", replacement = "__", fixed = TRUE)

  data_to_store$job_id %<>% gsub(pattern = ",|.|:", replacement = "", fixed = TRUE)

  tbl_exists <- target_table_job %in% RSQLite::dbListTables(conn)
  tbl_exists

  if(tbl_exists){

    fetch_jobid <- DBI::dbGetQuery(
      conn = conn,
      statement = paste0("SELECT * FROM ", target_table_job)
    )

    new_jobs <- data_to_store[!(data_to_store$job_id %in% fetch_jobid$job_id), ]

    # could also append = TRUE new_jobs. But new_jobs will not always have all required columns - not sure what the impacts
    # of always overwriting the data is.
    to_upload <- dplyr::bind_rows(
      dplyr::mutate_all(fetch_jobid, as.character),
      dplyr::mutate_all(new_jobs, as.character)
    )

    missing_Cols <- names(new_jobs)[!(names(new_jobs) %in% names(fetch_jobid))]

    # Fehler: near ".1": syntax error --> error handling
    dupl_col <- new_jobs %>%
      names %>%
      grepl(pattern = "[.]") %>%
      which

    dupl_col
    if(length(dupl_col)){

      warning(glue("duplicate columns with name: {names(new_jobs)[dupl_col]} is/are removed."))
      new_jobs[[dupl_col]] <- NULL
      missing_Cols <- names(new_jobs)[!(names(new_jobs) %in% names(fetch_jobid))]

    }

    statem <- glue("ALTER TABLE {target_table_job} ADD COLUMN {missing_Cols} TEXT")

    sapply(statem, dbExecute, conn = conn)

  }else{

    to_upload <- data_to_store
    new_jobs <- data_to_store

  }

  # cant upload new_jobs only
  n_jobs <- new_jobs %>%
    unlist %>%
    length

  n_jobs
  if(n_jobs){

    DBI::dbWriteTable(
      conn = conn,
      name = target_table_job,
      value = to_upload,
      overwrite = TRUE
    )

    scrape_log_info(
      target_name = target_name,
      url = url,
      msg = glue("{n_jobs} new jobs were inserted in job_id data base."),
      logger_name = logger_name
    )
    message(glue("{n_jobs} new jobs were inserted in job_id data base."))

  }else{

    scrape_log_info(
      target_name = target_name,
      url = url,
      msg = glue("no new content to insert in data base. Updating time info if necessary Proceeeding,..."),
      logger_name = logger_name
    )

    message("no new content to insert in data base. Updating time info if necessary Proceeeding,...")

  }

  DBI::dbDisconnect(conn = conn)

  ################ Time TABLE

  date_Today <- Sys.Date() %>%
    as.numeric %>%
    toString

  tbl <- table(data_to_store$job_id %>% trimws)
  today_jobs_time <- data.frame(as.numeric(tbl))
  rownames(today_jobs_time) = names(tbl)
  colnames(today_jobs_time) <- date_Today

  conn <- DBI::dbConnect(RSQLite::SQLite(), db_name)

  tbl_exists <- target_table_time %in% dbListTables(conn)
  tbl_exists

  if(tbl_exists){

    fetch_time <- DBI::dbGetQuery(
      conn = conn,
      statement = paste0("SELECT * FROM ", target_table_time)
      # row.names = TRUE
    )

    date_Col_Exists <- toString(as.numeric(Sys.Date())) %in% colnames(fetch_time)
    date_Col_Exists
    if(!date_Col_Exists){

      date_Int <- toString(as.numeric(Sys.Date()))
      statem <- glue("ALTER TABLE {target_table_time} ADD COLUMN '{date_Int}' INTEGER DEFAULT 0")
      sapply(statem, dbExecute, conn = conn)
      scrape_log_info(
        target_name = target_name,
        url = url,
        msg = glue("In time database date column: {date_Int} is added."),
        logger_name = logger_name
      )

      # have to update fetch_time variable since it does not contain new column, yet.
      fetch_time <- DBI::dbGetQuery(
        conn = conn,
        statement = paste0("SELECT * FROM ", target_table_time),
        row.names = TRUE
      )

    }

    #### TIME TABLE -  add new rows (with 0 initially!) for jobs that does not exist yet
    new_jobs_name <- rownames(today_jobs_time)[!(rownames(today_jobs_time) %in% rownames(fetch_time))]
    length(new_jobs_name)

    if(length(new_jobs_name)){

      scrape_log_info(
        target_name = target_name,
        url = url,
        msg = glue("Found {n_jobs} new jobs for the given day: {Sys.Date()} that are not in the time database. Add rows for that with value of 0 for the
                   past, since they didnt exist back then. This value has to be equal to the amount of new jobs in the id data table.."),
        logger_name = logger_name
      )


      n_cols <- dim(fetch_time)[2]
      n_jobs <- length(new_jobs_name)
      new_jobs <- matrix(0, nrow = n_jobs, ncol = n_cols)
      rownames(new_jobs) <- new_jobs_name
      colnames(new_jobs) <- colnames(fetch_time)
      all_jobdata_till_today <- rbind(fetch_time, new_jobs)

    }else{

      all_jobdata_till_today <- fetch_time
      scrape_log_warn(
        target_name = target_name,
        url = url,
        msg = glue("0 new job titles for the time database for the given day: {Sys.Date()}."),
        logger_name = logger_name
      )

    }

    idx_to_Change <- match(rownames(all_jobdata_till_today), rownames(today_jobs_time)) %>%
      is.na %>%
      magrittr::not() %>%
      which
    idx_to_Change

    # insert amt jobs for the jobs found today
    all_jobdata_till_today[[date_Today]][idx_to_Change] <- today_jobs_time[[1]]
    all_jobdata <- all_jobdata_till_today

    DBI::dbWriteTable(
      conn = conn,
      name = target_table_time,
      value = all_jobdata,
      overwrite = TRUE,
      row.names= TRUE
    )

    amt_duplicate_positions <- today_jobs_time[[1]] %>%
      .[. > 1] %>%
      {sum(.) - length(.)}

    scrape_log_info(
      target_name = target_name,
      url = url,
      msg = glue("{length(idx_to_Change)} new jobs were updated in multi_time data base. {amt_duplicate_positions} of it are duplicates."),
      logger_name = logger_name
    )
    message(glue("{length(idx_to_Change)} new jobs were updated in multi_time data base. {amt_duplicate_positions} of it are duplicates."))

  }else{

    to_db <- today_jobs_time
    scrape_log_info(
      target_name = target_name,
      url = url,
      msg = glue("Time table did not exist yet. Creating it. Morevoer, {dim(today_jobs_time)[1]} job titles are inserted in the job_id data base."),
      logger_name = logger_name
    )

    DBI::dbWriteTable(
      conn = conn,
      name = target_table_time,
      value = to_db,
      overwrite = TRUE,
      row.names= TRUE
    )

  }

  dbDisconnect(conn = conn)


  # fetch$`18392` <- NULL
  # to_db <- fetch
  # fetch$`2020-05-10` <- "18392"

}



#setwd("C:/Users/user1/Documents/TMP/raspi")
# load(glue("scraper_rvest.RData"))

start <- Sys.time()


# SteveAI_dir <- "/home/pi/sivis/scrape"
SteveAI_dir <- "~"
setwd(SteveAI_dir)
# load(file.path(SteveAI_dir, "scraper_rvest.RData"))
logger_name <- "sivis"

if(!dir.exists("dataRvest")){

  dir.create("dataRvest")

}

file_path <- file.path(getwd(), paste0("rvest_single_", Sys.Date(), ".log"))

flog.info(msg = paste0("Logger successfully initialized from calling script at: ", file_path), logger= logger_name)

# load("~/TMP/raspi/scraper.RData")
# scrapers <- scraper
# scraper <- scrapers[[2]]
# library(magrittr)


rvestScraping <- function(response, name, scraper){

  # check direct is its xml?
  if(is.character(response)){
    stop("The provided response is not of type xml document, but of type character. The download might have failed, check the downloaded doument for validity.")
  }

  status <- response %>% httr::status_code()
  url = scraper$url

  log_status(
    status = status,
    name = name,
    url = url
  )

  encoding <- response$headers$`content-type` %>%
    ifelse(is.null(.), yes = "", no = .) %>%
    strsplit(split = "charset=") %>%
    unlist %>%
    .[2]

  if(is.na(encoding)){

    scrape_log_info(
      target_name = name,
      url = url,
      msg = glue::glue("No encoding found, defaulting to UTF-8"),
      logger_name = logger_name
    )

  }

  content <- response %>%
    httr::content(type = "text", encoding = encoding)

  content_len <- content %>%
    nchar

  nodes <- content %>%
    xml2::read_html() %>%
    rvest::html_nodes(xpath = scraper$jobNameXpath)

  log_node_len(nodes, name = name, scraper = scraper, content = content)


  rvestOut <- gsub(
    pattern = "\n|   |\tNew|\t",
    replacement = "",
    x = nodes %>% rvest::html_text()
  )

  if(is.na(scraper$href)){

    links <- NA

  }else{

    links <- content %>%
      xml2::read_html() %>%
      html_nodes(xpath = scraper$href) %>%
      html_attr(name = "href")

  }

  # rvestLink <- getRvestHref(
  #   url = url,
  #   XPath = XPath
  # )

  if(length(rvestOut)){

    out <- data.frame(
      # x = rvestLink,
      jobName = rvestOut,
      links = links,
      comp = name,
      date = Sys.Date(),
      location = "",
      eingestelltAm = "",
      bereich = ""
    )
  }else{

    out <- NULL

  }

  return(out)
}



scrape_log_info <- function(target_name, url, msg, logger_name){

  msg <- glue::glue("For comp_name:'{target_name}' with url:'{url}' the following log is written: {msg}")
  flog.info(msg = msg, name = logger_name)

}

scrape_log_warn <- function(target_name, url, msg, logger_name){

  msg <- glue::glue("For comp_name:'{target_name}' with url:'{url}' the following log is written: {msg}")
  flog.warn(msg = msg, name = logger_name)

}

scrape_log_error <- function(target_name, url, msg, logger_name){

  if(is.null(url)){

    msg <- glue::glue("Missing url for comp_name:'{target_name}' Provided url is NULL - please provide a valid url.")

  }else{

    msg <- glue::glue("For comp_name:'{target_name}' with url:'{url}' the following error was recorded: {msg}") %>%
      toString

  }

  flog.error(msg = msg, name = logger_name)

}


run <- function(){

  print(Sys.time())
  data_raw <- list()
  durationFileName <- glue("{SteveAI_dir}/scrapeDuration_{Sys.Date()}.csv")

  folder_name <- glue("response_raw/{Sys.Date()}")
  dir.create("response_raw")
  dir.create(folder_name)

  get_nr <- 1

  #length()

  #
  for(get_nr in seq(SteveAI::rvestScraper)){
    print(get_nr)

    target_name <- names(SteveAI::rvestScraper)[get_nr]
    scraper = SteveAI::rvestScraper[[get_nr]]
    response <- tryCatchLog(
      expr = scraper$url %>% httr::GET(),
      error = function(e){

        scrape_log_error(
          target_name = target_name,
          msg = e,
          url = scraper$url,
          logger_name = logger_name
        )

      }
    )

    file_Name <- glue("{names(SteveAI::rvestScraper)[get_nr]}_{Sys.Date()}.RData")
    save(response, file = glue("{folder_name}/{file_Name}"))
  }

  responses <- list.files(folder_name)
  nms <- responses %>%
    sapply(FUN = function(response){
      strsplit(x = response, split = "_") %>% unlist %>% .[1]
    })

  if(!length(nms)) stop("Did not find any downloaded files.")

  nr <- 1
  for(nr in seq(SteveAI::rvestScraper)){

    print(nr)

    scraper <- SteveAI::rvestScraper[[nr]]
    name <- names(SteveAI::rvestScraper)[nr]

    file_Name <- which(name == nms) %>% names

    if(!length(file_Name)){
      warning("no such file with response.")
      next
    }

    # loading variable: response here
    load(file.path(folder_name, file_Name))

    start <- Sys.time()

    print(name)
    data_raw[[name]] <- tryCatchLog(
      expr = rvestScraping(response = response, scraper = scraper, name = name),
      error = function(e){
        print(e)
        name <- names(SteveAI::rvestScraper)[nr]
        url <- SteveAI::rvestScraper[[nr]]$url

        msg <- glue::glue("Scrape for comp_name:'{name}' failed for url:'{url}'. The error reads: {e}.")

        scrape_log_error(
          target_name = name,
          msg = msg,
          url = scraper$url,
          logger_name = logger_name
        )

      }
    )

    if(is.null(data_raw[[name]]) | length(data_raw[[name]]) < 2) next
    # data_raw

    # has_Id <- FALSE #names(data_raw[[name]])



    # if(has_Id){
    #
    # }else{
    #
    #   # build id - take all non-empty columns that do not have blacklist items
    #   apply(data_raw, 2, nchar)
    #
    # }

    end <- Sys.time()
    scrapeDuration <- as.numeric(end - start)

    # fileNameJobDesc = paste0("dataRvest/JobDescLinks_", name, "_", Sys.Date(), ".csv")
    # write.csv2(x = data_raw[[name]], file = fileNameJobDesc, row.names = FALSE)


    # write.table(
    #   data.frame(
    #     name = name,
    #     duration = scrapeDuration
    #   ),
    #   file = durationFileName,
    #   append = TRUE,
    #   row.names = FALSE,
    #   col.names = FALSE
    # )

    db_name <- "rvest_scraper.db"
    target_table_job <- "RVEST_SINGLE_JOBS"
    target_table_time <- "RVEST_SINGLE_TIME"
    out = data_raw[[name]]

    if(!is.null(out)){

      write_To_DB(
        db_name = db_name,
        target_table_job = target_table_job,
        target_table_time = target_table_time,
        out = out,
        target_name = name,
        url = scraper$url,
        logger_name = logger_name
      )

    }else{

      warning(glue("No new data to insert for company: {name}. Might be due to wrong xpath, check the logs from the requests."))
      scrape_log_warn(
        target_name = name,
        url = url,
        msg = glue::glue("No new data to insert for company: {name}. Might be due to wrong xpath, check the logs from the requests."),
        logger_name = logger_name
      )

    }

  }




  end <- Sys.time()
  end - start


}

### repair SteveAI::rvestScraper
# for(nr in seq(SteveAI::rvestScraper)){
#   nms <- names(SteveAI::rvestScraper[[nr]])
#   idx <- nms == "XPath"
#   if(sum(idx)){
#     print(idx)
#     nms[idx] <- "jobNameXpath"
#     SteveAI::rvestScraper[[nr]] <- lapply(
#       SteveAI::rvestScraper[[nr]],
#       FUN = function(x){
#         ifelse(test = typeof(x) == "closure", yes = x, no = as.character(x))
#       }
#     )
#     names(SteveAI::rvestScraper[[nr]]) <- nms
#   }
# }
# save(SteveAI::rvestScraper, file = "scraper_rvest.RData")





# new_jobNames <- setdiff(rownames(new_jobs_time), rownames(fetch))
# to_add <- matrix(0, ncol = dim(fetch)[2], nrow = length(new_jobNames)) %>%
#   data.frame(row.names = new_jobNames) %>%
#   setNames(colnames(fetch))
#
# old_data <- rbind(fetch, to_add)
# old_data$title <- rownames(old_data)
# to_db <- merge(
#   x = old_data,
#   y = data.frame(title = rownames(new_jobs_time), count = new_jobs_time[[1]]),
#   by = "title",
#   all.x = TRUE
# )
# to_db$count[is.na(to_db$count)] <- 0
#
# rownames(to_db) <- to_db$title
# to_db$title <- NULL
# old_data$title <- NULL
# colnames(to_db) <- c(colnames(old_data), Sys.Date())
#
# if(need_update){
#
#   DBI::dbWriteTable(
#     conn = conn,
#     name = target_table_time,
#     value = to_db,
#     overwrite = TRUE,
#     row.names= TRUE
#   )
#
# }

