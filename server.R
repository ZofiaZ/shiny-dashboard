library(lubridate)

server <- function(input, output, session) {
  orders <- read.csv("data/orders.csv", header = TRUE, stringsAsFactors = TRUE)
  orders$date <- ymd(orders$date)
  
  daily_production <- read.csv("data/daily_production.csv", header = TRUE, stringsAsFactors = TRUE)
  daily_production$date <- ymd(daily_production$date)
  
  output$profit <- renderText({ 
    getProfitByDate(orders, daily_production, 2020)
  })
  
  output$orders_count <- renderText({ 
    getOrdersCountByDate(orders, 2020)
  })
  
  callModule(choroplethMap, "revenueByCountryMap", metric="Revenue")
}