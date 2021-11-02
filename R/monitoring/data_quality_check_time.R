db_name <- "rvest_scraper.db"
db_exists <- file.exists(db_name)
target_table_time <- "RVEST_SINGLE_TIME"
conn <- DBI::dbConnect(RSQLite::SQLite(), db_name)

fetch_time <- DBI::dbGetQuery(
  conn = conn,
  statement = paste0("SELECT * FROM ", target_table_time)
)
fetch_time %>% head
today_num <- Sys.Date() %>% as.numeric() %>% as.character()
yest_num <- as.character(as.numeric(Sys.Date()) - 1)
today_num
yest_num

wrong_id <- any(fetch_time$id %in% c("", 0, 1))
wrong_id

head(fetch_time)
sum(fetch_time[[today_num]] == fetch_time[[yest_num]]) / length(fetch_time[[yest_num]])

library(dplyr)
fetch_time$comp <- fetch_time$id %>%
  sapply(strsplit, "__") %>%
  sapply("[", 2) %>%
  unname

fetch_time %>% group_by(comp) %>% dplyr::count(`18925` > 0)
xx <- fetch_time %>%
  group_by(comp) %>%
  mutate(count1 = sum(`18925` > 0)) %>%
  mutate(count2 = sum(`18926` > 0))

xx %>% select(comp, count1, count2) %>% unique

rr <- fetch_time %>%
  group_by(comp) %>%
  filter(`18927` != `18926`)
rr


false_pos <- fetch_time$id %>%
  {.[grepl(., pattern = "HUK-AUSSEN")]} %>%
  sapply(strsplit, "__") %>%
  sapply("[", 1) %>%
  unname

false_pos %>% dput

c("Arbeiten & Leben", "Compliance", "Datenschutz", "Einstieg & Entwicklung",
  "Engagement", "Hilfe und Kontakt", "Historie", "Ihr Weg zu heine",
  "Impressum", "Jobs & Bewerbung", "Karriere", "Kataloge", "Nachhaltige Produkte",
  "Nachhaltigkeit", "Presse", "Presseanfragen", "Pressenews", "Sozialverantwortung",
  "Über uns", "Umwelt", "Unternehmen")

