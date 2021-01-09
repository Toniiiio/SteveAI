load("xpath_href.RData")
#SteveAI::rvestScraper$xpath_href <- xpath_href

nr <- 1
comp <- SteveAI::rvestScraper[[nr]]
doc <- comp$url %>% read_html()
links <- doc %>%
  html_nodes(xpath = xpath_href[nr]) %>%
  html_attr(name = "href")

xxx <- lapply(links, htm2txt::gettxt)



# text1 <- xxx[[1]]
# text2 <- xxx[[2]]

findEnd <- function(text1, text2, reverse = FALSE){

  if(reverse){
    text1 <- text1 %>%
      strsplit(split = "") %>%
      "[["(1) %>%
      rev() %>%
      paste(collapse = "")

    text2 <- text2 %>%
      strsplit(split = "") %>%
      "[["(1) %>%
      rev() %>%
      paste(collapse = "")

  }

  max <- min(nchar(text1), nchar(text2))
  seq <- seq(10, max, by = 70)
  same <- TRUE
  nr <- 1

  while(same){
    dist <- adist(substr(text1, 1, seq[nr]), substr(text2, 1, seq[nr])) / seq[nr]
    same <- dist[1, 1] == 0
    print(same)
    nr <- nr + 1
  }

  if(nr == 2) return(0)


  pos <- seq[nr]
  while(!same){
    print(pos)
    dist <- adist(substr(text1, 1, pos), substr(text2, 1, pos)) / pos
    same <- dist[1, 1] == 0
    pos <- pos - 1
  }

  if(reverse) pos = c(nchar(text1) - pos, nchar(text2) - pos)

  return(pos)
}


xx <- findEnd(text1, text2, reverse = TRUE)

cut1 <- substring(text1, 1, pos)
cut2 <- substring(text1, xx[1], nchar(text1))

text_raw <- xxx[[25]]

extract_article <- function(text_raw, cut1, cut2){

  str_len <- nchar(cut1)
  s <- 1000
  if(str_len > s) cut1 <- substring(cut1, 1, s)
  m <- aregexec(cut1, text_raw, max.distance = 0.3)
  replace1 <- substring(text_raw, first = m[[1]][1], last = str_len) %>%
    unlist %>%
    .[1]

  str_len <- nchar(cut2)
  s <- 1000
  if(str_len > s) cut2 <- substring(cut2, 1, s)
  m <- aregexec(cut2, text_raw, max.distance = 0.3)

  if(m[[1]][1] == -1){

    warning("No match!")
    replace <- NULL
    asd

  }else{

    replace2 <- substring(text_raw, first = m[[1]][1], last = m[[1]][1] + str_len) %>%
      unlist %>%
      .[1]

  }

  text_raw %>%
    gsub(pattern = replace1, replacement = "", fixed = TRUE) %>%
    gsub(pattern = replace2, replacement = "", fixed = TRUE)

}

s <- lapply(xxx, extract_article, cut1 = cut1, cut2 = cut2)
names(s) <- links

cat(s[[3]])
cat(s[[25]])

