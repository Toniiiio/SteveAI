configure_xpath <- function(xpath, doc, ses, url) {

  phantom_results <- html_nodes(x = doc, xpath = xpath) %>% html_text()
  xml2_results <- full_results <- html_nodes(x = url %>% xml2::read_html(), xpath = xpath) %>% html_text()
  require_js <- !identical(phantom_results, xml2_results)

  classes <- c()
  node <- html_nodes(doc, xpath = xpath)[1]
  name <- "x"
  while(name != "html"){
    classes <- c(classes, node %>% html_attr(name = "class"))
    node %<>% html_nodes(xpath = "..")
    name <- html_name(node)
  }
  classes <- c(classes, node %>% html_attr(name = "class")) %>% rev
  has_classes <- classes %>% is.na %>% magrittr::not()

  tags_pure <- xpath %>% gsub(pattern = "\\[@class=\"([^]]+)\"\\]", replacement = "") %>%
    strsplit(split = "/") %>%
    .[[1]] %>%
    .[-1]

  xp <- tags_pure %>%
    paste(collapse = "/") %>%
    paste0("/", .)

  ses$go(url = url)
  elem <- ses$findElement(xpath = "/*")
  doc <- elem$getAttribute(name = "innerHTML") %>% xml2::read_html()
  doc %>% rvest::html_nodes(xpath = xp)

  elem_limit <- doc %>% rvest::html_nodes(xpath = xpath) %>% html_text()
  elem_full <- doc %>% rvest::html_nodes(xpath = xp) %>% html_text()



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
  diff <- (lens - required_len)/required_len
  winner <- which(diff == 0)
  if(!length(winner)){
    warning("Did not find exact match")
    winner <- which(diff < 0.1)
  }

  xps[winner]

}
