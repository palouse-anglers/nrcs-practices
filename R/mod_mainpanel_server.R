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
    output$console_output <- renderPrint({
      req(sidebar_data$clean_output$logs())
      cat(sidebar_data$clean_output$logs(), sep = "\n")

    })

# cleaned data
    output$data_preview <- DT::renderDT({
      req(sidebar_data$clean_output$data())
      DT::datatable(
        sidebar_data$clean_output$data(),
        extensions = "Buttons",
        options = list(
          lengthMenu=list(c(25,50,100,-1),c("25","50","100","All")),
          pageLength = -1,
          dom = 'lBfrtip',
          buttons = c("copy","pdf", "print")
        ),
        class = "stripe hover"
      )
    })


    output$download_clean_data <- downloadHandler(
      filename = function() {
        paste0("cleaned_nrcs_data_", Sys.Date(), ".xlsx")
      },
      content = function(file) {
        df <- sidebar_data$clean_output$data()
        openxlsx::write.xlsx(df, file = file)
      }
    )


    })
}
