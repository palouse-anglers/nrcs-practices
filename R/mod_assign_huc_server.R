mod_assign_huc_server <- function(id, selected_districts) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    # Show button only if at least one district is selected
    output$show_button <- renderUI({
      req(selected_districts())
      if (length(selected_districts()) > 0) {
        actionButton(ns("get_hucs"), "Get HUCs")
      }
    })

    observeEvent(input$get_hucs, {
      req(selected_districts())


      cleaned_names <- sub(" CD$", "", selected_districts())
      cleaned_names <- sub(" County$", "", cleaned_names)

      print(cleaned_names)

      # Use purrr to run function for each selected district
      huc_df <- middlesnake::get_huc_by_cd(
        district_name = cleaned_names)


      # Summarize: number of unique HUC12s per district
      summary_tbl <- huc_df %>%
        dplyr::group_by(swcd_name) %>%
        dplyr::summarise(n_huc12 = dplyr::n_distinct(huc12), .groups = "drop")

      # Print message
      output$summary <- renderPrint({
        cat("Unique HUC12s per district:\n")
        print(summary_tbl)
      })

      # Optionally return data
      # return(reactive(huc_df))
    })
  })
}
