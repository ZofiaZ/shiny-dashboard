#source("data/data-generator.R")
source("functions/getDataByTimeRange.R")
source("functions/getTimeFilterChoices.R")
source("functions/getPercentChange.R")
source("functions/getPrevTimeRange.R")
source("modules/choropleth_map.R")
source("modules/dygraph_chart.R")
source("modules/metric_summary.R")

# settings
data_last_day <- '2020-05-06' %>% as.Date()
data_first_day <- '2018-01-01' %>% as.Date()
