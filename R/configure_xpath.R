configure_xpath <- function(xpath, doc, ses, url) {

  phantom_results <- html_nodes(x = doc, xpath = xpath) %>% html_text()
  xml2_results <- full_results <- html_nodes(x = url %>% xml2::read_html(), xpath = xpath) %>% html_text()
  require_js <- !identical(phantom_results, xml2_results)

  tags_with_class <- xpath %>%
    strsplit(split = "/") %>%
    .[[1]] %>%
    .[-1]

  tags_pure <- sapply(tags_with_class, function(tag) tag %>% strsplit(split = "[[]") %>% .[[1]] %>% .[1]) %>% unname

  has_class <- tags_with_class %>%
    grepl(pattern = "@class")

  xp <- tags_pure %>%
    paste(collapse = "/") %>%
    paste0("/", .)

  ses$go(url = url)
  elem <- ses$findElement(xpath = "/*")
  doc <- elem$getAttribute(name = "innerHTML") %>% xml2::read_html()
  doc %>% rvest::html_nodes(xpath = xp)

  elem_limit <- doc %>% rvest::html_nodes(xpath = xpath) %>% html_text()
  elem_full <- doc %>% rvest::html_nodes(xpath = xp) %>% html_text()

  classes <- stringr::str_match(tags_with_class, 'class=\"(.*?)\"')[, 2]

  out <- list(
    elem_limit = elem_limit,
    elem_full = elem_full,
    require_js = require_js,
    classes = classes,
    tags_pure = tags_pure
  )

  names(out)[1:2] <- c(xpath, xp)

  return(out)
}

add_classes <- function(required_len, tags_pure, classes, doc){

  lens <- rep(NA, length(classes))
  xps <- rep(NA, length(classes))
  for(nr in seq(classes)){
    tags_to_edit <- tags_pure
    if(!is.na(classes[nr])){
      tags_to_edit[nr] <- paste0(tags_to_edit[nr], '[@class="', classes[nr], '"]')
    }
    xps[nr] <- tags_to_edit %>% paste(collapse = "/") %>% paste0("/", .)
    elems <- doc %>% rvest::html_nodes(xpath = xps[nr]) %>% html_text()
    lens[nr] <- elems %>% length
  }
  xps[which(lens == required_len)]

}
