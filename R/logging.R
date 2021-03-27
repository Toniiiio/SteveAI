library(tryCatchLog)
library(futile.logger)
library(magrittr)
# Setze globale Option um Full Call Stack nicht auszugeben
options(tryCatchLog.include.full.call.stack = FALSE)
options(keep.source = TRUE)

#file_name <- file.path(log_path, paste0(UC_Name, "_", Sys.Date(), ".log"))
initialize  <- function(logger_name = "sivis", trennzeichen = "___", log_path = "~", UC_Name = "rvest_single", file_name){

  flog.logger(
    name = logger_name
  )

  #flog.threshold(I)

  flog.appender(
    name = logger_name,
    appender.file(file = file_name)
  )
  file.create(file_name)

  # Setze Logging-Funktionen f?r tryCatchLog

  tryCatchLog::set.logging.functions(

    error.log.func = function(msg)
      flog.error(msg = msg, name = logger_name),

    warn.log.func = function(msg)
      flog.warn(msg = msg, name = logger_name),

    info.log.func = function(msg)
      flog.info(msg = msg, name = logger_name)
  )



  # Globale Logging Layout Funktion
  layoutFunc <- function (level, msg, ...){
    time  <- gsub(x = Sys.time(), pattern = " ", replacement = "T") %>%
      gsub(pattern = ":", replacement = "-")


    processID <- Sys.getpid()

    func <- tryCatch(
      expr = deparse(sys.call(.where - 1)[[1]]),
      error = function(e) "(shell)"
    )

    func <- ifelse(
      test = length(grep('flog\\.', func)) == 0,
      yes = func,
      no = '(shell)'
    )

    namespace <- ifelse(
      test = flog.namespace() == "futile.logger",
      yes = "ROOT",
      no = flog.namespace()
    )

    if (length(list(...)) > 0) {
      parsed <- lapply(list(...), function(x)
        ifelse(
          test = is.null(x),
          yes = "NULL",
          no = x
        )
      )

      msg <- do.call(
        what = sprintf,
        args = c(msg, parsed)
      )
    }

    # avoid line breaks and usage of reserved characters
    msg <- gsub(
      x = msg,
      pattern = paste0(c("\n", trennzeichen), collapse = "|"),
      replacement = ""
    )

    c(time, processID, func, names(level), paste0(msg, "\n")) %>%
      paste(collapse = trennzeichen)

  }

  flog.layout(layoutFunc, name = logger_name)


  log_status <<- function(status, name, url){

    msg <- glue::glue("Server response status code for comp_name:'{name}' is code:{status} for url:'{url}'.")

    if(status == 200){

      flog.info(
        msg = msg,
        name = logger_name
      )

    }else if(status >= 400 & status <= 499){

      flog.error(
        msg = msg,
        name = logger_name
      )

    }else{

      flog.warn(
        msg = msg,
        name = logger_name
      )

    }

  }

  log_node_len <<- function(nodes, name, scraper, content, iterNr = 1){

    nodes_len <- nodes %>% length
    url <- scraper$url
    if(!is.null(scraper$no_job_id)){
      valid_no_items <- grepl(pattern = scraper$no_job_id, x = content %>% toString)
    }else{
      valid_no_items <- FALSE
    }

    if(nodes_len == 0 & iterNr == 1 & !valid_no_items){

      flog.error(
        msg = glue::glue("Amount nodes for comp_name:'{name}' is amount_nodes:{nodes %>% length} for url:'{url}'."),
        name = logger_name
      )


    }else if(valid_no_items){

      msg <- glue::glue("Amount nodes for comp_name:'{name}' is amount_nodes:{nodes %>% length} for url:'{url}'. Found id valid_no_items:'{scraper$no_job_id}'.")
      flog.info(
        msg = msg,
        name = logger_name
      )


    }else{

      flog.info(
        msg = glue::glue("Amount nodes for comp_name:'{name}' is amount_nodes:{nodes %>% length} for url:'{url}'."),
        name = logger_name
      )

    }

  }

  #flog.info(msg = "Logger successfully initialized within function definition.", logger= logger_name)


  # aaa <- function(){
  #   b()
  # }
  #
  # b <- function(){
  #   tryCatchLog(expr = sum("a"*b), error = function(e){
  #   })
  # }
  #
  #
  # aaa()


  scrape_log_info <<- function(target_name, url, msg, logger_name){

    msg <- glue::glue("For comp_name:'{target_name}' with url:'{url}' the following log is written: {msg}")
    flog.info(msg = msg, name = logger_name)

  }

  scrape_log_warn <<- function(target_name, url, msg, logger_name){

    msg <- glue::glue("For comp_name:'{target_name}' with url:'{url}' the following log is written: {msg}")
    flog.warn(msg = msg, name = logger_name)

  }

  scrape_log_error <<- function(target_name, url, msg, logger_name){

    if(is.null(url)){

      msg <- glue::glue("Missing url for comp_name:'{target_name}' Provided url is NULL - please provide a valid url.")

    }else{

      msg <- glue::glue("For comp_name:'{target_name}' with url:'{url}' the following error was recorded: {msg}") %>%
        toString

    }

    flog.error(msg = msg, name = logger_name)

  }


  flog.info(msg = "Logger successfully initialized within function definition.", name = logger_name)

}

