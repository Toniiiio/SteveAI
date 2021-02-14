

filter_links <- function(links, domain, parsed_links, filter_domain = FALSE){

  # some links are reported like: "//www.saturn.de/de/category/_teegeräte-476120.html".
  needs_start <- substring(text = links$href, first = 1, last = 1) == "/" &
    !grepl(x = links$href, pattern = "http") &
    !grepl(x = links$href, pattern = "www.", fixed = TRUE)

  links$href %<>%
    {ifelse(test = needs_start, yes = paste0("https://www.", domain, .), no = .)}

  domains <- links$href %>%
    urltools::domain() %>%
    gsub(pattern = "www.", replacement = "")
  # e.g. jobs.lidl.de should be same_domain as lidl.de - therefore use grepl instead of "=="
  same_domain <- is.na(domains) | grepl(pattern = domain, x = domains)

  hash_link <- substr(links$href, 1, 1) == "#"
  is_empty <- !nchar(links$href)
  is_na <- is.na(links$href)
  alr_exist <- links$href %in% parsed_links
  is_html <- sapply(c("mailto:", "javascript:", ".tif", ".mp4", ".mp3", ".tiff", ".png", ".gif", ".jpeg",".jpg", ".zip", ".pdf"),
                    FUN = grepl, x = tolower(links$href)) %>%
    rowSums %>%
    magrittr::not()

  #!is_na & --> need NA for click with selenium
  # links2 <- links
  # links <- links2
  keep <- !hash_link & !is_empty & !alr_exist & is_html
  keep[is.na(keep)] <- TRUE
  links %<>%
    .[keep, ] %>%
    {.[!duplicated(.), ]}

  if(filter_domain) links %<>% .[same_domain, ]
  # links %>% grepl(pattern = "jobs") %>% which %>% {links2[.]}

  not_matched <- grepl(substring(text = links$href, first = 1, last = 1), pattern = "[a-z]", perl = TRUE) &
    !grepl(links$href, pattern = "https://") &
    !grepl(links$href, pattern = "www.")

  links$href %<>%
    {ifelse(
      test = not_matched,
      yes = paste0("https://www.", domain, "/", .),
      no = .)
    }


  return(links)

}

sort_links <- function(links){

  if(!dim(links)[1]){
    warning("No links to sort: links are empty.")
    return(links)
  }
  # urls have to be case sensitive, see https://www.saturn.de/webapp/wcs/stores/servlet/MultiChannelAllJobsOverview.
  links$text <- tolower(links$text)
  direct_match <- c("(?=.*jobs)(?=.*suche)", "(?=.*jobs)(?=.*suche)(?=.*page=)", "(?=.*jobs)(?=.*suche)") %>% paste(collapse = "|")
  # todo: könnte reihenfolge hier reinbringen - stellenangebote vor "über uns"
  prioritize <- c("stellenmarkt", "current-vacancies", "vacancies", "bewerber", "jobfinder ", "stellen suchen", "jobbörse", "jobboerse", "jobs", "job", "all-jobs", "jobsuche","offenestellen", "offene-stellen", "stellenangebote", "job offers", "careers", "karriere", "beruf", "über uns", "ueber uns", "ueber-uns", "uber ", "über ", "ueber ")
  de_prioritize <- c("impressum", "nutzungsbedingungen", "kontakt", "standort", "veranstaltungen", "newsletter", "datenschutz")

   # lapply(direct_match, function(direct) lapply(links$href, grepl, perl = TRUE, pattern = direct))
  direct <- sapply(links$href, grepl, perl = TRUE, pattern = direct_match, USE.NAMES = FALSE) %>%
    which

  href <- sapply(unique(prioritize), stringr::str_count, string = tolower(links$href))
  href[is.na(href)] <- 0
  text <- sapply(unique(prioritize), stringr::str_count, string = links$text)
  text[is.na(text)] <- 0

  # todo: only heuristic
  dims <- dim(text)
  weights <- matrix(rep(rev(seq(dims[2])^2), dims[1]), nrow = dims[1], byrow = TRUE)
  all <- as.matrix(href + text)
  first <- as.matrix(all*weights) %>%
    rowSums(na.rm = TRUE) %>%
    {order(., decreasing = TRUE)[0:sum(. > 0)]}
    # unlist %>%
    # table %>% sort(decreasing = TRUE) %>%
    # {links[as.numeric(names(.))]}
  links[first, ]

  href <- sapply(unique(de_prioritize), stringr::str_count, string = tolower(links$href))
  text <- sapply(unique(de_prioritize), stringr::str_count, string = links$text)

  # todo: only heuristic
  dims <- dim(text)
  weights <- matrix(rep(rev(seq(dims[2])^2), dims[1]), nrow = dims[1], byrow = TRUE)
  all <- as.matrix(href + text)
  last <- as.matrix(all*weights) %>%
    rowSums(na.rm = TRUE) %>%
    {order(., decreasing = TRUE)[0:sum(. > 0)]}

  order <- c(direct, first, setdiff(seq(links$href), c(first, last, direct)),last)
  return(links[order, ])
}
