mod_assign_huc_ui <- function(id) {
  ns <- NS(id)
  tagList(
    uiOutput(ns("show_button")),     # conditional button
    uiOutput(ns("summary")) # display message
  )
}
