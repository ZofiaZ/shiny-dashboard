createOptionsList <- function(choices) {
  keys <- choices %>%
    lapply("[[", "title") %>%
    unname()
  
  values <- choices %>%
    lapply("[[", "id")
  
  names(values) <- keys
  return(values)
}


getMetricsChoices <- function(available_metrics, metrics_list) {
  metrics_list[available_metrics] %>% createOptionsList()
}

getMetricsChoicesByCategory <- function(category) {
  Filter(function(x) x$category == category, metrics_list) %>% createOptionsList()
}