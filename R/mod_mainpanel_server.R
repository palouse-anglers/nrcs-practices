# Server Module for main panel
mainPanelServer <- function(id, sidebar_data,selected_districts) {
  moduleServer(id, function(input, output, session) {


    mod_map_server("map", selected_districts = selected_districts)

    # Table output
    output$data_table <- renderTable({
      # Create sample data based on uploaded file and selected districts
      if (!is.null(sidebar_data$uploaded_file())) {
        file_info <- data.frame(
          "File Name" = sidebar_data$uploaded_file()$name,
          "File Size" = paste(round(sidebar_data$uploaded_file()$size / 1024, 2), "KB"),
          "Upload Date" = Sys.Date()
        )
      } else {
        file_info <- data.frame(
          "Status" = "No file uploaded"
        )
      }

      if (!is.null(sidebar_data$selected_districts()) &&
          length(sidebar_data$selected_districts()) > 0) {
        districts_info <- data.frame(
          "Selected Districts" = sidebar_data$selected_districts(),
          "Status" = "Active"
        )

        # Combine file and district info if both exist
        if (nrow(file_info) > 1 || names(file_info)[1] != "Status") {
          return(list("File Information" = file_info,
                      "District Information" = districts_info))
        } else {
          return(districts_info)
        }
      } else {
        return(file_info)
      }
    })
  })
}
