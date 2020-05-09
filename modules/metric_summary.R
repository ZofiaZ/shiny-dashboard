library(dygraphs)
source("./functions/getPercentChangeSpan.R")

metricSummaryOutput <- function(id) {
  ns <- NS(id)
  tagList(
    uiOutput(ns("select")),
    uiOutput(ns("summary"))
  )
}

metricSummary <-
  function(input,
           output,
           session,
           choices,
           monthly_df,
           yearly_df,
           y,
           m,
           previous_time_range,
           screen_readers_label) {
    metric <- reactive({
      validate(need(input$metric != "", "select metric"))
      metrics_list[[input$metric]]
    })

    output$select <- renderUI({
      ns <- session$ns
      selectInput(
        ns("metric"),
        screen_readers_label,
        getMetricsChoices(choices, metrics_list),
        width = NULL,
        selectize = FALSE
      )
    })

    output$summary <- renderUI({
      if (m() == 0) {
        df <- yearly_df
        prev_timerange_suffix <- "prev_year"
      } else {
        df <- monthly_df
        prev_timerange_suffix <- previous_time_range()
      }

      selected_date <-
        paste(y(), ifelse(m() == "0", "1", m()), "01", "sep" = "-") %>% as.Date()
      row <- df[df$date == selected_date, ]

      metric_total_value <- row[, metric()$id]
      metric_change_span <-
        row[, paste0(metric()$id, ".perc_", prev_timerange_suffix)] %>% getPercentChangeSpan()
      valuePrefix <-
        ifelse(!is.null(metric()$currency),
          paste0(metric()$currency, " "),
          ""
        )

      glue(
        '<span class="metric">{valuePrefix}{metric_total_value}</span>
        {metric_change_span}'
      ) %>% HTML()
    })
  }