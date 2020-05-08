library(dygraphs)

metricSummaryOutput <- function(id) {
  ns <- NS(id)
  uiOutput(ns("metricSummary"))
}

metricSummary <-
  function(input,
           output,
           session,
           metric,
           monthly_df,
           yearly_df,
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
    
    metric_total_value <- reactive({ row()[,metric$id] })
    metric_change <- reactive({ row()[,paste0(metric$id, '.perc_', prev_timerange_suffix())]  %>% getPercentChangeSpan()})
    valuePrefix <- ifelse(!is.null(metric$currency), paste0(metric$currency, " "), "")
      
    output$metricSummary <- renderUI({
      glue(
        '<span class="metric">{valuePrefix}{metric_total_value()}</span>
        <div class="metric-bottom-row">
          <span class="metric-label">{metric$title}</span>
          {metric_change()}
        </div>'
      ) %>% HTML()
    })
    }