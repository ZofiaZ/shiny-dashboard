library(RColorBrewer)
library(leaflet)

choroplethMapOutput <- function(id) {
  ns <- NS(id)
  leafletOutput(ns("choroplethCountryMap"))
}

getCountriesDataByDate <- function(df, y, m, metric, f = sum) {
  getSubsetByTimeRange(df, y, m, metric=c('country', metric)) %>%
    group_by(country) %>%
    summarize_at(.vars = c(metric), .funs = f)
}

choroplethMap <-
  function(input,
           output,
           session,
           metric,
           countriesGeoData,
           df,
           y,
           m) {
    
    countriesDf = reactive({
      getCountriesDataByDate(df, y(), m(), metric(), sum)
    })
  
  
    output$choroplethCountryMap <- renderLeaflet({
      # Create a color palette for the map
      mapPalette <-
        colorQuantile(
          palette = colorRampPalette(c("#f8d84d", '#bdd64b'))(6),
          domain = countriesDf()[[metric()]],
          6,
          na.color = "transparent"
        )
    
      # Prepare the text for tooltips:
      tooltip <- paste(
        "Country: ",
        countriesDf()$country,
        "<br/>",
        metric(),
        ": ",
        countriesDf()[[metric()]],
        "<br/>",
        sep = ""
      ) %>%
        lapply(htmltools::HTML)
      
      leaflet() %>%
        addTiles()  %>%
        addProviderTiles(providers$CartoDB.VoyagerNoLabels) %>%
        setView(lat = 10,
                lng = 0 ,
                zoom = 2) %>%
        leaflet::addPolygons(
          data = countriesGeoData,
          fillColor = ~ mapPalette(countriesDf()[[metric()]]),
          stroke = FALSE,
          fillOpacity = 0.9,
          label = tooltip,
          labelOptions = labelOptions(
            style = list("font-weight" = "normal", padding = "3px 8px"),
            textsize = "13px",
            direction = "auto"
          )
        )
    })
  }