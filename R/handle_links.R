

equalize_links <- function(link){
  rm_last_char <- substring(link, first = nchar(link)) == "/"
  ifelse(rm_last_char, yes = substring(link, first = 1, last = nchar(link) - 1), no = link)
}

filter_links <- function(links, domain, parsed_links, filter_domain = FALSE){

  links$href <- sapply(links$href, equalize_links)
  # some links are reported like: "//www.saturn.de/de/category/_teegeräte-476120.html".
  needs_start <- substring(text = links$href, first = 1, last = 1) %in% c("/", "?") &
    !grepl(x = links$href, pattern = "http") &
    !grepl(x = links$href, pattern = "www.", fixed = TRUE)
  needs_start[is.na(needs_start)] <- FALSE
  links$href[needs_start]
  # links %>% grepl(pattern = "https://www.aecom.com/http:")
  # links <- links2

  links$href %<>%
    {ifelse(test = needs_start, yes = paste0("https://", domain, .), no = .)}

  domains <- links$href %>%
    urltools::domain()

    # cant always use www. - will grab over domian() if www. is required.
    # domain ("https://www.google.de) will yield www.google.de others without wwww.
    # https://superuser.com/questions/453673/some-websites-dont-work-with-the-www-prefix#_=_
    # %>%
    # gsub(pattern = "www.", replacement = "")
  # e.g. jobs.lidl.de should be same_domain as lidl.de - therefore use grepl instead of "=="
  same_domain <- is.na(domains) | grepl(pattern = domain, x = domains)

  hash_link <- substr(links$href, 1, 1) == "#"
  is_empty <- !nchar(links$href)
  is_na <- is.na(links$href)
  alr_exist <- links$href %in% parsed_links
  is_html <- sapply(c("mailto:", "javascript:", ".tif", ".mp4", ".mp3", ".tiff", ".png", ".gif", ".jpeg",".jpg", ".zip", ".pdf"),
                    FUN = grepl, x = tolower(links$href)) %>%
                    as.matrix %>%
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
    !grepl(links$href, pattern = "http://") &
    !grepl(links$href, pattern = "www.") &
    !is.na(links$href)

  links$href %<>%
    {ifelse(
      test = not_matched,
      yes = paste0("https://", domain, "/", .),
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
  direct_match <- paste(c("(?=.*jobs)(?=.*suche)", "(?=.*jobs)(?=.*suche)(?=.*page=)", "(?=.*jobs)(?=.*suche)", "successfactors", "all open positions", "jobportal", "sjobs.brassring",
                    "Ergebnisse 1 – 25 von", "stellenboerse", "vacancies", "current-vacancies", "Artikel pro Seite", "1 – 10 of ", "bewerbungsportal", "myworkdayjobs"), collapse = "|")

  # todo: könnte reihenfolge hier reinbringen - stellenangebote vor "über uns"
  prioritize <- c("stellenmarkt", "stellenboerse", "current-vacancies", "offenepositionen", "vacancies", "bewerber", "jobfinder ", "stellen suchen", "jobportal", "jobbörse", "jobboerse", "jobs", "job", "all-jobs", "jobsuche","offenestellen", "offene-stellen", "stellenangebote", "job offers", "careers", "career", "karriere", "beruf", "über uns", "ueber uns", "ueber-uns", "uber ", "über ", "ueber ", "all open positions", "brassring")
  de_prioritize <- c("impressum", "paypal", "nutzungsbedingungen", "kontakt", "standort", "veranstaltungen", "newsletter", "datenschutz", "facebook", "instagram", "lpsnmedia.net", "google.com/recaptcha", "usercentrics", "linkedin", "googletagmanager", "cookies", "addthis.com", "xing.com", "youtube", "cookiebot.com", "google.com", "youtube-nocookie", "twitter", "linkedin", "signup", "request-password", "checkpoint", "signup", "wa.me", "vimeo",
                     "google.de/maps", "google.de/intl")

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

  links[first, ]$href

  href <- sapply(unique(de_prioritize), stringr::str_count, string = tolower(links$href))
  text <- sapply(unique(de_prioritize), stringr::str_count, string = links$text)

  # todo: only heuristic so far
  dims <- dim(text)
  weights <- matrix(rep(rev(seq(dims[2])^2), dims[1]), nrow = dims[1], byrow = TRUE)
  all <- as.matrix(href + text)
  last <- as.matrix(all*weights) %>%
    rowSums(na.rm = TRUE) %>%
    {order(., decreasing = TRUE)[0:sum(. > 0)]}

  iframe <- which(links$text == "iframe")
  iframe <- setdiff(iframe, last)
  first <- setdiff(first, last)

  order <- c(iframe, direct, first, setdiff(seq(links$href), c(first, last, direct)),last) %>%
    unique
  return(links[order, ])
}
