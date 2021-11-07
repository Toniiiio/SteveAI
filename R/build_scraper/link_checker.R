# open issues
# could be in pdf -
# than go over domain "68 74 74 70 73 3a 2f 2f 72 65 63 61 6c 6d 2e 63 6f 6d 2f 77 70 2d 63 6f 6e 74 65 6e 74 2f 75 70 6c 6f 61 64 73 2f 32 30 31 39 2f 30 37 2f 44 32 30 31 39 5f 30 37 5f 30 33 5f 41 75 73 73 63 68 72 65 69 62 75 6e 67 5f 41 62 73 63 68 6c 75 73 73 61 72 62 65 69 74 5f 45 6c 65 6b 74 72 6f 74 65 63 68 6e 69 6b 2e 70 64 66"

ec <- function(plaintext){
  charToRaw(plaintext) %>% as.character() %>% paste(collapse = " ")
}
# ec("https://careers.spglobal.com/jobs")

dc <- function(eurl){
  eurl %>% strsplit(split = " ") %>% .[[1]] %>% as.hexmode() %>% as.raw %>% rawToChar()
}
# (url <- dc(eurl))

start_selenium <- function(port_nr = 4452){

  #library(RSelenium)
  is_windows <- Sys.info()['sysname'] == "Windows"
  if(is_windows){

    remDr <- RSelenium::remoteDriver(
      remoteServerAddr = "localhost",
      port = port_nr
    )
    # port_nr = 4449
    # sudo: no tty present and no askpass program specified
    # --> https://stackoverflow.com/a/39553081/3502164
    tryCatch(
      system(
        paste0("docker run -d -p ", port_nr,":4444 selenium/standalone-firefox:2.53.0")
      ), error = function(e) warning("system docker call failed")
    )

  }else{

    remDr <- RSelenium::remoteDriver(port = port_nr)
    # port = 4449
    # sudo: no tty present and no askpass program specified
    # --> https://stackoverflow.com/a/39553081/3502164
    tryCatch(
      system(
        paste0("sudo -kS docker run -d -p ", port_nr,":4444 selenium/standalone-firefox:2.53.0"),
        input = "vistarundle1!!!"
      ), error = function(e) warning("system docker call failed")
    )

  }

  remDr$open()
  # So that all elements can be seen and are not hidden
  remDr$setWindowSize(width = 4800, height = 2400)
  return(remDr)

}

get_doc_selenium <- function(url, remDr){

  url <- as.character(url)
  remDr$navigate(url)
  domain <- remDr$getCurrentUrl()[[1]] %>%
    urltools::domain()
    # %>%
    # gsub(pattern = "www.", replacement = "")
  elem <- remDr$findElement(using = "xpath", value = "/*")
  doc <- elem$getElementAttribute("innerHTML") %>%
    .[[1]] %>%
      xml2::read_html()
  return(
    list(doc = doc, domain = domain)
  )
}

get_doc_phantom <- function(url, ses, pjs){

  url <- as.character(url)
  tryCatch(ses$go(url), error = function(e){
    warning("Need to restart phantom webdriver")
    pjs <<- webdriver::run_phantomjs()
    ses <<- webdriver::Session$new(port = pjs$port)
    ses$go(url)
  })


  url_before <- tryCatch(ses$getUrl(), error = function(e) return(""))
  domain <- url_before %>%
    urltools::domain()
    # %>%
    # gsub(pattern = "www.", replacement = "")

  doc <- tryCatch(ses$findElement(xpath = "/*")$getAttribute(name = "innerHTML") %>%
    xml2::read_html(), error = function(e){
      return("")
  })

  return(
    list(doc = doc, domain = domain, ses = ses, pjs = pjs, url_before = url_before)
  )
}

# start_phantom <- function(){
# pjs <- webdriver::run_phantomjs()
# ses <- webdriver::Session$new(port = pjs$port)
# }

#ses <- start_phantom()



get_doc <- function(url){
  url %>% xml2::read_html()
}
#
# library(magrittr)
# library(rvest)
# library(xml2)
# use_selenium = TRUE

