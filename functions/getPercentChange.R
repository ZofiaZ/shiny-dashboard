getPercentChangeHtml <- function(current_value, prev_value) {
  change <- ((current_value - prev_value) / prev_value * 100) %>% round(digits = 2)
  
  if (change > 0) {
    CSSclass <- 'positive-change'
  } else if (change < 0)  {
    CSSclass <- 'negative-change'
  } else {
    CSSclass <- 'zero-change'
  }
  
  paste0("<span class='", CSSclass, "'>", ifelse(change > 0, "+", ""), change, "%</span>") %>% HTML()
}