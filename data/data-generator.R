set.seed(1)

number_of_orders <- 4000
markets <- c("United States of America", "Brazil", "Germany", "Finland", "Spain")
product_categories <- c("Monitoring Cameras", "Sensoric Cables", "Fence")
business_start_date <- as.Date('2018/01/01')
today <- as.Date(Sys.Date())
business_running_interval <-  interval(start_date, today)
business_running_days <- time_length(business_running_interval, "days") + 1;

orders <- data.frame(
  "location" = sample(x = markets, size = number_of_orders, replace = TRUE),
  "order_value" = sample(x = 10000:50000, size = number_of_orders),
  "date" = sample(seq(start_date, today, by="day"),size = number_of_orders, replace = TRUE),
  "product_type" = sample(x = product_categories, size = number_of_orders, replace = TRUE)
)

orders %>%
  write_csv("data/orders.csv")

daily_production <- data.frame(
  "date" = seq(start_date, today, by="day"),
  "cost" = sample(x = 10:60, size = business_running_days, replace = TRUE)
)

daily_production  %>%
  write_csv("data/daily_production.csv")