library(stringr)
library(shiny)
library(DT)
library(magrittr)
library(glue)
library(xml2)
library(rvest)

get_error_items <- function(SteveAI_dir){

  date_today <- Sys.Date()


  browser_path <- "C:/Program Files (x86)/Google/Chrome/Application/chrome.exe"
  browser_path %>% file.exists()
  options(browser = browser_path)
  #source("C:/Users/User11/Desktop/Transfer/TMP/mypkg2/R/sivis.R")


  setwd(SteveAI_dir)
  load(file.path("~", "scraper_rvest.RData"))
  source(file.path(SteveAI_dir, "R/log_analysis_func.R"))

  log_file <- glue(SteveAI_dir, "/logs/rvest_single_{date_today}.log")

  log_data <- parse_logs(log_file = log_file)
  log_data %>% head

  error_items <- log_data %>%
    dplyr::filter(level == "ERROR")

  error_items
}

dont_run <- function(){

  SteveAI_dir <- "C:/Users/User11/Documents/SteveAI/"
  comp_names <- get_error_items(SteveAI_dir) %>%
    dplyr::filter(n_nodes == 0 | curl_error == TRUE) %>%
    dplyr::select(comp_name) %>%
    unlist %>%
    unname


  log_results2 <- list()
  load(file.path("~", "scraper_rvest.RData"))
  pjs <<- webdriver::run_phantomjs()
  ses <<- webdriver::Session$new(port = pjs$port)

  comp_name <- comp_names[2]
  for(comp_name in comp_names){
    print(comp_name)
    url <- rvestScraper[[comp_name]]$domain
    log_results2[[url]] <- tryCatch(
      find_job_page(url, ses, use_phantom = TRUE),
      error = function(e){
        pjs <<- webdriver::run_phantomjs()
        ses <<- webdriver::Session$new(port = pjs$port)
        print("Call to find_job_page failed with:")
        print(e)
        return("")
      }
    )
    save(log_results2, file = "data/log_results2.RData")

  }

  load("data/log_results2.RData")
  pjs <<- webdriver::run_phantomjs()
  ses <<- webdriver::Session$new(port = pjs$port)


  #comp_name <- comp_names[1]

  doc = rr$doc %>% xml2::read_html()
  doc %>% SteveAI::showHtmlPage()
  # doc %>% html_nodes(xpath = "//section/div/div/div/div/div/div/a/div/div[@class = 'title']")
  doc %>% html_nodes(xpath = "html/body/div[2]/div/main/section/div/article/div/section[1]/div/div/div/h5")

  nr <- 45
  url <- names(log_results2)[nr]
  url

  which(!is.na(sapply(log_results2, "[", "counts")))
  log_results2[[url]]$counts

  winner <- log_results2[[url]]$winner

  parsing_results <- log_results2[[url]]

  #parsing_results$all_docs[[parsing_results$winner]]
  parsing_results$all_docs[[parsing_results$winner]] %>% SteveAI::showHtmlPage()
  log_results2[[url]]$parsed_links$href[winner]
  log_results2[[url]]$parsed_links$href[winner] %>% browseURL()
  log_results2[[url]]$multipage <- FALSE
  log_results2[[url]]$has_jobs <- TRUE


  rr <- SteveAI::extract_target_text(parsing_results = parsing_results)

  x <- rr$candidate_meta
  log_results2[[url]]$require_js <- x$require_js
  log_results2[[url]]$require_js

  x
  save(log_results2, file = "data/log_results2.RData")
  doc = rr$doc
  doc %>% xml2::read_html() %>% html_nodes(xpath = '//*[@id="joboffers"]/div/div[1]/a')

  tags_pure = x$tags_pure
  required_len = 22
  classes = x$classes
  xp <- add_classes(required_len = required_len, tags_pure = tags_pure, classes = classes, doc = doc)
  xp
  xp <- '/html/body/div[2]/div/main/section/div/article/div/section[1]/div/div/div/h5'
  url


  # `Deutsche-RUECK` checken in historie
  insert <- rvestScraper$`CONRAD-CONNECT`

  insert$url <- log_results2[[url]]$parsed_links$href[winner]
  names(x)[4]
  insert$jobNameXpath <- names(x)[4]
  insert$jobNameXpath <- xp
  insert$domain <- urltools::domain(log_results2[[url]]$parsed_links$href[winner])
  rvestScraper$`CONRAD-CONNECT` <- insert

  # manuell


  rvestScraper$NETTO$url <- "https://www.netto-online.de/karriere/Stellenangebote.chtm"
  rvestScraper$NETTO$jobNameXpath <- "//section/div/div/div/div/div/div/a/div/div[@class = 'title']"
  rvestScraper$NETTO$domain <- "https://www.netto-online.de/"



  rvestScraper$`OTTO-MEDIA` <- NULL




  #load(file = "data/scraper_rvest.RData")

  save(rvestScraper, file = "data/scraper_rvest.RData")


}


