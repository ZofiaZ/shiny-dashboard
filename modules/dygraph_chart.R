library(dygraphs)
library(xts)

dygraphChartOutput <- function(id) {
  ns <- NS(id)
  dygraphOutput(ns("dygraph"), height = '200px')
}

dygraphChart <-
  function(input,
           output,
           session,
           df,
           metric,
           metric_name,
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
        metric_change_key <- paste0(metric, ".change_", previous_time_range())
        
      if (m() == "0") {
        subset <- getMonthlyDataByYear(df, y(), metric=c(metric, metric_change_key))
        diff_label = "prev year diff"
      } else {
        subset <- getSubsetByTimeRange(df, y(), m(), metric=c(metric, metric_change_key))
        diff_label = ifelse(previous_time_range()=="prev_year", "prev year diff", "prev month diff")
      }
        
      data <- xts(x = select(subset, c(metric, metric_change_key)), order.by = subset$date)
      
      dygraph(data) %>%
        dyBarChart() %>%
        dyAxis("y", label = metric_name, axisLabelWidth = 40) %>%
        dyAxis("x", drawGrid = FALSE) %>%
        dySeries(metric, label = metric_name, color = "rgba(41,190,216,1)") %>%
        dySeries(metric_change_key, label = diff_label, color = "rgba(248,216,77,0.8)") %>%
        dyOptions(
          includeZero = TRUE,
          axisLineColor = "#585858",
          gridLineColor = "#bdc2c6",
          axisLabelFontSize = 12,
          axisLabelColor = "#585858",
          disableZoom = TRUE)
    })
  }