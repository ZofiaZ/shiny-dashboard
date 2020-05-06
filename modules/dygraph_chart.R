library(dygraphs)

dygraphChartOutput <- function(id) {
  ns <- NS(id)
  dygraphOutput(ns("dygraph"), height = '200px')
}

dygraphChart <-
  function(input,
           output,
           session,
           df,
           metric = "cost",
           y,
           m,
           previous_time_range) {
    dyBarChart <- function(dygraph) {
      dyPlotter(
        dygraph = dygraph,
        name = "BarChart",
        path = system.file("plotters/barchart.js", package = "dygraphs")
      )
    }
    
    output$dygraph <- renderDygraph({
        metric_change_key <- paste0("cost_change_", previous_time_range())
        
      if (m() == "0") {
        costs <-getMonthlyDataByYear(df, y(), metric=c(metric,"cost_change_prev_year"))
        label = "prev year diff"
      } else {
        costs <- getSubsetByTimeRange(df, y(), m(), metric=c(metric,"cost_change_prev_month", "cost_change_prev_year"))
        label = ifelse(previous_time_range()=="prev_year", "prev year diff", "prev month diff")
      }
        
      data <- xts(x = select(costs, "cost", metric_change_key), order.by = costs$date)
      
      dygraph(data) %>%
        dyBarChart() %>%
        dyAxis("y", label = "costs ($)", axisLabelWidth = 40) %>%
        dyAxis("x", drawGrid = FALSE) %>%
        dySeries("cost", label = "costs ($)", color = "rgba(41,190,216,1)") %>%
        dySeries(metric_change_key, label = label, color = "rgba(248,216,77,0.8)") %>%
        dyOptions(
          includeZero = TRUE,
          axisLineColor = "#585858",
          gridLineColor = "#bdc2c6",
          axisLabelFontSize = 12,
          axisLabelColor = "#585858",
          disableZoom = TRUE)
    })
  }