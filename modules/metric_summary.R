library(dygraphs)
source("./functions/getPercentChangeSpan.R")


metricSummaryOutput <- function(id) {
  ns <- NS(id)
  
  choices <- list("Loading..." = "") %>% c(getMetricsChoicesByCategory(id))

  tagList(
    selectInput(
      ns("summary_metric"), "Metric",
      choices,
      width = NULL,
      selectize = FALSE
    ),
    uiOutput(ns("summary"))
  )
}

metricSummary <-
  function(input,
           output,
           session,
           monthly_df,
           yearly_df,
           y,
           m,
           previous_time_range,
           screen_readers_label) {
    metric <- reactive({
      validate(need(input$summary_metric != "", "select metric"))
      metrics_list[[input$summary_metric]]
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
      
      invert_colors <- metrics_list[[metric()$id]]$invert_colors
      metric_change_span <-
        row[, paste0(metric()$id, ".perc_", prev_timerange_suffix)] %>% getPercentChangeSpan(invert_colors)
      
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