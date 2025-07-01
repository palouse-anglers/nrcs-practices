mod_clean_nrcs_ui <- function(id) {
  ns <- NS(id)
  tagList(
    uiOutput(ns("show_clean_button")),
    verbatimTextOutput(ns("console_output"))
  )
}