follow_link <- function(link, use_selenium = FALSE){

  if(use_selenium){
    xp <- paste0("//*[contains(text(), '", "Search Jobs","')]")
    remDr$screenshot(display = TRUE)
    elem <- remDr$findElements(using = "xpath", value = xp)
    clickElement2 <- function(remDr, elem){
      remDr$executeScript("arguments[0].click();", args = elem[1])
    }
    clickElement2(remDr = remDr, elem = elem[2])

    elem[[1]]$clickElement()
    elem[[2]]$clickElement()
    out <- get_doc_selenium(url, remDr)
    doc <- out$doc
    domain <- out$domain

  }else{
    doc <- get_doc(link$href)
  }
}

generate_button_xpath <- function(){
  texts <- c('Ergebnisse anzeigen', 'Find your job', 'Jobsuche', 'Find jobs', 'search', 'Jobs Anzeigen', 'Stellen suchen', 'Search', 'Stellenangebote suchen', 'Jobs anzeigen')
  tagnames_raw <- c("button", "input")
  tagnames <- paste0("(", paste0("self::", tagnames_raw, collapse = " or "), ")")

  xp_text <- paste0(paste(paste0("./parent::*//*[contains(text(), '", texts,"')]"), collapse = " or "))
  paste0("//*", "[", tagnames, " and (", xp_text, ")]")
}

parse_link <- function(target_link, iter_nr, link_meta, use_selenium = FALSE, use_phantom = TRUE, ses = NULL, pjs, remDr = NULL){

  links <- link_meta$links
  all_docs <- link_meta$all_docs
  html_texts <- link_meta$html_texts
  matches <- link_meta$matches
  all_links <- link_meta$all_links
  counts <- link_meta$counts
  parsed_links <- link_meta$parsed_links

  link <- links$href[1]
  id <- c(iter_nr, target_link) %>% paste(collapse = "-")
  print(link)
  # workaround until frames are supported
  if(is.na(link)){
    exclude <- links$href %in% link
    links <- links[!exclude, ]
    message("skipping NA (frame link)")
    return()
  }

  #all_docs[[id]] %>% showHtmlPage()
  if(use_selenium){
    out <- get_doc_selenium(url = link, remDr)
    all_docs[[id]] <- out$doc
    domain <- out$domain
  }else if(use_phantom){
    out <- get_doc_phantom(url = link, ses = ses, pjs = pjs)
    ses <- out$ses
    domain <- out$domain
    url_before <- out$url_before
    all_docs[[id]] <- out$doc
  }else{
    all_docs[[id]] <- tryCatch(
      expr = link %>% xml2::read_html(),
      error = function(e) ""
    )
  }

  has_doc <- nchar(all_docs[[id]] %>% toString)
  if(has_doc){

    all_links[[id]] <- all_docs[[id]] %>%
      html_nodes(xpath = "//a") %>%
      {data.frame(href = html_attr(x = ., name = "href"), text = html_text(.))}
    # %>%{ifelse(test = substring(text = ., first = 1, last = 1) == "/", yes = paste0("https://www.", urltools::domain(link), .), no = .)}

    html_texts[[id]] <- tryCatch(htm2txt::htm2txt(as.character(all_docs[[id]])),
                                 error = function(e){
                                   message(e)
                                   warning(e)
                                   return("")
                                 })

  }else{

    all_links[[id]] <- data.frame(href = character(), text = character())
    message("No content")
    warning("No content")

    return(
      list(
        links = links[-1, ], all_docs = all_docs, all_links = all_links,
        parsed_links = parsed_links,
        html_texts = html_texts, matches = matches, counts = counts
      )
    )


  }

  #all_docs[[id]] %>% SteveAI::showHtmlPage()
  # html_texts[[id]] %>% cat

  doc <- all_docs[[id]]

  if(!exists("job_titles")) job_titles <- ""

  matches[[iter_nr]] <- target_indicator_count(job_titles = job_titles, doc = doc)

  counts[iter_nr] <- unlist(matches[[iter_nr]]) %>% as.numeric() %>% sum

  # todo: cant find src in code - maybe have to use swith to frame but cant use it as new link then
  iframe_links_raw <- doc %>%
    html_nodes(xpath = "//iframe") %>%
    html_attr("src")

  # speculative change: dont replace all values
  if(length(iframe_links_raw)){
      iframe_links_raw[is.na(iframe_links_raw)] <- ""
  }

  iframe_links <- data.frame(href = iframe_links_raw, text = rep("iframe", length(iframe_links_raw)))

  parsed_links[iter_nr, ]$href <- target_link$href
  parsed_links[iter_nr, ]$text <- target_link$text

  links <- rbind(iframe_links, links, all_links[[id]]) %>%
    filter_links(domain = domain, parsed_links = parsed_links, filter_domain = FALSE)

  links <- links[!duplicated(links$href), ]
  links$href

  links <- rbind(parsed_links, links)
  head(links)
  exclude <- links$href %in% parsed_links$href
  head(exclude)

  links <- links[!exclude, ] %>% sort_links()
  # taleo careersection jobsearch
  head(links$href)

  # links$href <- gsub(x = links$href, pattern = "www.www.", replacement = "www.", fixed = TRUE)

  # can fail

  links <- check_for_button(links, url_before, ses, pjs)

  return(
    list(
      links = links, all_docs = all_docs, all_links = all_links,
      parsed_links = parsed_links,
      html_texts = html_texts, matches = matches, counts = counts
    )
  )

}

