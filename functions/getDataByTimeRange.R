getSubsetByTimeRange <- function(df, y, m = NULL, metric) {
  if (is.null(m) || m == "0") {
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

getSubsetByTimeRangeToDay <- function(df, y, m = NULL, metric, data_last_day) {
  if (is.null(m) || m == "0") {
    day_in_year <- interval(floor_date(data_last_day, 'year'), data_last_day) %>% time_length("days")
    getSubsetByTimeRange(df, y, m, metric)[1:day_in_year,]
  } else {
    getSubsetByTimeRange(df, y, m, metric)[1:day(data_last_day),]
  }
}

getMetricByTimeRange <- function(df, y, m = NULL, metric, f, data_last_day=NULL) {
  if (is.null(data_last_day)) {
    filtered_df = getSubsetByTimeRange(df, y, m, metric)
  } else {
    filtered_df = getSubsetByTimeRangeToDay(df, y, m, metric, data_last_day)
  }
  
  if (nrow(filtered_df) == 0)
    0
  else {
    f(filtered_df[metric])
  }
}

getTotalRevenueByTimeRange <- function(orders_df, y, m = NULL) {
  # TODO: check functional programming and currying in R
  getMetricByTimeRange(orders_df, y, m, "revenue", sum)
}

getTotalCostByTimeRange <- function(production_df, y, m = NULL) {
  getMetricByTimeRange(production_df, y, m, "cost", sum)
}

getOrdersCountByTimeRange <- function(orders_df, y, m = NULL) {
  getMetricByTimeRange(orders_df, y, m, "revenue", nrow)
}

getMonthlyDataByYear  <- function(df, y, metric) {
  getSubsetByTimeRange(df, y, m = NULL, metric) %>%
    mutate(month = month(date)) %>%
    mutate(date = floor_date(date, "month") ) %>%
    group_by(date) %>%
    summarize_at(.vars = c(metric), .funs = sum)
}


