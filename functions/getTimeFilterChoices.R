getMonthsChoices <- function(year = NULL) {
  months <- c(1:12)
  names(months) = month.name
  months_choices <- months
  
  if (is.null(year) || year == year(today)) {
    months_choices <- months[1:month(today)]
  }
  c("All months" = "all", months_choices)
}

getYearChoices <- function(start_date) {
  c(year(today):year(start_date))
}