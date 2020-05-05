set.seed(1)

number_of_orders <- 6000
markets <- c("United States of America", "Brazil", "Germany", "Sweden", "Spain", "Zimbabwe")
product_categories <- c("Monitoring Cameras", "Sensoric Cables", "Fence")
business_start_date <- as.Date('2018/01/01')

last_day <- Sys.Date()
remaining_days_in_year <- interval(last_day, ceiling_date(last_day, "year")) %>% time_length("days")
business_running_days <- interval(business_start_date, last_day) %>% time_length("days") + 1;

orders <- data.frame(
  "date" = sample(seq(business_start_date, last_day, by="day"),size = number_of_orders, replace = TRUE),
  "country" = sample(x = markets, size = number_of_orders, replace = TRUE),
  "product_type" = sample(x = product_categories, size = number_of_orders, replace = TRUE)
) %>% arrange(date) %>% mutate(revenue = c(sample(x = 1000:2000, size = number_of_orders / 3, replace = TRUE), sample(x = 2000:3000, size = number_of_orders / 3, replace = TRUE), sample(x = 3000:4000, size = number_of_orders / 3, replace = TRUE)),
)

orders %>%
  write_csv("data/orders.csv")

daily_production <- data.frame(
  "date" = seq(business_start_date, ceiling_date(last_day, "year"), by="day"),
  "cost" = c(sample(x = 10:60, size = business_running_days, replace = TRUE), rep(0, times = remaining_days_in_year))
)

daily_production  %>%
  write_csv("data/daily_production.csv")