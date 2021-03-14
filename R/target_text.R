get_target_text <- function(parsing_results){

  rr <- parsing_results$matches[[parsing_results$winner]] %>%
    {.[names(.) != "apply_button"]} %>%
    unname %>%
    unlist(recursive = TRUE)

  #weights <- c("m/w/d" = 5, "m/w" = 4, "vollzeit" = 0.1) # has to have the same lengths
  rr[names(rr) %in% c("m/w/d",  "w/m/d")] %<>% {as.numeric(.)*5}
  rr %>%
    {names(.)[which.max(.)]}
}

extract_target_text <- function(parsing_results){
  doc <- parsing_results$doc %>% xml2::read_html()
  # doc %>% SteveAI::showHtmlPage()
  # parsing_results$all_docs[[parsing_results$winner]] %>% SteveAI::showHtmlPage()
  target_text <- get_target_text(parsing_results)
  # target_text <- "Kundenbetreuer (W/m/d)"
  target_text

  # doc %>% html_nodes(xpath = "//*[contains(text(), 'm/w/d')]") %>%
  #   html_text()



  #doc %>% SteveAI::showHtmlPage()
  xpath <- SteveAI::getXPathByText(text = target_text, doc = doc, add_class = TRUE, exact = TRUE)
  xpath


  source("R/configure_xpath.R")
  url <- parsing_results$parsed_links$href[parsing_results$winner]
  candidate_meta <- configure_xpath(xpath, doc, ses, url)
  candidate_meta$target_text = target_text
  parsing_results$candidate_meta <- candidate_meta
  return(parsing_results)

}
