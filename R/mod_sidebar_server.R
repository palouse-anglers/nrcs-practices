# Server Module for sidebar
sidebarServer <- function(id) {
  moduleServer(id, function(input, output, session) {

    selected_districts <- reactive({
      input$conservation_districts
      })

    uploaded_file <-  reactive({
      input$file_upload
      })
    huc_data <- mod_assign_huc_server("assign_huc",
           selected_districts = selected_districts)


    clean_output <- mod_clean_nrcs_server(
      id = "clean_nrcs",
      file_uploader = uploaded_file,
      huc_data = huc_data
    )

    # Return reactive values for use in main app
    return(
      list(
        uploaded_file = uploaded_file,
        selected_districts = selected_districts,
        huc_data = huc_data,
        clean_output = clean_output
      )
    )
  })
}
