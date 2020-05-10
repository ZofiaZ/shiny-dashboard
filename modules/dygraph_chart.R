library(dygraphs)
library(xts)

dygraphChartOutput <- function(id) {
  ns <- NS(id)

  time_metrics <- names(metrics_list) # add all available metrics to dygraph chart
  choices <- list("Loading..." = "") %>% c(getMetricsChoices(time_metrics, metrics_list))

  tagList(
    tags$div(
      class = "tile-header",
      selectInput(
        ns("metric"), "Select metric for the time chart",
        choices,
        width = NULL,
        selectize = FALSE
      )
    ),
    tags$div(
      class = "time-chart-container",
      dygraphOutput(ns("dygraph"), height = "200px")
    )
  )
}

dygraphChart <- function(input,
                         output,
                         session,
                         df,
                         y,
                         m,
                         previous_time_range) {
  metric <- reactive({
    validate(need(input$metric != "", "select metric"))
    metrics_list[[input$metric]]
  })

  dy_bar_chart <- function(dygraph) {
    dyPlotter(
      dygraph = dygraph,
      name = "BarChart",
      path = system.file("plotters/barchart.js", package = "dygraphs")
    )
  }

  output$dygraph <- renderDygraph({
    metric_change_key <- paste0(metric()$id, ".change_", previous_time_range())
    metric_suffix <- ifelse(!is.null(metric()$currency), glue(" ({metric()$currency})"), "")
    metric_legend <- paste0(metric()$legend, metric_suffix)

    if (m() == "0") {
      subset <- getMonthlyDataByYear(df, y(), metric = c(metric()$id, metric_change_key))
      diff_label <- "prev year diff"
    } else {
      subset <- getSubsetByTimeRange(df, y(), m(), metric = c(metric()$id, metric_change_key))
      diff_label <- ifelse(previous_time_range() == "prev_year", "change to prev. year", "change to prev. month")
    }

    data <- xts(x = select(subset, c(metric()$id, metric_change_key)), order.by = subset$date)

    dygraph(data) %>%
      dy_bar_chart() %>%
      dyAxis("y", axisLabelWidth = 60) %>%
      dyAxis("x", drawGrid = FALSE) %>%
      dySeries(metric()$id, label = metric_legend, color = "rgba(41,190,216,1)") %>%
      dySeries(metric_change_key, label = diff_label, color = "rgba(248,216,77,0.95)") %>%
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