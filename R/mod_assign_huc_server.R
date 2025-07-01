mod_assign_huc_server <- function(id, selected_districts) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    # Reactive value to store huc data
    huc_data <- reactiveVal()

    # Show button only if at least one district is selected
    output$show_button <- renderUI({
      req(selected_districts())
      if (length(selected_districts()) > 0) {
        actionButton(ns("get_hucs"), "Get HUCs")
      }
    })

    observeEvent(input$get_hucs, {
      req(selected_districts())

      withProgress(
        message = "Retrieving HUC data...",
        detail = "Please wait while data is downloaded.",
        value = 0.3, {

          huc_df <- purrr::map_dfr(selected_districts(), ~{
            incProgress(1 / length(selected_districts()), detail = paste("Getting", .x, "watersheds"))
            middlesnake::get_huc_by_cd(district_name = .x)
          })

          # Save to reactiveVal
          huc_data(huc_df)

          # Summarize
          summary_tbl <- huc_df %>%
            dplyr::group_by(swcd_name) %>%
            dplyr::summarise(n_huc12 = dplyr::n_distinct(huc12), .groups = "drop")

          # summary message
          output$summary <- renderUI({
            req(summary_tbl)
            req(huc_data())

            html_list <- paste0(
              "<ul>",
              paste0(
                "<li><strong>", summary_tbl$swcd_name, ":</strong> ",
                summary_tbl$n_huc12, " watersheds</li>",
                collapse = "\n"
              ),
              "</ul>"
            )

            HTML(paste0("<div><h5>Watersheds Loaded</h5>", html_list, "</div>"))
          })
        }
      )
    })

    return(huc_data)
  })
}
