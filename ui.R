library(shiny)
library(leaflet)
library(dygraphs)

htmlTemplate(
  "www/index.html",
  selectYear = selectInput("selected_year", "Year", getYearChoices(data_first_day, data_last_day), width = NULL),
  selectMonth = selectInput("selected_month", "Month", getMonthsChoices(year = NULL, data_last_day), width = NULL),
  previousTimeRange = radioButtons("previous_time_range", label = h3("Compare to:"),
                                   choices = list("Previous Year" = "previous_year", "Previous Month" = "previous_month"), 
                                   selected = "previous_year"),
  revenueByCountryMap = choroplethMapOutput("revenue_by_country_map"),
  profitSummary = metricSummaryOutput("profit"),
  ordersCountSummary = metricSummaryOutput("orders_count"),
  costDygraph = dygraphChartOutput("cost")
)
