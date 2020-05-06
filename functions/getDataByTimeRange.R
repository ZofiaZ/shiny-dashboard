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

getSubsetByTimeRangeToDate <- function(df, y, m = NULL, metric, to_date_limit) {
  if (is.null(m) || m == "0") {
    day_in_year <- interval(floor_date(to_date_limit, 'year'), to_date_limit) %>% time_length("days")
    getSubsetByTimeRange(df, y, m, metric)[1:day_in_year,]
  } else {
    getSubsetByTimeRange(df, y, m, metric)[1:day(to_date_limit),]
  }
}

getMetricByTimeRange <- function(df, y, m = NULL, metric, f, to_date_limit=NULL) {
  if (is.null(to_date_limit)) {
    filtered_df = getSubsetByTimeRange(df, y, m, metric)
  } else {
    filtered_df = getSubsetByTimeRangeToDate(df, y, m, metric, to_date_limit)
  }
  
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
