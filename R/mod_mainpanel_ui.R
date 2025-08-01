# UI Module for main panel
mainPanelUI <- function(id) {
  ns <- NS(id)

  navset_card_tab(
    nav_panel(
      title = "Map",
      card(
        card_header("Conservation Districts Map"),
        card_body(
          mod_map_ui(ns("map"))
        )
      )
    ),
    nav_panel(
      title = "Watersheds",
      card(
        card_header("Data Tables"),
        card_body(
          DT::dataTableOutput(ns("data_table"))
        )
      )
    ),
    nav_panel(
      title = "NRCS Data",
      card(
        card_header("Console Logs"),
        card_body(
          bslib::accordion(
            id = ns("nrcs_data_accordion"),
            bslib::accordion_panel(
          "View Cleaning Logs",
          verbatimTextOutput(ns("console_output")),
          value = "logs_panel"
            )
          )
         )
      ),
      card(full_screen = TRUE,

        card_header("Cleaned NRCS Data Preview"),
        card_body(
          downloadButton(ns("download_clean_data"), "Download Cleaned NRCS Data"),
          DT::dataTableOutput(ns("data_preview"))
        )
      )
    )
  )
}
