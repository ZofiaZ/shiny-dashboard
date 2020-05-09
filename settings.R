# common variables for generating sample data and shiny app (ui & server)

data_last_day <- "2020-05-07" %>% as.Date()
data_first_day <- "2018-01-01" %>% as.Date()

metrics_list <- list(
  revenue = list(
    id = "revenue",
    title = "Sales Revenue",
    currency = "$",
    legend = "Revenue"
  ),
  cost = list(
    id = "cost",
    title = "Production Costs",
    currency = "$",
    legend = "Cost"
  ),
  profit = list(
    id = "profit",
    title = "Profit",
    currency = "$",
    legend = "Profit"
  ),
  orders_count = list(
    id = "orders_count",
    title = "Orders",
    currency = NULL,
    legend = "Number of orders"
  ),
  produced_items = list(
    id = "produced_items",
    title = "Produced Items",
    currency = NULL,
    legend = "Produced items"
  ),
  users_active = list(
    id = "users_active",
    title = "Active Users",
    currency = NULL,
    legend = "Active users"
  ),
  users_dropped_out = list(
    id = "users_dropped_out",
    title = "Dropped Out Customers",
    currency = NULL,
    legend = "Dropped out customers"
  ),
  complaints_opened = list(
    id = "complaints_opened",
    title = "Opened Complaints",
    currency = NULL,
    legend = "Opened complaints"
  ),
  complaints_closed = list(
    id = "complaints_closed",
    title = "Closed Complaints",
    currency = NULL,
    legend = "Closed complaints"
  )
)

prev_time_range_choices <- list("Previous Year" = "prev_year", "Previous Month" = "prev_month")