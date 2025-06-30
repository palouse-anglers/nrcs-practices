mod_map_server <- function(id, selected_districts) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    # Static boundaries
    all_boundaries <- middlesnake::swcd_boundaries

    output$map <- renderLeaflet({
      leaflet() %>%
        addTiles() %>%
        addPolygons(
          data = all_boundaries,
          color = "black",
          weight = 0.6,
          label = ~CNSVDST,
          layerId = ~CNSVDST,
          group = "all"
        )
    })

    observe({
      req(selected_districts())

      # Subset to selected districts
      filtered <- all_boundaries[all_boundaries$CNSVDST %in% selected_districts(), ]

      leafletProxy(ns("map")) %>%
        clearGroup("selected") %>%
        addPolygons(
          data = filtered,
          fillColor = "red",
          color = "black",
          weight = 1,
          label = ~CNSVDST,
          group = "selected"
        )
    })
  })
}
