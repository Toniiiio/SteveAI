#source("logging.R")

which01 <- function(x, arr.ind = FALSE, useNames = TRUE, one = TRUE){
  if(one) x <- !x
  which(x = !x, arr.ind = FALSE, useNames = TRUE)
}



scrapeRvestMPage <- function(name){

  scraper <- scraperRvestMultiPage[name]
  urlGen <- scraper[[1]]$urlGen
  XPath <- scraper[[1]]$XPath
  output = list()
  rvestOut = "NonEmptyInitVal"
  continueScraping <- TRUE
  existsAlready <- 0

  url <- urlGen(nr = 1)
  if(FALSE & !is.null(scraper[[1]]$AmtJobsXPath)){

    maxIterRaw <- getRvestText(
      url = url,
      XPath = scraper[[1]]$AmtJobsXPath
    )
    if(length(grep(pattern = "of", x = maxIterRaw))) maxIterRaw <- strsplit(x = maxIterRaw, split = " of ")[[1]][2]
    maxJobs <- as.numeric(maxIterRaw)
    if(!length(maxJobs)) maxJobs <- 50000

  }else{
    maxJobs <- 50000
  }

  iterNr <- 1

  while(continueScraping){

    print(continueScraping)
    url <- urlGen(nr = iterNr)

    response <- tryCatchLog(
      expr = url %>% httr::GET(),
      error = function(e){
        flog.error(msg = e, name = logger_name)
        stop("Request failed. check logs above.")
      }
    )

    status <- response %>% httr::status_code()

    log_status(
      status = status,
      name = name,
      url = url
    )


    file_Name <- glue("{names(scraperRvestMultiPage)[nr]}_{Sys.Date()}.RData")
    save(response, file = glue("{folder_name}/{file_Name}"))

    rvestOutLink <- ""
    # todo:
    # rvestOutLinkRaw <- getRvestHref(
    #   url = url,
    #   XPath = XPath
    # )
    # if(!is.na(rvestOutLinkRaw[1])){
    #   rvestOutLink <- sapply(rvestOutLinkRaw, extractJobLink, baseUrl = url, USE.NAMES = FALSE)
    # }else{
    #   rvestOutLink <- rvestOutLinkRaw
    # }

    outXPath <- list()
    nms <- names(scraper[[1]])
    idx <- grep(pattern = tolower("XPath"), tolower(nms))
    XPathesToScrape <- setdiff(nms[idx], "AmtJobsXPath")

    # lapply(XPathesToScrape, FUN = html_nodes(xpath = .), doc = content(response))

    getRvestTexts <- function(code, XPath){
      code %>%
        html_nodes(xpath = XPath) %>%
        html_text()
    }

    xpathes <- scraper[[1]][XPathesToScrape]
    code <- content(response)
    if(length(code) != 2 & !is.list(code) ) code %<>% read_html #for EON
    rvestOutRaw <- lapply(xpathes, FUN = function(xp) html_nodes(xpath = xp, x = code) %>% html_text)

    log_node_len(
      nodes = unlist(rvestOutRaw),
      name = name,
      scraper = scraper,
      iterNr = iterNr
    )

    if(sum(lengths((rvestOutRaw)))){
      XPathOutput <- do.call(cbind, rvestOutRaw)
      colnames(XPathOutput) <- gsub(pattern = "XPath", replacement = "jobName", colnames(XPathOutput))

      out <- cbind(
        data.frame(
          x = rvestOutLink,
          comp = name,
          date = Sys.Date()
        ),
        XPathOutput
      )

      print(iterNr)
      if(length(output)) existsAlready <- sum(sapply(output, FUN = identical, y = out))
      output[[iterNr]] <- out

      amtScrapedJobsTotal <- length(unlist(lapply(output, "[[", "jobName")))
      amtScrapedJobsThisPage <- sum(lengths((rvestOutRaw)))
      continueScraping <- amtScrapedJobsThisPage & amtScrapedJobsTotal < maxJobs

      if(existsAlready > 0) continueScraping <- FALSE

      iterNr <- iterNr + 1
    }else{
      continueScraping <- FALSE
    }

    if(name == "FACEBOOK" & iterNr == 28) break
  }

  db_name <- "rvest_scraper.db"
  conn <- DBI::dbConnect(RSQLite::SQLite(), db_name)
  target_table_job <- "RVEST_MULTI_JOBS"
  target_table_time <- "RVEST_MULTI_TIME"

  has_results <- length(output)
  has_results
  if(has_results){

    write_To_DB(
      db_name = db_name,
      target_table_job = target_table_job,
      target_table_time = target_table_time,
      conn = conn,
      url = url,
      out = dplyr::bind_rows(output)
    )

  }else{

    stop("No results for given xpath.")

  }



  #### Quality Checks:
  ####################

  # fetch <- DBI::dbGetQuery(
  #   conn = conn,
  #   statement = paste0("SELECT * FROM ", target_table_time)
  # )

  # fetch2 <- DBI::dbGetQuery(
  #   conn = conn,
  #   statement = paste0("SELECT * FROM ", target_table_job)
  # )
  # fetch$`2020-05-09` %>% sum
  # fetch2 %>% dim %>% .[1]

  # out <- do.call(what = rbind, args = output)
  # amtItems <- apply(out, 2, nchar)
  #
  # # todo: dirty
  # if(is.null(dim(amtItems))) amtItems <- matrix(amtItems, nrow = 1)
  # with_data <- amtItems %>%
  #   apply(MARGIN = 2, FUN = sum) %>%
  #   which01() %>%
  #   out[, .]
  #
  #
  # job_id <- with_data[names(with_data) != "date"] %>%
  #   apply(MARGIN = 1, FUN = paste, collapse = "__")
  #
  # out <- cbind(job_id, with_data)
  #
  # data_to_store <- out[!is.null(out) & lengths(out) > 1]
  #
  # # todo: more special characters?
  # # 机械工程师| --> cant save as native encoding
  # data_to_store$job_id %<>%
  #   trimws %>%
  #   gsub(pattern = "||", replacement = "__", fixed = TRUE)
  #
  # data_to_store$job_id %<>% gsub(pattern = ",|.|:", replacement = "", fixed = TRUE)
  #
  # tbl_missing <- not(target_table %in% dbListTables(conn))
  # if(tbl_missing){
  #
  #   warning(glue("Sivis custom error: Cant find target table in database {db_name}. Creating one."))
  #   upload <- data_to_store
  #
  # }else{
  #
  #   fetch <- DBI::dbGetQuery(
  #     conn = conn,
  #     statement = paste0("SELECT * FROM ", target_table)
  #   )
  #
  #   upload <- data_to_store[not(data_to_store$job_id %in% fetch$job_id), ]
  #
  # }
  #
  # DBI::dbWriteTable(
  #   conn = conn,
  #   name = target_table,
  #   value = upload,
  #   append = TRUE
  # )


  # fileNameJobDesc = paste0("dataMultiRvest/JobDescLinks_", name, "_", Sys.Date(), ".csv")
  # write.csv2(x = do.call(what = rbind, args = output), file = fileNameJobDesc, row.names = FALSE)
  # print("DONE - SAVING NOW")
}


