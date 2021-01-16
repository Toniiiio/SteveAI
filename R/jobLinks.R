# Doku:
# In rvestScraping i save the links.
# I want to have single purpose functions.
# Therefore, i would separate this process.
# I dont necessarily need an update every day.
# Therefore, i would look in the database of
# all jobs and see if i have a scraped link.
# But not all jobs have a scraping path available.
# So check the database for all entries with
# a scraping path but no scraped job description.

# load("xpath_href.RData")


# # text1 <- xxx[[1]]
# # text2 <- xxx[[2]]
#

findEnd <- function(text1, text2, reverse = FALSE){

  if(text1 == text2){
    warning("text1 equals text2")
  }

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

  while(same & nr <= length(seq)){
    dist <- adist(substr(text1, 1, seq[nr]), substr(text2, 1, seq[nr])) / seq[nr]
    same <- dist[1, 1] == 0
    print(same)
    nr <- nr + 1
  }

  if(nr == 2 | (nr + 1) == length(seq)){
    warning("no match found - maybe they start or end with same text.")
    return(0)
  }


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
#
#
# xx <- findEnd(text1, text2, reverse = TRUE)
#
# cut1 <- substring(text1, 1, pos)
# cut2 <- substring(text1, xx[1], nchar(text1))
#
# text_raw <- xxx[[25]]
#

remove_header_footer <- function(text_raw, cut, dist = 0.3, header = TRUE){

  if(!nchar(cut)){
    return(text_raw)
  }

  str_len <- nchar(cut)
  s <- 1000
  if(str_len > s) cut <- substring(cut, 1, s)
  m <- aregexec(cut, text_raw, max.distance = dist, fixed = TRUE)

  if(m[[1]][1] == -1){
    warning(paste0("No match for ", cut))
    xx
    return(text_raw)
  }

  if(header){

    replace <- substring(text_raw, first = m[[1]][1], last = m[[1]][1] + str_len) %>%
      unlist %>%
      .[1]

  }else{

    replace <- substring(text_raw, first = m[[1]][1], last = str_len) %>%
      unlist %>%
      .[1]

  }

  out <- text_raw %>%
    gsub(pattern = replace, replacement = "", fixed = TRUE)

  return(out)

}

extract_article <- function(text_raw, cut1, cut2){

  if(text_raw[[1]] == "ERROR") return(text_raw[[1]])
  text_raw <- remove_header_footer(text_raw, cut1) # remove header
  text_raw <- remove_header_footer(text_raw, cut2) # remove footer
  return(text_raw)

}

#
# s <- lapply(xxx, extract_article, cut1 = cut1, cut2 = cut2)
# names(s) <- links
#
# cat(s[[3]])
# cat(s[[25]])
#
