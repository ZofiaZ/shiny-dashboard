getMonthsChoices <- function(year = NULL) {
  months <- c(1:12)
  names(months) = month.name
  months_choices <- months
  
  if (is.null(year) || year == year(last_day)) {
    months_choices <- months[1:month(last_day)]
  }
  c("All months" = "0", months_choices)
}

getYearChoices <- function(start_date) {
  c(year(last_day):year(start_date))
}