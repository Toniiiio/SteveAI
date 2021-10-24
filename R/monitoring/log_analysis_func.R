error_type_ident <- c(
  wrong_xpath = "No results for given xpath",
  diff_length_links_id = "Lengths of jobNames and links differ",
  wrong_url = "Missing url for comp_name",
  status_404 = "code:404",
  timeout = "Connection timed out after",
  no_encod = "No encoding supplied: defaulting to UTF-8",
  func_miss = "could not find function",
  curl_error = "Error in curl::curl_fetch_memory",
  connect_reset = "Send failure: Connection was resetCompact call",
  no_resolve_host = "Could not resolve host:"
)


parse_logs <- function(log_file){

  log_data_raw <- log_file %>%
    readLines

  if(!length(log_data_raw)){
    stop(paste0("the provided log file: ,", log_file," is empty!"))
  }

  log_Data <- log_file %>%
    readLines %>%
    strsplit(split = "___") %>%
    do.call(what = rbind) %>%
    data.frame %>%
    setNames(nm = c("date", "session_ID", "function", "level", "message"))

  if(log_Data %>% nrow() == 1) stop("Only one row")


  log_time <- log_Data$date %>%
    strsplit(split = "T") %>%
    {data.frame(Date = sapply(., FUN = "[", 1), Time = sapply(., FUN = "[", 2))}
  log_Data$date <- NULL
  log_Data %<>% cbind(log_time, .)
  head(log_Data)

  # Request failed. check logs above

  patterns <- c(
    comp_name = "comp_name:'(.*?)'", #|for target_name:'(.*?)'
    url = "url:'(.*?)'",
    valid_no_items = " valid_no_items:'(.*?)'.",
    n_nodes = "amount_nodes:(.*?) ",
    no_job_id = "valid_no_items:'(.*?)'",
    n_today_jobs = ": (.*?) new jobs were updated",
    n_duplicate_jobs = "[.] (.*?) of it are duplicates",
    status_code = "code:(.*?) ",
    missing_object = "object '(.*?)' not found"
  )

  obj_extr <- sapply(patterns, FUN = function(ptt) stringr::str_match(string = log_Data$message, pattern = ptt)[, 2])
  error_types <- sapply(error_type_ident, grepl, x = log_Data$message)
  log_Data <- cbind(log_Data, obj_extr, error_types)
  log_Data$n_nodes %<>% as.numeric()
  log_Data$n_today_jobs %<>% as.numeric()
  log_Data$n_duplicate_jobs %<>% as.numeric()

  return(log_Data)

}