check_for_button <- function(links, url_before, ses, pjs){

  # if fail here restart ses and go to url_before
  doc <- ses$findElement(xpath = "/*")
  doc_len_before <- doc$getAttribute("innerHTML") %>% nchar

  xp <- generate_button_xpath()
  buttons <- ses$findElements(xpath = xp)
  for(nr in seq(buttons)){
    tryCatch(buttons[[nr]]$click(), error = function(e) message(e))
  }

  input_xpath <- "//input[@type = 'submit' or @value = 'Search Jobs' or contains(@value, 'Search') or @title = 'Search Jobs' or @value='Suche starten']"
  inputs <- ses$findElements(xpath = input_xpath)
  xx

  job_related_page_xp <- "//*[contains(text(), 'Zurücksetzen') or contains(text(), 'Find a job') or contains(text(), 'Search and apply') or contains(text(), 'Global Career Opportunities') or contains(text(), 'Search Jobs') or contains(text(), 'Search for jobs') or contains(text(), 'Find Jobs')  or contains(text(), 'Aktuelle Stellenangebote') or contains(text(), 'gewünschte Stelle')  or contains(text(), 'job search') or contains(text(), 'Search Current Openings')  or contains(text(), 'Careers')]"
  is_job_related <- ses$findElements(xpath = job_related_page_xp) %>% length
  is_job_related


  # todo: finish
  #
  button_xpath <- "//button[./parent::*//*[contains(text(), 'GO')] or @title = 'Search for Jobs']"
  buttons <- ses$findElements(xpath = button_xpath)

  if(is_job_related){
    for(nr in seq(buttons)){
      tryCatch(buttons[[nr]]$click(), error = function(e) message(e))
    }
  }

  if(is_job_related){
    for(nr in seq(inputs)){
      message("Found and trying a relevant input")
      tryCatch(inputs[[nr]]$click(), error = function(e) message(e))
    }
  }

  alinks <- ses$findElements(xpath = "//a[@id = 'taleoSearchSubmit']")
  if(is_job_related){
    for(nr in seq(alinks)){
      message("Found and trying a relevant input")
      tryCatch(alinks[[nr]]$click(), error = function(e) message(e))
    }
  }

  url_after <- ses$getUrl()
  doc <- ses$findElement(xpath = "/*")
  doc_len_after <- doc$getAttribute("innerHTML") %>% nchar

  button_relevant <- url_after != url_before | doc_len_before != doc_len_after

  if(button_relevant){
    message("Found a relevant button")
    links <- rbind(
      data.frame(
        href = url_after,
        text = "Caused by SteveAI button click"
      ),
      links
    )
  }

  return(links)

}

extract_target_text <- function(parsing_results){

  doc <- parsing_results$doc %>% xml2::read_html()
  # doc %>% SteveAI::showHtmlPage()
  # parsing_results$all_docs[[parsing_results$winner]] %>% SteveAI::showHtmlPage()
  target_text <- get_target_text(parsing_results)
  # target_text <- "Account Executive"
  target_text

  # doc %>% html_nodes(xpath = "//*[contains(text(), 'm/w/d')]") %>%
  #   html_text()



  #doc %>% SteveAI::showHtmlPage()
  url <- parsing_results$parsed_links$href[parsing_results$winner]
  xpath <- SteveAI::getXPathByText(text = target_text, doc = doc, add_class = TRUE, exact = TRUE)
  xpath
  if(is.null(xpath)){
    message(glue("Did not find an xpath given the target text: {target_text}"))
    parsing_results$candidate_meta <- url
    return(parsing_results)
  }

  source("R/scrapers/configure_xpath.R")
  candidate_meta <- configure_xpath(xpath, doc, ses, url)
  parsing_results$candidate_meta <- candidate_meta
  return(parsing_results)

}


