library(shiny)
library(httr)
library(rhandsontable)
load("data/manMag.RData")
data <- read.csv2("data/rr.csv", stringsAsFactors = FALSE, sep = ",")[, -1]

ui <- fluidPage(
  actionButton("saveBtn", "saveBtn"),
  fluidRow(column(7, rHandsontableOutput("contents", width = 800, height = 800)))
)

server <- function(input,output){
  output$contents <- renderRHandsontable({
    hot_cols(rhandsontable(data, width = 800, height = 800), colWidths = 200, strict = FALSE)
  })
  
  saveData <- function(){
    finalDF <- hot_to_r(input$contents)
    dataNew <<- finalDF
    write.csv(finalDF, file = "C:/StVAI/rr.csv")
  }
  
  observeEvent(input$saveBtn, saveData())
}

runApp(list(ui = ui,server = server))


# remove
# 36, 37
# 46, 800
# 818
# 819
# 1002