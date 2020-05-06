library(dplyr)
library(lubridate)
library(glue)

source("./functions/getPrevValues.R")
source("./functions/getDiffValues.R")
source("./functions/getDataByTimeRange.R")

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

daily_production <- daily_production %>%
  mutate(cost_prev_month = mapply(getPrevMonthValue, date, MoreArgs = list(df=daily_production, metric="cost"))) %>%
  mutate(cost_change_prev_month = cost - cost_prev_month) %>%
  mutate(cost_prev_year = mapply(getPrevYearValue, date, MoreArgs = list(df=daily_production, metric="cost"))) %>%
  mutate(cost_change_prev_year = cost - cost_prev_year)

daily_data <- orders %>%
  group_by(date) %>%
  mutate(orders_count = n()) %>%
  summarize_at(.vars = c('revenue', 'orders_count'), .funs = sum) %>%
  left_join(daily_production, by = "date") %>%
  mutate(profit = revenue - cost)

print("test")

monthly_data <- daily_data %>% 
  mutate(date = floor_date(date, 'month')) %>%
  group_by(date) %>% 
  summarize_at(.vars = c('revenue', 'orders_count', 'profit', 'cost'), .funs = sum) %>%
  mutate(revenue_change_prev_month = mapply(getPrevMonthChange, date, revenue, lag(revenue), MoreArgs=list(data_last_day=data_last_day))) %>%
  mutate(profit_change_prev_month = mapply(getPrevMonthChange, date, profit, lag(profit), MoreArgs=list(data_last_day=data_last_day))) %>%
  mutate(orders_count_change_prev_month = mapply(getPrevMonthChange, date, orders_count, lag(orders_count), MoreArgs=list(data_last_day=data_last_day)))

monthly_data <- monthly_data %>%
  mutate(revenue_change_prev_year = mapply(getPrevYearMonthlyChange, date, revenue, MoreArgs=list(df=monthly_data,metric="revenue", data_last_day=data_last_day))) %>%
  mutate(profit_change_prev_year = mapply(getPrevYearMonthlyChange, date, revenue, MoreArgs=list(df=monthly_data,metric="profit", data_last_day=data_last_day))) %>%
  mutate(orders_count_change_prev_year = mapply(getPrevYearMonthlyChange, date, orders_count, MoreArgs=list(df=monthly_data,metric="orders_count", data_last_day=data_last_day)))

yearly_data <- monthly_data %>% 
  mutate(date = floor_date(date, 'year')) %>%
  group_by(date) %>%
  summarize_at(.vars = c('revenue', 'orders_count', 'profit', 'cost'), .funs = sum) %>%
  mutate(revenue_change_prev_year = mapply(getPrevYearChange, date, revenue, lag(revenue), MoreArgs = list(data_last_day=data_last_day))) %>%
  mutate(profit_change_prev_year = mapply(getPrevYearChange, date, profit, lag(profit), MoreArgs = list(data_last_day=data_last_day))) %>%
  mutate(orders_count_change_prev_year = mapply(getPrevYearChange, date, orders_count, lag(orders_count), MoreArgs = list(data_last_day=data_last_day)))

data_by_country <- orders %>% 
  mutate(date = floor_date(date, "month")) %>%
  group_by(country, date) %>% 
  mutate(orders_count = n()) %>%
  summarize_at(.vars = c('revenue', 'orders_count'), .funs = sum)

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
    yearly_data = yearly_data,
    monthly_data = monthly_data,
    metric = "profit",
    title = "Total Profit",
    y = selected_year,
    m = selected_month,
    previous_time_range = previous_time_range
  )
  
  callModule(
    module = metricSummaryServer,
    id = "orders_count",
    yearly_data = yearly_data,
    monthly_data = monthly_data,
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
    countriesGeoData = countriesGeoData,
    metric = "revenue",
    y = selected_year,
    m = selected_month
  )
  
  callModule(
    module = dygraphChart,
    id = "cost",
    df = daily_production,
    metric = "cost",
    metric_name = "Cost ($)",
    y = selected_year,
    m = selected_month,
    previous_time_range = previous_time_range
  )
}