c("Altersvorsorge", "Ambulante Zusatz­versicherung", "Amtshaftpflicht & Vermögensschadenhaftpflicht",
  "Amts­haftpflicht & Vermögensschaden­haftpflicht", "Anhänger- & Wohnwagen-Versicherung",
  "Anhänger-Versicherung", "Anhänger & Wohnmobil", "Apps", "Auslandskranken­versicherung",
  "Autoankauf & Verkauf", "Autokredit", "Autos", "Autoservice",
  "Auto­versicherung", "BARMER Zusatz­versicherung", "Bauen", "Baufinanzierung",
  "Bau­finanzierung", "Bauherrenhaftpflicht", "Bauherren­haftpflicht",
  "Bauleistungsversicherung", "Bauleistungs­versicherung", "Bausparen",
  "Bau­sparen", "Berufs­unfähigkeits­versicherung", "Datenschutz",
  "Dienst­unfähigkeits­versicherung", "Direkt­versicherung", "E-Bike-Versicherung",
  "E-Scooter- & Segway-Versicherung", "E-Scooter-Versicherung",
  "Elektroautos", "Elementarschadenversicherung", "Elementar­schaden­versicherung",
  "Existenzschutz­versicherung", "Existenzsicherung", "Fahrerschutz­versicherung",
  "Finanzen", "Generation60 Plus", "Gesundheitsschutz kompakt",
  "Haftpflicht", "Haftpflichtversicherung", "Haus- & Grundbesitzerhaftpflicht",
  "Haus- & Grundbesitzer­haftpflicht", "Haus & Wohnung", "Haus & Wohnung",
  "Hausratversicherung", "Hausrat­versicherung", "HUK-COBURG @facebook",
  "HUK-COBURG @instagram", "HUK-COBURG @linkedin", "HUK-COBURG @pinterest",
  "HUK-COBURG @twitter", "HUK-COBURG @xing", "HUK-COBURG @youtube",
  "Hunde­haftpflicht", "Ihr Ratgeber rund um die Themen Auto & Mobilität",
  "Ihr Ratgeber rund um die Themen Gesundheit, Vorsorge und Vermögen",
  "Ihr Ratgeber rund um die Themen Haus, Haftung & Recht", "Impressum",
  "Jagdhaftpflichtversicherung", "Jagd­haftpflicht­versicherung",
  "Kfz-Schutzbrief", "Kfz-Versicherung", "Kontakt-Center", "Krankenhaustagegeld",
  "Krankenhauszusatz­versicherung", "Krankentagegeld­versicherung",
  "Kranken­voll­versicherung", "Kranken­zusatz­versicherung", "Kunden werben Kunden",
  "Leicht­kraftrad-Versicherung", "Lieferwagen-Versicherung", "Magazin",
  "Meine HUK", "Mobilität", "Moped­versicherung", "Motorrad- & Leicht­kraftrad-Versicherung",
  "Motorrad­versicherung", "Öffentlicher Dienst", "Oldtimer & Youngtimer",
  "Pferde­haftpflicht", "Pflege-Assistance-Leistungen", "Pflege-Monatsgeld­versicherung",
  "Pflegemonatsgeld-Versicherung", "Pflege­versicherung", "Postbank Girokonto",
  "Postbank Kreditkarte", "Premium Rente", "Privat-, Berufs- & Verkehrsrechtsschutz",
  "Privat-, Berufs- & Verkehrsrechtsschutz", "Private Haftpflichtversicherung",
  "Private Haft­pflicht­versicherung", "Private Kranken­versicherung für Beamte",
  "Private Kranken­versicherung", "Produkte für Unternehmen", "Quad-Versicherung",
  "Ratgeber Auto & Mobilität", "Ratgeber Gesundheit, Vorsorge & Vermögen",
  "Ratgeber Haus, Haftung & Recht", "Rechts­schutz­versicherung",
  "Rechtsschutzversicherung", "Riester Rente", "Risiko­lebens­versicherung",
  "Rürup Rente", "Schadenservice", "Sitemap", "Sofortrente", "Staatlich geförderte Pflegezusatz­versicherung",
  "Startseite", "Sterbegeld­versicherung", "Telematik Plus", "Tierhalterhaftpflicht",
  "Tierhalter­haftpflicht", "Tierkranken­versicherung", "Tier­versicherung",
  "Übersicht Altersvorsorge", "Übersicht Anhänger & Wohnmobil",
  "Übersicht Autos", "Übersicht Bauen", "Übersicht Existenzsicherung",
  "Übersicht Finanzen", "Übersicht Haftpflicht", "Übersicht Haftpflichtversicherung",
  "Übersicht Haus & Wohnung", "Übersicht Haus & Wohnung", "Übersicht Kfz-Versicherung",
  "Übersicht Kranken­zusatz­versicherung", "Übersicht Mobilität",
  "Übersicht Pflege­versicherung", "Übersicht Private Kranken­versicherung",
  "Übersicht Rechts­schutz­versicherung", "Übersicht Rechtsschutzversicherung",
  "Übersicht Tier­versicherung", "Übersicht Zusatzschutz", "Übersicht Zweiräder & Quads",
  "Unfallmeldedienst (UMD)", "Unfall­versicherung", "Verkehrsrechtsschutz",
  "Wassersportversicherung", "Wassersport­versicherung", "Wohn-Riester Bausparen",
  "Wohn-Riester", "Wohngebäudeversicherung", "Wohn­gebäude­versicherung",
  "Wohnmobil-Versicherung", "Wohnwagen-Versicherung", "Zahnzusatz­versicherung",
  "Zusatzschutz", "Zweiräder & Quads")

sum(fetch_time$`18924` == fetch_time$`18925`)/length(fetch_time$`18924`)
#
# xx <- rownames(fetch_time) %>% {grepl(pattern = "http", .)}
# which(xx)
#
# fdd <- gsub(
#   pattern = "__.*__",
#   replacement = "__",
#   x = rownames(fetch_time)[which(xx)],
#   perl = TRUE
# )
#
# fdd %in% rownames(fetch_time)
# row_idx <- sapply(fdd, function(fd) which(fd == rownames(fetch_time)), USE.NAMES = FALSE)
# col_idx <- which(colnames(fetch_time) == "18638")
# fetch_time[row_idx, col_idx] <- 1
# fetch_time[which(xx), ] <- 0
#
#
# DBI::dbWriteTable(
#   conn = conn,
#   name = target_table_time,
#   value = fetch_time,
#   overwrite = TRUE
# )
#
#
#
#
#
#
#
#
#
db_name <- "rvest_scraper.db"
db_exists <- file.exists(db_name)
target_table_jobs <- "RVEST_SINGLE_JOBS"
conn <- DBI::dbConnect(RSQLite::SQLite(), db_name)
#
fetch_job <- DBI::dbGetQuery(
  conn = conn,
  statement = paste0("SELECT * FROM ", target_table_jobs)
)
fetch_job %>% head

id_name_diffs <- which(!apply(fetch_job, 1, function(row) grepl(pattern = row[2], x = row[1], fixed = TRUE)))
fetch_job[id_name_diffs, ][1, ]


DBI::dbDisconnect(conn)
#
#
# rr <- fetch_job$job_id %>% {grepl(pattern = "http", .)}
# rrr <- fetch_job[-which(rr), ]
#
# DBI::dbWriteTable(
#   conn = conn,
#   name = target_table_jobs,
#   value = rrr,
#   overwrite = TRUE
# )
#
#
#
#
#
#
#
#
