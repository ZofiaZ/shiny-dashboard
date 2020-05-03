number_of_orders <- 10;

countries <- sample(x = c("United States of America", "Brazil", "Germany", "Finland", "Spain"),
                    size = number_of_orders,
                    replace = TRUE)

values <- sample(x = 100000:600000, size = number_of_orders)

dates <- sample(seq(as.Date('2018/01/01'), as.Date('2020/05/05'), by="day"), 
                size = number_of_orders, 
                replace = TRUE)

product_types <- sample(x = c("Monitoring Cameras", "Sensoric Cables", "Fence"),
                       size = number_of_orders,
                       replace = TRUE)

orders <- data.frame("location" = countries, "value" = values, "date" = dates, "product_type" = product_types )

orders %>%
  write_csv("data/orders.csv")
