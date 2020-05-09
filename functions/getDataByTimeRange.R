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

getMonthlyDataByYear <- function(df, y, metric) {
  getSubsetByTimeRange(df, y, m = NULL, metric) %>%
    mutate(date = floor_date(date, "month")) %>%
    group_by(date) %>%
    summarize_at(.vars = c(metric), .funs = sumAllNonNAValues)
}

sumAllNonNAValues <- function(v) {
  if (length(v[!is.na(v)]) != 0) {
    sum(v, na.rm = TRUE)
  } else {
    # return NA instead of 0 if all months data is missing
    # (eg. future months needed for nicer 'current year' dygraph display)
    return(NA)
  }
}