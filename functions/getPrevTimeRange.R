getPrevYearMonth <- 
  function(selected_year,
           selected_month,
           prev_time_range) {
    year <- as.numeric(selected_year)
    month <- as.numeric(selected_month)
    
    if (prev_time_range == "previous_year" || selected_month == "0") {
      year <- year - 1
    } else if (month == 1) {
      year <- year - 1
      month <- 12
    } else {
      month <- month - 1
    }
    
    return(list("year" = year, "month" = month))
  }

getToDateLimit <- function(selected_year, selected_month, data_last_day) {
    is_time_ <-
      selected_year == year(data_last_day) && 
      (selected_month == month(data_last_day) || selected_month == "0")
    
    
    if (should_apply_limit) {
      return(data_last_day)
    } else {
      return(NULL)
    }
}

getDaysInMonth <- function(date, data_last_day) {
  if (year(date) == year(data_last_day) && month(date) == month(data_last_day)) {
    day(data_last_day)
  } else {
    days_in_month(date)
  }
}