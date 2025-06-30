mod_map_ui <- function(id) {
  ns <- NS(id)
  leafletOutput(ns("map"), height = 800)
}
