
# UI Module for main panel
mainPanelUI <- function(id) {
  ns <- NS(id)

  navset_card_tab(
    nav_panel(
      title = "Map",
      card(
        card_header("Conservation Districts Map"),
        card_body(
          # Placeholder for map content
          mod_map_ui(ns("map"))
        )
      )
    ),
    nav_panel(
      title = "Tables",
      card(
        card_header("Data Tables"),
        card_body(
          # Placeholder for table content
          tableOutput(ns("data_table"))
        )
      )
    )
  )
}
