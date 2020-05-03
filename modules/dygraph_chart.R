library(dygraphs)

dygraphChartOutput <- function(id) {
  ns <- NS(id)
  dygraphOutput (ns("dygraph"), height = '200px')
}

dygraphChart <-
  function(input,
           output,
           session,
           df,
           metric = "cost",
           y = 2020,
           m = 1) {
    days_in_month_count <- paste(y, m, '01', 'sep' = '-') %>%
      as.Date() %>%
      days_in_month()
    
    costs <- getSubsetByDate(df, y, m, metric)
    data <- xts(x = costs$cost, order.by = costs$date)
    
    dyBarChart <- function(dygraph) {
      dyPlotter(
        dygraph = dygraph,
        name = "BarChart",
        path = system.file("plotters/barchart.js", package = "dygraphs")
      )
    }
    
    output$dygraph <- renderDygraph({
      dygraph(data) %>%
        dyBarChart() %>%
        dyAxis("y", label = "costs ($)") %>%
        dySeries("V1", label = "costs ($)", color = "#29bed8") %>%
        dyOptions(
          stackedGraph = TRUE,
          axisLineColor = "#585858",
          gridLineColor = "#bdc2c6"
        )
    })
  }