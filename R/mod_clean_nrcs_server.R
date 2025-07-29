mod_clean_nrcs_server <- function(id, file_uploader, huc_data) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    # Reactive values to store output and logs
    logs <- reactiveVal(NULL)
    clean_data <- reactiveVal(NULL)

    # Append a message to the logs and update the UI log output
    append_log <- function(msg) {
      current <- logs()
      new <- paste(current, msg, sep = "\n")
      logs(gsub("\033\\[[0-9;]*m", "", new))
      shinyjs::html(id = ns("log_output"), html = htmltools::htmlEscape(new))
    }

    # UI for the action button, rendered only if prerequisites exist
    output$show_clean_button <- renderUI({
      req(file_uploader(), huc_data())
      actionButton(ns("run_clean"), "Clean NRCS Data")
    })

    output$show_wria_button <- renderUI({
      req(file_uploader(), huc_data(),clean_data())
      actionButton(ns("run_wria"), "Assign WRIA")
    })



    # Run cleaning when button is clicked
    observeEvent(input$run_clean, {
      req(file_uploader(), huc_data())

      # Clear previous log
      logs("")
      shinyjs::html(id = ns("log_output"), html = "")

      withProgress(message = "Running cleaning function...", value = 0.2, {

        # Run cleaning function while capturing messages and warnings
        tryCatch({
          result <- withCallingHandlers(
            middlesnake::clean_nrcs_data(
              dataset_path = file_uploader()$datapath,
              huc_12_codes = huc_data()$huc12
            ),
            message = function(m) {
              append_log(m$message)
              invokeRestart("muffleMessage")
            },
            warning = function(w) {
              append_log(paste("⚠️", w$message))
              invokeRestart("muffleWarning")
            }
          )

          append_log("✅ Cleaning complete.")
          clean_data(result)

        }, error = function(e) {
          append_log(paste("❌ Error:", e$message))
        })

      }) # end withProgress
    }) # end observeEvent


    # try to assign WRIA to huc 12
    observeEvent(wria_reactive(), {
      req(wria_reactive(), huc_data(),clean_data())

      tryCatch({
        result2 <- middlesnake::assign_wria_to_huc12(
          huc12_sf = huc_data(),
          wria_sf = wria_reactive()
        ) %>%
        select(huc12,WRIA_NR,WRIA_NM)

        joined_data <- dplyr::left_join(
          clean_data(),
          sf::st_drop_geometry(result2),  # drop geometry if clean_data() is not spatial
          by = "huc12"
        )

        clean_data(joined_data)
        showNotification("✅ WRIA successfully assigned to HUC12 data.", type = "message", duration = 4)

      }, error = function(e) {
        showNotification("❌ Failed to assign WRIA to HUC12.", type = "error", duration = 5)
      })
    })




    # Optional backup: renderText version of logs for places where shinyjs fails

    output$console_output <- renderText({
      req(logs())
      logs()
    })




    # Run wria button is clicked
    wria_reactive <- reactiveVal(NULL)

    # try to download wria data
    observeEvent(input$run_wria, {
      req(file_uploader(), huc_data(), clean_data())

      tryCatch({
        wria <- middlesnake::get_geoserver_layer("washington-wria")
        wria_reactive(wria)
        showNotification("✅ WRIA layer successfully downloaded.", type = "message", duration = 3)
      }, error = function(e) {
        wria_reactive(NULL)
        showNotification("⚠️ Issue downloading WRIA", type = "error", duration = 5)
      })
    })






    # Return both cleaned data and logs for use in the main panel
    return(list(
      data = clean_data,
      logs = logs
    ))
  })
}
