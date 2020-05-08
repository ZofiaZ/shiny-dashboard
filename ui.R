library(shiny)
library(leaflet)
library(lubridate)
library(dygraphs)

htmlTemplate(
  "www/index.html",
  selectYear = selectInput("selected_year", "Year", getYearChoices(data_first_day, data_last_day), width = NULL),
  selectMonth = selectInput("selected_month", "Month", getMonthsChoices(year = NULL, data_last_day), width = NULL),
  previousTimeRange = radioButtons("previous_time_range", label = h3("Compare to:"),
                                   choices = list("Previous Year" = "prev_year", "Previous Month" = "prev_month"), 
                                   selected = "prev_year"),
  countryMap = choroplethMapOutput("country_map"),
  profitSummary = metricSummaryOutput("profit"),
  ordersCountSummary = metricSummaryOutput("orders_count"),
  selectDygraphMetric = selectInput("dygraph_metric", "Metric", list("Production Costs" = "cost", "Profit"= "profit", "Orders" = "orders_count"), width = NULL),
  selectMapMetric = selectInput("map_metric", "Metric", list("Sales Revenue" = "revenue", "Orders count"= "orders_count"), width = NULL),
  costDygraph = dygraphChartOutput("time_chart")
)
