library(DiagrammeR)
?DiagrammeR







library(DiagrammeR)

ui = shinyUI(fluidPage(
  titlePanel("DiagrammeR + shiny"),
  
  sidebarLayout(
    sidebarPanel(
      helpText("Example showing DiagrammeR output in a shiny app."),
      
      selectInput("orientation",
                  label = "Select diagram orientation",
                  choices = c("BT", "TB", "LR", "RL"),
                  selected = "TB")
    ),
    
    mainPanel(DiagrammeROutput("diagram"))
  )
))

server = shinyServer(
  function(input, output) {
    output$diagram <- renderDiagrammeR({
      d <- paste(
        paste0("graph ", input$orientation),
        "a[MyAppMyAppMyAppMyAppMyApp] --> DB(fa:fa-database MySQL)",
        "style DB fill:#00758f",
        "style a fill:#00758f",
        sep = "\n")
      mermaid(d)
    })
  }
)

shinyApp(ui, server)