run_multi <- function(){

  scrape_Dir <- "~"
  #source(file.path(scrape_Dir, "rvestFunctions.R"))
  setwd(scrape_Dir)
  load(file.path(scrape_Dir, "scraperRvestMultiPage.RData"))
  folder_name <- glue("response_raw/{Sys.Date()}")
  dir.create("response_raw")
  dir.create("dataMultiRvest")
  dir.create(folder_name)

  nr <- 1
  name <- "VNG"
  name <- names(scraperRvestMultiPage)[50]

  print(nr)
  scraper <- scraperRvestMultiPage[[name]]

  nr <- 1


  out <- list()
  scraperNr <- 15
  durationFileName <- file.path(scrape_Dir, paste0("scrapeDuration_", Sys.Date(), ".csv"))

  names(scraperRvestMultiPage)
  for(scraperNr in 1:length(scraperRvestMultiPage)){ #1:
    # if(scraperNr %in% c(1, 2, 3, 4, 35)) next

    start <- Sys.time()
    print(paste0("scraperNr: ", scraperNr))
    name <- names(scraperRvestMultiPage)[scraperNr]
    print(name)
    out[[name]] <- tryCatchLog(
      expr = scrapeRvestMPage(name = name),
      error = function(e){
        print(e)
        # flog.error(msg = e, logger = logger_name)
      }
    )
    end <- Sys.time()
    scrapeDuration <- as.numeric(end - start)

    # write.table(
    #   data.frame(
    #     name = name,
    #     duration = scrapeDuration
    #   ),
    #   file = durationFileName,
    #   append = TRUE,
    #   col.names = FALSE,
    #   row.names = FALSE
    # )

  }


}