dont_run <- function(){


    date_today <- Sys.Date()


    browser_path <- "C:/Program Files (x86)/Google/Chrome/Application/chrome.exe"
    browser_path %>% file.exists()
    options(browser = browser_path)
    #source("C:/Users/User11/Desktop/Transfer/TMP/mypkg2/R/sivis.R")

    SteveAI_dir <- "C:/Users/User11/Documents/SteveAI"
    setwd(SteveAI_dir)
    load(file.path("~", "scraper_rvest.RData"))
    source(file.path(SteveAI_dir, "R/log_analysis_func.R"))

    log_file <- glue("~/rvest_single_{date_today}.log")

    log_data <- parse_logs(log_file = log_file)
    log_data %>% head

    error_items <- log_data %>%
      dplyr::filter(level == "ERROR") %>%
      dplyr::select(comp_name) %>%
      unlist %>%
      unname

    bb <- log_data[which(log_data$comp_name %>% is.na), ]
    log_data$n_nodes

    log_data %<>%
      dplyr::group_by(comp_name) %>%
      dplyr::mutate(db_consist = (sum(n_today_jobs, na.rm = TRUE) + sum(n_duplicate_jobs, na.rm = TRUE) == sum(n_nodes, na.rm = TRUE)))
    log_data$db_consist

    ui = fluidPage({

      mainPanel(
        tabsetPanel(
          tabPanel("Overview", fluidRow(

            numericInput(
              inputId = "min_nodes",
              label = "Min amt nodes:",
              min = 0,
              value = 0,
              max = 500
            ),

            selectInput(
              inputId = "logicals",
              label = "Filter logicals",
              choices = names(error_type_ident),
              multiple = TRUE,
              selectize = TRUE,
              selected = NULL
            ),

            checkboxInput(
              inputId = "obj_has_txt",
              label = "Missing object in code",
              value = FALSE
            ),

            DTOutput('tbl_all')

          )
          ),
          tabPanel(
            title = "Analyse",

            uiOutput("items"),
            DTOutput('tbl_single'),

            fluidRow(
              column(width = 3,
                     actionButton(inputId = "open_scrape_url", label = "Open current url:"),
                     actionButton(inputId = "google_search", label = "Search for new page at google:"),
                     actionButton(inputId = "remove", label = "Remove this item"),
                     actionButton(inputId = "curl", label = "Try curl in cmd."),
                     actionButton(inputId = "domain", label = "Ping domain."),
                     shiny::fluidRow(
                       textInput(inputId = "new_url", label = "New url:"),
                       actionButton(inputId = "add_new_url", label = "Add new url!")
                     ),
                     textInput(inputId = "target_text", label = "Text for xpath:", value = "m/w"),
                     uiOutput("xpath"),
                     actionButton(inputId = "get_xpath", label = "Get xpath"),
                     actionButton(inputId = "use_xpath", label = "Use xpath"),
                     verbatimTextOutput(outputId = "curl"),
                     textInput(inputId = "no_job_id", label = "Text to identify valid no jobs:", value = ""),
                     actionButton(inputId = "add_nojob_id", label = "Add no job id"),
                     actionButton(inputId = "finish_item", label = "Mark as done."),

              ),
              column(width = 9,
                     htmlOutput("frame")
              )
            )

          )
        )
      )
    })

    server = function(input, output) {

      global <- reactiveValues(curl_output = NULL, error_items = error_items, xpath_output = NULL)

      output$frame <- renderUI({

        tags$iframe(src = rvestScraper[[input$error_item]]$url, height = 600, width = 1500)

      })

      output$items <- renderUI({
        print(length(global$error_items))
        selectInput(
          inputId = "error_item",
          label = "Error item:",
          choices = global$error_items,
          selected = global$error_items[1]
        )
      })

      observeEvent(input$finish_item, {
        print(input$finish_item)
        print(input$error_item)
        print(length(unlist(global$error_items)))
        rvestScraper[[input$error_item]]$no_job_id <- input$no_job_id
        global$error_items <- setdiff(global$error_items, input$error_item)
        print(length(unlist(global$error_items)))
      })


      observeEvent(input$add_nojob_id, {

        rvestScraper[[input$error_item]]$no_job_id <- input$no_job_id
        save(rvestScraper, file = file.path(SteveAI_dir, "scraper_rvest.RData"))

      })


      observeEvent(input$error_item, {

        req(input$error_item)
        print(input$error_item)
        print("input$error_item")
        scrape_url <- rvestScraper[[input$error_item]]$url

        global$doc <- tryCatch(expr = scrape_url %>%
                                 httr::GET() %>%
                                 httr::content(type = "text"),
                               error = function(e) NULL
        )

      })

      observeEvent(c(input$target_text, input$get_xpath, input$error_item, global$doc), {

        req(nchar(input$target_text) > 0)
        req(!is.null(global$doc))
        print("input$target_text")
        print(input$target_text)
        print("doc")
        print(global$doc)

        txt <- SteveAI::getXPathByText(doc = global$doc, text = input$target_text)
        print(txt)
        output$xpath <- renderUI({
          textInput(inputId = "xpath", label = "xpath:", value = txt %>% toString)
        })

      })


      observeEvent(input$xpath, {

        global$items <- global$doc %>%
          xml2::read_html() %>%
          rvest::html_nodes(xpath = input$xpath) %>%
          rvest::html_text()
        print(global$items)
        global$xpath_output <- global$items
        output$curl <- renderPrint(global$xpath_output)

      })




      observeEvent(input$add_new_url, {
        rvestScraper[[input$error_item]]$url <- input$new_url
        save(rvestScraper, file = file.path(SteveAI_dir, "scraper_rvest.RData"))
      })


      observeEvent(input$curl, {

        url <- rvestScraper[[input$error_item]]$url
        global$curl_output <- system(command = glue::glue("curl {url}"), intern = TRUE)

        output$curl <- renderPrint(global$curl_output)

      })



      observeEvent(input$domain, {

        url <- rvestScraper[[input$error_item]]$url
        domain <- urltools::domain(url)
        global$domain_output <- httr::GET(url = domain)

        output$curl <- renderPrint(global$domain_output)

      })



      observeEvent(input$remove, {
        print(rvestScraper[[input$error_item]])
        rvestScraper[[input$error_item]] <- NULL
        save(rvestScraper, file = file.path(SteveAI_dir, "scraper_rvest.RData"))
        ### add: are you sure?
      })

      observeEvent(input$google_search, {
        glue::glue("https://www.google.de/search?q={input$error_item}+jobs") %>%
          browseURL()
      })

      observeEvent(input$open_scrape_url, {
        rvestScraper[[input$error_item]]$url %>%
          browseURL()
      })


      data <- reactive({

        req(input$min_nodes)

        log_data %<>% dplyr::filter(as.numeric(n_nodes) >= input$min_nodes | is.na(n_nodes))

        log_data %<>% dplyr::filter(!is.na(missing_object) == input$obj_has_txt)

        log_data

      })

      output$tbl_all = renderDT(
        datatable(data(), filter = 'top'), options = list(lengthChange = FALSE)
      )

      output$tbl_single = renderDT(
        datatable(data() %>% dplyr::filter(comp_name == input$error_item), filter = 'top'), options = list(lengthChange = FALSE)
      )

    }

    shinyApp(ui, server)

}



