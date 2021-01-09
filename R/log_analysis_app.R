# browser_path <- "C:/Program Files (x86)/Google/Chrome/Application/chrome.exe"
# browser_path %>% file.exists()
# options(browser = browser_path)
# #source("C:/Users/User11/Desktop/Transfer/TMP/mypkg2/R/sivis.R")
# getXPathByText <- function(text, doc, exact = FALSE, attr = NULL, byIndex = FALSE, onlyTags = FALSE, do_Warn = TRUE){
#
#   if(is.character(doc)){
#
#     warning("doc is of type character - trying to convert to xml doc with xml2::read_html")
#     doc %<>% xml2::read_html()
#
#   }
#
#   text %<>% tolower %>% gsub(pattern = " ", replacement = "")
#   xpath <- paste0("//*[text()[contains(translate(., 'ABCDEFGHIJKLMNOPQRSTUVWXYZ ', 'abcdefghijklmnopqrstuvwxyz'), '", text, "')]]")
#   tag <- doc %>% rvest::html_nodes(xpath = xpath)
#
#   tagName <- ""
#   tags <- c()
#
#   if(length(tag) > 1){
#
#     tagNames <- sapply(tag, rvest::html_name())
#     match <- which(tagNames != "script")
#     if(!length(match)) match <- 1
#     tag <- tag[match[1]]
#
#   }else if(length(tag) == 0){
#
#     if(do_Warn){
#       warning(glue("Did not find an xpath element that matches target Text: {text}!"))
#     }
#
#     return(NULL)
#
#   }
#
#   while(tagName != "html"){
#     tagName <- tag %>% rvest::html_name()
#     tags <- c(tags, tagName)
#     tag <- tag %>% rvest::html_nodes(xpath = "..")
#   }
#
#   if(onlyTags){
#     return(tags %>% unique)
#   }
#
#   xpath <- paste(c("", tags[length(tags):1]), collapse = "/")
#   xpath
#
# }
#
# SteveAI_dir <- getwd()
# #setwd(SteveAI_dir)
# load(file.path(SteveAI_dir, "scraper_rvest.RData"))
# source(file.path(SteveAI_dir, "log_analysis_func.R"))
#
# log_file <- glue("rvest_single_{Sys.Date()}.log")
#
# log_data <- parse_logs(log_file = log_file)
#
# error_items <- log_data %>%
#   dplyr::filter(level == "ERROR") %>%
#   dplyr::select(comp_name) %>%
#   unlist %>%
#   unname
#
# bb <- log_data[which(log_data$comp_name %>% is.na), ]
# log_data$n_nodes
#
# log_data %<>%
#   dplyr::group_by(comp_name) %>%
#   dplyr::mutate(db_consist = (sum(n_today_jobs, na.rm = TRUE) + sum(n_duplicate_jobs, na.rm = TRUE) == sum(n_nodes, na.rm = TRUE)))
# log_data$db_consist
#
#
#
# ui = fluidPage({
#
#   mainPanel(
#     tabsetPanel(
#       tabPanel("Overview", fluidRow(
#
#         numericInput(
#           inputId = "min_nodes",
#           label = "Min amt nodes:",
#           min = 0,
#           value = 0,
#           max = 500
#         ),
#
#         selectInput(
#           inputId = "logicals",
#           label = "Filter logicals",
#           choices = names(error_type_ident),
#           multiple = TRUE,
#           selectize = TRUE,
#           selected = NULL
#         ),
#
#         checkboxInput(
#           inputId = "obj_has_txt",
#           label = "Missing object in code",
#           value = FALSE
#         ),
#
#         DTOutput('tbl_all')
#
#       )
#       ),
#       tabPanel(
#         title = "Analyse",
#
#         uiOutput("items"),
#
#         DTOutput('tbl_single'),
#         actionButton(inputId = "open_scrape_url", label = "Open current url:"),
#         actionButton(inputId = "google_search", label = "Search for new page at google:"),
#         actionButton(inputId = "remove", label = "Remove this item"),
#         actionButton(inputId = "curl", label = "Try curl in cmd."),
#         shiny::fluidRow(
#           textInput(inputId = "new_url", label = "New url:"),
#           actionButton(inputId = "add_new_url", label = "Add new url!")
#         ),
#         textInput(inputId = "target_text", label = "Text for xpath:", value = ""),
#         uiOutput("xpath"),
#         actionButton(inputId = "get_xpath", label = "Get xpath"),
#         actionButton(inputId = "use_xpath", label = "Use xpath"),
#         verbatimTextOutput(outputId = "curl"),
#         textInput(inputId = "no_job_id", label = "Text to identify valid no jobs:", value = ""),
#         actionButton(inputId = "add_nojob_id", label = "Add no job id"),
#         actionButton(inputId = "finish_item", label = "Mark as done.")
#       )
#     )
#   )
# })
#
# server = function(input, output) {
#
#   global <- reactiveValues(curl_output = NULL, error_items = error_items)
#
#
#
#   output$items <- renderUI({
#     print(length(global$error_items))
#     selectInput(
#       inputId = "error_item",
#       label = "Error item:",
#       choices = global$error_items,
#       selected = global$error_items[1]
#     )
#   })
#
#   observeEvent(input$finish_item, {
#     print(input$finish_item)
#     print(input$error_item)
#     print(length(unlist(global$error_items)))
#     rvestScraper[[input$error_item]]$no_job_id <- input$no_job_id
#     global$error_items <- setdiff(global$error_items, input$error_item)
#     print(length(unlist(global$error_items)))
#   })
#
#
#   observeEvent(input$add_nojob_id, {
#
#     rvestScraper[[input$error_item]]$no_job_id <- input$no_job_id
#     save(rvestScraper, file = file.path(SteveAI_dir, "scraper_rvest.RData"))
#
#   })
#
#
#   observeEvent(input$error_item, {
#
#     req(input$error_item)
#     print(input$error_item)
#     scrape_url <- rvestScraper[[input$error_item]]$url
#
#     global$doc <- tryCatch(expr = scrape_url %>%
#       httr::GET() %>%
#       httr::content(type = "text"),
#       error = function(e) NULL
#     )
#
#   })
#
#   observeEvent(input$get_xpath, {
#
#     print(input$target_text)
#     print(global$doc)
#     txt <- getXPathByText(doc = global$doc, text = input$target_text)
#     print(txt)
#     output$xpath <- renderUI({
#       textInput(inputId = "xpath", label = "xpath:", value = txt %>% toString)
#     })
#
#   })
#
#   observeEvent(input$use_xpath, {
#
#     global$items <- global$doc %>%
#       xml2::read_html() %>%
#       rvest::html_nodes(xpath = input$xpath) %>%
#       rvest::html_text()
#     print(global$items)
#   })
#
#   observeEvent(input$add_new_url, {
#     rvestScraper[[input$error_item]]$url <- input$new_url
#     save(rvestScraper, file = file.path(SteveAI_dir, "scraper_rvest.RData"))
#   })
#
#
#   observeEvent(input$curl, {
#     url <- rvestScraper[[input$error_item]]$url
#     global$curl_output <- system(command = glue::glue("curl {url}"), intern = TRUE)
#   })
#
#   output$curl <- renderPrint(global$curl_output)
#
#   observeEvent(input$remove, {
#     print(rvestScraper[[input$error_item]])
#     rvestScraper[[input$error_item]] <- NULL
#     save(rvestScraper, file = file.path(SteveAI_dir, "scraper_rvest.RData"))
#     ### add: are you sure?
#   })
#
#   observeEvent(input$google_search, {
#     glue::glue("https://www.google.de/search?q={input$error_item}+jobs") %>%
#       browseURL()
#   })
#
#   observeEvent(input$open_scrape_url, {
#     rvestScraper[[input$error_item]]$url %>%
#       browseURL()
#   })
#
#
#   data <- reactive({
#
#     req(input$min_nodes)
#
#     log_data %<>% dplyr::filter(as.numeric(n_nodes) >= input$min_nodes | is.na(n_nodes))
#
#     log_data %<>% dplyr::filter(!is.na(missing_object) == input$obj_has_txt)
#
#     log_data
#
#   })
#
#   output$tbl_all = renderDT(
#     datatable(data(), filter = 'top'), options = list(lengthChange = FALSE)
#   )
#
#   output$tbl_single = renderDT(
#     datatable(data() %>% dplyr::filter(comp_name == input$error_item), filter = 'top'), options = list(lengthChange = FALSE)
#   )
#
#
# }
#
# shinyApp(ui, server)
#
#
# # 'NA' does not exist in current working directory
# # UPS-DTLD - 77
# # nicht anwendbare Methode für 'status_code' auf Objekt der Klasse "character" angewendet
# # DEFINIENS - 58
#
# # Missing url for target_name
# # Timeout was reached:
# # schannel: next InitializeSecurityContext failed: SEC_E_CERT_EXPIRED
# # Must specify at least one of url or handleCompact call
# # Failure when receiving data from the peerCompact call stack:
# # Operation was aborted by an application callbackCompact call stack: 1 tryCatchLog(expr = scraper$url %>% httr::GET(), error = function(e) {
# #
# # log_data %>% dplyr::filter(level == "ERROR") %>% dplyr::select("message") %>% unique
#
#
# # 404 pages
# # could have a new pagename, but the rest remains the same.
# # Then i could try to find pages that link to this page and see which of the links changed, that could be
# # the link of interest.
# # In order to find pages that link to the page i can search all links (and hope for a link back.) But this
# # doesnt work for the woolworth page.
# #
# # Could use something like: http://wummel.github.io/linkchecker/.
# # - have to include settings https://github.com/wummel/linkchecker/issues/715#issuecomment-322203882
# #
# # Open questions:
# # Does it download every page. Isnt that too much for the server
# # If page is visited anyway cant we keep the loaded page.
# # --> Maybe just own implementation in R?
# #
# #
# # Search for the text - does not work on google
#
#
#
# # curl curl fetch memory:
#
# # update curl and httr: https://github.com/jeroen/curl/issues/220
# # should have that as an auto check.
# # devtools::install_github(repo = "jeroen/curl")
# # devtools::install_github(repo = "r-lib/httr")
# # devtools::install_github(repo = "r-lib/xml2")
#
# # but does not always work:
# # Redirect did not work
# # https://www.nuernberger.de/ueber-uns/karriere/wir-als-arbeitgeber/stellenangebote/
# # -->
# # https://www.nuernberger.de/ueber-uns/karriere/stellenangebote/
#
# # in cmd:
# # C:\Users\User11>curl https://www.nuernberger.de/ueber-uns/karriere/wir-als-arbeitgeber/stellenangebote/
# #   <!DOCTYPE HTML PUBLIC "-//IETF//DTD HTML 2.0//EN">
# #   <html><head>
# #   <title>301 Moved Permanently</title>
# #   </head><body>
# #   <h1>Moved Permanently</h1>
# #   <p>The document has moved <a href="http://www.nuernberger.de/ueber-uns/karriere/stellenangebote/">here</a>.</p>
# #   </body></html>
#
# # hint for redirect. how can i automatically catch these.
#
# # do this hin
