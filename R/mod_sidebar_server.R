# Server Module for sidebar
sidebarServer <- function(id) {
  moduleServer(id, function(input, output, session) {

    # Return reactive values for use in main app
    return(
      list(
        uploaded_file = reactive({ input$file_upload }),
        selected_districts = reactive({ input$conservation_districts })
      )
    )
  })
}
