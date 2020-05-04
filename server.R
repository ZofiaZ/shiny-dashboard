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
    getTotalProfitByTimeRange(orders,
                    daily_production,
                    input$selected_year,
                    input$selected_month)
  })
  
  output$orders_count <- renderText({
    getOrdersCountByTimeRange(orders, input$selected_year, input$selected_month)
  })
  
  observeEvent(c(input$selected_year),
               {
                 monthsChoices <- getMonthsChoices(input$selected_year)
                 selectedMonth <- if (input$selected_month %in% monthsChoices) input$selected_month else "all"
                 updateSelectInput(session,
                                   "selected_month",
                                   selected = selectedMonth,
                                   choices = monthsChoices)
               })
  
  callModule(choroplethMap, "revenueByCountryMap", metric = "Revenue")
  callModule(
    module = dygraphChart,
    id = "cost",
    df = daily_production,
    metric = "cost",
    y = reactive({
      input$selected_year
    }),
    m =  reactive({
      input$selected_month
    })
  )
}