# 'NA' does not exist in current working directory
# UPS-DTLD - 77
# nicht anwendbare Methode für 'status_code' auf Objekt der Klasse "character" angewendet
# DEFINIENS - 58

# Missing url for target_name
# Timeout was reached:
# schannel: next InitializeSecurityContext failed: SEC_E_CERT_EXPIRED
# Must specify at least one of url or handleCompact call
# Failure when receiving data from the peerCompact call stack:
# Operation was aborted by an application callbackCompact call stack: 1 tryCatchLog(expr = scraper$url %>% httr::GET(), error = function(e) {
#
# log_data %>% dplyr::filter(level == "ERROR") %>% dplyr::select("message") %>% unique


# 404 pages
# could have a new pagename, but the rest remains the same.
# Then i could try to find pages that link to this page and see which of the links changed, that could be
# the link of interest.
# In order to find pages that link to the page i can search all links (and hope for a link back.) But this
# doesnt work for the woolworth page.
#
# Could use something like: http://wummel.github.io/linkchecker/.
# - have to include settings https://github.com/wummel/linkchecker/issues/715#issuecomment-322203882
#
# Open questions:
# Does it download every page. Isnt that too much for the server
# If page is visited anyway cant we keep the loaded page.
# --> Maybe just own implementation in R?
#
#
# Search for the text - does not work on google



# curl curl fetch memory:

# update curl and httr: https://github.com/jeroen/curl/issues/220
# should have that as an auto check.
# devtools::install_github(repo = "jeroen/curl")
# devtools::install_github(repo = "r-lib/httr")
# devtools::install_github(repo = "r-lib/xml2")

# but does not always work:
# Redirect did not work
# https://www.nuernberger.de/ueber-uns/karriere/wir-als-arbeitgeber/stellenangebote/
# -->
# https://www.nuernberger.de/ueber-uns/karriere/stellenangebote/

# in cmd:
# C:\Users\User11>curl https://www.nuernberger.de/ueber-uns/karriere/wir-als-arbeitgeber/stellenangebote/
#   <!DOCTYPE HTML PUBLIC "-//IETF//DTD HTML 2.0//EN">
#   <html><head>
#   <title>301 Moved Permanently</title>
#   </head><body>
#   <h1>Moved Permanently</h1>
#   <p>The document has moved <a href="http://www.nuernberger.de/ueber-uns/karriere/stellenangebote/">here</a>.</p>
#   </body></html>

# hint for redirect. how can i automatically catch these.

# do this hin
