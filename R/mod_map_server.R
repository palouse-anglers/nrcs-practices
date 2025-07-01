mod_map_server <- function(id, selected_districts,huc_data) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    # Static boundaries
    all_boundaries <- middlesnake::swcd_boundaries

    output$map <- renderLeaflet({
      leaflet() %>%
        addTiles(group = "OSM") %>%
        addProviderTiles(providers$CartoDB.Positron, group = "Light") %>%
        addProviderTiles(providers$CartoDB.DarkMatter, group = "Dark") %>%
        addProviderTiles(providers$Esri.WorldImagery, group = "Satellite") %>%

        addPolygons(
          data = all_boundaries,
          color = "black",
          weight = 0.6,
          label = ~CNSVDST,
          layerId = ~CNSVDST,
          group = "CD"
        ) %>%
        setView(lng = -120.84, lat = 47.275, zoom = 7) %>%
        addLayersControl(
          overlayGroups = c("CD", "Selected", "HUC12"),
          baseGroups = c( "Light","OSM", "Dark", "Satellite"),
          options = layersControlOptions(collapsed = TRUE)
        )
    })


    observe({
      req(selected_districts())

      # Subset to selected districts
      filtered <- all_boundaries[all_boundaries$swcd_name %in% selected_districts(), ]

      leafletProxy(ns("map")) %>%
        clearGroup("selected") %>%
        addPolygons(
          data = filtered,
          fillColor = "red",
          color = "black",
          weight = 1,
          label = ~CNSVDST,
          group = "Selected"
        )
    })

    # Update HUC layer when huc_data becomes available
    observe({
      req(huc_data())

      leafletProxy("map") %>%
        clearGroup("HUC12") %>%
        addPolygons(
          data = huc_data(),
          color = "blue",
          weight = 1,
          fillOpacity = 0.3,
          label = ~name,  # or any other name column you want to show
          group = "HUC12"
        )
    })


    })
}
