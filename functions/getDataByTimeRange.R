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

getMetricByTimeRange <- function(df, y, m = NULL, metric, f, to_date_limit=NULL) {
  filtered_df = getSubsetByTimeRange(df, y, m, metric)
  
  if (nrow(filtered_df) == 0)
    0
  else {
    f(filtered_df[metric])
  }
}

getMonthlyDataByYear  <- function(df, y, metric) {
  getSubsetByTimeRange(df, y, m = NULL, metric) %>%
    mutate(date = floor_date(date, "month") ) %>%
    group_by(date) %>%
    summarize_at(.vars = c(metric), .funs = sumNonNAValues)
}

sumNonNAValues <- function(v) {
  if (length(v[!is.na(v)]) == 0) {
    return(NA)
  } else {
    sum(v, na.rm=TRUE)
  }
}
