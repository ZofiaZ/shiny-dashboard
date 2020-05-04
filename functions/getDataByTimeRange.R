getSubsetByTimeRange <- function(df, y, m = NULL, metric) {
  if (is.null(m) || m == "all") {
    subset(
      x = df,
      subset = year(date) == y,
      select = c("date", metric)
    )
  } else {
    subset(
      x = df,
      subset = year(date) == y & month(date) == m,
      select = c("date", metric)
    )
  }
}

getMetricByTimeRange <- function(df, y, m = NULL, metric, f) {
  filtered_df = getSubsetByTimeRange(df, y, m, metric)
  
  if (nrow(filtered_df) == 0)
    0
  else {
    f(filtered_df[metric])
  }
}

getTotalRevenueByTimeRange <- function(orders_df, y, m = NULL) {
  # TODO: check functional programming and currying in R
  getMetricByTimeRange(orders_df, y, m, "order_value", sum)
}

getTotalCostByTimeRange <- function(production_df, y, m = NULL) {
  getMetricByTimeRange(production_df, y, m, "cost", sum)
}

getOrdersCountByTimeRange <- function(orders_df, y, m = NULL) {
  getMetricByTimeRange(orders_df, y, m, "order_value", nrow)
}

getTotalProfitByTimeRange <- function(orders_df, production_df, y, m = NULL) {
  totalRevenue <- getTotalRevenueByTimeRange(orders_df, y, m)
  totalCost <- getTotalCostByTimeRange(production_df, y, m)
  totalRevenue - totalCost
}

getMonthlyDataByYear  <- function(df, y, metric) {
  getSubsetByTimeRange(df, y, m = NULL, metric) %>%
    mutate(month = month(date)) %>%
    mutate(date = floor_date(date, "month") ) %>%
    group_by(date) %>%
    summarize_at(.vars = c(metric), .funs = sum)
}
