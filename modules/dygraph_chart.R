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
    # days_in_month_count <-
    #   reactive({
    #     paste(y(), m(), '01', 'sep' = '-') %>%
    #       as.Date() %>%
    #       days_in_month()
    #   })
    
    dyBarChart <- function(dygraph) {
      dyPlotter(
        dygraph = dygraph,
        name = "BarChart",
        path = system.file("plotters/barchart.js", package = "dygraphs")
      )
    }
    
    output$dygraph <- renderDygraph({
      if (m() == "0") {
        costs <- reactive({
          getMonthlyDataByYear(df, y(), metric)
        })
      } else {
        costs <- reactive({
          getSubsetByTimeRange(df, y(), m(), metric)
        })
      }
      
      data <-
        reactive({
          xts(x = costs()[[metric]], order.by = costs()$date)
        })
      
      dygraph(data()) %>%
        dyBarChart() %>%
        dyAxis("y", label = "costs ($)", axisLabelWidth = 40) %>%
        dyAxis("x", drawGrid = FALSE) %>%
        dySeries("V1", label = "costs ($)", color = "#29bed8") %>%
        dyOptions(
          includeZero = TRUE,
          axisLineColor = "#585858",
          gridLineColor = "#bdc2c6",
          axisLabelFontSize = 12,
          axisLabelColor = "#585858",
          disableZoom = TRUE
        )
    })
  }