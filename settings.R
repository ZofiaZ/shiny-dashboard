# settings (for generating sample data and shiny app)

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
  users = list(
    id = "users",
    title = "Active Users",
    currency = NULL,
    legend = "Active users"
  ),
  complaints = list(
    id = "complaints",
    title = "Open Complaints",
    currency = NULL,
    legend = "Open complaints"
  )
)