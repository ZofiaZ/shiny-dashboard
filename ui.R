library(shiny)
library(leaflet)

ui <- fluidPage(
  choroplethMapOutput("revenueByCountryMap")
)
