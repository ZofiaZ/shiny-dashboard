getMetricsChoices <- function(available_metrics, metrics_list) {
  choices <- metrics_list[available_metrics]

  keys <- choices %>%
    lapply("[[", "title") %>%
    unname()

  values <- choices %>%
    lapply("[[", "id")

  names(values) <- keys
  return(values)
}