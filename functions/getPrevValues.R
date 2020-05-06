getPrevMonthValue <- function(current_date, df, metric) {
  prev_date <- current_date %m-% months(1)
  
  if (prev_date %in% df$date && current_date <= data_last_day) {
    df[df$date == prev_date, metric]
  } else {
    return(NA)
  }
}

getPrevYearValue <- function(current_date, df, metric) {
  prev_date <- current_date %m-% years(1)
  
  if (prev_date %in% df$date && current_date <= data_last_day) {
    df[df$date == prev_date, metric]
  } else {
    return(NA)
  }
}