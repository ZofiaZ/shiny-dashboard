set.seed(1)

number_of_orders <- 4000
markets <- c("United States of America", "Brazil", "Germany", "Finland", "Spain")
product_categories <- c("Monitoring Cameras", "Sensoric Cables", "Fence")
business_start_date <- as.Date('2018/01/01')

today <- Sys.Date()
remaining_days_in_year <- interval(today, ceiling_date(today, "year")) %>% time_length("days")
business_running_days <- interval(business_start_date, today) %>% time_length("days") + 1;

orders <- data.frame(
  "date" = sample(seq(business_start_date, today, by="day"),size = number_of_orders, replace = TRUE),
  "location" = sample(x = markets, size = number_of_orders, replace = TRUE),
  "order_value" = sample(x = 10000:50000, size = number_of_orders),
  "product_type" = sample(x = product_categories, size = number_of_orders, replace = TRUE)
)

orders %>%
  write_csv("data/orders.csv")

daily_production <- data.frame(
  "date" = seq(business_start_date, ceiling_date(today, "year"), by="day"),
  "cost" = c(sample(x = 10:60, size = business_running_days, replace = TRUE), rep(0, times = remaining_days_in_year))
)

daily_production  %>%
  write_csv("data/daily_production.csv")