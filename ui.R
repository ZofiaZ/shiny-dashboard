library(shiny)
library(leaflet)
library(lubridate)
library(dygraphs)

htmlTemplate(
  "www/index.html",
  selectYear = selectInput(
    "selected_year", "Year", 
    choices = getYearChoices(data_first_day, data_last_day),
    selectize = FALSE
  ),
  selectMonth = selectInput(
    "selected_month", "Month",
    choices = getMonthsChoices(year = NULL, data_last_day),
    selectize = FALSE
  ),
  previousTimeRange = radioButtons("previous_time_range",
    label = h3("Compare to:"),
    choices = prev_time_range_choices,
    selected = "prev_year"
  ),
  salesSummary = metricSummaryOutput("sales_summary"),
  productionSummary = metricSummaryOutput("production_summary"),
  usersSummary = metricSummaryOutput("users_summary"),
  complaintsSummary = metricSummaryOutput("complaints_summary"),
  timeChart = dygraphChartOutput("time_chart"),
  countryMap = choroplethMapOutput("map")
)