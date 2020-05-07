library(dplyr)
library(lubridate)
library(glue)

source("./functions/getPrevValues.R")
source("./functions/getDiffValues.R")
source("./functions/getDataByTimeRange.R")

daily_stats <-
  read.csv("data/daily_stats.csv",
           header = TRUE,
           stringsAsFactors = TRUE) %>%
  mutate(date = ymd(date))

monthly_stats <-
  read.csv("data/monthly_stats.csv",
           header = TRUE,
           stringsAsFactors = TRUE) %>%
  mutate(date = ymd(date))

yearly_stats <-
  read.csv("data/yearly_stats.csv",
           header = TRUE,
           stringsAsFactors = TRUE) %>%
  mutate(date = ymd(date))

countries_stats <-
  read.csv("data/countries_stats.csv",
           header = TRUE,
           stringsAsFactors = TRUE) %>%
  mutate(date = ymd(date))

countriesGeoData <-
  geojsonio::geojson_read("data/countries.geojson", what = "sp")

countriesGeoData@data <- countriesGeoData@data %>%
  mutate(country = ADMIN)

server <- function(input, output, session) {
  observeEvent(c(input$selected_year),
               {
                 monthsChoices <- getMonthsChoices(input$selected_year, data_last_day)
                 selectedMonth <-
                   ifelse(input$selected_month %in% monthsChoices,
                          input$selected_month,
                          "0")
                 updateSelectInput(session,
                                   "selected_month",
                                   selected = selectedMonth,
                                   choices = monthsChoices)
               })
  
  observeEvent(c(input$selected_month),
               {
                 if (input$selected_month == "0") {
                   updateRadioButtons(
                     session,
                     "previous_time_range",
                     choices = list("Previous Year" = "prev_year"),
                     selected = "prev_year"
                   )
                 } else {
                   updateRadioButtons(
                     session,
                     "previous_time_range",
                     choices = list("Previous Year" = "prev_year", "Previous Month" = "prev_month"),
                     selected = input$previous_time_range
                   )
                 }
               })
  
  
  selected_year <- reactive({
    input$selected_year
  })
  
  selected_month <- reactive({
    input$selected_month
  })
  
  previous_time_range <- reactive({
    input$previous_time_range
  })
  
  callModule(
    module = metricSummaryServer,
    id = "profit",
    yearly_df = yearly_stats,
    monthly_df = monthly_stats,
    metric = "profit",
    title = "Total Profit",
    y = selected_year,
    m = selected_month,
    previous_time_range = previous_time_range
  )
  
  callModule(
    module = metricSummaryServer,
    id = "orders_count",
    yearly_df = yearly_stats,
    monthly_df = monthly_stats,
    metric = "orders_count",
    title = "Total orders",
    y = selected_year,
    m = selected_month,
    previous_time_range = previous_time_range
  )
  
  callModule(
    module = choroplethMap,
    id = "revenue_by_country_map",
    df = countries_stats,
    countriesGeoData = countriesGeoData,
    metric = "revenue",
    y = selected_year,
    m = selected_month
  )
  
  callModule(
    module = dygraphChart,
    id = "cost",
    df = daily_stats,
    metric = "cost",
    metric_name = "Cost ($)",
    y = selected_year,
    m = selected_month,
    previous_time_range = previous_time_range
  )
}
