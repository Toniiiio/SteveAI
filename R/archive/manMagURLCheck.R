library(httr)
load("data/manMag.RData")
head(data)
idx <- which(!data$doesURLExist)

exists <- c()
check <- function(nr){
  !http_error(data$URL[idx[nr]], config(followlocation = 1))
}
for(nr in 15:220){
  res <- tryCatch(expr = check(nr), error = function(e) "ERROR")
  print(c(nr,idx[nr], res, data$URL[idx[nr]]))
  exists[nr] <- res
}

exists[is.na(exists)] <- FALSE

data$doesURLExist[idx] <- exists == "TRUE"
save(list = "data",file = "data/manMag.RData")
