library(dygraphs)

metricSummaryOutput <- function(id) {
  ns <- NS(id)
  uiOutput(ns("metricSummary"))
}

metricSummaryServer <-
  function(input,
           output,
           session,
           yearly_df,
           monthly_df,
           metric,
           title,
           y,
           m,
           previous_time_range) {
    df <- reactive({
      if(m() == 0) {
        yearly_df
      } else {
        monthly_df
      }
    })
    
    selected_date <- reactive({paste(y(), ifelse(m()=="0", "1", m()), '01', 'sep' = '-') %>% as.Date() })
    row <- reactive({ df()[df()$date == selected_date(),] })
    prev_timerange_suffix <- reactive({
      if(m() == 0) {
        "prev_year"
      } else {
        previous_time_range()
      }
    })
    
    metric_total_value <- reactive({ row()[,metric] })
    metric_change <- reactive({ row()[,paste0(metric, '.perc_', prev_timerange_suffix())]  %>% getPercentChangeSpan()})

    output$metricSummary <- renderUI({
      glue(
        '<span class="metric">$ {metric_total_value()}</span>
        <div class="metric-bottom-row">
          <span class="metric-label">{title}</span>
          {metric_change()}
        </div>'
      ) %>% HTML()
    })
    }