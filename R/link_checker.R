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

# javascript
url <- "https://www.aok.de"

# #link within --> Selenium
url <- "https://www.gamestop.de/"

url <- "https://www.fida.de/"

#works now
url <- "https://www.lunchnow.com"

#works
url <- "https://www.implico.com"

url <- "https://www.sportplatz-media.com"

# selenium javascript
url <- "https://www.aboutyou.de/"

#works
url <- "https://www.wisag.de"

# very strange links
url <- "https://www.mytoys.de/"

url <- "https://www.wwf.de/"


# txt <- target_url %>%
#   read_html %>% html_text %>%
#   tolower %>%
#   gsub(pattern = "\n|\t", replacement = " ")
# #txt %>% mypkg2:::show_html_page()
# has_match <- txt %>% aregexec(pattern = tolower(target), max.distance = 0.1) %>%
#   unlist %>% "!="(-1) %>% sum
# has_match


# grab all links from that url

find_job_page <- function(url){

  domain <- urltools::domain(url) %>%
    gsub(pattern = "www.", replacement = "")
  parsed_links <- data.frame(href = character(), text = character())
  links_per_level <- list()
  docs_per_level <- list()
  doc <- url %>% read_html
  links <- doc %>%
    html_nodes(xpath = "//a") %>%
    {data.frame(href = html_attr(x = ., name = "href"), text = html_text(.))}
  links %>% grepl(pattern = "jobs") %>% sum
  head(links)
  iter_nr <- 1
  links_per_level[1] <- url

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
    print(link)
    all_docs[[link]] <- tryCatch(
      expr = link %>% xml2::read_html(),
      error = function(e) ""
    )

    has_doc <- nchar(all_docs[[link]] %>% toString)
    if(has_doc){

      all_links[[link]] <- all_docs[[link]] %>%
        html_nodes(xpath = "//a") %>%
        {data.frame(href = html_attr(x = ., name = "href"), text = html_text(.))}
      # %>%{ifelse(test = substring(text = ., first = 1, last = 1) == "/", yes = paste0("https://www.", urltools::domain(link), .), no = .)}

      html_texts[[link]] <- htm2txt::htm2txt(as.character(all_docs[[link]]))

    }else{

      all_links[[link]] <- data.frame(href = character(), text = character())
      warning("No content")

    }

    #all_docs[[link]] %>% SteveAI::showHtmlPage()
    # html_texts[[link]] %>% cat
    # doc <- "https://www.bofrost.de/karriere/job/" %>% read_html

    doc <- all_docs[[link]]

    if(!exists("job_titles")) job_titles <- ""

    matches[[iter_nr]] <- target_indicator_count(job_titles = job_titles, doc = doc)

    counts[iter_nr] <- unlist(matches[[iter_nr]]) %>% as.numeric() %>% sum

    links <- rbind(links, all_links[[link]]) %>% filter_links(domain = domain, parsed_links = parsed_links)
    head(links)
    parsed_links <- rbind(parsed_links, target_link)

    exclude <- duplicated(links$href) | duplicated(links$href, fromLast = TRUE)
    links <- links[!exclude, ]

    links$href <- gsub(x = links$href, pattern = "www.www.", replacement = "www.", fixed = TRUE)
    head(links)

  }

  winner <- which(max(counts, na.rm = TRUE) == counts)[1]
  # targets <- parsed_links[max(counts, na.rm = TRUE) == counts]
  # targets[1] %>% browseURL()

  return(
    list(
      doc = doc,
      counts = counts,
      parsed_links = parsed_links,
      matches = matches,
      winner = winner
    )
  )
}

# selenium javascript strange order
url <- "https://www.wmf.de"

url <- "https://www.sitel.com"

# works
url <- "https://www.bofrost.de"

# ungenau
url <- "https://www.vodafone.de"

#no jobs
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

