library(shiny)
library(leaflet)

htmlTemplate("www/index.html", 
  revenueByCountryMap = choroplethMapOutput("revenueByCountryMap"),
  totalRevenue = textOutput("totalRevenue", inline=TRUE)
)
