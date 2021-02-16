# open issues
# could be in pdf -
# than go over domain https://recalm.com/wp-content/uploads/2019/07/D2019_07_03_Ausschreibung_Abschlussarbeit_Elektrotechnik.pdf

# start in der anderen dom?ne
# https://recruitingapp-5118.de.umantis.com/Vacancies/2972/Description/1?lang=ger&DesignID=00

# start with a url
# url <- "https://www.fida.de/jobs/stellenangebote/"
# target <- "werkstudent bereich personal"
# url <- "https://careers.cid.com/de"
# target <- "Informatiker (m/w)"

# url <- "https://recalm.com/"
# target <- "Praktikum Entrepreneurship (m/w/d)"

url <- "https://www.deutsche-leasing.com/de"
target_url <- "https://www.deutsche-leasing.com/de/unternehmen/karriere/unsere-stellenangebote"
target <- "Strategischer IT-Eink?ufer (m/w/d)"

target_url <- "https://www.dzbank.de/content/dzbank_de/de/home/unser_profil/karriere/berufserfahrene.html"
url <- "https://www.dzbank.de/content/dzbank_de/de/home.html"
target <- "Senior Revisor IT"

target <- "DATA INTEGRATION ENGINEER (M/W/D)"
target_url <- "https://veact-jobs.personio.de/"
url <- "https://veact-jobs.personio.de/job/80470"


target_url <- "https://www.asklepios.com/beruf/stellenangebote-und-bewerbung/alle-stellenangebote/"
url <- "https://www.asklepios.com/konzern/"
target <- "Ergotherapeuten (w/m/d)"

# yields javascript
url <- "https://www.dzbank.de"

#worls now
url <- "https://www.adecco.de"

# works
url <- "http://www.amadeus-fire.de"

# keine relevante seite
url <- "https://dasbesteteam.com/"

url <- "https://www.arvato.co.uk"

url <- "https://karriere.aldi-sued.de/"

url <- "https://www.aldi-nord.de/"

url <- "https://www.lidl.de/"

url <- "https://www.uipath.com/de/"

# JS
url <- "https://www.automationanywhere.com/de/"

url <- "https://www.blueprism.com/de/"

# works with a lot of warnings
url <- "https://www.hornbach.de"

# hash links
url <- "https://www.obi.de"
# false positive match
url <- "https://www.obi.de/karriere/"


# #link within --> Selenium
url <- "https://www.gamestop.de/"

url <- "https://www.fida.de/"

#works now
url <- "https://www.lunchnow.com"

#works
url <- "https://www.implico.com"

url <- "https://www.sportplatz-media.com"


#works
url <- "https://www.wisag.de"

# very strange links
url <- "https://www.mytoys.de/"

url <- "https://www.wwf.de/"
url <- "https://www.dzbank.de/"

# works with javascript
url <- "https://www.quantexa.com"

# selenium javascript - fails if try to get html - with permission denied
url <- "https://www.aboutyou.de/"


# txt <- target_url %>%
#   read_html %>% html_text %>%
#   tolower %>%
#   gsub(pattern = "\n|\t", replacement = " ")
# #txt %>% mypkg2:::show_html_page()
# has_match <- txt %>% aregexec(pattern = tolower(target), max.distance = 0.1) %>%
#   unlist %>% "!="(-1) %>% sum
# has_match


start_selenium <- function(port_nr = 4445){

  # port = 4449
  # sudo: no tty present and no askpass program specified
  # --> https://stackoverflow.com/a/39553081/3502164
  tryCatch(
    system(
      paste0("sudo -kS docker run -d -p ", port_nr,":4444 selenium/standalone-firefox:2.53.0"),
      input = "vistarundle1!!!"
    ), error = function(e) warning("system docker call failed")
  )

  #library(RSelenium)
  is_windows <- Sys.info()['sysname'] == "Windows"
  if(is_windows){
    remDr <- remoteDriver(
      remoteServerAddr = "localhost",
      port = port_nr
    )
  }else{
    remDr <- RSelenium::remoteDriver(port = port_nr)
  }

  remDr$open()
  # So that all elements can be seen and are not hidden
  remDr$setWindowSize(width = 4800, height = 2400)
  return(remDr)

}

# remDr <- start_selenium(port = 4450)

# has german/english local problem
url <- "https://www.dzbank.de"
url <- "http://www.cewe.de"

# javascript - hidden behind buttons
url <- "https://www.aok.de"

# strange start but works
url <- "https://www.wmf.de"

# german local english potential problem, doesnt find search page
url <- "https://www.lidl.de"

url <- "https://www.aldi-sued.de"

# grab all links from that url

# url <- "https://www.danone.de"
get_doc_selenium <- function(url, remDr){

  url <- as.character(url)
  remDr$navigate(url)
  elem <- remDr$findElement(using = "xpath", value = "/html")
  doc <- elem$getElementAttribute("innerHTML") %>%
    .[[1]] %>%
      xml2::read_html()
  return(doc)
}

