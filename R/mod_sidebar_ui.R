mod_sidebar_ui <- function(id,districts) {
  ns <- NS(id)

  list(
    # File uploader for Excel files
    fileInput(
      inputId = ns("file_upload"),
      label = "Upload NRCS Excel File",
      accept = c(".xlsx", ".xls"),
      buttonLabel = "Browse...",
      placeholder = "No file selected"
    ),

    # Picker input for conservation districts
    pickerInput(
      inputId = ns("conservation_districts"),
      label = "Select Conservation District(s)",
      choices = districts,
      selected = NULL,
      multiple = FALSE,
      options = pickerOptions(
        actionsBox = FALSE,
        selectAllText = "Select All",
        deselectAllText = "Deselect All",
        noneSelectedText = "No districts selected"
      )
    ),
    mod_assign_huc_ui(ns("assign_huc")),
    mod_clean_nrcs_ui(ns("clean_nrcs"))
  )
}
