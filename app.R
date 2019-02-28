library(shiny)
library(migviz)

#jsCode <- "shinyjs.pageCol = function(params){$rendervalue;}"

# Define UI for application that draws a histogram
ui <- shinyUI(
  fluidPage(
    titlePanel("Chord Diagram"),
    sidebarLayout(
      sidebarPanel(
        sliderInput(inputId = "years", label = "Period Begins:",
                    min = 1990, max = 2010, step = 5, value = 1990, sep = "")
      ),
      mainPanel(
        chord_expandOutput('cd', height = '600px')
      )
    )
  )
)

server <- function(input, output) {
  output$cd <- renderCd_expand(
    chord_expand(j0, year = input$years)
  )
}

shinyApp(ui = ui, server = server)
