getPercentChangeValue <- function(current_value, prev_value) {
  if (is.null(prev_value)) {
    return(NA)
  }
  if (prev_value == 0) {
    return(100)
  }
  ((current_value - prev_value) / prev_value * 100) %>% round(digits = 2)
}

getPercentChangeSpan <- function(changeValue) {
  if (is.na(changeValue)) {
    return("<span class='no-data'>NA*</span>")
  }
  
  if (changeValue > 0) {
    CSSclass <- 'positive-change'
    sign <- '+'
  } else if (changeValue < 0)  {
    CSSclass <- 'negative-change'
    sign <- ''
  } else {
    CSSclass <- 'zero-change'
    sign <- ''
  }
  
  glue("<span class='{CSSclass}'> {sign}{changeValue}%</span>")
}

getPrevMonthChange <-
  function(current_date,
           current_value,
           prev_value,
           data_last_day) {
    if (is.na(prev_value)) {
      return(NA)
    }
    current_no_of_days <- getDaysInMonth(current_date, data_last_day)
    prev_date <- floor_date(current_date - 1, 'month')
    prev_no_of_days <- days_in_month(prev_date)
    
   if (current_no_of_days != prev_no_of_days) {
        prev_mean <- prev_value / prev_no_of_days
        prev_value <- prev_value + prev_mean * (current_no_of_days - prev_no_of_days)
   }
    
    return(getPercentChangeValue(current_value, prev_value))
  }

getPrevYearMonthlyChange <- function(current_date,
                              current_value,
                              df,
                              metric,
                              data_last_day) {
  current_no_of_days <- getDaysInMonth(current_date, data_last_day)
  prev_year <- year(current_date) - 1
  prev_date <- paste(prev_year, month(current_date), '01', sep='-') %>% as.Date()
  prev_value <- df[df$date == prev_date, metric]
  prev_no_of_days <- days_in_month(prev_date)
  
  if (nrow(prev_value) == 0) {
    return(NA)
  }
  
  prev_value_standardized <- getStandardizedPrevValue(prev_value, current_no_of_days, prev_no_of_days)
  
  return(getPercentChangeValue(current_value, prev_value_standardized))
}

getPrevYearChange <- function(current_date,
                  current_value,
                  prev_value,
                  data_last_day) {
  if (is.na(prev_value)) {
    return(NA)
  }
  
  current_year <- year(current_date)
  prev_year <- current_year - 1
  prev_date <- paste(prev_year, '01', '01', sep="-") %>% as.Date()
  
  if(year(current_date) == year(data_last_day)) {
    end_of_current_year <- data_last_day
  } else {
    end_of_current_year <- ceiling_date(current_date, 'year')
  }
  current_no_of_days <- interval(floor_date(current_date, "year"), end_of_current_year) %>% time_length("days")
  prev_no_of_days <- interval(floor_date(prev_date, "year"), ceiling_date(prev_date, 'year')) %>% time_length("days")

  prev_value_standardized <- getStandardizedPrevValue(prev_value, current_no_of_days, prev_no_of_days)

  return(getPercentChangeValue(current_value, prev_value_standardized))
}

getStandardizedPrevValue <- function(prev_value, current_no_of_days, prev_no_of_days) {
  if (current_no_of_days != prev_no_of_days) {
    prev_mean <- prev_value / prev_no_of_days
    return(prev_value + prev_mean * (current_no_of_days - prev_no_of_days))
  } else {
    return(prev_value)
  }
}

getDaysInMonth <- function(date, data_last_day) {
  if (year(date) == year(data_last_day) && month(date) == month(data_last_day)) {
    day(data_last_day)
  } else {
    days_in_month(date)
  }
}