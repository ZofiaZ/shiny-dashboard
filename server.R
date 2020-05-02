library(RColorBrewer)

server <- function(input, output, session) {
  callModule(choroplethMap, "revenueByCountryMap", metric="Revenue")
}