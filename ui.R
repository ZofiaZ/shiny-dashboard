library(shiny)
library(leaflet)
library(lubridate)
library(dygraphs)

htmlTemplate(
  "www/index.html",
  selectYear = selectInput(
    "selected_year", "Year", getYearChoices(data_first_day, data_last_day),
    width = NULL
  ),
  selectMonth = selectInput(
    "selected_month", "Month", getMonthsChoices(year = NULL, data_last_day),
    width = NULL
  ),
  previousTimeRange = radioButtons("previous_time_range",
    label = h3("Compare to:"),
    choices = list("Previous Year" = "prev_year", "Previous Month" = "prev_month"),
    selected = "prev_year"
  ),
  salesSummary = metricSummaryOutput("sales_summary"),
  productionSummary = metricSummaryOutput("production_summary"),
  usersSummary = metricSummaryOutput("users_summary"),
  complaintsSummary = metricSummaryOutput("complaints_summary"),
  timeChart = dygraphChartOutput("time_chart"),
  countryMap = choroplethMapOutput("map")
)