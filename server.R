library(dplyr)
library(lubridate)
library(glue)

source("./functions/getDataByTimeRange.R")

daily_stats <-
  read.csv("data/daily_stats.csv",
    header = TRUE,
    stringsAsFactors = TRUE
  ) %>%
  mutate(date = ymd(date))

monthly_stats <-
  read.csv("data/monthly_stats.csv",
    header = TRUE
  ) %>%
  mutate(date = ymd(date))

yearly_stats <-
  read.csv("data/yearly_stats.csv",
    header = TRUE
  ) %>%
  mutate(date = ymd(date))

countries_stats <-
  read.csv("data/countries_stats.csv",
    header = TRUE
  ) %>%
  mutate(date = ymd(date))

countries_geo_data <-
  geojsonio::geojson_read("data/countries.geojson", what = "sp")

countries_geo_data@data <- countries_geo_data@data %>%
  mutate(country = ADMIN)

server <- function(input, output, session) {
  observeEvent(c(input$selected_year), {
    months_choices <-
      getMonthsChoices(input$selected_year, data_last_day)
    selected_month <-
      ifelse(input$selected_month %in% months_choices,
        input$selected_month,
        "0"
      )
    updateSelectInput(session,
      "selected_month",
      selected = selected_month,
      choices = months_choices
    )
  })

  observeEvent(c(input$selected_month), {
    if (input$selected_month == "0") {
      updateRadioButtons(
        session,
        "previous_time_range",
        choices = prev_time_range_choices["Previous Year"],
        selected = prev_time_range_choices[["Previous Year"]]
      )
    } else {
      updateRadioButtons(
        session,
        "previous_time_range",
        choices = prev_time_range_choices,
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
    module = metricSummary,
    id = "sales",
    monthly_df = monthly_stats,
    yearly_df = yearly_stats,
    y = selected_year,
    m = selected_month,
    previous_time_range = previous_time_range,
    screen_readers_label="Select sales-related metric"
  )

  callModule(
    module = metricSummary,
    id = "production",
    monthly_df = monthly_stats,
    yearly_df = yearly_stats,
    y = selected_year,
    m = selected_month,
    previous_time_range = previous_time_range,
    screen_readers_label="Select production-related metric"
  )

  callModule(
    module = metricSummary,
    id = "users",
    yearly_df = yearly_stats,
    monthly_df = monthly_stats,
    y = selected_year,
    m = selected_month,
    previous_time_range = previous_time_range,
    screen_readers_label="Select users-related metric"
  )

  callModule(
    module = metricSummary,
    id = "complaints",
    yearly_df = yearly_stats,
    monthly_df = monthly_stats,
    y = selected_year,
    m = selected_month,
    previous_time_range = previous_time_range,
    screen_readers_label="Select complaints-related metric"
  )

  callModule(
    module = dygraphChart,
    id = "time_chart",
    df = daily_stats,
    y = selected_year,
    m = selected_month,
    previous_time_range = previous_time_range
  )

  callModule(
    module = choroplethMap,
    id = "map",
    df = countries_stats,
    countries_geo_data = countries_geo_data,
    y = selected_year,
    m = selected_month
  )
}