create_link_meta <- function(use_selenium, url, remDr, use_phantom, ses, pjs, link, parsed_links, max_iter) {

  if(use_selenium){
    out <- get_doc_selenium(url, remDr)
    doc <- out$doc
    domain <- out$domain
  }else if(use_phantom){
    out <- tryCatch(get_doc_phantom(url, ses, pjs), error = function(e){
      warning(e)
      # ses <<- webdriver::Session$new(port = pjs$port)
      return(
        list(ses = ses, domain = "", doc = "")
      )
    })
    ses <<- out$ses
    domain <- out$domain
    doc <- out$doc
  }else{
    doc <- tryCatch(
      expr = link %>% xml2::read_html(),
      error = function(e) ""
    )
  }

  #
  # ses$getUrl()
  doc %>% SteveAI::showHtmlPage()
  tags <- doc %>% html_nodes(xpath = "//*[self::a or self::button or self::input]")
  txt <- tags %>% html_text()
  val <- tags %>% html_attr(name = "value") %>% ifelse(is.na(.), "", .)
  links <- data.frame(text = paste0(txt, val), href = tags %>% html_attr(name = "href"))

  if(!dim(links)[1]) stop("No links found for initial page.")
  links %>% grepl(pattern = "jobs") %>% sum
  head(links)

  #links_per_level[1] <- url


  links <- filter_links(links = links, domain = domain, parsed_links = parsed_links, filter_domain = FALSE)

  # catch document and all links
  html_texts <- list()
  all_links <- list()
  all_docs <- list()
  matches <- list()
  counts <- rep(NA, max_iter)

  links <- sort_links(links)
  links %>% head

  list(
    links = links, all_docs = all_docs, all_links = all_links,
    parsed_links = parsed_links,
    html_texts = html_texts, matches = matches, counts = counts
  )
}

# remDr = NULL
# # ses <<- start_phantom()
# use_selenium = FALSE
# use_phantom = TRUE
find_job_page <- function(url, remDr = NULL, ses = NULL, pjs = NULL, use_selenium = FALSE, use_phantom = TRUE){

  iter_nr <- 0
  max_iter <- 12
  parsed_links <- data.frame(href = character(max_iter), text = character(max_iter))
  links_per_level <- list()
  docs_per_level <- list()


  #links[1] %>% browseURL()
  link <- url
  link
  link_meta <- create_link_meta(use_selenium, url, remDr, use_phantom, ses, pjs, link, parsed_links, max_iter)
  print("ses")
  print(ses)
  if(use_phantom & is.null(ses)) stop("Phantom is used, but session is still NULL.")
  link_meta$links %>% head

  while(iter_nr < max_iter){

    iter_nr <- iter_nr + 1
    target_link <- link_meta$links[1, ]

    if(is.na(target_link$href)){
      link_meta$links <- link_meta$links[-1, ]
      next
    }

    link_meta <- parse_link(
      target_link = target_link,
      iter_nr = iter_nr, link_meta = link_meta,
      use_selenium = FALSE, use_phantom = TRUE,
      remDr = NULL, ses = ses, pjs = pjs
    )

    link_meta$links %>% head

  }

  winner <- which(max(link_meta$counts, na.rm = TRUE) == link_meta$counts)[1]
  # targets <- parsed_links[max(counts, na.rm = TRUE) == counts]
  # targets[1] %>% browseURL()

  # link_meta$counts
  # link_meta$parsed_links$href
  # link_meta$parsed_links$href[winner]
  # link_meta$parsed_links$href[4] %>% browseURL()
  # link_meta$all_docs[[winner]] %>% SteveAI::showHtmlPage()
  # link_meta$all_docs[[winner]] %>% toString %>% grepl(pattern = "Elektro")

  parsing_results <- list(
    doc = as.character(link_meta$all_docs[[winner]]),
    all_docs = lapply(link_meta$all_docs, as.character),
    counts = link_meta$counts,
    parsed_links = link_meta$parsed_links,
    matches = link_meta$matches,
    winner = winner
  )

  out <- extract_target_text(parsing_results)
  out$candidate_meta
  return(out)
}
