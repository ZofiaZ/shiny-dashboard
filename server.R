library(lubridate)
library(glue)

orders <-
  read.csv("data/orders.csv",
           header = TRUE,
           stringsAsFactors = TRUE) %>%
  mutate(date = ymd(date))

daily_production <-
  read.csv("data/daily_production.csv",
           header = TRUE,
           stringsAsFactors = TRUE) %>%
  mutate(date = ymd(date))

daily_data <- orders %>%
  #mutate(date = floor_date(date, "day")) %>%
  group_by(date) %>%
  mutate(orders_count = n()) %>%
  summarize_at(.vars = c('revenue', 'orders_count'), .funs = sum) %>%
  left_join(daily_production, by = "date") %>%
  mutate(profit = revenue - cost)

data_by_country <- orders %>% 
  mutate(date = floor_date(date, "month")) %>%
  group_by(country, date) %>% 
  mutate(orders_count = n()) %>%
  summarize_at(.vars = c('revenue', 'orders_count'), .funs = sum)
# TODO add costs data by country

countriesGeoData <-
  geojsonio::geojson_read("data/countries.geojson", what = "sp")

countriesGeoData@data <- countriesGeoData@data %>%
  mutate(country = ADMIN)

server <- function(input, output, session) {
  observeEvent(c(input$selected_year),
               {
                 monthsChoices <- getMonthsChoices(input$selected_year)
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
                     choices = list("Previous Year" = "previous_year"),
                     selected = "previous_year"
                   )
                 } else {
                   updateRadioButtons(
                     session,
                     "previous_time_range",
                     choices = list("Previous Year" = "previous_year", "Previous Month" = "previous_month"),
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
    df = daily_data[, c('date', 'profit')],
    metric = "profit",
    title = "Total Profit",
    y = selected_year,
    m = selected_month,
    previous_time_range = previous_time_range
  )
  
  callModule(
    module = metricSummaryServer,
    id = "orders_count",
    df = daily_data[, c('date', 'orders_count')],
    metric = "orders_count",
    title = "Total orders",
    y = selected_year,
    m = selected_month,
    previous_time_range = previous_time_range
  )
  
  callModule(
    module = choroplethMap,
    id = "revenue_by_country_map",
    df = data_by_country,
    metric = "revenue",
    y = selected_year,
    m = selected_month
  )
  
  callModule(
    module = dygraphChart,
    id = "cost",
    df = daily_production,
    metric = "cost",
    y = selected_year,
    m = selected_month
  )
}
