library(shiny)
library(leaflet)

htmlTemplate("www/index.html", 
  revenueByCountryMap = choroplethMapOutput("revenueByCountryMap"),
  profit = textOutput("profit", inline=TRUE),
  orders_count = textOutput("orders_count", inline=TRUE)
)
