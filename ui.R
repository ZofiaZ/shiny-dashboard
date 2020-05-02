library(shiny)
library(leaflet)

htmlTemplate("www/index.html", 
  revenueByCountryMap = choroplethMapOutput("revenueByCountryMap")
)
