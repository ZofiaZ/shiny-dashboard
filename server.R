library(lubridate)

server <- function(input, output, session) {
  orders <-
    read.csv("data/orders.csv",
             header = TRUE,
             stringsAsFactors = TRUE)
  orders$date <- ymd(orders$date)
  
  daily_production <-
    read.csv("data/daily_production.csv",
             header = TRUE,
             stringsAsFactors = TRUE)
  daily_production$date <- ymd(daily_production$date)
  
  output$profit <- renderText({
    getProfitByDate(orders,
                    daily_production,
                    input$selected_year,
                    input$selected_month)
  })
  
  output$orders_count <- renderText({
    getOrdersCountByDate(orders, input$selected_year, input$selected_month)
  })
  
  observeEvent(c(input$selected_year),
               {
                 updateSelectInput(session,
                                   "selected_month",
                                   choices = getMonthsChoices(input$selected_year))
                 
               })
  
  callModule(choroplethMap, "revenueByCountryMap", metric = "Revenue")
  callModule(dygraphChart, "cost", df = daily_production, metric = "cost")
}