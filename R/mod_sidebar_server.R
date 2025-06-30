# Server Module for sidebar
sidebarServer <- function(id) {
  moduleServer(id, function(input, output, session) {

    selected_districts <- reactive({
      input$conservation_districts
      })

    huc_data <- mod_assign_huc_server("assign_huc",
                                      selected_districts = selected_districts)
    # Return reactive values for use in main app
    return(
      list(
        uploaded_file = reactive({ input$file_upload }),
        selected_districts = selected_districts,
        huc_data = huc_data
      )
    )
  })
}
