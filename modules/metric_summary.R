library(dygraphs)

metricSummaryOutput <- function(id) {
  ns <- NS(id)
  uiOutput(ns("metricSummary"))
}

metricSummaryServer <-
  function(input,
           output,
           session,
           df,
           metric,
           title,
           y,
           m,
           previous_time_range) {
    metricTotalValue <-
      reactive({
        getMetricByTimeRange(
          df = df,
          y = y(),
          m = m(),
          metric = metric,
          f = sum
        )
      })
    
    metricTotalValuePrev <- reactive({
      year <- as.numeric(y())
      month <- as.numeric(m())
      
      if (previous_time_range() == "previous_year" || m() == "0") {
        year <- year - 1
      } else if (month == 1) {
        year <- year - 1
        month <- 12
      } else {
        month <- month - 1
      }
      
      should_apply_limit <- y() == year(data_last_day) && (m() == month(data_last_day) || m() == "0")
      if (should_apply_limit) {
        last_day <- data_last_day
      } else {
        last_day <- NULL
      }

      getMetricByTimeRange(
        df = df,
        y = year,
        m = month,
        metric = metric,
        f = sum,
        data_last_day = last_day
      )
  })
    
    metricChange <- reactive({
      getPercentChangeSpan(metricTotalValue(), metricTotalValuePrev())
    })
    
    output$metricSummary <- renderUI({
      glue(
        '<span class="metric">$ {metricTotalValue()}</span>
        <div class="metric-bottom-row">
          <span class="metric-label">{title}</span>
          {metricChange()}
        </div>'
      ) %>% HTML()
    })
    }