library(shiny)
library(leaflet)
library(dygraphs)

htmlTemplate(
  "www/index.html",
  selectYear = selectInput("selected_year", "Year", getYearChoices(business_start_date), width = NULL),
  selectMonth = selectInput("selected_month", "Month", getMonthsChoices(), width = NULL),
  revenueByCountryMap = choroplethMapOutput("revenueByCountryMap"),
  profit = textOutput("profit", inline = TRUE),
  orders_count = textOutput("orders_count", inline = TRUE),
  costDygraph = dygraphChartOutput("cost")
)
