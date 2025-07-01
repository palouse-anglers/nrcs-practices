# Server Module for main panel
mainPanelServer <- function(id, sidebar_data,selected_districts,huc_data) {
  moduleServer(id, function(input, output, session) {


    mod_map_server("map", selected_districts = selected_districts,huc_data)

    # Table output
    output$data_table <- DT::renderDT({
    req(huc_data())
    huc_data()
    })



# logs
    output$console_output <- renderText({
      req(sidebar_data$clean_output$logs())
      sidebar_data$clean_output$logs()
    })

# cleaned data
    output$data_preview <- DT::renderDT({
      req(sidebar_data$clean_output$data())
      DT::datatable(
        sidebar_data$clean_output$data(),
        extensions = "Buttons",
        options = list(
          pageLength = 50,
          dom = 'Bfrtip',
          buttons = c("copy", "csv", "excel", "pdf", "print")
        ),
        class = "stripe hover"
      )
    })



    })
}
