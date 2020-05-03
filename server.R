library(RColorBrewer)

server <- function(input, output, session) {
  callModule(choroplethMap, "revenueByCountryMap", metric="Revenue")
  
  ordersData <- read.csv("data/orders.csv", header = TRUE)
  orders <- data.frame(ordersData)
  
  output$totalRevenue <- renderText({ 
    sum(orders$value)
  })
}