library(shiny)
library(bslib)
library(shinyWidgets)
library(middlesnake)


purrr::walk(list.files("R", full.names = TRUE, pattern = "\\.R$"), source)


district_names <- middlesnake::swcd_boundaries %>%
  pull(CNSVDST) %>%
  unique()

# Main UI
ui <- page_sidebar(
  title = "NRCS Practices Calculator",
  theme = bs_theme(version = 5, bootswatch = "flatly"),

  sidebar = sidebar(
    title = "Controls",
    mod_sidebar_ui("sidebar_module",districts = district_names)
  ),

  mainPanelUI("main_module")
)

# Main Server
server <- function(input, output, session) {

  # Call sidebar module server
  sidebar_data <- sidebarServer("sidebar_module")

  uploaded_file <- sidebar_data$uploaded_file
  selected_districts <- sidebar_data$selected_districts

  # Call main panel module server with sidebar data
  mainPanelServer("main_module", sidebar_data,selected_districts)
}

# Run the app
shinyApp(ui = ui, server = server)
