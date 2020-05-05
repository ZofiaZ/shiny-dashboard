getPercentChange <- function(current_value, prev_value) {
  ((current_value - prev_value) / prev_value * 100) %>% round(digits = 2)
}

getPercentChangeSpan <- function(current_value, prev_value) {
  change <- getPercentChange(current_value, prev_value)
  
  if (change > 0) {
    CSSclass <- 'positive-change'
    sign <- '+'
  } else if (change < 0)  {
    CSSclass <- 'negative-change'
    sign <- ''
  } else {
    CSSclass <- 'zero-change'
    sign <- ''
  }

  
  glue("<span class='{CSSclass}'> {sign}{change}%</span>")
}
