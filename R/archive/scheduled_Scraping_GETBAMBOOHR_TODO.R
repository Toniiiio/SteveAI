load("scraperBAMBOOHR.RData")
compnName <- "web3"
output <- list()
for(compName in compNames){
  getURL <- sprintf("https://%s.bamboohr.com/jobs/", compnName)
  output[[compName]] <- getURL %>% GET %>% content
}

output[[compName]] %>% html_nodes(xpath = "//*[contains(text(), 'Manager')]")
lapply(output, object.size)


source("../sivis/rvestFunctions.R")
xx <- output[[compName]] %>% html_nodes(xpath = "//body")
getXPathByTag(tag = xx, text = "Analyst")
