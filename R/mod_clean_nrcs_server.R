mod_clean_nrcs_server <- function(id, file_uploader, huc_data) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    # UI for the action button
    output$show_clean_button <- renderUI({
      req(file_uploader(), huc_data())
      actionButton(ns("run_clean"), "Clean NRCS Data")
    })

    # Reactive values to store output and logs
    logs <- reactiveVal(NULL)
    clean_data <- reactiveVal(NULL)

    observeEvent(input$run_clean, {
      req(file_uploader(), huc_data())

      log_text <- NULL
      result <- NULL

      withProgress(message = "Running cleaning function...", value = 0.2, {
        # Capture output and messages
        log_text <- capture.output({
          result <- withCallingHandlers(
            middlesnake::clean_nrcs_data(
              dataset_path = file_uploader()$datapath,
              huc_12_codes = huc_data()$huc12
            ),
            message = function(m) {
              message(m$message)  # Allow messages to print
              invokeRestart("muffleMessage")
            }
          )
        })
      })

      # Store results and logs
      clean_data(result)
      logs(paste(log_text, collapse = "\n"))
    })

    # Output the logs to UI
    output$console_output <- renderText({
      req(logs())
      logs()
    })

    # Return both cleaned data and log
    return(list(
      data = clean_data,
      logs = logs
    ))
  })
}