get_doc <- function(url){
  url %>% xml2::read_html()
}

library(magrittr)
library(rvest)
library(xml2)
use_selenium = TRUE

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
    doc <- get_doc_selenium(url, remDr)
  }else{
    doc <- get_doc(link$href)
  }
}


find_job_page <- function(url, remDr, use_selenium = TRUE){

  domain <- urltools::domain(url) %>%
    gsub(pattern = "www.", replacement = "")
  parsed_links <- data.frame(href = character(), text = character())
  links_per_level <- list()
  docs_per_level <- list()

  if(use_selenium){
    doc <- get_doc_selenium(url, remDr)
  }else{
    doc <- get_doc(url)
  }

  tags <- doc %>% html_nodes(xpath = "//*[self::a or self::button or self::input]")
  txt <- tags %>% html_text()
  val <- tags %>% html_attr(name = "value") %>% ifelse(is.na(.), "", .)
  links <- data.frame(text = paste0(txt, val), href = tags %>% html_attr(name = "href"))

  # links <- doc %>%
  #   html_nodes(xpath = "//button") %>%
  #   {data.frame(href = html_attr(x = ., name = "href"), text = html_text(.))}

  if(!dim(links)[1]) stop("No links found")
  links %>% grepl(pattern = "jobs") %>% sum
  head(links)
  iter_nr <- 1
  #links_per_level[1] <- url

  html_texts <- list()
  links <- filter_links(links = links, domain = domain, parsed_links = parsed_links)
  links


  # catch document and all links
  all_links <- list()
  all_docs <- list()
  matches <- list()

  links <- sort_links(links)
  links %>% head

  #links[1] %>% browseURL()
  iter_nr <- 0
  max_iter <- 10
  counts <- rep(NA, max_iter)

  while(iter_nr < max_iter){

    iter_nr <- iter_nr + 1
    target_link <- links[1, ]
    link <- links$href[1]
    id <- c(iter_nr, target_link) %>% paste(collapse = "-")
    print(link)
    if(use_selenium){
      all_docs[[id]] <- get_doc_selenium(link, remDr)
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

      html_texts[[id]] <- htm2txt::htm2txt(as.character(all_docs[[id]]))

    }else{

      all_links[[id]] <- data.frame(href = character(), text = character())
      warning("No content")

    }

    #all_docs[[id]] %>% SteveAI::showHtmlPage()
    # html_texts[[id]] %>% cat
    # doc <- "https://www.bofrost.de/karriere/job/" %>% read_html

    doc <- all_docs[[id]]

    if(!exists("job_titles")) job_titles <- ""

    matches[[iter_nr]] <- target_indicator_count(job_titles = job_titles, doc = doc)

    counts[iter_nr] <- unlist(matches[[iter_nr]]) %>% as.numeric() %>% sum

    # "https://careers.danone.com/de-global/" %in% links$href
    # "https://careers.danone.com/de-global/" %in% links2$href
    links <- rbind(links, all_links[[id]]) %>% filter_links(domain = domain, parsed_links = parsed_links)

    parsed_links <- rbind(parsed_links, target_link)
    links <- rbind(links, parsed_links)

    exclude <- duplicated(links$href) | duplicated(links$href, fromLast = TRUE)

    links <- links[!exclude, ] %>% sort_links()
    links$href %>% grepl(pattern = "stellenangebote")
    # taleo careersection jobsearch
    head(links)

    links$href <- gsub(x = links$href, pattern = "www.www.", replacement = "www.", fixed = TRUE)
    head(links)

  }

  winner <- which(max(counts, na.rm = TRUE) == counts)[1]
  # targets <- parsed_links[max(counts, na.rm = TRUE) == counts]
  # targets[1] %>% browseURL()

  return(
    list(
      doc = as.character(all_docs[[winner]]),
      all_docs = all_docs,
      counts = counts,
      parsed_links = parsed_links,
      matches = matches,
      winner = winner
    )
  )
}

# cant replicate
url <- "https://www.volkswagen.de"

# falscher abbieger zu linkedin - erst bei ferienjbos
url <- "https://www.daimler.de"

# works, but wrong filter
url <- "https://www.rewe.de"


# selenium javascript strange order
url <- "https://www.wmf.de"

url <- "https://www.sitel.com"

# works
url <- "https://www.bofrost.de"

# ungenau
url <- "https://www.vodafone.de"

#no jobs present
url <- "https://www.lotto.de"

url <- "https://www.lotto-hessen.de"

# javascript
url <- "https://www.quantexa.com"
url <- "https://quantexa.com/careers/current-vacancies/"

url <- "https://www.revolut.com"

url <- "http://www.die-lohners.de"

# selenium
url <- "http://www.actioservice.de"

url <- "https://ayka-therapie.de/"

"Results 1 – 25 of"
"Ergebnisse 1 – 25 von"
"vacancies"
"current-vacancies"

