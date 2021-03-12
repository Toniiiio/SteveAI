library(shiny)
library(shinyjs)
library(shinydashboard)


# User interface for the locations input
TestUI <- function(id) {
  ns <- NS(id)

  fluidPage(

    useShinyjs(),

    # Action button to save the parameters ----
    actionButton(inputId = ns("save"),
                 label = "Save locations"),

    # Input: Text field and action button to add test street ----
    textInput(inputId = ns("location_name"),
              label = "Location name:"),
    actionButton(inputId = ns("add_location"),
                 label = "Add location"),
    div(id='add'),

    # User interface for already existing locations ----
    uiOutput(outputId = ns("locations")),

    # User interface for the locations that are added by the user ----
    uiOutput(outputId = ns("locations_added")),

    # textoutput
    textOutput(outputId = ns("counter"))
  )
}

# Server side for the locations input
TestServer <- function(id) {
  moduleServer(
    id,
    function(input, output, session) {

      # Create namespace functions
      ns <- session$ns

      # Set the filenames
      fn_locations <- "populations.csv"

      # What is the last time this file was saved and load the file
      input_matrix <- reactiveFileReader(5000, session, fn_locations, read.csv2)

      # Store the names of the locations
      location_names <- reactiveValues()

      # Add input fields for the already existing locations from the file
      output$locations <- renderUI({

        if(nrow(input_matrix()) > 0){

          input_list <- lapply(1:nrow(input_matrix()), function(i) {

            location_names[[paste0(i)]] <- input_matrix()[i,1]

            wellPanel(
              fluidRow(
                column(12, titlePanel(input_matrix()[i,1]))
              ),
              fluidRow(
                column(2,
                       numericInput(inputId = ns(paste0("population_", i)),
                                    label = "Population",
                                    min = 0,
                                    step = 1,
                                    value = input_matrix()[i,2])),
                column(1,
                       checkboxInput(inputId = ns(paste0("save_", i)),
                                     label = "Opslaan",
                                     value = TRUE))
              )
            )
          })
        } else{
          input_list <- list(wellPanel(tags$h4("No locations have been saved")))
        }

        do.call(tagList, input_list)
      })

      # List for the UI's with the added locations
      added_input_list <- list()

      # Add an UI for a new location ----
      observeEvent(input$add_location, {

        if(input$add_location > 0){

          input_list <- lapply(1:input$add_location, function(i) {

            if(i == input$add_location){
              location_names[[paste0(nrow(input_matrix()) + i)]] <- input$location_name
            }

            wellPanel(
              fluidRow(
                column(12, titlePanel(location_names[[paste0(nrow(input_matrix()) + i)]])
                ),
                fluidRow(
                  column(2,
                         numericInput(inputId = ns(paste0("population_",nrow(input_matrix()) + i)),
                                      label = "Population",
                                      min = 0,
                                      step = 1,
                                      value = ifelse(i == input$add_location, 0, input[[paste0("population_", nrow(input_matrix()) + i)]]))),
                  column(1,
                         checkboxInput(inputId = ns(paste0("save_", nrow(input_matrix()) + i)),
                                       label = "Opslaan",
                                       value = ifelse(i == input$add_location, TRUE, input[[paste0("save_", nrow(input_matrix()) +  i)]])))
                )
              )
            )
          })

          output$locations_added <- renderUI({
            do.call(tagList, input_list)
          })
        }
      })

      observeEvent(input$save, {
        # Which elements should be saved?
        savers <- sapply(paste0("save_", 1:(nrow(input_matrix()) + input$add_location)), function(x) input[[x]])

        to_write_matrix <- matrix(data = NA, nrow = sum(savers), ncol = 2)
        i <- 1
        j <- 1

        while(i <= sum(savers)){

          # Only save the rows for which the save option was TRUE
          if(input[[paste0("save_",j)]]){
            row_i <- c(location_names[[paste0(j)]],
                       input[[paste0("population_", j)]])

            to_write_matrix[i, ] <- row_i
            i <- i + 1
          }
          j <- j + 1
        }

        while(i <= length(reactiveValuesToList(location_names))){

          # Use shinyJS to remove these inputs starting from i
          runjs(paste0("Shiny.setInputValue('",ns(paste0("population_",i)),"',null)"))
          runjs(paste0("Shiny.setInputValue('",ns(paste0("save_",i)),"',null)"))
          i <- i + 1
        }

        # Write the locations to a file
        write.csv2(to_write_matrix, file = fn_locations, row.names=FALSE)

        # Remove the old added locations
        runjs(paste0("Shiny.setInputValue('",ns("add_location"),"',0)"))
        output$locations_added <- NULL

        # Show notification that the save was successfull
        showNotification("The locations have been saved")
      })

      output$counter <- renderText(input$add_location)
    }
  )
}

ui <- dashboardPage(

  dashboardHeader(title = "Dashboard"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Dashboard", tabName = "Dashboard", icon = icon("signal"))
    )
  ),
  dashboardBody(

    tabItems(
      tabItem(tabName = "Dashboard", TestUI(id = "locations"))
    )
  ),

  useShinyjs()
)

server <- function(input, output, session) {

  TestServer("locations")
}

shinyApp(ui, server)



# xx <- data.frame(
#   V1 = c("Amsterdam", "Brussels", "Berlin"),
#   V2 = c("800000", "700000", "1500000")
# )
#
# write.csv(xx, file = "www/populations.csv")
#
