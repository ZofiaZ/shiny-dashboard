getSubsetByDate <- function(df, y, m, metric) {
  if (is.null(m) || m == "all") {
    subset(
      x = df,
      subset = year(date) == y,
      select = c(metric)
    )
  } else {
    subset(
      x = df,
      subset = year(date) == y & month(date) == m,
      select = c(metric)
    )
  }
}

getMetricByDate <- function(df, y, m = NULL, metric, f) {
  values = getSubsetByDate(df, y, m, metric)
  
  if (nrow(values) == 0)
    0
  else {
    f(values)
  }
}

getRevenueByDate <- function(orders_df, y, m = NULL) {
  # TODO: check functional programming and currying in R
  getMetricByDate(orders_df, y, m, "order_value", sum)
}

getTotalCostByDate <- function(production_df, y, m = NULL) {
  getMetricByDate(production_df, y, m, "cost", sum)
}

getOrdersCountByDate <- function(orders_df, y, m = NULL) {
  getMetricByDate(orders_df, y, m, "order_value", nrow)
}

getProfitByDate <- function(orders_df, production_df, y, m = NULL) {
  totalRevenue <- getRevenueByDate(orders_df, y, m)
  totalCost <- getTotalCostByDate(production_df, y, m)
  totalRevenue - totalCost
}
