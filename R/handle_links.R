

filter_links <- function(links, filter_domain = FALSE){

  links %<>%
    {ifelse(test = substring(text = ., first = 1, last = 1) == "/", yes = paste0("https://www.", domain, .), no = .)}

  domains <- links %>%
    urltools::domain() %>%
    gsub(pattern = "www.", replacement = "")
  # e.g. jobs.lidl.de should be same_domain as lidl.de - therefore use grepl instead of "=="
  same_domain <- is.na(domains) | grepl(pattern = domain, x = domains)

  hash_link <- substr(links, 1, 1) == "#"
  is_empty <- !nchar(links)
  is_na <- is.na(links)
  alr_exist <- links %in% parsed_links
  is_html <- sapply(c("mailto:", "javascript:void", ".tif", ".mp4", ".mp3", ".tiff", ".png", ".gif", ".jpeg",".jpg", ".zip", ".pdf"),
                    FUN = grepl, x = links) %>%
    rowSums %>%
    magrittr::not()

  links %<>%
    .[!hash_link & !is_na & !is_empty & !alr_exist & is_html] %>%
    unique
  if(filter_domain) links %<>% .[same_domain] %>% unique
  # links %>% grepl(pattern = "jobs") %>% which %>% {links2[.]}

  not_matched <- grepl(substring(text = links, first = 1, last = 1), pattern = "[a-z]", perl = TRUE) &
    !grepl(links, pattern = "https://") &
    !grepl(links, pattern = "www.")

  links %<>%
    {ifelse(
      test = not_matched,
      yes = paste0("https://www.", domain, "/", .),
      no = .)
    }


  return(links)

}

sort_links <- function(links){

  links <- tolower(links)
  direct_match <- c("(?=.*jobs)(?=.*suche)(?=.*page=)", "(?=.*jobs)(?=.*suche)")
  prioritize <- c("stellenmarkt", "jobboerse", "jobs", "all-jobs", "jobsuche","offenestellen", "offene-stellen", "stellenangebote", "job offers", "careers", "karriere", "beruf")
  de_prioritize <- c("impressum", "nutzungsbedingungen", "kontakt", "standort", "veranstaltungen", "newsletter", "datenschutz")

  direct <- sapply(direct_match, grep, perl = TRUE, x = links) %>%
    unlist %>%
    {links[.]}

  first <- sapply(unique(prioritize), stringr::str_count, string = links) %>%
    rowSums(na.rm = TRUE) %>%
    order(decreasing = TRUE) %>%
    links[.]
    # unlist %>%
    # table %>% sort(decreasing = TRUE) %>%
    # {links[as.numeric(names(.))]}

  last <- sapply(de_prioritize, grep, x = links) %>%
    unlist %>%
    {links[.]}

  links <- c(direct, first, setdiff(links, c(first, last)),last)
  return(links)
}
